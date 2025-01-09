import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl([AuthDatasource? datasource])
      : this._datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return _datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return _datasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullname) {
    return _datasource.register(email, password, fullname);
  }
}
