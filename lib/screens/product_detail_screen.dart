import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/favorites_service.dart';
import '../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final ProductService productService;
  final FavoritesService favoritesService;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productService,
    required this.favoritesService,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;
  late Future<bool> _isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    _productFuture = widget.productService.fetchProductById(widget.productId);
    _isFavoriteFuture =
        widget.favoritesService.isFavorite(widget.productId);
  }

  void _retry() {
    setState(_loadProduct);
  }

  Future<void> _toggleFavorite() async {
    final isFavorite =
        await widget.favoritesService.isFavorite(widget.productId);

    if (isFavorite) {
      await widget.favoritesService.removeFavorite(widget.productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removido dos favoritos")),
        );
      }
    } else {
      await widget.favoritesService.addFavorite(widget.productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Adicionado aos favoritos")),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isFavoriteFuture =
            widget.favoritesService.isFavorite(widget.productId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes"), elevation: 0),
      body: FutureBuilder<Product>(
        future: _productFuture,
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
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = snapshot.data!;
          return FutureBuilder<bool>(
            future: _isFavoriteFuture,
            builder: (context, favoriteSnapshot) {
              final isFavorite = favoriteSnapshot.data ?? false;
              return _ProductDetails(
                product: product,
                isFavorite: isFavorite,
                onFavoriteToggle: _toggleFavorite,
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _ProductDetails({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.image_not_supported, size: 80),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(product.category)),
              if (product.brand != null && product.brand!.isNotEmpty)
                Chip(label: Text(product.brand!)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              if (product.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(
                      " ${product.rating!.toStringAsFixed(1)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (product.stock != null)
                _InfoChip(
                  icon: Icons.inventory_2_outlined,
                  label: "Estoque: ${product.stock}",
                ),
              if (product.discountPercentage != null)
                _InfoChip(
                  icon: Icons.local_offer_outlined,
                  label:
                      "${product.discountPercentage!.toStringAsFixed(1)}% off",
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Descricao",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Adicionado ao carrinho")),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Carrinho"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(isFavorite ? "Favoritado" : "Favoritar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 4), Text(label)],
    );
  }
}
