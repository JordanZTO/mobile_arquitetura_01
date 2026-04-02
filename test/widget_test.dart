import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:product_app/main.dart';
import 'package:product_app/services/product_service.dart';

void main() {
  testWidgets('HomeScreen loads successfully', (WidgetTester tester) async {
    final productService = ProductService(http.Client());
    
    await tester.pumpWidget(MyApp(productService: productService));

    expect(find.text('Product Store'), findsOneWidget);
    expect(find.text('Welcome to Product Store'), findsOneWidget);
    expect(find.byIcon(Icons.store), findsOneWidget);
  });
}
