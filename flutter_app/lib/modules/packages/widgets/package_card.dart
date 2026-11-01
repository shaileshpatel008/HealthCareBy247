import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/fly_to_cart.dart';
import '../../../core/widgets/pressable.dart';
import '../../../data/models/package_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Package row: name, test count, the first few tests, price with the MRP
/// struck through and % off, "View tests" (the RN info button) and Add.
class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package});
  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    final p = package;
    return Pressable(
      scale: 0.98,
      onTap: () => Get.toNamed(AppRoutes.packageDetail, arguments: p),
      child: Obx(() {
        final added = cart.hasPackage(p);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: added ? AppColors.indigo : Colors.transparent, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Formatters.titleCase(p.displayName), style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text(
                          p.tests.isEmpty ? 'Single investigation' : '${p.tests.length} tests · ${p.tests.take(3).join(', ')}',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (p.discountPercent > 0)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.sun, borderRadius: BorderRadius.circular(8)),
                      child: Text('${p.discountPercent}% OFF', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.sunInk)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: Formatters.rupees(p.price), style: AppTextStyles.price),
                      if (p.mrp > p.price)
                        TextSpan(
                          text: '  ${Formatters.rupees(p.mrp)}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.muted, decoration: TextDecoration.lineThrough),
                        ),
                    ])),
                  ),
                  Text('View tests', style: AppTextStyles.label.copyWith(color: AppColors.indigo)),
                  const SizedBox(width: 10),
                  Builder(
                    builder: (btn) => Pressable(
                      semanticLabel: added ? 'Remove ${p.displayName}' : 'Add ${p.displayName}',
                      onTap: () {
                        if (added) {
                          cart.removePackage(p);
                          AppToast.info('${Formatters.titleCase(p.displayName)} removed from cart');
                        } else {
                          FlyToCart.run(btn, icon: Icons.inventory_2_outlined);
                          cart.addPackage(p);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: added ? AppColors.successSoft : AppColors.indigo, borderRadius: BorderRadius.circular(12)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(added ? Icons.check_rounded : Icons.add_rounded, size: 16, color: added ? AppColors.success : Colors.white),
                          const SizedBox(width: 5),
                          Text(added ? 'Added' : 'Add',
                              style: TextStyle(color: added ? AppColors.success : Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
