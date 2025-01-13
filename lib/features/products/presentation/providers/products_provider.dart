import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';
import 'package:teslo_shop/helpers/logger.dart';

final productsProvider = AsyncNotifierProvider<ProductsNotifier, ProductsState>(
    ProductsNotifier.new);

class ProductsNotifier extends AsyncNotifier<ProductsState> {
  late final ProductsRepository _productsRepository;
  @override
  Future<ProductsState> build() {
    this._productsRepository = ref.watch(productsRepositoryProvider);

    return loadInitPage();
  }

  Future<ProductsState> loadInitPage() async {
    await Future.delayed(Duration(seconds: 3));
    final products = await _productsRepository.getProductsByPage(
      limit: 10,
      offset: 0,
    );

    return ProductsState(
      isLastPage: products.isEmpty,
      limit: 10,
      offset: 10,
      isLoading: false,
      products: products,
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.value?.isLastPage == true) return;

    state = AsyncLoading();
    final previousState = state.valueOrNull;
    LoggerPrint.info(previousState);
    LoggerPrint.error(
        "isLoading: ${state.isLoading}, isRefresh: ${state.isRefreshing}");

    await Future.delayed(Duration(seconds: 3));
    final products = await _productsRepository.getProductsByPage(
      limit: state.requireValue.limit,
      offset: state.requireValue.offset,
    );
    state = AsyncValue.data(
      state.requireValue.copyWith(
        offset: state.requireValue.offset + state.requireValue.limit,
        isLoading: false,
        isLastPage: false,
        products: [...state.requireValue.products, ...products],
      ),
    );
    LoggerPrint.error(
        "isLoading: ${state.isLoading}, isRefresh: ${state.isRefreshing}");
    // if (previousState == null) return;

    // if (products.isEmpty) {
    //   state = await AsyncValue.guard(() async =>
    //       previousState.copyWith(isLastPage: true, isLoading: false));
    // } else {
    //   state = state.copyWithPrevious(
    //       AsyncValue.data(
    //         previousState.copyWith(
    //           offset: previousState.offset + previousState.limit,
    //           isLoading: false,
    //           isLastPage: false,
    //           products: [...previousState.products, ...products],
    //         ),
    //       ),
    //       isRefresh: false);
    //   // state = await AsyncValue.guard(() async => previousState.copyWith(
    //   //       offset: previousState.offset + previousState.limit,
    //   //       isLoading: false,
    //   //       isLastPage: false,
    //   //       products: [...previousState.products, ...products],
    //   //     ));
    // }
  }
}

// class ProductsNotifier extends Notifier<ProductsState> {
//   late final ProductsRepository _productsRepository;
//   @override
//   ProductsState build() {
//     this._productsRepository = ref.watch(productsRepositoryProvider);

//     state = ProductsState();
//     loadNextPage();
//     return state;
//   }

//   Future<void> loadNextPage() async {
//     if (state.isLoading || state.isLastPage) return;

//     state = state.copyWith(isLoading: true);

//     final products = await _productsRepository.getProductsByPage(
//       limit: state.limit,
//       offset: state.offset,
//     );

//     if (products.isEmpty) {
//       state = state.copyWith(isLastPage: true, isLoading: false);
//     } else {
//       state = state.copyWith(
//         offset: state.offset + state.limit,
//         isLoading: false,
//         isLastPage: false,
//         products: [...state.products, ...products],
//       );
//     }
//   }
// }

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) {
    return ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }
}
