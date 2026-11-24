// Test de humo: la app arranca en la pantalla de inicio de sesión de ParkLink.
import 'package:flutter_test/flutter_test.dart';

import 'package:parklink_mobile/main.dart';

void main() {
  testWidgets('Muestra la pantalla de inicio de sesión', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Parklink'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
