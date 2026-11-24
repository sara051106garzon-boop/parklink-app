import 'package:flutter/foundation.dart';

/// Configuración central de la API de ParkLink.
///
/// Resolución de la URL base (siempre **sin** barra final):
///
/// 1. Si se define `API_BASE_URL` en tiempo de compilación
///    (`--dart-define=API_BASE_URL=...`), se usa ese valor como override.
/// 2. En **web** (producción/preview en Vercel) se usa [Uri.base.origin], es
///    decir, el mismo origen HTTPS desde el que se cargó la app
///    (`https://parklink-app.vercel.app`). Vercel reenvía `/api/*` al back-end
///    de EC2 mediante `vercel.json`; así se eliminan el Mixed Content y el CORS
///    (la app nunca llama directo a `http://3.138.221.70:8001` desde el
///    navegador).
/// 3. En emulador Android, `http://10.0.2.2:5000`.
/// 4. En escritorio local, `http://127.0.0.1:5000`.
///
/// Los endpoints finales quedan como `https://parklink-app.vercel.app/api/...`
/// y **nunca** como `/api/api/...`: `uri('/api/auth/login')` antepone la base
/// sin agregar un segundo `/api`.
class ApiConfig {
  ApiConfig._();

  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL');

  static const String _localBaseUrl = 'http://127.0.0.1:5000';
  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:5000';

  /// URL base del back-end, sin barra final.
  static String get baseUrl {
    final configured = _configuredBaseUrl.trim();
    if (configured.isNotEmpty) {
      return _normalize(configured);
    }

    // En web, las peticiones van al mismo origen; Vercel hace el proxy a EC2.
    if (kIsWeb) {
      final origin = _normalize(Uri.base.origin);
      if (origin.isNotEmpty) {
        return origin;
      }
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulatorBaseUrl;
    }

    return _localBaseUrl;
  }

  /// Indica si la URL vino de `--dart-define=API_BASE_URL=...`.
  static bool get isConfigured => _configuredBaseUrl.trim().isNotEmpty;

  /// URL base del módulo de autenticación.
  static String get authBaseUrl => '$baseUrl/api/auth';

  /// Construye una URL absoluta para un endpoint, por ejemplo `/api/auth/login`.
  static Uri uri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalizedPath');
  }

  static String _normalize(String value) {
    var normalized = value.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
