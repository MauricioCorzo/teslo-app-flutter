import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';
import "dart:developer" as dev;

class AuthDatasourceImpl implements AuthDatasource {
  final _dio = Dio(BaseOptions(
    baseUrl: Environment.API_URL,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await _dio.get("/auth/check-status",
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));

      final user = UserMapper.json_to_user(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data["message"], 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(e.response?.data["message"], 408);
      }
      throw Exception("An error occurred");
    } catch (_) {
      throw Exception("An error occurred");
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio
          .post("/auth/login", data: {"email": email, "password": password});
      // LoggerPrint.debug(response.data);
      final user = UserMapper.json_to_user(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data["message"], 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(e.response?.data["message"], 408);
      }

      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullname) async {
    try {
      final response = await _dio.post("/auth/register",
          data: {"email": email, "password": password, "fullName": fullname});

      final user = UserMapper.json_to_user(response.data);
      dev.debugger();
      return user;
    } catch (e) {
      throw Exception();
    }
  }
}
