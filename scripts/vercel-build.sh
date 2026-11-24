#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Build de Flutter Web para Vercel (o para CI).
#
# Uso local:
#   API_BASE_URL=http://3.138.221.70:8000 bash scripts/vercel-build.sh
#
# En Vercel, API_BASE_URL se toma de las Environment Variables del proyecto
# (Preview = staging, Production = producciÃ³n). Si no estÃ¡ definida en un
# build de Vercel, el script falla para evitar publicar una app apuntando a
# localhost.
# ---------------------------------------------------------------------------
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.50.1}"
FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"

if [ -z "${API_BASE_URL:-}" ]; then
  if [ "${VERCEL:-0}" = "1" ]; then
    echo "ERROR: API_BASE_URL no estÃ¡ configurada en Vercel." >&2
    echo "ConfigÃºrala en Settings > Environment Variables para Preview y Production." >&2
    exit 1
  fi
  API_BASE_URL="http://127.0.0.1:5000"
fi

# Quita barras finales para evitar URLs del tipo http://host:8000//api/auth/login
while [ "${API_BASE_URL%/}" != "$API_BASE_URL" ]; do
  API_BASE_URL="${API_BASE_URL%/}"
done

API_BASE_URL="$(printf '%s' "$API_BASE_URL" | tr -d '\r\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")"
case "$API_BASE_URL" in
  http://*|https://*) ;;
  *)
    echo "ERROR: API_BASE_URL debe empezar por http:// o https:// (valor: $API_BASE_URL)" >&2
    exit 1
    ;;
esac

if [ "${API_BASE_URL#http://}" != "$API_BASE_URL" ] && [ "${VERCEL:-0}" = "1" ]; then
  echo "ADVERTENCIA: el frontend se sirve por HTTPS y API_BASE_URL usa HTTP." >&2
  echo "Los navegadores bloquearÃ¡n las llamadas por contenido mixto. Usa HTTPS en el back-end." >&2
fi

export PATH="$FLUTTER_HOME/bin:$PATH"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter no estÃ¡ instalado. Descargando Flutter $FLUTTER_VERSION en $FLUTTER_HOME..."
  rm -rf "$FLUTTER_HOME"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_HOME"
  export PATH="$FLUTTER_HOME/bin:$PATH"
fi

flutter --version
flutter config --enable-web >/dev/null 2>&1 || true
flutter --disable-analytics >/dev/null 2>&1 || true
flutter pub get
flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"

echo "Build listo en build/web (API_BASE_URL=$API_BASE_URL)"
