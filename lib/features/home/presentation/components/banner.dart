import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/banner.dart';
import '../../../../core/widgets/cached_network_image.dart';

class BannerItem extends StatelessWidget {
  final BannerData bannerData;
  
  const BannerItem({super.key, required this.bannerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: bannerData.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 144,
          placeholder: Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 48),
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms)
      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0))
      .slideY(begin: 0.2, end: 0.0)
      .then(delay: 300.ms)
      .shimmer(duration: 1200.ms, color: Colors.white);
  }
}
