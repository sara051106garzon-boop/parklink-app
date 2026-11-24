# Despliegue de ParkLink Frontend en Vercel

Este repositorio es una app **Flutter** (móvil y web), no un proyecto Vite/React.
El despliegue en Vercel publica la compilación de **Flutter Web** (`build/web`).

## 1. Piezas del despliegue

| Archivo | Para qué sirve |
| :--- | :--- |
| `lib/config/api_config.dart` | Lee `API_BASE_URL` con `String.fromEnvironment` y centraliza las URLs de la API. |
| `vercel.json` | Build, salida `build/web`, rewrites de SPA, cabeceras y bloqueo del build automático de Git. |
| `scripts/vercel-build.sh` | Instala Flutter si no existe (build nativo de Vercel) y ejecuta `flutter build web --release --dart-define=API_BASE_URL=...`. |
| `.github/workflows/deploy-vercel.yml` | CI/CD con GitHub Actions: `main` → Production, Pull Request → Preview, ejecución manual → entorno elegido. |
| `.env.example` | Referencia de valores. **Flutter no lee `.env` automáticamente.** |

La variable `API_BASE_URL` debe ser la raíz del back-end, **sin** `/api` al final.
`AuthService` agrega `/api/auth/login`.

## 2. Variables de entorno en Vercel

Configúralas en **Vercel → Project → Settings → Environment Variables**:

| Entorno de Vercel | Cuándo se usa | `API_BASE_URL` |
| :--- | :--- | :--- |
| **Production** | Push a `main` / deploy de producción | `http://3.138.221.70:8001` |
| **Preview** | Pull Requests y ramas de prueba (staging) | `http://3.138.221.70:8000` |
| **Development** (opcional) | Solo para pruebas locales con `vercel dev` | `http://127.0.0.1:5000` |

No marques `API_BASE_URL` como secreta: es una URL pública. No la escribas en el
repositorio.

También puedes crearlas desde la CLI (te pedirá el valor, no queda en Git):

```bash
npx vercel env add API_BASE_URL production
npx vercel env add API_BASE_URL preview
```

> **Importante:** `API_BASE_URL` debe existir en el entorno correcto. Si falta en
> un build de Vercel, `scripts/vercel-build.sh` falla a propósito para no publicar
> una app apuntando a `localhost`.

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
   - Pull Request hacia `main` → deploy de **Preview** (staging).
   - **Run workflow** manual → eliges `preview` o `production`.

   Los secretos nunca se imprimen en logs. Si un PR viene de un fork, el job se
   omite porque GitHub no entrega secretos a forks.

### Opción alternativa: build nativo de Vercel (sin GitHub Actions)

Si prefieres que Vercel compile en cada push:

1. Elimina el bloque `"git": { "deploymentEnabled": false }` de `vercel.json`
   (o cámbialo a `true`).
2. Conecta el repositorio en Vercel y deja el preset **Other**.
3. `scripts/vercel-build.sh` detecta que Flutter no está instalado y lo
   descarga automáticamente. El build tarda más la primera vez.
4. No actives también el workflow, para no desplegar dos veces.

## 4. CORS en el back-end (EC2, puertos 8000 y 8001)

El back-end Flask usa `Flask-CORS` y `Flask-SocketIO` con los orígenes de la
variable `CORS_ORIGINS` (`app/config/settings.py`). Por defecto solo permite
`http://localhost:5173` y `http://127.0.0.1:5173`, por lo que **el dominio de
Vercel debe agregarse en cada entorno de EC2**:

```env
# .env del back-end de STAGING (EC2, puerto 8000)
CORS_ORIGINS=https://parklink-app.vercel.app,https://parklink-app-git-main-TU-EQUIPO.vercel.app,https://parklink-app-git-staging-TU-EQUIPO.vercel.app

# .env del back-end de PRODUCCIÓN (EC2, puerto 8001)
CORS_ORIGINS=https://parklink-app.vercel.app,https://parklink-app-git-main-TU-EQUIPO.vercel.app
```

- Usa los dominios reales que muestre Vercel (Project → Domains).
- No uses `*`: el backend configura `supports_credentials=True` y los
  navegadores rechazan `Access-Control-Allow-Origin: *` con credenciales.
- Los **Preview Deployments** reciben una URL distinta en cada PR
  (`parklink-app-<hash>-<equipo>.vercel.app`). Para que funcionen contra staging,
  asigna un dominio/alias estable de preview en Vercel y agrégalo a `CORS_ORIGINS`,
  o agrega temporalmente la URL del preview que estés probando.
