import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract interface class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<Product> createUpdateProduct(Product product);
}
