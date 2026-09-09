import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'formulario_entrada_screen.dart';
import 'formulario_salida_screen.dart';
import 'mapa_grafico_screen.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  final List<Map<String, dynamic>> _zonas = const [
    {"nombre": "Torre A - Piso 1", "ocupadas": 7, "total": 9},
    {"nombre": "Torre A - Piso 2", "ocupadas": 4, "total": 6},
    {"nombre": "Sótano 1 - General", "ocupadas": 2, "total": 4},
    {"nombre": "Sótano 2 - VIP", "ocupadas": 1, "total": 2},
  ];

  @override
  Widget build(BuildContext context) {
    int totalOcupadas = _zonas.fold(0, (sum, z) => sum + (z["ocupadas"] as int));
    int totalCeldas = _zonas.fold(0, (sum, z) => sum + (z["total"] as int));
    double porcentaje = totalCeldas == 0 ? 0 : totalOcupadas / totalCeldas;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text("Panel de Control", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta general de ocupación
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.primaryDark, AppTheme.primary]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ocupación General", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text("$totalOcupadas / $totalCeldas celdas", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: porcentaje,
                          minHeight: 10,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(porcentaje > 0.85 ? AppTheme.accent : Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("${(porcentaje * 100).toStringAsFixed(0)}% de ocupación", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Accesos rápidos
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(context, "Registrar\nEntrada", Icons.login_rounded, AppTheme.success, const FormularioEntradaScreen()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(context, "Registrar\nSalida", Icons.logout_rounded, AppTheme.accent, const FormularioSalidaScreen()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(context, "Mapa\nGráfico", Icons.grid_view_rounded, AppTheme.primary, const MapaGraficoScreen()),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const Text("Ocupación por Zona", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const SizedBox(height: 14),
                ..._zonas.map((z) {
                  double pct = (z["ocupadas"] as int) / (z["total"] as int);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(z["nombre"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTheme.textDark)),
                            Text("${z["ocupadas"]}/${z["total"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(pct > 0.8 ? AppTheme.accent : AppTheme.success),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickAction(BuildContext context, String label, IconData icon, Color color, Widget destino) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destino)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
            ],
          ),
        ),
      ),
    );
  }
}