- `CORS_ORIGINS` también se usa para WebSockets, así que deben ser orígenes
  exactos.
- Después de editar el `.env` del servidor, recrea el contenedor para que tome
  la variable:

  ```bash
  docker compose up -d --force-recreate web
  ```

- Verifica el preflight desde tu máquina:

  ```bash
  curl -i -X OPTIONS "http://3.138.221.70:8000/api/auth/login" \
    -H "Origin: https://TU-DOMINIO.vercel.app" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: content-type"
  ```

  Debe responder `200`/`204` con
  `Access-Control-Allow-Origin: https://TU-DOMINIO.vercel.app`.

- El Security Group de EC2 debe permitir los puertos `8000` y `8001` (idealmente
  solo desde las IPs necesarias; Vercel no tiene IPs fijas de salida).

> Si al abrir un Preview Deployment Vercel pide iniciar sesión, revisa
> **Settings → Deployment Protection** y desactiva la protección para previews
> (o usa un dominio de preview accesible) antes de probar el CORS.

## 5. HTTPS y contenido mixto (crítico)

Vercel publica el frontend por **HTTPS**. Si `API_BASE_URL` apunta a
`http://3.138.221.70:8000` o `:8001`, el navegador bloqueará las peticiones por
**contenido mixto** y verás errores de red/CORS aunque el backend esté bien.

Para producción, expón el backend por HTTPS. Ejemplo con Caddy en la misma EC2:

```caddyfile
api-staging.tudominio.com {
    reverse_proxy 127.0.0.1:8000
}

api.tudominio.com {
    reverse_proxy 127.0.0.1:8001
}
```

Luego cambia las variables en Vercel:

```env
# Preview
API_BASE_URL=https://api-staging.tudominio.com

# Production
API_BASE_URL=https://api.tudominio.com
```

Y agrega los dominios de Vercel a `CORS_ORIGINS`. Un túnel (Cloudflare Tunnel,
ngrok) sirve para una demo, pero no como solución permanente.

## 6. Probar el build en local

```powershell
flutter --version
flutter pub get
flutter analyze
flutter test

# Build de staging (PowerShell)
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8000

# Build de producción
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8001
```

El resultado queda en `build\web`. Para revisar que la URL se inyectó:

```powershell
Select-String -Path build\web\main.dart.js -Pattern "3.138.221.70:8000"
```

Servir el build localmente (usa el puerto 5173 para coincidir con el CORS por
defecto del backend):

```powershell
cd build\web
python -m http.server 5173
```

Abre `http://localhost:5173`.

También puedes probar el script tal como lo ejecuta Vercel (Git Bash o WSL):

```bash
API_BASE_URL=http://3.138.221.70:8000 bash scripts/vercel-build.sh
```

## 7. Verificar el despliegue

1. **GitHub Actions**: en la pestaña Actions debe aparecer el workflow
   **Deploy a Vercel** en verde.

   ```bash
   gh run list --workflow "Deploy a Vercel"
   gh run watch
   ```

   El resumen del run muestra la URL publicada.

2. **Vercel**: revisa el deployment en el dashboard o con la CLI:

   ```bash
   npx vercel ls
   npx vercel inspect <URL-DEL-DEPLOY>
   ```

3. **HTTP**: la raíz y una ruta interna deben responder `200` (rewrite de SPA):

   ```bash
   curl -I https://TU-DOMINIO.vercel.app
   curl -I https://TU-DOMINIO.vercel.app/login
   ```

4. **Aplicación**: abre la URL, inicia sesión y revisa en DevTools → Network que
   las peticiones van al host y puerto correctos (`8000` en Preview, `8001` en
   Production) y que el preflight OPTIONS responde con el origen permitido.

5. **Logs**: en Vercel → Deployment → Logs, o `npx vercel logs <URL>`, no debe
   haber errores de build.

## 8. Seguridad de credenciales

- `VERCEL_TOKEN`, `VERCEL_ORG_ID` y `VERCEL_PROJECT_ID` viven únicamente en
  **GitHub Secrets**.
- `.env`, `.env.*` (excepto `.env.example`), `.vercel/`, `*.pem` y `*.key` están
  en `.gitignore`.
- Rotar `VERCEL_TOKEN` si se expone: Vercel → Account Settings → Tokens.
- No agregues tokens en `vercel.json`, en el workflow ni en la documentación.
