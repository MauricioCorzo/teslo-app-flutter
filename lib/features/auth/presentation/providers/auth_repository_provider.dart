import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((_) {
  return AuthRepositoryImpl();
});
