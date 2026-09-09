import 'package:flutter/material.dart';
import '../../app_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Datos del perfil
  final TextEditingController _nombreCtrl = TextEditingController(text: "Carlos Mendoza");
  final TextEditingController _correoCtrl = TextEditingController(text: "carlos.mendoza@redeban.com");
  final TextEditingController _telefonoCtrl = TextEditingController(text: "+57 300 123 4567");
  final TextEditingController _areaCtrl = TextEditingController(text: "Tecnología & TI");
  final TextEditingController _cargoCtrl = TextEditingController(text: "Desarrollador Senior");

  // Preferencias
  bool _notifReserva = true;
  bool _notifRecordatorios = true;
  bool _modoOscuro = false;

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Perfil actualizado correctamente"),
            ],
          ),
          backgroundColor: AppTheme.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.accent),
            SizedBox(width: 8),
            Text("Cerrar Sesión"),
          ],
        ),
        content: const Text("¿Estás seguro de que deseas salir de tu cuenta Parklink?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
          filled: true,
          fillColor: enabled ? AppTheme.cardBg : Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Banner / Header de Perfil
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primary, Color(0xFF1A365D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                                  ),
                                  child: const CircleAvatar(
                                    radius: 46,
                                    backgroundColor: AppTheme.primary,
                                    child: Icon(Icons.person_rounded, size: 54, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Carlos Mendoza", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                                SizedBox(width: 6),
                                Icon(Icons.verified_rounded, size: 18, color: AppTheme.primary),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text("carlos.mendoza@redeban.com", style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Empleado Redeban • Sede Principal",
                                style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjetas de Métricas de Usuario
                Row(
                  children: [
                    _buildStatCard("Reservas", "12", Icons.event_available_rounded, AppTheme.primary),
                    const SizedBox(width: 12),
                    _buildStatCard("Vehículos", "2", Icons.directions_car_rounded, Colors.orange),
                    const SizedBox(width: 12),
                    _buildStatCard("Puntualidad", "98%", Icons.workspace_premium_rounded, AppTheme.success),
                  ],
                ),
                const SizedBox(height: 24),

                // Formulario de Información Personal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.badge_rounded, color: AppTheme.primary),
                            SizedBox(width: 8),
                            Text("Información Personal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildTextField("Nombre Completo", _nombreCtrl, Icons.person_outline_rounded),
                        _buildTextField("Correo Corporativo", _correoCtrl, Icons.email_outlined, enabled: false),
                        Row(
                          children: [
                            Expanded(child: _buildTextField("Teléfono", _telefonoCtrl, Icons.phone_outlined)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTextField("Departamento / Área", _areaCtrl, Icons.business_outlined)),
                          ],
                        ),
                        _buildTextField("Cargo", _cargoCtrl, Icons.work_outline_rounded),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _guardarCambios,
                            icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
                            label: const Text("Guardar Cambios", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Preferencias del Sistema
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune_rounded, color: AppTheme.primary),
                          SizedBox(width: 8),
                          Text("Preferencias y Notificaciones", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        ],
                      ),
                      const Divider(height: 24),
                      SwitchListTile(
                        title: const Text("Notificaciones de Reservas", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: const Text("Recibir confirmaciones cuando una reserva sea asignada", style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        value: _notifReserva,
                        activeColor: AppTheme.primary,
                        onChanged: (val) => setState(() => _notifReserva = val),
                      ),
                      SwitchListTile(
                        title: const Text("Recordatorios de Salida", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: const Text("Alertas 15 minutos antes de finalizar el tiempo de celda", style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        value: _notifRecordatorios,
                        activeColor: AppTheme.primary,
                        onChanged: (val) => setState(() => _notifRecordatorios = val),
                      ),
                      SwitchListTile(
                        title: const Text("Modo Oscuro", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: const Text("Cambiar la interfaz a tema oscuro", style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        value: _modoOscuro,
                        activeColor: AppTheme.primary,
                        onChanged: (val) => setState(() => _modoOscuro = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Botón Cerrar Sesión
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _confirmarCerrarSesion,
                    icon: const Icon(Icons.logout_rounded, color: AppTheme.accent),
                    label: const Text("Cerrar Sesión", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 15)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.accent, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}