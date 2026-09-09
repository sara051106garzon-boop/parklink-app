import 'package:flutter/material.dart';

class AdminKpisScreen extends StatefulWidget {
  const AdminKpisScreen({super.key});

  @override
  State<AdminKpisScreen> createState() => _AdminKpisScreenState();
}

class _AdminKpisScreenState extends State<AdminKpisScreen> {
  String _selectedPeriod = 'Hoy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO PRINCIPAL DE KPIS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rendimiento General del Parqueadero',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Métricas analíticas operativas en tiempo real para empleados y visitantes.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Filtro de Periodo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _selectedPeriod = newValue);
                              }
                            },
                            items: <String>['Hoy', 'Esta Semana', 'Este Mes']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Badge Sistema en Vivo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Color(0xFF16A34A),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sistema en Vivo',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // GRID DE TARJETAS DE KPIS
              Row(
                children: [
                  _buildKpiCard(
                    title: 'Ocupación Actual',
                    value: '84.5%',
                    subtext: '+4.2% que ayer',
                    isPositive: true,
                    icon: Icons.local_parking_rounded,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 16),
                  _buildKpiCard(
                    title: 'Celdas Disponibles',
                    value: '18 / 120',
                    subtext: 'Listas para ocupar',
                    isPositive: true,
                    icon: Icons.event_seat_rounded,
                    iconBg: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 16),
                  _buildKpiCard(
                    title: 'Rotación Promedio',
                    value: '45 min',
                    subtext: '-5 min por vehículo',
                    isPositive: true,
                    icon: Icons.timer_rounded,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(width: 16),
                  _buildKpiCard(
                    title: 'Incidentes / Alertas',
                    value: '2 Activas',
                    subtext: 'Requieren atención',
                    isPositive: false,
                    icon: Icons.warning_amber_rounded,
                    iconBg: const Color(0xFFFEF2F2),
                    iconColor: const Color(0xFFEF4444),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // PANEL DE ESTADO GENERAL DE CELDAS CON BARRA DE CAPACIDAD
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estado General de Celdas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Capacidad Total: 120 espacios',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Barra de progreso interactiva
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.85,
                        minHeight: 14,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Desglose de vehículos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildVehicleStatusItem(
                          icon: Icons.directions_car_rounded,
                          label: 'Carros Ocupados',
                          value: '72 / 80',
                          color: const Color(0xFF2563EB),
                        ),
                        Container(height: 36, width: 1, color: const Color(0xFFE2E8F0)),
                        _buildVehicleStatusItem(
                          icon: Icons.two_wheeler_rounded,
                          label: 'Motos Ocupadas',
                          value: '30 / 40',
                          color: const Color(0xFF8B5CF6),
                        ),
                        Container(height: 36, width: 1, color: const Color(0xFFE2E8F0)),
                        _buildVehicleStatusItem(
                          icon: Icons.check_circle_rounded,
                          label: 'Celdas Libres',
                          value: '18 Disponibles',
                          color: const Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtext,
    required bool isPositive,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtext,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }
}