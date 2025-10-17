import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/cached_network_image.dart';

class Good extends StatelessWidget {
  final String name;
  final int price;
  final String imageUrl;
  final String unitText;
  final VoidCallback? onAddToCart;

  const Good({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unitText,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 0,
    );
    return Container(
      height: 198,
      width: 114,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 114,
              width: 114,
              fit: BoxFit.cover,
              placeholder: Container(
                height: 114,
                width: 114,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: Container(
                height: 114,
                width: 114,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ).animate()
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0))
            .fadeIn(duration: 500.ms)
            .then(delay: 200.ms)
            .shimmer(duration: 1000.ms, color: Colors.white),
          SizedBox(height: 5),
          SizedBox(
            height: 74,
            width: 114,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'Stolzl',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0.0),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              formatCurrency.format(
                                price,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Stolzl',
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                                height: 1,
                              ),
                            ).animate()
                              .fadeIn(duration: 400.ms, delay: 400.ms)
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
                            const SizedBox(width: 2),
                            Text(
                              '/$unitText',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Stolzl',
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                                height: 1,
                              ),
                            ).animate()
                              .fadeIn(duration: 400.ms, delay: 450.ms)
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: IconButton(
                        onPressed: onAddToCart,
                        icon: SvgPicture(
                          width: 16,
                          height: 16,
                          AssetBytesLoader('assets/svg/cart.svg.vec'),
                        ),
                      ),
                    ).animate()
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .then()
                      .shimmer(duration: 1200.ms, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideX(begin: 0.3, end: 0.0)
      .then()
      .shimmer(duration: 1500.ms, color: Colors.white);
  }
}
