import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client
          .get(Uri.parse("https://dummyjson.com/products"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      final List data = decoded is Map<String, dynamic>
          ? decoded["products"] as List
          : decoded as List;

      final products = data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return products;
    } catch (_) {
      rethrow;
    }
  }
}
