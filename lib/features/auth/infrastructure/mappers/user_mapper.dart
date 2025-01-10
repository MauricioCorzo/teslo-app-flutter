import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User json_to_user(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullname: json['fullName'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'] ?? "",
    );
  }
}
