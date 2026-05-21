import '../models/product_model.dart';

class ProductCacheDatasource {
  List<ProductModel>? _cache;

  void save(List<ProductModel> products) {
    _cache = products;
  }

  List<ProductModel>? get() {
    return _cache;
  }

  void addProduct(Map<String, dynamic> productData) {
    if (_cache != null) {
      final newProduct = ProductModel(
        id: productData["id"],
        title: productData["title"],
        price: productData["price"],
        image: productData["image"],
        description: productData["description"],
        category: productData["category"],
        rating: productData["rating"],
        brand: productData["brand"],
        stock: productData["stock"],
        discountPercentage: productData["discountPercentage"],
        thumbnail: productData["thumbnail"],
        images:
            (productData["images"] as List?)?.whereType<String>().toList() ??
            const <String>[],
      );
      _cache!.add(newProduct);
    }
  }

  void updateProduct(Map<String, dynamic> productData) {
    if (_cache != null) {
      final index = _cache!.indexWhere((p) => p.id == productData["id"]);
      if (index != -1) {
        _cache![index] = ProductModel(
          id: productData["id"],
          title: productData["title"],
          price: productData["price"],
          image: productData["image"],
          description: productData["description"],
          category: productData["category"],
          rating: productData["rating"],
          brand: productData["brand"],
          stock: productData["stock"],
          discountPercentage: productData["discountPercentage"],
          thumbnail: productData["thumbnail"],
          images:
              (productData["images"] as List?)?.whereType<String>().toList() ??
              const <String>[],
        );
      }
    }
  }

  void deleteProduct(int productId) {
    if (_cache != null) {
      _cache!.removeWhere((p) => p.id == productId);
    }
  }
}
