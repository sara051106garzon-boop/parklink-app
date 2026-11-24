# Despliegue de ParkLink Frontend en Vercel

Este repositorio es una app **Flutter** (móvil y web), no un proyecto Vite/React.
El despliegue en Vercel publica la compilación de **Flutter Web** (`build/web`).

## 1. Cómo se conecta al back-end (proxy inverso)

Para eliminar el **Mixed Content** (HTTPS → HTTP) y el **CORS**, la app web **no**
llama directo a `http://3.138.221.70:8001`. En su lugar:

1. `lib/config/api_config.dart` resuelve la URL base a `Uri.base.origin` cuando
   `kIsWeb` es verdadero, es decir `https://parklink-app.vercel.app`.
2. La app llama a su mismo origen: `https://parklink-app.vercel.app/api/auth/login`.
3. `vercel.json` reenvía `/api/:path*` al back-end de EC2, servidor a servidor:

   ```json
   { "source": "/api/:path*", "destination": "http://3.138.221.70:8001/api/:path*" }
   ```

   El navegador solo ve HTTPS con su propio origen (sin Mixed Content) y el
   back-end recibe la petición desde Vercel sin cabecera `Origin` (sin CORS).

| Archivo | Para qué sirve |
| :--- | :--- |
| `lib/config/api_config.dart` | Resuelve la URL base: override `API_BASE_URL`, o `Uri.base.origin` en web. |
| `vercel.json` | Build, salida `build/web`, **rewrite `/api/*` → EC2**, rewrite de SPA y cabeceras. |
| `scripts/vercel-build.sh` | Instala Flutter (si no existe) y compila `build/web`. |
| `.github/workflows/deploy-vercel.yml` | CI/CD: `main` → Production, Pull Request → Preview, manual → entorno elegido. |
| `.env.example` | Referencia de valores. **Flutter no lee `.env` automáticamente.** |

## 2. Variables de entorno en Vercel

**Para web no se necesita ninguna variable.** La app usa `Uri.base.origin` y el
rewrite se encarga del resto.

`API_BASE_URL` queda como **override opcional** (solo para builds móviles/desktop
o pruebas locales directas):

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8001
```

> ⚠️ **Limitación del rewrite estático:** el `destination` de `vercel.json` es un
> string fijo y apunta al back-end de **producción (`8001`)**. Por tanto, los
> **Preview Deployments** también reenviarán a `8001` (no a staging `8000`). Si
> necesitas que preview apunte a `8000`, usa una **Edge/Middleware de Vercel**
> que lea una variable de entorno por entorno, o crea dos proyectos de Vercel
> (uno por entorno) con distinto `vercel.json`. Ver la nota al final de la
> sección 4.

## 3. Conectar Vercel con GitHub (opción recomendada: GitHub Actions)

1. En [vercel.com/new](https://vercel.com/new), importa el repositorio
   `sara051106garzon-boop/parklink-app` y crea el proyecto.
2. Framework preset: **Other** (Vercel leerá `vercel.json`).
3. `vercel.json` incluye `"git": { "deploymentEnabled": false }`, así que los
   deploys los hará el workflow, no el build automático de Git. Esto evita
   builds duplicados y permite verificar el build Flutter antes de publicar.
4. En tu máquina, vincula la carpeta para obtener los IDs del proyecto:

   ```bash
   npx vercel login
   npx vercel link
   ```

   Esto crea `.vercel/project.json` (ignorado por Git). Obtén los IDs con:

   ```powershell
   Get-Content .vercel\project.json
   ```

   ```json
   { "orgId": "team_xxxxxxxx", "projectId": "prj_xxxxxxxx" }
   ```

5. Copia el contenido del archivo de token y agrega los tres **GitHub Secrets**
   en **GitHub → Settings → Secrets and variables → Actions**:

   | Secret | Dónde obtenerlo |
   | :--- | :--- |
   | `VERCEL_TOKEN` | [vercel.com/account/tokens](https://vercel.com/account/tokens) → Create Token |
   | `VERCEL_ORG_ID` | `orgId` de `.vercel/project.json` |
   | `VERCEL_PROJECT_ID` | `projectId` de `.vercel/project.json` |

   Con GitHub CLI (cada comando pide el valor y no lo escribe en el repo):

   ```bash
   gh secret set VERCEL_TOKEN
   gh secret set VERCEL_ORG_ID
   gh secret set VERCEL_PROJECT_ID
   ```

6. El workflow queda así:

   - Push a `main` → deploy a **Production**.
   - Pull Request hacia `main` → deploy de **Preview**.
   - **Run workflow** manual → eliges `preview` o `production`.

   Los secretos nunca se imprimen en logs. Si un PR viene de un fork, el job se
   omite porque GitHub no entrega secretos a forks.

### Opción alternativa: build nativo de Vercel (sin GitHub Actions)

1. Elimina el bloque `"git": { "deploymentEnabled": false }` de `vercel.json`
   (o cámbialo a `true`).
2. Conecta el repositorio en Vercel y deja el preset **Other**.
3. `scripts/vercel-build.sh` detecta que Flutter no está instalado y lo
   descarga automáticamente. El build tarda más la primera vez.
4. No actives también el workflow, para no desplegar dos veces.

## 4. CORS y acceso desde EC2

Con el proxy inverso, el navegador hace **misma-origen**, así que **no hay CORS
ni preflight** para la web. El back-end recibe la petición desde Vercel sin
cabecera `Origin`, por lo que no es necesario tocar `CORS_ORIGINS`.

Qué sí debes garantizar en EC2:

- El **Security Group** de EC2 debe permitir el puerto `8001` (y `8000` si lo
  usas) desde Internet, ya que Vercel reenvía desde sus servidores (Vercel no
  tiene IPs de salida fijas).
- Si más adelante algún cliente llama directo al back-end (p. ej. desarrollo
  local con `flutter run -d chrome` + `--dart-define=API_BASE_URL=...`), entonces
  sí necesitas agregar ese origen a `CORS_ORIGINS` en el `.env` del servidor:

  ```env
  # .env del back-end en EC2 (ejemplo)
  CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173,https://parklink-app.vercel.app
  ```

  Después de editarlo, recrea el contenedor:

  ```bash
  docker compose up -d --force-recreate web
  ```

### Nota: proxy por entorno (staging 8000 vs producción 8001)

Si necesitas que **Preview → 8000** y **Production → 8001**, el rewrite estático
no alcanza. Opciones:

- **Edge/Middleware** que lea `BACKEND_URL` por entorno y haga el proxy
  (`middleware.ts` con `NextResponse.rewrite` no aplica aquí porque no hay Next;
  usar una **Edge Function** `/api/[...path].ts` que reenvíe a
  `process.env.BACKEND_URL`).
- **Dos proyectos de Vercel** (uno por entorno) con `vercel.json` distinto.
- **HTTPS en el back-end** con dominios por entorno (`api-staging`, `api`) y
  `API_BASE_URL` por entorno.

## 5. Probar el build en local

```powershell
flutter --version
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test

