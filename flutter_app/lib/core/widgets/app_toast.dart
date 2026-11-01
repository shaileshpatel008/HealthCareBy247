import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';

enum ToastType { success, error, warning, info }

/// Toasts from the mockup's feedback board: success on dark ink with a
/// green tick chip; error / warning / info as soft tinted cards with a
/// coloured icon. They slide up from the bottom and leave after 3 s.
class AppToast {
  AppToast._();

  static void show(String message, {ToastType type = ToastType.info, String? actionLabel, VoidCallback? onAction}) {
    final (bg, fg, iconColor, border, icon) = switch (type) {
      ToastType.success => (AppColors.ink, Colors.white, Colors.white, Colors.transparent, Icons.check_rounded),
      ToastType.error => (AppColors.errorSoft, AppColors.errorInk, AppColors.error, const Color(0xFFF3C6C6), Icons.error_outline_rounded),
      ToastType.warning =>
        (AppColors.warningSoft, AppColors.warningInk, AppColors.warning, const Color(0xFFF6D9AE), Icons.warning_amber_rounded),
      ToastType.info => (AppColors.infoSoft, AppColors.infoInk, AppColors.info, const Color(0xFFC8D7F7), Icons.info_outline_rounded),
    };

    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      messageText: Text(message, style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
      icon: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: type == ToastType.success
            ? Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFF2E9E5B), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: Colors.white, size: 18),
              )
            : Icon(icon, color: iconColor, size: 24),
      ),
      mainButton: actionLabel == null
          ? null
          : TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onAction?.call();
              },
              child: Text(actionLabel, style: TextStyle(color: type == ToastType.success ? const Color(0xFFA9B4FF) : fg, fontWeight: FontWeight.w800)),
            ),
      backgroundColor: bg,
      borderColor: border,
      borderWidth: 1,
      borderRadius: 18,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 320),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      boxShadows: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.18), blurRadius: 24, offset: const Offset(0, 10))],
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void success(String m, {String? actionLabel, VoidCallback? onAction}) =>
      show(m, type: ToastType.success, actionLabel: actionLabel, onAction: onAction);
  static void error(String m) => show(m, type: ToastType.error);
  static void warning(String m) => show(m, type: ToastType.warning);
  static void info(String m) => show(m, type: ToastType.info);
}
