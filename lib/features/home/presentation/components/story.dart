import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/story.dart';
import '../../../../core/widgets/cached_network_image.dart';

class Story extends StatelessWidget {
  const Story({
    required this.storyData,
    super.key,
  });

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      width: 80,
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: storyData.previewImage,
                  fit: BoxFit.cover,
                  width: 64,
                  height: 64,
                  placeholder: Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ).animate()
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
              .fadeIn(duration: 500.ms)
              .then(delay: 100.ms)
              .shimmer(duration: 800.ms, color: Colors.white),
            SizedBox(height: 4),
            Text(
              storyData.title,
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'Stolzl',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0.0),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideX(begin: -0.2, end: 0.0)
      .then()
      .shimmer(duration: 1000.ms, color: Colors.white);
  }
}
