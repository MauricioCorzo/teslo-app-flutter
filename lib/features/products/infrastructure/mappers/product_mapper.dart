import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

class ProductMapper {
  static Product json_to_product(Map<String, dynamic> json) => Product(
      id: json['id'],
      title: json['title'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tag) => tag)),
      images: List<String>.from(json['images'].map(
        (image) => image.startsWith('http')
            ? image
            : '${Environment.API_URL}/files/product/$image',
      )),
      user: UserMapper.json_to_user(json['user']));
}