# Web (producción/preview): sin variable, la app usa Uri.base.origin
flutter build web --release

# Override explícito (móvil/escritorio o pruebas directas)
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8001
```

El resultado queda en `build\web`. Para confirmar que los endpoints usan ruta
relativa (sin duplicar `/api`):

```powershell
Select-String -Path build\web\main.dart.js -Pattern "/api/auth/login"
```

Para probar el proxy como en producción, usa Vercel Dev (aplica `vercel.json`
localmente y reenvía `/api/*` a EC2):

```bash
npx vercel dev
# abre http://localhost:3000
```

> Servir `build/web` con `python -m http.server` **no** aplica el rewrite de
> Vercel, así que `/api/*` devolverá 404. Para desarrollo web local usa
> `vercel dev` o `flutter run -d chrome` con `--dart-define` + CORS.

## 6. Verificar el despliegue

1. **GitHub Actions**: en la pestaña Actions debe aparecer el workflow
   **Deploy a Vercel** en verde.

   ```bash
   gh run list --workflow "Deploy a Vercel"
   gh run watch
   ```

2. **Vercel**: revisa el deployment en el dashboard o con la CLI:

   ```bash
   npx vercel ls
   npx vercel inspect <URL-DEL-DEPLOY>
   ```

3. **HTTP**: la raíz y una ruta interna deben responder `200` (rewrite de SPA):

   ```bash
   curl -I https://parklink-app.vercel.app
   curl -I https://parklink-app.vercel.app/login
   ```

4. **Proxy de la API**: haz login a través del dominio de Vercel y confirma que
   responde el back-end (revisa DevTools → Network):

   ```bash
   curl -i -X POST "https://parklink-app.vercel.app/api/auth/login" \
     -H "Content-Type: application/json" \
     -d '{"correo":"tu@correo.com","password":"TuClave"}'
   ```

   Debe devolver `200` con el JSON de `access_token`/`token`, igual que si
   llamaras directo a `http://3.138.221.70:8001/api/auth/login`.

5. **Logs**: en Vercel → Deployment → Logs, o `npx vercel logs <URL>`, no debe
   haber errores de build.

## 7. Seguridad de credenciales

- `VERCEL_TOKEN`, `VERCEL_ORG_ID` y `VERCEL_PROJECT_ID` viven únicamente en
  **GitHub Secrets**.
- `.env`, `.env.*` (excepto `.env.example`), `.vercel/`, `*.pem` y `*.key` están
  en `.gitignore`.
- Rotar `VERCEL_TOKEN` si se expone: Vercel → Account Settings → Tokens.
- No agregues tokens en `vercel.json`, en el workflow ni en la documentación.
