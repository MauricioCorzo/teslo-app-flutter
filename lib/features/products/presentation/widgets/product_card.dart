import 'package:flutter/widgets.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ImageViewer(images: widget.product.images),
          const SizedBox(height: 20),
          Text(
            widget.product.title,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          // Text(product.price.toString()),
        ],
      ),
    );
  }

// https://stackoverflow.com/questions/57980225/flutter-issue-listview-rebuilding-items-when-scrolled
  @override
  bool get wantKeepAlive => true;
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.png',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fadeOutDuration: const Duration(milliseconds: 500),
        fadeInCurve: Curves.decelerate,
        fit: BoxFit.cover,
        height: 250,
        image: NetworkImage(
          images.first,
        ),
        placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );
  }
}
