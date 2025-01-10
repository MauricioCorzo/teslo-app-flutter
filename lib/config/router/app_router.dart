import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  // final appRouterNotifier = ref.watch(appRouterNotifierProvider);

  final authNotifierProvider = ref.watch(authProvider.notifier);

  final appRouter = GoRouter(
    initialLocation: '/splash',
    routes: [
      ///* Auth Routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) =>
            ProductDetailsScreen(productId: state.params["id"] ?? "no-id"),
      ),
    ],
    // refreshListenable: appRouterNotifier,
    refreshListenable: authNotifierProvider,
    //Middleware para todas las rutas
    redirect: (context, state) {
      final authProviderState = ref.read(authProvider);
      switch (authProviderState.status) {
        case AuthStatus.checking:
          return '/splash';
        case AuthStatus.unauthenticated:
          if (state.subloc == "/register" || state.subloc == "/login") {
            return null;
          } else {
            return '/login';
          }

        case AuthStatus.authenticated:
          return '/';
      }
    },
  );

  return appRouter;
});
