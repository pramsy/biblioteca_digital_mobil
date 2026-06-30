// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:biblioteca_digital/app/app.dart';
import 'package:biblioteca_digital/app/config/injection.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Inicializar injeção para o teste (ou mockar se necessário)
    await setupInjection();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verifica se a tela de login aparece (botão ENTRAR)
    expect(find.text('ENTRAR AGORA'), findsOneWidget);
  });
}
