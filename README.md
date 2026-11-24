<div align="center">

# ParkLink — App Móvil

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-yellow.svg)](LICENSE)

Aplicación móvil de **ParkLink** para la gestión de parqueaderos: control de
entrada y salida de vehículos, reservas de cupos, turnos de vigilancia y
panel administrativo con indicadores.

</div>

---

## Descripción

La app consume la API REST del back-end de ParkLink y adapta la interfaz según el
**rol del usuario autenticado**. Está construida con Flutter y organizada por
módulos: cada rol tiene su propio conjunto de pantallas.

## Roles y pantallas

| Rol | Módulo | Pantallas principales |
| :--- | :--- | :--- |
| **Usuario** | `lib/screens/user/` | Inicio, perfil, vehículos, reservas, historial, notificaciones, semáforo de ocupación, ayuda |
| **Vigilante** | `lib/screens/vigilante/` | Apertura y cierre de turno, registro de entrada y salida, visitantes, novedades, historial del turno, mapa de celdas |
| **Administrador** | `lib/screens/admin/` | Dashboard, KPIs, tendencias, usuarios, vehículos, cupos, alertas, reportes, logs, configuración |
| **Común** | `lib/screens/` | Inicio de sesión, tema global (`app_theme.dart`) |

## Estructura del proyecto

```
lib/
├── main.dart                 Punto de entrada
├── app_theme.dart            Tema y estilos globales
├── config/
│   └── api_config.dart       URL base de la API (API_BASE_URL)
├── screens/
│   ├── login_screen.dart
│   ├── admin/                Panel administrativo (11 pantallas)
│   ├── user/                 Módulo de usuario (9 pantallas)
│   └── vigilante/            Módulo de vigilancia (14 pantallas)
└── services/
    └── auth_service.dart     Autenticación contra la API
```

## Requisitos

- Flutter 3.x y Dart 3.x
- Back-end de ParkLink en ejecución (por defecto `http://127.0.0.1:5000`)

## Cómo ejecutarla

```bash
flutter pub get
flutter run                 # elige un emulador o dispositivo conectado

# Otros destinos
flutter run -d chrome
flutter run -d windows
```

## Configuración del back-end (`API_BASE_URL`)

La URL base de la API se lee en tiempo de compilación desde la variable
`API_BASE_URL` (ver `lib/config/api_config.dart`). No hay URLs hardcodeadas en
los servicios:

```bash
# Desarrollo local (valor por defecto si no se define la variable)
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000

# Emulador Android
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000

# Back-end de staging en EC2
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8000

# Back-end de producción en EC2
flutter build web --release --dart-define=API_BASE_URL=http://3.138.221.70:8001
```

Sin `--dart-define`, la app usa `http://127.0.0.1:5000` (web/escritorio) o
`http://10.0.2.2:5000` (emulador Android). `.env.example` documenta los valores;
Flutter **no** carga archivos `.env` automáticamente.

> El frontend en Vercel se sirve por HTTPS. Un back-end `http://` provoca
> bloqueo por contenido mixto en el navegador. Lee la sección de HTTPS en
> [`DEPLOY.md`](DEPLOY.md) antes de publicar.

## Despliegue en Vercel

El repositorio ya incluye:

- `vercel.json` — build de Flutter Web, rewrites para SPA y cabeceras.
- `scripts/vercel-build.sh` — instala Flutter (si hace falta) y compila `build/web`.
- `.github/workflows/deploy-vercel.yml` — CI/CD con GitHub Actions y Vercel CLI.

Los pasos completos (variables por entorno, GitHub Secrets, CORS en EC2 y
verificación) están en [`DEPLOY.md`](DEPLOY.md).

## Pruebas

```bash
flutter test
```

## Repositorios relacionados

- Back-end (API REST): [parklink-backend](https://github.com/sara051106garzon-boop/parklink-backend)

## Autor

**Sara Garzón** · [github.com/sara051106garzon-boop](https://github.com/sara051106garzon-boop)

## Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).
