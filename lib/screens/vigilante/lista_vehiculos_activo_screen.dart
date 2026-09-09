import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'formulario_salida_screen.dart';

class ListaVehiculosActivoScreen extends StatefulWidget {
  const ListaVehiculosActivoScreen({super.key});

  @override
  State<ListaVehiculosActivoScreen> createState() => _ListaVehiculosActivoScreenState();
}

class _ListaVehiculosActivoScreenState extends State<ListaVehiculosActivoScreen> {
  final _busquedaController = TextEditingController();

  final List<Map<String, dynamic>> _vehiculos = [
    {"placa": "ABC-123", "tipo": "Carro", "zona": "Torre A - Piso 1", "celda": "A-01", "hora": DateTime.now().subtract(const Duration(hours: 2, minutes: 15))},
    {"placa": "XYZ-89", "tipo": "Moto", "zona": "Sótano 1 - General", "celda": "S1-02", "hora": DateTime.now().subtract(const Duration(minutes: 40))},
    {"placa": "JKL-456", "tipo": "Camioneta", "zona": "Torre A - Piso 2", "celda": "B-04", "hora": DateTime.now().subtract(const Duration(hours: 5))},
    {"placa": "MNP-321", "tipo": "Carro", "zona": "Sótano 2 - VIP", "celda": "VIP-02", "hora": DateTime.now().subtract(const Duration(hours: 1, minutes: 10))},
  ];

  IconData _iconoTipo(String tipo) {
    switch (tipo) {
      case "Moto":
        return Icons.two_wheeler_rounded;
      case "Camioneta":
        return Icons.airport_shuttle_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  String _duracion(DateTime entrada) {
    final diff = DateTime.now().difference(entrada);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return h > 0 ? "${h}h ${m}min" : "${m}min";
  }

  @override
  Widget build(BuildContext context) {
    final filtro = _busquedaController.text.trim().toUpperCase();
    final vehiculosFiltrados = filtro.isEmpty ? _vehiculos : _vehiculos.where((v) => (v["placa"] as String).contains(filtro)).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text("Vehículos Activos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _busquedaController,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() {}),
                  decoration: AppTheme.inputStyle("Buscar por placa...", Icons.search_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("${vehiculosFiltrados.length} vehículos dentro", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: vehiculosFiltrados.isEmpty
                    ? const Center(child: Text("No se encontraron vehículos", style: TextStyle(color: AppTheme.textMuted)))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: vehiculosFiltrados.length,
                        itemBuilder: (context, index) {
                          final v = vehiculosFiltrados[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppTheme.cardShadow,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                                  child: Icon(_iconoTipo(v["tipo"] as String), color: AppTheme.primary),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(v["placa"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                                      const SizedBox(height: 2),
                                      Text("${v["zona"]} · Celda ${v["celda"]}", style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule, size: 12, color: AppTheme.textMuted),
                                          const SizedBox(width: 4),
                                          Text(_duracion(v["hora"] as DateTime), style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.logout_rounded, color: AppTheme.accent),
                                  tooltip: "Registrar salida",
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FormularioSalidaScreen()));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
