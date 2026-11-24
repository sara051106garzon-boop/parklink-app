import 'package:flutter/foundation.dart';

/// Configuración central de la API de ParkLink.
///
/// La URL del back-end se inyecta en tiempo de compilación con:
///
/// ```bash
/// flutter build web --release \
///   --dart-define=API_BASE_URL=http://3.138.221.70:8001
/// ```
///
/// En Vercel la variable `API_BASE_URL` se configura por entorno
/// (Preview = staging 8000, Production = 8001) y el workflow la pasa al build.
///
/// Si no se define `API_BASE_URL`, se usan valores seguros para desarrollo
/// local: `127.0.0.1:5000` en web/escritorio y `10.0.2.2:5000` en el emulador
/// Android.
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
