import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      // Plus Jakarta Sans via google_fonts — registers the family for
      // runtime download/caching and resolves to the name Flutter needs, so
      // every plain TextStyle in the app picks it up through the default
      // TextTheme without naming the font itself.
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.indigo,
        primary: AppColors.indigo,
        secondary: AppColors.sky,
        error: AppColors.error,
        surface: AppColors.background,
      ),
      textTheme: TextTheme(
        headlineMedium: AppTextStyles.h1,
        headlineSmall: AppTextStyles.h2,
        titleLarge: AppTextStyles.h3,
        titleMedium: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.line,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.indigo, textStyle: AppTextStyles.label),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _border(AppColors.line, 1.5),
        enabledBorder: _border(AppColors.line, 1.5),
        focusedBorder: _border(AppColors.indigo, 2),
        errorBorder: _border(AppColors.error, 2),
        focusedErrorBorder: _border(AppColors.error, 2),
        errorStyle: const TextStyle(height: 0, fontSize: 0),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        showDragHandle: false,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.indigo),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
}
