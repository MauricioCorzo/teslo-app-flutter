import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract interface class AuthDatasource {
  Future<User> login(String email, String password);

  Future<User> register(String email, String password, String fullname);

  Future<User> checkAuthStatus(String token);
}
