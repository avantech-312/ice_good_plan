import 'package:flutter/cupertino.dart';

/// Ice Good Plan theme colors
abstract final class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color barBackground = Color(0xFFE3F2FD);
  static const Color accent = Color(0xFF42A5F5);
  static const Color cardSurface = Color(0xFFF8F8F8);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF6B6B70);
}

CupertinoThemeData get appTheme => CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accent,
      primaryContrastingColor: Color(0xFFFFFFFF),
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: AppColors.barBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.textPrimary,
        textStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
        ),
        navTitleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
        pickerTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 21,
        ),
      ),
    );
