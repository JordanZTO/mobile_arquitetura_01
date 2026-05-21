import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:product_app/main.dart';
import 'package:product_app/services/auth_service.dart';
import 'package:product_app/services/product_service.dart';
import 'package:product_app/services/session_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('LoginScreen loads when there is no active session', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    final client = MockClient((request) async => http.Response('{}', 400));
    final productService = ProductService(client);
    final authService = AuthService(client);
    final sessionManager = SessionManager(authService);

    await tester.pumpWidget(
      MyApp(productService: productService, sessionManager: sessionManager),
    );
    await tester.pumpAndSettle();

    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsWidgets);
    expect(find.byIcon(Icons.login), findsOneWidget);
  });
}
