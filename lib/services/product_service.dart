import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final http.Client client;
  static const String _apiUrl = "https://fakestoreapi.com/products";
  
  // Cache em memória
  List<Product>? _cache;

  ProductService(this.client);

  /// Busca todos os produtos da API
  Future<List<Product>> fetchProducts() async {
    try {
      print('[ProductService] Iniciando requisição para API');
      final response = await client.get(
        Uri.parse(_apiUrl),
      ).timeout(const Duration(seconds: 10));

      print('[ProductService] Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}');
      }

      final List data = jsonDecode(response.body);
      print('[ProductService] Produtos recebidos: ${data.length}');

      final products = data.map((json) => Product.fromJson(json)).toList();
      
      // Salva em cache
      _cache = products;
      print('[ProductService] Produtos parseados e cacheados: ${products.length}');

      return products;
    } catch (e) {
      print('[ProductService] Erro ao buscar: $e');
      
      // Retorna cache como fallback
      if (_cache != null) {
        print('[ProductService] Usando cache com ${_cache!.length} produtos');
        return _cache!;
      }
      
      rethrow;
    }
  }

  /// Adiciona um novo produto
  Future<void> addProduct(Product product) async {
    print('[ProductService] Adicionando produto: ${product.title}');
    // Em produção, seria um POST para a API
    // Por enquanto, apenas adiciona ao cache
    _cache ??= [];
    _cache!.add(product);
    print('[ProductService] Produto adicionado ao cache');
  }

  /// Atualiza um produto existente
  Future<void> updateProduct(Product product) async {
    print('[ProductService] Atualizando produto: ${product.title}');
    // Em produção, seria um PUT para a API
    if (_cache != null) {
      final index = _cache!.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _cache![index] = product;
        print('[ProductService] Produto atualizado no cache');
      }
    }
  }

  /// Deleta um produto
  Future<void> deleteProduct(int productId) async {
    print('[ProductService] Deletando produto ID: $productId');
    // Em produção, seria um DELETE para a API
    if (_cache != null) {
      _cache!.removeWhere((p) => p.id == productId);
      print('[ProductService] Produto deletado do cache');
    }
  }

  /// Retorna um produto específico pelo ID
  Product? getProductById(int id) {
    if (_cache == null) return null;
    try {
      return _cache!.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna todos os produtos do cache
  List<Product>? getCachedProducts() {
    return _cache;
  }
}
