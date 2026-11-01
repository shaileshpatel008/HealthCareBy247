import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'cart_icon_button.dart';
import 'pressable.dart';

/// Screen header from the mockup: square white back (or menu) button,
/// title with an optional subtitle, optional cart button with count badge.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading = HeaderLeading.back,
    this.onLeading,
    this.showCart = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final HeaderLeading leading;
  final VoidCallback? onLeading;
  final bool showCart;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          if (leading != HeaderLeading.none) ...[
            HeaderIconButton(
              icon: leading == HeaderLeading.menu ? Icons.menu_rounded : Icons.arrow_back_rounded,
              semanticLabel: leading == HeaderLeading.menu ? 'Open menu' : 'Back',
              onTap: onLeading ?? () => Get.back(),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h2, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption.copyWith(fontSize: 13)),
              ],
            ),
          ),
          ?trailing,
          if (showCart) const CartIconButton(),
        ],
      ),
    );
  }
}

enum HeaderLeading { back, menu, none }

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({super.key, required this.icon, required this.onTap, required this.semanticLabel, this.dark = false});

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: dark ? Colors.white.withValues(alpha: 0.14) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 22, color: dark ? Colors.white : AppColors.ink),
      ),
    );
  }
}
