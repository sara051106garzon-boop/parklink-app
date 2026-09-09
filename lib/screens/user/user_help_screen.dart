import 'package:flutter/material.dart';
import '../../app_theme.dart';

class UserHelpScreen extends StatefulWidget {
  const UserHelpScreen({Key? key}) : super(key: key);

  @override
  State<UserHelpScreen> createState() => _UserHelpScreenState();
}

class _UserHelpScreenState extends State<UserHelpScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = "";

  final List<Map<String, String>> _faqs = [
    {
      "pregunta": "¿Cómo cancelar mi reserva?",
      "respuesta": "Ingresa a 'Mis Reservas', selecciona la reserva activa que deseas cancelar y presiona el botón 'Cancelar Reserva'. Recuerda hacerlo con al menos 15 minutos de anticipación.",
      "categoria": "Reservas"
    },
    {
      "pregunta": "¿Qué hago si mi celda asignada está ocupada?",
      "respuesta": "Si al llegar encuentras tu celda ocupada por otro vehículo, presiona el botón 'Reportar Incidencia' en la app para asignarte una nueva celda de inmediato y notificar a la administración.",
      "categoria": "Celdas"
    },
    {
      "pregunta": "¿Cuántos vehículos puedo tener activos?",
      "respuesta": "Puedes registrar hasta 2 vehículos (Carro o Moto) en tu perfil de Redeban, pero solo uno puede mantener una reserva activa al mismo tiempo.",
      "categoria": "Cuenta"
    },
    {
      "pregunta": "¿Cuál es el horario de atención del parqueadero?",
      "respuesta": "El parqueadero de la Sede Principal opera de Lunes a Viernes de 06:00 AM a 09:00 PM. Fuera de este horario el acceso requiere autorización previa.",
      "categoria": "Horarios"
    },
    {
      "pregunta": "¿Qué ocurre si excedo el tiempo de reserva?",
      "respuesta": "Recibirás una notificación de advertencia en la app. Exceder el tiempo sin justificación puede penalizar la prioridad de tus próximas reservas.",
      "categoria": "Sanciones"
    },
  ];

  List<Map<String, String>> get _faqsFiltradas {
    if (_query.isEmpty) return _faqs;
    return _faqs.where((faq) {
      final p = faq["pregunta"]!.toLowerCase();
      final r = faq["respuesta"]!.toLowerCase();
      return p.contains(_query.toLowerCase()) || r.contains(_query.toLowerCase());
    }).toList();
  }

  void _mostrarDialogoTicket() {
    final TextEditingController asuntoCtrl = TextEditingController();
    final TextEditingController mensajeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.report_problem_rounded, color: AppTheme.accent),
            SizedBox(width: 8),
            Text("Reportar Problema", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: asuntoCtrl,
              decoration: InputDecoration(
                labelText: "Asunto / Motivo",
                prefixIcon: const Icon(Icons.subject_rounded, color: AppTheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mensajeCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Describe la situación...",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description_rounded, color: AppTheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tu reporte ha sido enviado al equipo de Soporte Redeban"),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Enviar Reporte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted), textAlign: TextAlign.center),
              ],
            ),
          ),
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
        title: const Text("Ayuda y Soporte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF1A365D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("¿En qué podemos ayudarte?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 4),
                            Text("Resuelve tus dudas rápidamente o contáctate con el equipo de soporte de Redeban.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.support_agent_rounded, size: 36, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Canales Rápidos de Contacto
                Row(
                  children: [
                    _buildContactCard("WhatsApp Soporte", "Chat en vivo", Icons.chat_rounded, Colors.green, () {}),
                    const SizedBox(width: 12),
                    _buildContactCard("Correo Soporte", "soporte@parklink.com", Icons.email_rounded, AppTheme.primary, () {}),
                    const SizedBox(width: 12),
                    _buildContactCard("Reportar Falla", "Crear Ticket", Icons.report_problem_rounded, AppTheme.accent, _mostrarDialogoTicket),
                  ],
                ),
                const SizedBox(height: 24),

                // Buscador de Preguntas
                TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _query = val),
                  decoration: InputDecoration(
                    hintText: "Buscar en preguntas frecuentes...",
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = "");
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.cardBg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
                  ),
                ),
                const SizedBox(height: 24),

                // Título Sección
                const Text("Preguntas Frecuentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const SizedBox(height: 12),

                // Lista de Acordeones
                if (_faqsFiltradas.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 50, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          const Text("No se encontraron coincidencias para tu búsqueda", style: TextStyle(color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _faqsFiltradas.length,
                    itemBuilder: (context, index) {
                      final faq = _faqsFiltradas[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.cardShadow,
                          border: Border.all(color: Colors.black.withOpacity(0.03)),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.help_outline_rounded, color: AppTheme.primary, size: 20),
                            ),
                            title: Text(
                              faq["pregunta"]!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                child: Text(
                                  faq["respuesta"]!,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}