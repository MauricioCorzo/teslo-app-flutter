import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

final appRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.watch(authProvider.notifier);

  return AppRouterNotifier(authNotifier);
});

class AppRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  var _authStatus = AuthStatus.checking;

  AppRouterNotifier(this._authNotifier) {
    _authNotifier.listenSelf(
      (previous, currentState) {
        authStatus = currentState.status;
      },
    );
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus status) {
    _authStatus = status;
    notifyListeners();
  }
}
