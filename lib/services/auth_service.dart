import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Resultado de un intento de autenticación contra el back-end de ParkLink.
class AuthResult {
  const AuthResult({
    required this.ok,
    this.mensaje,
    this.token,
    this.rol,
    this.nombre,
  });

  final bool ok;
  final String? mensaje;
  final String? token;
  final String? rol;
  final String? nombre;
}

class AuthService {
  /// Inicia sesión contra `POST /api/auth/login`.
  ///
  /// El back-end acepta `correo`/`email` y `password`/`contrasena`; se envía
  /// `correo` + `password`. Devuelve `AuthResult.ok == true` en caso de éxito,
  /// junto con el token JWT y el rol (`usuario`, `vigilante` o `administrador`).
  static Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http
          .post(
            ApiConfig.uri('/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final usuario =
            (data['usuario'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
        final rol = (usuario['rol'] ?? data['rol'] ?? 'usuario')
            .toString()
            .toLowerCase();

        return AuthResult(
          ok: true,
          token: (data['access_token'] ?? data['token'])?.toString(),
          rol: rol,
          nombre: usuario['nombre_completo']?.toString(),
        );
      }

      // 401 (credenciales), 403 (cuenta inactiva), etc.
      var mensaje = 'Credenciales inválidas.';
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final backendMessage = data['mensaje']?.toString();
        if (backendMessage != null && backendMessage.isNotEmpty) {
          mensaje = backendMessage;
        }
      } catch (_) {
        // El cuerpo no era JSON; se conserva el mensaje genérico.
      }

      return AuthResult(ok: false, mensaje: mensaje);
    } catch (_) {
      return AuthResult(
        ok: false,
        mensaje: 'No se pudo conectar con el servidor.',
      );
    }
  }
}
