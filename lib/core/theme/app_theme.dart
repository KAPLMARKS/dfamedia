import 'package:dfamedia/core/theme/app_colors.dart';
import 'package:dfamedia/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // Основные цвета
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.white,

    // ColorScheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.white,
      secondary: AppColors.grey700,
      onPrimary: AppColors.grey800,
      onSecondary: AppColors.white,
      error: AppColors.crimson400,
    ),

    // AppBar тема
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // IconButton тема
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.grey800,
        padding: const EdgeInsets.all(8),
      ),
    ),

    // Text тема
    textTheme: TextTheme(
      bodyLarge: AppFonts.medium16s500w,
      bodyMedium: AppFonts.regular12s400w,
      bodySmall: AppFonts.regular10s400w,
    ),

    // Icon тема
    iconTheme: const IconThemeData(color: AppColors.grey800),

    // Card тема
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // BottomNavigationBar тема
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.crimson400,
      unselectedItemColor: AppColors.grey800,
      type: BottomNavigationBarType.fixed,
    ),

    // Divider тема
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
    ),

    // InputDecoration тема
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey800, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.grey700),
      hintStyle: const TextStyle(color: AppColors.grey700),
    ),

    // ElevatedButton тема
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey800,
        foregroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // TextButton тема
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // OutlinedButton тема
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.grey800,
        side: const BorderSide(color: AppColors.grey800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    // Основные цвета
    primaryColor: AppColors.grey800,
    scaffoldBackgroundColor: AppColors.grey800,

    // ColorScheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.grey800,
      secondary: AppColors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.grey700,
      error: AppColors.crimson400,
    ),

    // AppBar тема
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.grey700,
      elevation: 0,
      centerTitle: true,
    ),

    // IconButton тема
    // IconButton тема
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.all(8),
      ),
    ),

    // Text тема
    textTheme: TextTheme(
      bodyLarge: AppFonts.medium16s500w,
      bodyMedium: AppFonts.regular12s400w,
      bodySmall: AppFonts.regular10s400w,
    ),

    // Icon тема
    iconTheme: const IconThemeData(color: AppColors.white),

    // Card тема
    cardTheme: CardThemeData(
      color: AppColors.grey800,
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // BottomNavigationBar тема
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.grey800,
      selectedItemColor: AppColors.crimson400,
      unselectedItemColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
    ),

    // Divider тема
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
    ),

    // InputDecoration тема
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.white),
      hintStyle: const TextStyle(color: AppColors.white),
    ),

    // ElevatedButton тема
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // TextButton тема
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // OutlinedButton тема
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
