import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/datasources/products_datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  late Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: Environment.API_URL,
          connectTimeout: Duration(seconds: 6),
          headers: {"Authorization": "Bearer ${accessToken}"},
        ));

  set hhtpClientNewAccessToken(String newToken) {
    dio.options.copyWith(headers: {"Authorization": "Bearer $newToken"});
  }

  @override
  Future<Product> createUpdateProduct(Product product) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await dio.get<List<dynamic>>("/products",
        queryParameters: {"limit": limit, "offset": offset});

    final products = response.data
        ?.map((product) => ProductMapper.json_to_product(product))
        .toList();

    return products ?? [];
  }
}
