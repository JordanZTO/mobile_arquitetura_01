import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import '../services/product_service.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';
import 'product_list_screen.dart';

class SplashScreen extends StatefulWidget {
  final ProductService productService;
  final SessionManager sessionManager;
  final FavoritesService favoritesService;

  const SplashScreen({
    super.key,
    required this.productService,
    required this.sessionManager,
    required this.favoritesService,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await widget.sessionManager.restoreSession();

    if (!mounted) return;

    final nextScreen = widget.sessionManager.isAuthenticated
        ? ProductListScreen(
            productService: widget.productService,
            sessionManager: widget.sessionManager,
            favoritesService: widget.favoritesService,
          )
        : LoginScreen(
            productService: widget.productService,
            sessionManager: widget.sessionManager,
          );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
