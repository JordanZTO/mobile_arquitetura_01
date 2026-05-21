import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  final http.Client client;
  static const String _baseUrl = "https://dummyjson.com";

  // Cache em memoria para fallback simples quando a rede falhar.
  List<Product>? _cache;

  ProductService(this.client);

  /// Busca todos os produtos da DummyJSON pelo endpoint /products.
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await client
          .get(Uri.parse("$_baseUrl/products"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      final List data = decoded is Map<String, dynamic>
          ? decoded["products"] as List
          : decoded as List;

      final products = data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      _cache = products;

      return products;
    } catch (e) {
      if (_cache != null) {
        return _cache!;
      }

      rethrow;
    }
  }

  /// Busca um produto especifico pelo endpoint /products/{id}.
  Future<Product> fetchProductById(int id) async {
    try {
      final response = await client
          .get(Uri.parse("$_baseUrl/products/$id"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}');
      }

      final product = Product.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      _cache = [
        ...?_cache?.where((cached) => cached.id != product.id),
        product,
      ];

      return product;
    } catch (_) {
      final cached = getProductById(id);
      if (cached != null) {
        return cached;
      }

      rethrow;
    }
  }

  /// Adiciona um novo produto no cache local.
  Future<void> addProduct(Product product) async {
    _cache ??= [];
    _cache!.add(product);
  }

  /// Atualiza um produto existente no cache local.
  Future<void> updateProduct(Product product) async {
    if (_cache != null) {
      final index = _cache!.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _cache![index] = product;
      }
    }
  }

  /// Deleta um produto do cache local.
  Future<void> deleteProduct(int productId) async {
    if (_cache != null) {
      _cache!.removeWhere((p) => p.id == productId);
    }
  }

  /// Retorna um produto especifico pelo ID a partir do cache.
  Product? getProductById(int id) {
    if (_cache == null) return null;
    try {
      return _cache!.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna todos os produtos do cache.
  List<Product>? getCachedProducts() {
    return _cache;
  }
}
