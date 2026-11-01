import 'package:flutter/material.dart';

/// Palette from the approved redesign mockup ("Health Care Lab — Flutter App
/// Redesign" canvas, Design system board). Indigo is the logo's own blue and
/// the React Native app's `colors.primary` (#3E4095), so the brand carries
/// over; everything else is the mockup's soft clinical surface set plus one
/// status colour per message type, each paired with a soft fill for
/// text-on-tint use (toasts, banners, inline field states).
class AppColors {
  AppColors._();

  // Brand
  static const Color indigo = Color(0xFF3E4095);
  static const Color indigoDark = Color(0xFF2C2E78);
  static const Color indigoSoft = Color(0xFFECEDFA);
  static const Color indigoRingA = Color(0xFF4A4CA3);
  static const Color indigoRingB = Color(0xFF35378A);
  static const Color sky = Color(0xFF0B78B8);
  static const Color skyInk = Color(0xFF0A5F92);
  static const Color skySoft = Color(0xFFE3F3FC);
  static const Color sun = Color(0xFFFDB022);
  static const Color sunInk = Color(0xFF3A2400);
  static const Color sunSoft = Color(0xFFFFF4DE);
  static const Color sunSoftInk = Color(0xFF6B4100);

  // Neutrals
  static const Color ink = Color(0xFF14163B);
  static const Color ink2 = Color(0xFF4A4E6E);
  static const Color muted = Color(0xFF6B6F8E);
  static const Color line = Color(0xFFE3E5F0);
  static const Color background = Color(0xFFF3F4FA);
  static const Color field = Color(0xFFF7F8FC);
  static const Color card = Colors.white;
  static const Color scrim = Color(0xFFD9DBEA);
  static const Color navIdle = Color(0xFFC9CBE0);

  // Status — strong colour for icons/buttons, soft fill + deep ink for
  // text sitting on a tinted background (all pairs pass 4.5:1).
  static const Color success = Color(0xFF157F3B);
  static const Color successSoft = Color(0xFFE6F5EC);
  static const Color successInk = Color(0xFF115F2D);
  static const Color error = Color(0xFFC42B2B);
  static const Color errorSoft = Color(0xFFFCEBEB);
  static const Color errorInk = Color(0xFF8E1D1D);
  static const Color errorField = Color(0xFFFFF8F8);
  static const Color warning = Color(0xFFA75A06);
  static const Color warningSoft = Color(0xFFFDF1E1);
  static const Color warningInk = Color(0xFF7A4204);
  static const Color info = Color(0xFF1E56C8);
  static const Color infoSoft = Color(0xFFE8EFFC);
  static const Color infoInk = Color(0xFF173F94);
}
