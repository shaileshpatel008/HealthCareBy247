import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/cart_controller.dart';

/// Board 05 "My cart".
class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final items = controller.cart.items;
          return Column(
            children: [
              ScreenHeader(
                title: 'My cart',
                subtitle: items.isEmpty ? null : '${items.length} item${items.length == 1 ? '' : 's'}',
                trailing: items.isEmpty
                    ? null
                    : TextButton.icon(
                        onPressed: () => controller.browse(HomeTab.tests),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add more'),
                        style: TextButton.styleFrom(backgroundColor: AppColors.indigoSoft, shape: const StadiumBorder()),
                      ),
              ),
              Expanded(
                child: items.isEmpty
                    ? EmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: 'Your cart is empty',
                        message: 'Add a test or package to book a home collection.',
                        actions: [
                          SoftButton(label: 'Browse tests', icon: Icons.science_outlined, onTap: () => controller.browse(HomeTab.tests)),
                          SoftButton(label: 'Packages', icon: Icons.inventory_2_outlined, onTap: () => controller.browse(HomeTab.packages)),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CartRow(item: items[i], controller: controller).staggerIn(i),
                            ),
                          Text('Tip: swipe an item left to remove it', textAlign: TextAlign.center, style: AppTextStyles.caption),
                          const SizedBox(height: 16),
                          _BillSummary(controller: controller).staggerIn(items.length),
                          if (controller.cart.savings > 0) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(16)),
                              child: Row(children: [
                                const Icon(Icons.local_offer_outlined, color: AppColors.success, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'You’re saving ${Formatters.rupees(controller.cart.savings)} on this order',
                                  style: AppTextStyles.label.copyWith(color: AppColors.successInk),
                                ),
                              ]),
                            ).animate().fadeIn(delay: 200.ms).shimmer(delay: 500.ms, duration: 1200.ms, color: Colors.white54),
                          ],
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              onPressed: controller.clearAll,
                              child: Text('Empty cart', style: AppTextStyles.label.copyWith(color: AppColors.error)),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() => controller.cart.items.isEmpty
          ? const SizedBox.shrink()
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Pressable(
                onTap: controller.proceed,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.indigo,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 12))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue · Patient details', style: AppTextStyles.button.copyWith(color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ).animate().slideY(begin: 1, duration: 380.ms, curve: Curves.easeOutCubic),
            )),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item, required this.controller});
  final CartItemModel item;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.key),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => controller.confirmRemove(item),
      onDismissed: (_) => controller.remove(item, confirmed: true),
      background: Container(
        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(22)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white),
            Text('Remove', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: item.isPackage ? AppColors.indigo : AppColors.indigoSoft, borderRadius: BorderRadius.circular(16)),
              child: Icon(
                item.isPackage ? Icons.inventory_2_outlined : Icons.water_drop_outlined,
                color: item.isPackage ? Colors.white : AppColors.indigo,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.isPackage ? 'PACKAGE · ${item.package!.tests.length} TESTS' : 'TEST',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: item.isPackage ? AppColors.indigo : AppColors.skyInk),
                  ),
                  const SizedBox(height: 2),
                  Text(Formatters.titleCase(item.title), style: AppTextStyles.titleSmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Formatters.rupees(item.price), style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                if (item.mrp > item.price)
                  Text(Formatters.rupees(item.mrp), style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.muted)),
              ],
            ),
            const SizedBox(width: 8),
            Pressable(
              semanticLabel: 'Remove ${item.title}',
              onTap: () => controller.remove(item),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.errorSoft, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillSummary extends StatelessWidget {
  const _BillSummary({required this.controller});
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final cart = controller.cart;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bill summary', style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _line('MRP total', Formatters.rupees(cart.mrp), AppColors.ink2),
          if (cart.savings > 0) ...[
            const SizedBox(height: 8),
            _line('Package savings', '−${Formatters.rupees(cart.savings)}', AppColors.success, bold: true),
          ],
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: AppColors.line)),
          Row(
            children: [
              Expanded(child: Text('To pay', style: AppTextStyles.h3)),
              TweenAnimationBuilder<double>(
                tween: Tween(end: cart.total.toDouble()),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                builder: (_, v, _) => Text(Formatters.rupees(v.round()), style: AppTextStyles.h3),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Our representative will call you to confirm your booking.', style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _line(String label, String value, Color color, {bool bold = false}) => Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: color, fontWeight: bold ? FontWeight.w700 : FontWeight.w500))),
          Text(value, style: AppTextStyles.body.copyWith(color: color, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
        ],
      );
}
