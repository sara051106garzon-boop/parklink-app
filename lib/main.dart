import 'package:flutter/material.dart';

// Importa tus pantallas usando rutas relativas exactas desde 'lib/main.dart'
import 'screens/login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/user/user_profile_screen.dart';
import 'screens/user/user_notifications_screen.dart';
import 'screens/user/user_help_screen.dart';
import 'screens/user/user_traffic_light_screen.dart';
import 'screens/user/user_reservations_screen.dart';
import 'screens/user/user_vehicles_screen.dart';
import 'screens/user/user_dashboard_screen.dart';
import 'screens/user/user_history_screen.dart';
import 'screens/vigilante/inicio_screen.dart';
import 'screens/vigilante/vigilante_dashboard_screen.dart';
import 'screens/vigilante/control_screen.dart';
import 'screens/vigilante/apertura_turno_screen.dart';
import 'screens/vigilante/cierre_turno_screen.dart';
import 'screens/vigilante/consola_transferencia_screen.dart';
import 'screens/vigilante/formulario_entrada_screen.dart';
import 'screens/vigilante/formulario_salida_screen.dart';
import 'screens/vigilante/formulario_visitantes_screen.dart';
import 'screens/vigilante/historial_turno_screen.dart';
import 'screens/vigilante/lista_vehiculos_activo_screen.dart';
import 'screens/vigilante/mapa_grafico_screen.dart';
import 'screens/vigilante/registro_novedades_screen.dart';
import 'screens/vigilante/vigilante_incidents_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parklink',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/user/dashboard': (context) => const UserDashboardScreen(),
        '/user/profile': (context) => const UserProfileScreen(),
        '/user/notifications': (context) => const UserNotificationsScreen(),
        '/user/help': (context) => const UserHelpScreen(),
        '/user/traffic-light': (context) => const UserTrafficLightScreen(),
        '/user/reservations': (context) => const UserReserveSpotScreen(),
        '/user/vehicles': (context) => const UserVehiclesScreen(),
        '/user/history': (context) => const UserHistoryScreen(),

        // Rutas del Módulo de Vigilante
        '/vigilante/dashboard': (context) => const VigilanteDashboardScreen(),
        '/vigilante/inicio': (context) => const InicioScreen(),
        '/vigilante/control': (context) => const ControlScreen(),
        '/vigilante/apertura-turno': (context) => const AperturaTurnoScreen(),
        '/vigilante/cierre-turno': (context) => const CierreTurnoScreen(),
        '/vigilante/consola-transferencia': (context) => const ConsolaTransferenciaScreen(),
        '/vigilante/formulario-entrada': (context) => const FormularioEntradaScreen(),
        '/vigilante/formulario-salida': (context) => const FormularioSalidaScreen(),
        '/vigilante/formulario-visitantes': (context) => const FormularioVisitantesScreen(),
        '/vigilante/historial-turno': (context) => const HistorialTurnoScreen(),
        '/vigilante/lista-vehiculos': (context) => const ListaVehiculosActivoScreen(),
        '/vigilante/mapa-grafico': (context) => const MapaGraficoScreen(),
        '/vigilante/registro-novedades': (context) => const RegistroNovedadesScreen(),
        '/vigilante/incidencias': (context) => const VigilanteIncidentsScreen(),
        // Nota: '/vigilante/modal-confirmacion' NO se registra como ruta de página:
        // ModalConfirmacionScreen es un diálogo reutilizable que exige parámetros
        // (titulo, mensaje). Se invoca así donde lo necesites, no por Navigator.pushNamed:
        //   ModalConfirmacionScreen.mostrar(context, titulo: "...", mensaje: "...");
      },
    );
  }
}