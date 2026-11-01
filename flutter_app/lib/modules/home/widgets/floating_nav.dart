import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/widgets/cart_icon_button.dart';
import '../../../core/widgets/fly_to_cart.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../controllers/home_controller.dart';

/// The mockup's floating dark pill nav: Home, Tests, Packages, Cart,
/// Contact. The active tab expands into a white pill with its label.
class FloatingNav extends StatefulWidget {
  const FloatingNav({super.key});

  @override
  State<FloatingNav> createState() => _FloatingNavState();
}

class _FloatingNavState extends State<FloatingNav> {
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    FlyToCart.addTarget(_cartKey);
  }

  @override
  void dispose() {
    FlyToCart.removeTarget(_cartKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final cart = Get.find<CartService>();
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.25), blurRadius: 32, offset: const Offset(0, 16))],
        ),
        child: Obx(() {
          final active = c.tab.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', active: active == HomeTab.home, onTap: () => c.goTo(HomeTab.home)),
              _NavItem(icon: Icons.science_outlined, label: 'Tests', active: active == HomeTab.tests, onTap: () => c.goTo(HomeTab.tests)),
              _NavItem(
                icon: Icons.inventory_2_outlined,
                label: 'Packages',
                active: active == HomeTab.packages,
                onTap: () => c.goTo(HomeTab.packages),
              ),
              Pressable(
                onTap: () => Get.toNamed(AppRoutes.cart),
                semanticLabel: 'Cart',
                child: SizedBox(
                  key: _cartKey,
                  width: 46,
                  height: 46,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: AppColors.navIdle, size: 23),
                      Positioned(top: 2, right: 0, child: CartBadge(cart: cart, borderColor: AppColors.ink)),
                    ],
                  ),
                ),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Contact',
                active: active == HomeTab.contact,
                onTap: () => c.goTo(HomeTab.contact),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        height: 46,
        padding: EdgeInsets.symmetric(horizontal: active ? 14 : 11),
        decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: active ? 21 : 23, color: active ? AppColors.ink : AppColors.navIdle),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: active
                  ? Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(label, style: const TextStyle(color: AppColors.ink, fontSize: 13.5, fontWeight: FontWeight.w700)),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
