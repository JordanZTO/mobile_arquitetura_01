import 'package:product_app/domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final Product? selectedProduct;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.selectedProduct,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    Product? selectedProduct,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error ?? this.error,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}
