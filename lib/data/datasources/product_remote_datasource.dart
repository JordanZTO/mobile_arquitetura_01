import 'dart:convert';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    try {
      print('[ProductRemoteDatasource] Iniciando requisição para API');
      final response = await client.get(
        Uri.parse("https://fakestoreapi.com/products"),
      ).timeout(const Duration(seconds: 10));

      print('[ProductRemoteDatasource] Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}');
      }

      final List data = jsonDecode(response.body);
      print('[ProductRemoteDatasource] Produtos recebidos: ${data.length}');

      final products = data.map((json) => ProductModel.fromJson(json)).toList();
      print('[ProductRemoteDatasource] Produtos parseados: ${products.length}');
      
      return products;
    } catch (e) {
      print('[ProductRemoteDatasource] Erro: $e');
      rethrow;
    }
  }
}
