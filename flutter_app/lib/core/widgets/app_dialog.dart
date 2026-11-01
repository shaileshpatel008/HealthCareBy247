import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'animated_check.dart';
import 'pressable.dart';

enum AppDialogType { success, error, warning, info, neutral }

enum AppDialogIcon { auto, phone, chat, trash, exit, location, camera, cart }

/// The mockup's "Dialogs, messages & states" board as one helper: every
/// dialog pairs an icon, a colour and a plain sentence; it scales in with a
/// soft spring over a dimmed screen. Success shows the self-drawing tick.
///
/// - [show] — one button (acknowledge).
/// - [confirm] — two buttons; resolves `true` only for the primary action.
class AppDialog {
  AppDialog._();

  static Future<void> show({
    required AppDialogType type,
    required String title,
    required String message,
    String buttonText = 'OK',
    AppDialogIcon icon = AppDialogIcon.auto,
    bool barrierDismissible = true,
  }) async {
    await Get.dialog<bool>(
      _AppDialogCard(type: type, icon: icon, title: title, message: message, confirmText: buttonText, cancelText: null),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.ink.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 220),
    );
  }

  static Future<bool> confirm({
    required AppDialogType type,
    required String title,
    required String message,
    required String confirmText,
    String cancelText = 'Cancel',
    AppDialogIcon icon = AppDialogIcon.auto,
  }) async {
    final result = await Get.dialog<bool>(
      _AppDialogCard(type: type, icon: icon, title: title, message: message, confirmText: confirmText, cancelText: cancelText),
      barrierColor: AppColors.ink.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 220),
    );
    return result ?? false;
  }

  static Color strong(AppDialogType t) => switch (t) {
        AppDialogType.success => AppColors.success,
        AppDialogType.error => AppColors.error,
        AppDialogType.warning => AppColors.warning,
        AppDialogType.info => AppColors.info,
        AppDialogType.neutral => AppColors.indigo,
      };

  static Color soft(AppDialogType t) => switch (t) {
        AppDialogType.success => AppColors.successSoft,
        AppDialogType.error => AppColors.errorSoft,
        AppDialogType.warning => AppColors.warningSoft,
        AppDialogType.info => AppColors.infoSoft,
        AppDialogType.neutral => AppColors.indigoSoft,
      };

  static IconData iconFor(AppDialogType t, AppDialogIcon i) => switch (i) {
        AppDialogIcon.phone => Icons.call_outlined,
        AppDialogIcon.chat => Icons.chat_bubble_outline_rounded,
        AppDialogIcon.trash => Icons.delete_outline_rounded,
        AppDialogIcon.exit => Icons.logout_rounded,
        AppDialogIcon.location => Icons.location_on_outlined,
        AppDialogIcon.camera => Icons.photo_camera_outlined,
        AppDialogIcon.cart => Icons.shopping_cart_outlined,
        AppDialogIcon.auto => switch (t) {
            AppDialogType.success => Icons.check_rounded,
            AppDialogType.error => Icons.close_rounded,
            AppDialogType.warning => Icons.warning_amber_rounded,
            AppDialogType.info => Icons.info_outline_rounded,
            AppDialogType.neutral => Icons.help_outline_rounded,
          },
      };
}

class _AppDialogCard extends StatelessWidget {
  const _AppDialogCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
  });

  final AppDialogType type;
  final AppDialogIcon icon;
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    final strong = AppDialog.strong(type);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppDialog.soft(type), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: type == AppDialogType.success && icon == AppDialogIcon.auto
                      ? const AnimatedCheck(size: 36, color: AppColors.success)
                      : Icon(AppDialog.iconFor(type, icon), color: strong, size: 32),
                ),
                const SizedBox(height: 14),
                Text(title, textAlign: TextAlign.center, style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(fontSize: 14)),
                const SizedBox(height: 20),
                if (cancelText == null)
                  _DialogButton(label: confirmText, background: strong, foreground: Colors.white, onTap: () => Get.back(result: true))
                else
                  Row(
                    children: [
                      Expanded(
                        child: _DialogButton(
                          label: cancelText!,
                          background: AppColors.background,
                          foreground: AppColors.ink,
                          onTap: () => Get.back(result: false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DialogButton(label: confirmText, background: strong, foreground: Colors.white, onTap: () => Get.back(result: true)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .scale(begin: const Offset(0.86, 0.86), duration: 320.ms, curve: Curves.easeOutBack)
          .fadeIn(duration: 180.ms),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.label, required this.background, required this.foreground, required this.onTap});

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: AppTextStyles.titleSmall.copyWith(color: foreground)),
      ),
    );
  }
}
