import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/storage_repository_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/storage_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> implements Listenable {
  late AuthRepository authRepository;
  late StorageService storage_service;
  late VoidCallback? _listener;

  @override
  AuthState build() {
    //dependency injection whit NotifierProvider
    this.authRepository = ref.watch(authRepositoryProvider);
    this.storage_service = ref.watch(storageServiceProvider);

    state = AuthState();
    checkAuthStatus();
    return state;
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = await authRepository.login(email, password);
      await _setLoggedInUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout("An error occurred");
    }
  }

  Future<void> registerUser(
      String email, String password, String fullname) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = await authRepository.register(email, password, fullname);
      await _setLoggedInUser(user);
      // await storage_service.setKeyValue<String>("user_token", user.token);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout("An error occurred");
    }
  }

  Future<void> logout([String? errorMessage]) async {
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage ?? "",
    );
    await storage_service.removeKey("user_token");
    _listener?.call();
  }

  void checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await storage_service.getValue<String>("user_token");

    if (token == null) {
      return logout();
    }

    try {
      final user = await authRepository.checkAuthStatus(token);

      _setLoggedInUser(user);
    } catch (e) {
      logout("An error occurred. Try login again");
    }
  }

  _setLoggedInUser(User user) async {
    await storage_service.setKeyValue<String>("user_token", user.token);
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: "",
    );
    _listener?.call();
  }

  @override
  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _listener = null;
  }
}

enum AuthStatus { authenticated, unauthenticated, checking }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = "",
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
