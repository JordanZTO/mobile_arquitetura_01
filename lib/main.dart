import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/home_screen.dart';
import 'services/product_service.dart';

void main() {
  final productService = ProductService(http.Client());
  runApp(MyApp(productService: productService));
}

class MyApp extends StatelessWidget {
  final ProductService productService;

  const MyApp({super.key, required this.productService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(productService: productService),
    );
  }
}