import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/favorites_service.dart';
import '../services/product_service.dart';
import '../services/session_manager.dart';
import '../widgets/product_card.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final ProductService productService;
  final SessionManager sessionManager;
  final FavoritesService favoritesService;

  const ProductListScreen({
    super.key,
    required this.productService,
    required this.sessionManager,
    required this.favoritesService,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  Set<int> _favoriteIds = {};
  bool _loadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.productService.fetchProducts();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favoriteIds = await widget.favoritesService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteIds = favoriteIds.toSet();
          _loadingFavorites = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingFavorites = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(int productId) async {
    final isFavorite = _favoriteIds.contains(productId);
    
    if (isFavorite) {
      await widget.favoritesService.removeFavorite(productId);
      if (mounted) {
        setState(() {
          _favoriteIds.remove(productId);
        });
      }
    } else {
      await widget.favoritesService.addFavorite(productId);
      if (mounted) {
        setState(() {
          _favoriteIds.add(productId);
        });
      }
    }
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = widget.productService.fetchProducts();
    });
  }

  Future<void> _logout() async {
    await widget.sessionManager.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          productService: widget.productService,
          sessionManager: widget.sessionManager,
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.sessionManager.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Produtos"),
            if (user != null)
              Text(user.fullName, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        elevation: 0,
        actions: [
          if (user?.image != null && user!.image!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CircleAvatar(backgroundImage: NetworkImage(user.image!)),
            ),
          IconButton(
            tooltip: "Atualizar produtos",
            onPressed: _refreshProducts,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: "Sair",
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Erro: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshProducts,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("Nenhum produto encontrado"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isFavorite = _favoriteIds.contains(product.id);

              return ProductCard(
                product: product,
                isFavorite: isFavorite,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        productId: product.id,
                        productService: widget.productService,
                        favoritesService: widget.favoritesService,
                      ),
                    ),
                  ).then((favoritesModified) {
                    // Se favoritos foram modificados, recarrega a lista
                    if (favoritesModified == true) {
                      _loadFavorites();
                    }
                  });
                },
                onFavoriteTap: () {
                  _toggleFavorite(product.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Atualizar",
        onPressed: _refreshProducts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
