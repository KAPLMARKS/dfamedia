import 'package:flutter/material.dart';

class AppColors {
  static const Color crimson400 = Color(0xFFE50D32);
  static const Color gray100 = Color(0xFFF2F3F8);
  static const Color grey200 = Color(0xFFBEBFC8);
  static const Color grey700 = Color(0xFF2A2C39);
  static const Color grey800 = Color(0xFF1F2029);
  static const Color systemYellow100 = Color(0xFFFCF3D2);
  static const Color white = Color(0xFFFFFFFF);

  static const Gradient storiesGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF74B521), Color(0xFFE50D32)],
    stops: [0.0, 0.1, 0.5, 1],
  );

  static const Gradient darkStoriesGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6366F1), // Индиго
      Color(0xFF8B5CF6), // Фиолетовый
    ],
    stops: [0.0, 0.1, 0.5, 1],
  );
}
