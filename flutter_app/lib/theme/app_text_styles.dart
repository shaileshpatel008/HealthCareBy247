import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type scale from the mockup's Design system board. Plus Jakarta Sans is
/// set once as the theme's `fontFamily` in [AppTheme]; these styles just
/// inherit it like every other TextStyle in the app.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle _base = TextStyle(color: AppColors.ink);

  static TextStyle get display => _base.copyWith(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.15);
  static TextStyle get h1 => _base.copyWith(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.3);
  static TextStyle get h2 => _base.copyWith(fontSize: 22, fontWeight: FontWeight.w800);
  static TextStyle get h3 => _base.copyWith(fontSize: 18, fontWeight: FontWeight.w800);
  static TextStyle get title => _base.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle get titleSmall => _base.copyWith(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle get body => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, height: 1.45);
  static TextStyle get bodyMuted => _base.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.ink2, height: 1.4);
  static TextStyle get caption => _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.ink2);
  static TextStyle get label => _base.copyWith(fontSize: 13, fontWeight: FontWeight.w700);
  static TextStyle get overline =>
      _base.copyWith(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: AppColors.indigo);
  static TextStyle get button => _base.copyWith(fontSize: 16, fontWeight: FontWeight.w800);
  static TextStyle get price => _base.copyWith(fontSize: 18, fontWeight: FontWeight.w800);
}
