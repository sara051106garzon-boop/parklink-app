#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Build de Flutter Web para Vercel (o para CI).
#
# Con el proxy inverso de Vercel (vercel.json), el frontend web llama a su
# MISMO origen (/api/...) y Vercel reenvía al back-end de EC2. Por eso, en los
# builds de Vercel NO se define API_BASE_URL: ApiConfig usa Uri.base.origin.
#
# API_BASE_URL (--dart-define) queda como override OPCIONAL, por ejemplo para
# builds móviles/desktop o desarrollo local directo:
#   API_BASE_URL=http://3.138.221.70:8001 bash scripts/vercel-build.sh
# ---------------------------------------------------------------------------
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.50.1}"
FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"

BUILD_ARGS=()

if [ -n "${API_BASE_URL:-}" ]; then
  # Limpieza defensiva: quita comillas, saltos de línea y espacios sobrantes.
  API_BASE_URL="$(printf '%s' "$API_BASE_URL" | tr -d '\r\n' \
    | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' \
          -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")"

  # Quita barras finales para evitar URLs del tipo http://host:8000//api/...
  while [ "${API_BASE_URL%/}" != "$API_BASE_URL" ]; do
    API_BASE_URL="${API_BASE_URL%/}"
  done

  case "$API_BASE_URL" in
    http://*|https://*) ;;
    *)
      echo "ERROR: API_BASE_URL debe empezar por http:// o https:// (valor: $API_BASE_URL)" >&2
      exit 1
      ;;
  esac

  if [ "${API_BASE_URL#http://}" != "$API_BASE_URL" ] && [ "${VERCEL:-0}" = "1" ]; then
    echo "ADVERTENCIA: se inyecta API_BASE_URL con HTTP en un build de Vercel." >&2
    echo "El proxy de Vercel solo actúa cuando la app llama a su mismo origen." >&2
  fi

  BUILD_ARGS=(--dart-define=API_BASE_URL="$API_BASE_URL")
  echo "Build con API_BASE_URL=$API_BASE_URL (override explícito)."
else
  echo "API_BASE_URL no definida: en web se usará Uri.base.origin (proxy de Vercel)."
fi

export PATH="$FLUTTER_HOME/bin:$PATH"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter no está instalado. Descargando Flutter $FLUTTER_VERSION en $FLUTTER_HOME..."
  rm -rf "$FLUTTER_HOME"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_HOME"
  export PATH="$FLUTTER_HOME/bin:$PATH"
fi

flutter --version
flutter config --enable-web >/dev/null 2>&1 || true
flutter --disable-analytics >/dev/null 2>&1 || true
flutter pub get
flutter build web --release "${BUILD_ARGS[@]}"

echo "Build listo en build/web"
