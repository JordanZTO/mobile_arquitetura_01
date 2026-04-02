import 'package:product_app/domain/entities/product.dart';
import '../datasources/product_remote_datasource.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import '../datasources/product_cache_datasource.dart';
import 'package:product_app/core/errors/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      print('[ProductRepository] Iniciando carregamento de produtos');
      final models = await remote.getProducts();
      print('[ProductRepository] Produtos obtidos da API: ${models.length}');
      
      cache.save(models);
      print('[ProductRepository] Produtos salvos em cache');

      final products = models
          .map((m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                description: m.description,
                category: m.category,
                rating: m.rating,
              ))
          .toList();
      
      print('[ProductRepository] Produtos convertidos para entity: ${products.length}');
      return products;
    } catch (e) {
      print('[ProductRepository] Erro ao carregar de API: $e');
      
      final cached = cache.get();

      if (cached != null) {
        print('[ProductRepository] Usando cache com ${cached.length} produtos');
        return cached
            .map((m) => Product(
                  id: m.id,
                  title: m.title,
                  price: m.price,
                  image: m.image,
                  description: m.description,
                  category: m.category,
                  rating: m.rating,
                ))
            .toList();
      }

      print('[ProductRepository] Cache vazio, throwando erro');
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    // Adiciona produto à lista e atualiza cache
    final modelToAdd = _productToModel(product);
    cache.addProduct(modelToAdd);
  }

  @override
  Future<void> updateProduct(Product product) async {
    // Atualiza produto no cache
    final modelToUpdate = _productToModel(product);
    cache.updateProduct(modelToUpdate);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    // Remove produto do cache
    cache.deleteProduct(productId);
  }

  _productToModel(Product product) {
    return {
      "id": product.id,
      "title": product.title,
      "price": product.price,
      "image": product.image,
      "description": product.description,
      "category": product.category,
      "rating": product.rating,
    };
  }
}