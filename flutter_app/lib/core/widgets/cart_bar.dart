import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../services/cart_service.dart';
import '../utils/formatters.dart';
import 'pressable.dart';

/// Dark "N items · ₹total · View cart" bar that slides up from the bottom
/// once the cart has something in it (Tests / Packages boards).
class CartBar extends StatelessWidget {
  const CartBar({super.key, this.aboveNav = false});

  /// On a shell tab the bar sits above the floating nav.
  final bool aboveNav;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    final bottom = MediaQuery.of(context).padding.bottom + (aboveNav ? 92 : 20);
    return Obx(() {
      final n = cart.items.length;
      return AnimatedSlide(
        offset: n == 0 ? const Offset(0, 1.6) : Offset.zero,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: n == 0 ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Pressable(
              scale: 0.98,
              onTap: n == 0 ? null : () => Get.toNamed(AppRoutes.cart),
              child: Container(
                height: 64,
                padding: const EdgeInsets.fromLTRB(18, 0, 9, 0),
                decoration: BoxDecoration(
                  color: AppColors.indigo,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$n item${n == 1 ? '' : 's'} added', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          Text(Formatters.rupees(cart.total), style: AppTextStyles.h3.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                    Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        Text('View cart', style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.indigo)),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.indigo),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
