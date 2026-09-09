import 'package:flutter/material.dart';

class AdminLogScreen extends StatefulWidget {
  const AdminLogScreen({super.key});

  @override
  State<AdminLogScreen> createState() => _AdminLogScreenState();
}

class _AdminLogScreenState extends State<AdminLogScreen> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'Todos';

  // Lista de logs del sistema
  final List<Map<String, dynamic>> _allLogs = [
    {
      'timestamp': '2026-06-06 14:32:10',
      'user': 'carlos.admin',
      'action': 'Modificación de tarifas y promociones',
      'category': 'Configuración',
      'status': 'Éxito',
      'icon': Icons.settings_applications_rounded,
    },
    {
      'timestamp': '2026-06-06 13:15:42',
      'user': 'vigilante_sur',
      'action': 'Liberación forzosa de celda B-02',
      'category': 'Operación',
      'status': 'Éxito',
      'icon': Icons.lock_open_rounded,
    },
    {
      'timestamp': '2026-06-06 11:05:22',
      'user': 'ana.gomez',
      'action': 'Intento de reserva con credencial vencida',
      'category': 'Seguridad',
      'status': 'Bloqueado',
      'icon': Icons.shield_outlined,
    },
    {
      'timestamp': '2026-06-06 09:40:11',
      'user': 'carlos.admin',
      'action': 'Creación de nuevo usuario operador',
      'category': 'Usuarios',
      'status': 'Éxito',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'timestamp': '2026-06-06 08:12:05',
      'user': 'vigilante_norte',
      'action': 'Apertura manual de talanquera principal',
      'category': 'Acceso',
      'status': 'Advertencia',
      'icon': Icons.warning_amber_rounded,
    },
  ];

  List<Map<String, dynamic>> get _filteredLogs {
    return _allLogs.where((log) {
      final matchesSearch = log['user']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          log['action']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatusFilter == 'Todos' ||
          log['status'] == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalLogs = _allLogs.length;
    final successCount = _allLogs.where((l) => l['status'] == 'Éxito').length;
    final alertCount = _allLogs.where((l) => l['status'] != 'Éxito').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Historial de Actividad',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Consulta eventos de seguridad, cambios de configuración y registros del sistema.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF334155),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Exportar Log', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // KPIS SUPERIORES DE AUDITORÍA
              Row(
                children: [
                  _buildSummaryCard(
                    'Total Registros',
                    '$totalLogs',
                    Icons.format_list_bulleted_rounded,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    'Operaciones Exitosas',
                    '$successCount',
                    Icons.check_circle_outline_rounded,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    'Alertas / Bloqueos',
                    '$alertCount',
                    Icons.gpp_maybe_outlined,
                    const Color(0xFFEF4444),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // BARRA DE BÚSQUEDA Y FILTROS
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Buscar por usuario, acción o detalle...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', 'Éxito', 'Advertencia', 'Bloqueado'].map((status) {
                      final isSelected = _selectedStatusFilter == status;
                      return ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedStatusFilter = status);
                        },
                        selectedColor: const Color(0xFF3B82F6),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // TABLA / LISTA DE LOGS
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _filteredLogs.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron registros.',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredLogs.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final log = _filteredLogs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    // Icono del Evento
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        log['icon'] as IconData,
                                        size: 20,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Fecha y Hora
                                    SizedBox(
                                      width: 150,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            log['timestamp'].toString().split(' ')[0],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          Text(
                                            log['timestamp'].toString().split(' ')[1],
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Usuario Responsable
                                    SizedBox(
                                      width: 140,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: const Color(0xFFDBEAFE),
                                            child: Text(
                                              log['user'].toString()[0].toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1D4ED8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              log['user'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Descripción de la Acción
                                    Expanded(
                                      child: Text(
                                        log['action'].toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),

                                    // Badge de Estado
                                    _buildStatusBadge(log['status'].toString()),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Éxito':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        break;
      case 'Advertencia':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        break;
      case 'Bloqueado':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFF991B1B);
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}