import 'package:flutter/material.dart';
import '../../app_theme.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({Key? key}) : super(key: key);

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  String _filtroEstado = "Todas";
  String _busqueda = "";

  final List<Map<String, String>> _historialOriginal = const [
    {
      "id": "RES-8841",
      "celda": "Celda A-12",
      "tipo": "Carro",
      "placa": "ABC-123",
      "fecha": "06 Sep 2026",
      "horario": "08:00 AM - 05:00 PM",
      "duracion": "9 hrs",
      "estado": "Completada",
      "sede": "Sede Principal Redeban",
    },
    {
      "id": "RES-8710",
      "celda": "Celda M-04",
      "tipo": "Moto",
      "placa": "XYZ-987",
      "fecha": "04 Sep 2026",
      "horario": "07:30 AM - 04:30 PM",
      "duracion": "9 hrs",
      "estado": "Completada",
      "sede": "Sede Principal Redeban",
    },
    {
      "id": "RES-8592",
      "celda": "Celda A-08",
      "tipo": "Carro",
      "placa": "ABC-123",
      "fecha": "01 Sep 2026",
      "horario": "09:00 AM - 01:00 PM",
      "duracion": "4 hrs",
      "estado": "Cancelada",
      "sede": "Sede Principal Redeban",
    },
    {
      "id": "RES-8201",
      "celda": "Celda A-05",
      "tipo": "Carro",
      "placa": "ABC-123",
      "fecha": "28 Ago 2026",
      "horario": "08:00 AM - 06:00 PM",
      "duracion": "10 hrs",
      "estado": "Completada",
      "sede": "Sede Principal Redeban",
    },
  ];

  List<Map<String, String>> get _historialFiltrado {
    return _historialOriginal.where((item) {
      bool coincideEstado = _filtroEstado == "Todas" || item["estado"] == _filtroEstado;
      bool coincideBusqueda = _busqueda.isEmpty ||
          item["celda"]!.toLowerCase().contains(_busqueda.toLowerCase()) ||
          item["placa"]!.toLowerCase().contains(_busqueda.toLowerCase()) ||
          item["id"]!.toLowerCase().contains(_busqueda.toLowerCase());
      return coincideEstado && coincideBusqueda;
    }).toList();
  }

  void _mostrarDetalleReserva(Map<String, String> item) {
    bool completada = item["estado"] == "Completada";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Detalle de Reserva #${item['id']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (completada ? AppTheme.success : AppTheme.accent).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item["estado"]!,
                    style: TextStyle(color: completada ? AppTheme.success : AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _infoRow(Icons.local_parking_rounded, "Celda Asignada", item["celda"]!),
            _infoRow(Icons.directions_car_rounded, "Vehículo registrado", "${item['tipo']} (${item['placa']})"),
            _infoRow(Icons.calendar_today_rounded, "Fecha y Horario", "${item['fecha']} • ${item['horario']}"),
            _infoRow(Icons.timer_outlined, "Duración total", item["duracion"]!),
            _infoRow(Icons.business_rounded, "Sede Corporativa", item["sede"]!),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Cerrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textMuted, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ],
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
        title: const Text("Historial de Reservas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tarjetas de Métricas (KPIs)
                      Row(
                        children: [
                          _buildKpiCard("Total Reservas", "4", Icons.receipt_long_rounded, AppTheme.primary),
                          const SizedBox(width: 12),
                          _buildKpiCard("Horas Parklink", "32 hrs", Icons.access_time_filled_rounded, Colors.orange),
                          const SizedBox(width: 12),
                          _buildKpiCard("Efectividad", "75%", Icons.verified_rounded, AppTheme.success),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Buscador y Filtros
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
                        child: Column(
                          children: [
                            // Campo de Búsqueda
                            TextField(
                              onChanged: (val) => setState(() => _busqueda = val),
                              decoration: InputDecoration(
                                hintText: "Buscar por celda, placa o código...",
                                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Filtro por Estado (Chips)
                            Row(
                              children: ["Todas", "Completadas", "Canceladas"].map((estado) {
                                String estadoFiltro = estado == "Completadas" ? "Completada" : estado == "Canceladas" ? "Cancelada" : "Todas";
                                bool selected = _filtroEstado == estadoFiltro;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(estado),
                                    selected: selected,
                                    selectedColor: AppTheme.primary,
                                    labelStyle: TextStyle(
                                      color: selected ? Colors.white : AppTheme.textDark,
                                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                    backgroundColor: Colors.grey[100],
                                    onSelected: (bool isSelected) {
                                      if (isSelected) {
                                        setState(() {
                                          _filtroEstado = estadoFiltro;
                                        });
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Listado de Historial
                      if (_historialFiltrado.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.history_toggle_off_rounded, size: 54, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                const Text("No se encontraron reservas con esos filtros", style: TextStyle(color: AppTheme.textMuted)),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _historialFiltrado.length,
                          itemBuilder: (context, index) {
                            final item = _historialFiltrado[index];
                            bool completada = item["estado"] == "Completada";
                            bool esCarro = item["tipo"] == "Carro";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppTheme.cardShadow,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: () => _mostrarDetalleReserva(item),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Row(
                                      children: [
                                        // Icono de vehículo
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: (completada ? AppTheme.primary : Colors.grey).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Icon(
                                            esCarro ? Icons.directions_car_rounded : Icons.two_wheeler_rounded,
                                            color: completada ? AppTheme.primary : AppTheme.textMuted,
                                            size: 26,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Datos principales
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(item["celda"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)),
                                                  const SizedBox(width: 8),
                                                  Text("#${item['id']}", style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.calendar_month_outlined, size: 14, color: AppTheme.textMuted),
                                                  const SizedBox(width: 4),
                                                  Text("${item['fecha']}  •  Placa: ${item['placa']}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Estado & Flecha
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: (completada ? AppTheme.success : AppTheme.accent).withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                item["estado"]!,
                                                style: TextStyle(
                                                  color: completada ? AppTheme.success : AppTheme.accent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            const Row(
                                              children: [
                                                Text("Ver detalles", style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                                                Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.primary),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}