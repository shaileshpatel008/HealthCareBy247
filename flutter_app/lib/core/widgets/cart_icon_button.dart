import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../services/cart_service.dart';
import 'fly_to_cart.dart';
import 'pressable.dart';

/// Cart button with the sun-yellow count badge. The badge bounces every
/// time something is added (motion board "Add to cart"), and the button is
/// the landing target for the fly-to-cart animation.
class CartIconButton extends StatefulWidget {
  const CartIconButton({super.key, this.dark = false});

  /// White-on-translucent variant for dark headers (Home hero).
  final bool dark;

  @override
  State<CartIconButton> createState() => _CartIconButtonState();
}

class _CartIconButtonState extends State<CartIconButton> {
  final GlobalKey _targetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    FlyToCart.addTarget(_targetKey);
  }

  @override
  void dispose() {
    FlyToCart.removeTarget(_targetKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return Pressable(
      onTap: () => Get.toNamed(AppRoutes.cart),
      semanticLabel: 'Cart',
      child: SizedBox(
        key: _targetKey,
        width: 50,
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: widget.dark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.shopping_cart_outlined, size: 22, color: widget.dark ? Colors.white : AppColors.ink),
            ),
            Positioned(
              top: -4,
              right: -2,
              child: CartBadge(cart: cart, borderColor: widget.dark ? AppColors.ink : AppColors.background),
            ),
          ],
        ),
      ),
    );
  }
}

/// Count badge that plays a bounce whenever [CartService.addPulse] ticks.
class CartBadge extends StatefulWidget {
  const CartBadge({super.key, required this.cart, this.borderColor = AppColors.background});

  final CartService cart;
  final Color borderColor;

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  late final Worker _worker;

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.45).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
    TweenSequenceItem(tween: Tween<double>(begin: 1.45, end: 0.9).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
    TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
  ]).animate(_c);

  @override
  void initState() {
    super.initState();
    // Delayed so the bounce lands as the flying chip arrives.
    _worker = ever<int>(widget.cart.addPulse, (_) => Future.delayed(const Duration(milliseconds: 480), () {
          if (mounted) _c.forward(from: 0);
        }));
  }

  @override
  void dispose() {
    _worker.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final n = widget.cart.items.length;
      if (n == 0) return const SizedBox.shrink();
      return ScaleTransition(
        scale: _scale,
        child: Container(
          constraints: const BoxConstraints(minWidth: 21),
          height: 21,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.sun,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: widget.borderColor, width: 2),
          ),
          child: Text('$n', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.sunInk)),
        ),
      );
    });
  }
}
