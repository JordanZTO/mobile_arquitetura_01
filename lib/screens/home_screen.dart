import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import '../services/product_service.dart';
import '../services/session_manager.dart';

class HomeScreen extends StatelessWidget {
  final ProductService productService;
  final SessionManager sessionManager;

  const HomeScreen({
    super.key,
    required this.productService,
    required this.sessionManager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Store"), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Product Store",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Browse our collection of products",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text("View Products"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(
                      productService: productService,
                      sessionManager: sessionManager,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
