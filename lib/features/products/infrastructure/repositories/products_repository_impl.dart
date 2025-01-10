import 'package:teslo_shop/features/products/domain/datasources/products_datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasource _datasource;

  ProductsRepositoryImpl({required ProductsDatasource datasource})
      : this._datasource = datasource;
  @override
  Future<Product> createUpdateProduct(Product product) {
    return this._datasource.createUpdateProduct(product);
  }

  @override
  Future<Product> getProductById(String id) {
    return this._datasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return this._datasource.getProductsByPage(limit: limit, offset: offset);
  }
}
