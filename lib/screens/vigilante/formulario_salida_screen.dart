import 'package:flutter/material.dart';
import '../../app_theme.dart';

class FormularioSalidaScreen extends StatefulWidget {
  const FormularioSalidaScreen({super.key});

  @override
  State<FormularioSalidaScreen> createState() => _FormularioSalidaScreenState();
}

class _FormularioSalidaScreenState extends State<FormularioSalidaScreen> {
  final _placaController = TextEditingController();
  Map<String, dynamic>? _vehiculoEncontrado;
  bool _buscando = false;

  final List<Map<String, dynamic>> _vehiculosActivos = [
    {"placa": "ABC-123", "tipo": "Carro", "zona": "Torre A - Piso 1", "celda": "A-01", "hora": DateTime.now().subtract(const Duration(hours: 2, minutes: 15))},
    {"placa": "XYZ-89", "tipo": "Moto", "zona": "Sótano 1 - General", "celda": "S1-02", "hora": DateTime.now().subtract(const Duration(minutes: 40))},
    {"placa": "JKL-456", "tipo": "Camioneta", "zona": "Torre A - Piso 2", "celda": "B-04", "hora": DateTime.now().subtract(const Duration(hours: 5))},
  ];

  void _buscarVehiculo() async {
    setState(() {
      _buscando = true;
      _vehiculoEncontrado = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));

    final placa = _placaController.text.trim().toUpperCase();
    final encontrado = _vehiculosActivos.where((v) => v["placa"] == placa).toList();

    setState(() {
      _buscando = false;
      _vehiculoEncontrado = encontrado.isNotEmpty ? encontrado.first : {};
    });
  }

  String _duracion(DateTime entrada) {
    final diff = DateTime.now().difference(entrada);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return h > 0 ? "${h}h ${m}min" : "${m}min";
  }

  void _confirmarSalida() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 28),
            SizedBox(width: 10),
            Text("Salida Registrada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: Text("El vehículo ${_vehiculoEncontrado!["placa"]} salió del parqueadero."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _vehiculoEncontrado = null;
                _placaController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Aceptar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.accent,
        elevation: 0,
        title: const Text("Registrar Salida", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _placaController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: AppTheme.inputStyle("Placa a buscar", Icons.search_rounded),
                          onSubmitted: (_) => _buscarVehiculo(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 52,
                        width: 52,
                        child: ElevatedButton(
                          onPressed: _buscando ? null : _buscarVehiculo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _buscando
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (_vehiculoEncontrado != null && _vehiculoEncontrado!.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppTheme.accent),
                        SizedBox(width: 12),
                        Expanded(child: Text("No se encontró un vehículo activo con esa placa.", style: TextStyle(color: AppTheme.textDark, fontSize: 13))),
                      ],
                    ),
                  ),

                if (_vehiculoEncontrado != null && _vehiculoEncontrado!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.cardShadow,
                      border: Border.all(color: AppTheme.success.withOpacity(0.3), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.15), shape: BoxShape.circle),
                              child: const Icon(Icons.directions_car_rounded, color: AppTheme.success),
                            ),
                            const SizedBox(width: 12),
                            Text(_vehiculoEncontrado!["placa"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          ],
                        ),
                        const Divider(height: 28),
                        _infoRow("Tipo de vehículo", _vehiculoEncontrado!["tipo"]),
                        _infoRow("Zona", _vehiculoEncontrado!["zona"]),
                        _infoRow("Celda", _vehiculoEncontrado!["celda"]),
                        _infoRow("Tiempo dentro", _duracion(_vehiculoEncontrado!["hora"])),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _confirmarSalida,
                            icon: const Icon(Icons.logout_rounded, color: Colors.white),
                            label: const Text("Confirmar Salida", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
