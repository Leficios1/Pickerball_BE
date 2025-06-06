import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class AppTheme {

  static ThemeData getTheme(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Adjust font sizes based on screen width
    final fontSizeMultiplier = width < 360
        ? 0.8
        : width < 600
            ? 1.0
            : width < 900
                ? 1.1
                : 1.2;

    final baseTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      fontFamily: 'Roboto',
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        errorStyle: TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 1.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 1.6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 1.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 1.6),
        ),
        labelStyle: TextStyle(
          fontSize: 17,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.all(4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: Colors.grey.shade200),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: AppColors.primaryColor,
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
    );

    // Create responsive text theme
    final textTheme = baseTheme.textTheme.copyWith(
      displayLarge: baseTheme.textTheme.displayLarge!.copyWith(
        fontSize: 32 * fontSizeMultiplier,
      ),
      displayMedium: baseTheme.textTheme.displayMedium!.copyWith(
        fontSize: 28 * fontSizeMultiplier,
      ),
      displaySmall: baseTheme.textTheme.displaySmall!.copyWith(
        fontSize: 24 * fontSizeMultiplier,
      ),
      headlineLarge: baseTheme.textTheme.headlineLarge!.copyWith(
        fontSize: 22 * fontSizeMultiplier,
      ),
      headlineMedium: baseTheme.textTheme.headlineMedium!.copyWith(
        fontSize: 20 * fontSizeMultiplier,
      ),
      headlineSmall: baseTheme.textTheme.headlineSmall!.copyWith(
        fontSize: 18 * fontSizeMultiplier,
      ),
      titleLarge: baseTheme.textTheme.titleLarge!.copyWith(
        fontSize: 16 * fontSizeMultiplier,
      ),
      titleMedium: baseTheme.textTheme.titleMedium!.copyWith(
        fontSize: 14 * fontSizeMultiplier,
      ),
      titleSmall: baseTheme.textTheme.titleSmall!.copyWith(
        fontSize: 12 * fontSizeMultiplier,
      ),
      bodyLarge: baseTheme.textTheme.bodyLarge!.copyWith(
        fontSize: 16 * fontSizeMultiplier,
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium!.copyWith(
        fontSize: 14 * fontSizeMultiplier,
      ),
      bodySmall: baseTheme.textTheme.bodySmall!.copyWith(
        fontSize: 12 * fontSizeMultiplier,
      ),
    );

    // Return theme with responsive text
    return baseTheme.copyWith(
      textTheme: textTheme,
    );
  }
}
