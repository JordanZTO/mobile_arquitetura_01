import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/favorites_service.dart';
import 'services/product_service.dart';
import 'services/session_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final client = http.Client();
  final productService = ProductService(client);
  final authService = AuthService(client);
  final sessionManager = SessionManager(authService);
  final favoritesService = FavoritesService();

  runApp(MyApp(
    productService: productService,
    sessionManager: sessionManager,
    favoritesService: favoritesService,
  ));
}

class MyApp extends StatelessWidget {
  final ProductService productService;
  final SessionManager sessionManager;
  final FavoritesService favoritesService;

  const MyApp({
    super.key,
    required this.productService,
    required this.sessionManager,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Store',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: SplashScreen(
        productService: productService,
        sessionManager: sessionManager,
        favoritesService: favoritesService,
      ),
    );
  }
}
