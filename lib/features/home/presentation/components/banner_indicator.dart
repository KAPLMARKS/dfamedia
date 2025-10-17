import 'package:dfamedia/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BannerIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const BannerIndicator({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalCount,
        (index) {
          final isActive = index == currentIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 32 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.grey200,
            ),
          ).animate()
            .fadeIn(duration: 400.ms, delay: (index * 100).ms)
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0))
            .then()
            .shimmer(
              duration: 800.ms, 
              color: isActive ? Colors.white : Colors.transparent,
            );
        },
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: 200.ms)
      .slideY(begin: 0.3, end: 0.0);
  }
}
