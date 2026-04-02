import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/core/errors/failure.dart';
import '../viewmodels/product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    print('[ProductViewModel] loadProducts() iniciado');
    state.value = state.value.copyWith(isLoading: true, error: null);

    try {
      print('[ProductViewModel] Chamando repository.getProducts()');
      final products = await repository.getProducts();

      print('[ProductViewModel] Produtos recebidos: ${products.length}');
      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
        error: null,
      );
      print('[ProductViewModel] Estado atualizado com sucesso');
    } catch (e) {
      print('[ProductViewModel] Erro capturado: $e');
      
      String errorMessage;
      if (e is Failure) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      print('[ProductViewModel] Mensagem de erro: $errorMessage');

      state.value = state.value.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  void addProduct(Product product) {
    final updatedProducts = [...state.value.products, product];
    state.value = state.value.copyWith(products: updatedProducts);
  }

  void updateProduct(Product product) {
    final products = state.value.products;
    final index = products.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      final updatedProducts = [...products];
      updatedProducts[index] = product;
      state.value = state.value.copyWith(products: updatedProducts);
    }
  }

  void deleteProduct(int productId) {
    final updatedProducts =
        state.value.products.where((p) => p.id != productId).toList();
    state.value = state.value.copyWith(products: updatedProducts);
  }

  Product? getProductById(int id) {
    try {
      return state.value.products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
