import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/product_card.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // ref.read(productsProvider.notifier).loadNextPage();

    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return productsState.when(
        skipLoadingOnReload: true,
        loading: () => const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            )),
        error: (error, _) => Center(child: Text("Error: $error")),
        data: (productsState) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MasonryGridView.count(
                addAutomaticKeepAlives: true,
                cacheExtent: 4000.0,
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 35,
                itemCount: productsState.products.length,
                itemBuilder: (context, index) {
                  final product = productsState.products[index];
                  return GestureDetector(
                    onTap: () => context.push("/product/${product.id}"),
                    child: ProductCard(product: product),
                  );
                },
              ),
              // GridView.custom(
              //   controller: scrollController,
              //   physics: BouncingScrollPhysics(),
              //   shrinkWrap: true,
              //   gridDelegate: SliverQuiltedGridDelegate(
              //     crossAxisCount: 4,
              //     mainAxisSpacing: 20,
              //     crossAxisSpacing: 15,
              //     repeatPattern: QuiltedGridRepeatPattern.inverted,
              //     pattern: const [
              //       QuiltedGridTile(5, 2),
              //       QuiltedGridTile(2, 1),
              //       QuiltedGridTile(2, 1),
              //       QuiltedGridTile(3, 2),
              //     ],
              //   ),
              //   childrenDelegate: SliverChildBuilderDelegate(
              //     childCount: productsState.products.length,
              //     (context, index) {
              //       final product = productsState.products[index];
              //       // return Tile(index: index);
              //       return ProductCard(product: product);
              //     },
              //   ),
              // ),
            ));
  }
}

// https://fluttercomponentlibrary.com/#components/de65bd1f9647382b6c1a26c5068d10b4647257ceac57f14f169d68ab5f6104a2
class Tile extends StatelessWidget {
  final int index;

  const Tile({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Tile $index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

const List<Color> colors = [
  Color(0xffC75B7A), // Midnight Blue
  Color(0xFF333333), // Charcoal
  Color(0xFF2F4F4F), // Dark Slate Gray
  Color(0xFFD9ABAB), // Crimson
  Color(0xFF4682B4), // Steel Blue
  Color(0xffe7e8d83), // Olive Drab
  Color(0xFFAF8260), // Dim Gray
  Color(0xFFB22222), // Firebrick
  Color(0xFF708090), // Slate Gray
  Color(0xFF2E8B57),
];
