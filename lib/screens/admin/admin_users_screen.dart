import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _searchQuery = '';
  String _selectedRole = 'Todos';

  // Lista de usuarios registrados
  final List<Map<String, dynamic>> _allUsers = [
    {
      'name': 'Carlos Mendoza',
      'email': 'carlos.mendoza@redeban.com',
      'role': 'Empleado',
      'status': 'Activo',
      'plate': 'ABC-123',
    },
    {
      'name': 'Ana Gómez',
      'email': 'ana.gomez@redeban.com',
      'role': 'Empleado',
      'status': 'Activo',
      'plate': 'XYZ-789',
    },
    {
      'name': 'Javier Pérez',
      'email': 'javier.perez@redeban.com',
      'role': 'Vigilante',
      'status': 'Activo',
      'plate': 'N/A',
    },
    {
      'name': 'Laura Ruiz',
      'email': 'laura.ruiz@redeban.com',
      'role': 'Administrador',
      'status': 'Activo',
      'plate': 'KTM-456',
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    return _allUsers.where((user) {
      final matchesSearch = user['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['email']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesRole =
          _selectedRole == 'Todos' || user['role'] == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Registrar Nuevo Usuario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo Corporativo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Usuario creado exitosamente'),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _allUsers.length;
    final employeeCount = _allUsers.where((u) => u['role'] == 'Empleado').length;
    final vigilanteCount = _allUsers.where((u) => u['role'] == 'Vigilante').length;

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
                        'Directorio y Control de Accesos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Administra las credenciales, roles y permisos del personal autorizado.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _showAddUserDialog,
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Nuevo Usuario', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // KPIS DE USUARIOS
              Row(
                children: [
                  _buildUserStatCard(
                    'Total Personal',
                    '$totalCount Registrados',
                    Icons.people_alt_rounded,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 16),
                  _buildUserStatCard(
                    'Colaboradores',
                    '$employeeCount Empleados',
                    Icons.badge_rounded,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 16),
                  _buildUserStatCard(
                    'Equipo Seguridad',
                    '$vigilanteCount Vigilantes',
                    Icons.local_police_rounded,
                    const Color(0xFFF59E0B),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // BUSCADOR Y FILTROS DE ROL
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o correo corporativo...',
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
                          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', 'Empleado', 'Vigilante', 'Administrador'].map((role) {
                      final isSelected = _selectedRole == role;
                      return ChoiceChip(
                        label: Text(role),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedRole = role);
                        },
                        selectedColor: const Color(0xFF2563EB),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // LISTA DE TARJETAS DE USUARIO
              Expanded(
                child: _filteredUsers.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Text(
                            'No se encontraron usuarios coincidentes.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredUsers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          final initial = user['name'].toString().isNotEmpty
                              ? user['name'].toString()[0].toUpperCase()
                              : '?';

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Avatar con Inicial
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFFEFF6FF),
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Nombre y Correo
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user['email'].toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Vehículo Asignado
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.directions_car_rounded, size: 16, color: Color(0xFF94A3B8)),
                                      const SizedBox(width: 6),
                                      Text(
                                        user['plate'].toString(),
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                                // Badge de Rol
                                _buildRoleBadge(user['role'].toString()),
                                const SizedBox(width: 16),

                                // Menú de Opciones
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
                                  onSelected: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Acción "$value" para ${user['name']}'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'Editar',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 18, color: Color(0xFF475569)),
                                          SizedBox(width: 10),
                                          Text('Editar permisos'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Inactivar',
                                      child: Row(
                                        children: [
                                          Icon(Icons.block_rounded, size: 18, color: Color(0xFFEF4444)),
                                          SizedBox(width: 10),
                                          Text('Desactivar acceso', style: TextStyle(color: Color(0xFFEF4444))),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget _buildUserStatCard(String label, String value, IconData icon, Color color) {
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
                    fontSize: 14,
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

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color fg;

    switch (role) {
      case 'Administrador':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFF991B1B);
        break;
      case 'Vigilante':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        break;
      default:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}