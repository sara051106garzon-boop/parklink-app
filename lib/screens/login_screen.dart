import 'package:flutter/material.dart';
import '../../app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulación de respuesta de autenticación
      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/user/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryDark,
              AppTheme.primary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Container(
              // Limita el ancho máximo para evitar que se distorsione en web
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(36.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono de la marca
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_parking_rounded,
                        size: 52,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Título y Subtítulo
                    const Text(
                      "Parklink",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Gestión de Parqueaderos Redeban",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo de Correo
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 15, color: AppTheme.textDark),
                      decoration: AppTheme.inputStyle(
                        "Correo corporativo",
                        Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu correo";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Campo de Contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontSize: 15, color: AppTheme.textDark),
                      decoration: AppTheme.inputStyle(
                        "Contraseña",
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.textMuted,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu contraseña";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Opción de recuperación
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de Iniciar Sesión
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          elevation: 3,
                          shadowColor: AppTheme.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Iniciar Sesión",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}