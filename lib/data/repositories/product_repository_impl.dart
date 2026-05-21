import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';

import '../datasources/product_cache_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);

      return models.map(_modelToEntity).toList();
    } catch (_) {
      final cached = cache.get();

      if (cached != null) {
        return cached.map(_modelToEntity).toList();
      }

      throw Failure("Nao foi possivel carregar os produtos");
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    cache.addProduct(_productToModel(product));
  }

  @override
  Future<void> updateProduct(Product product) async {
    cache.updateProduct(_productToModel(product));
  }

  @override
  Future<void> deleteProduct(int productId) async {
    cache.deleteProduct(productId);
  }

  Product _modelToEntity(ProductModel model) {
    return Product(
      id: model.id,
      title: model.title,
      price: model.price,
      image: model.image,
      description: model.description,
      category: model.category,
      rating: model.rating,
      brand: model.brand,
      stock: model.stock,
      discountPercentage: model.discountPercentage,
      thumbnail: model.thumbnail,
      images: model.images,
    );
  }

  Map<String, dynamic> _productToModel(Product product) {
    return {
      "id": product.id,
      "title": product.title,
      "price": product.price,
      "image": product.image,
      "description": product.description,
      "category": product.category,
      "rating": product.rating,
      "brand": product.brand,
      "stock": product.stock,
      "discountPercentage": product.discountPercentage,
      "thumbnail": product.thumbnail,
      "images": product.images,
    };
  }
}
