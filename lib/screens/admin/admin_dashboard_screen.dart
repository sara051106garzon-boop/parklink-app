import 'package:flutter/material.dart';
import 'admin_kpis_screen.dart';
import 'admin_alerts_screen.dart';
import 'admin_spots_screen.dart';
import 'admin_config_screen.dart';
import 'admin_log_screen.dart';
import 'admin_registro_screen.dart';
import 'admin_tendencias_screen.dart';
import 'admin_vehiculos_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_users_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 3; // Inicia por defecto en Vehículos

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas (AdminVehiculosScreen sin 'const' para permitir estado interactivo)
    final List<Widget> adminScreens = [
      const AdminKpisScreen(),
      const AdminSpotsScreen(),
      const AdminAlertsScreen(),
      const AdminVehiclesScreen(),
      const AdminRegistroScreen(),
      const AdminTendenciasScreen(),
      const AdminLogScreen(),
      const AdminConfigScreen(),
      const AdminReportsScreen(),
      const AdminUsersScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Envolvemos el NavigationRail para solucionar el Overflow de 15px en pantallas pequeñas
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      selectedIconTheme: const IconThemeData(color: Color(0xFF3B82F6)),
                      selectedLabelTextStyle: const TextStyle(
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      unselectedIconTheme: const IconThemeData(color: Color(0xFF64748B)),
                      unselectedLabelTextStyle: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.analytics_outlined),
                          selectedIcon: Icon(Icons.analytics),
                          label: Text('KPIs'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.grid_view_outlined),
                          selectedIcon: Icon(Icons.grid_view),
                          label: Text('Celdas'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.notifications_outlined),
                          selectedIcon: Icon(Icons.notifications),
                          label: Text('Alertas'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.directions_car_outlined),
                          selectedIcon: Icon(Icons.directions_car),
                          label: Text('Vehículos'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.app_registration_outlined),
                          selectedIcon: Icon(Icons.app_registration),
                          label: Text('Registro'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.trending_up_outlined),
                          selectedIcon: Icon(Icons.trending_up),
                          label: Text('Tendencias'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.history_outlined),
                          selectedIcon: Icon(Icons.history),
                          label: Text('Logs'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Config'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bar_chart_outlined),
                          selectedIcon: Icon(Icons.bar_chart),
                          label: Text('Reportes'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.people_outline),
                          selectedIcon: Icon(Icons.people),
                          label: Text('Usuarios'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: adminScreens,
            ),
          ),
        ],
      ),
    );
  }
}