import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/services/launcher_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/cart_icon_button.dart';
import '../../../core/widgets/fly_to_cart.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../data/models/package_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Board 04 "Package details" — port of `PackageDetails.js` ("Following
/// tests are included in this package") as a full screen with the
/// redesign's hero, fasting note and sticky add-to-cart bar.
class PackageDetailView extends StatelessWidget {
  const PackageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Get.arguments as PackageModel;
    final cart = Get.find<CartService>();
    final needsFasting = p.tests.any((t) => RegExp(r'\b(FBS|FASTING|LIPID|GLYCO|PPBS)\b', caseSensitive: false).hasMatch(t));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                _Hero(package: p),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (needsFasting)
                        Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: AppColors.infoSoft, borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, color: AppColors.info),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Includes fasting tests. Please fast for 10–12 hours before sample collection.',
                                  style: AppTextStyles.label.copyWith(color: AppColors.infoInk, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ).staggerIn(0),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tests included', style: AppTextStyles.h3.copyWith(fontSize: 17)),
                            const SizedBox(height: 4),
                            Text('Following tests are included in this package.', style: AppTextStyles.caption),
                            const SizedBox(height: 14),
                            if (p.tests.isEmpty)
                              Text('This is a single investigation — no sub-tests listed.', style: AppTextStyles.bodyMuted)
                            else
                              for (var i = 0; i < p.tests.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_rounded, size: 19, color: AppColors.success),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(p.tests[i], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
                                    ],
                                  ),
                                ).staggerIn(i, maxSteps: 12),
                          ],
                        ),
                      ).staggerIn(1),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('How it works', style: AppTextStyles.h3.copyWith(fontSize: 17)),
                            const SizedBox(height: 12),
                            for (final (i, step) in const [
                              'Book and pick a collection slot',
                              'Our team collects the sample at your home',
                              'Get your report the same day',
                            ].indexed)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(10)),
                                      child: Text('${i + 1}', style: AppTextStyles.label.copyWith(color: AppColors.indigo, fontSize: 14)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(step, style: AppTextStyles.body)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ).staggerIn(2),
                      const SizedBox(height: 16),
                      Pressable(
                        onTap: () => LauncherService.confirmAndCall(),
                        child: Text(
                          'Questions about this package? Call the lab',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.label.copyWith(color: AppColors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.08), blurRadius: 30, offset: const Offset(0, -10))],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.mrp > p.price)
                          Text(Formatters.rupees(p.mrp), style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.muted)),
                        Text(Formatters.rupees(p.price), style: AppTextStyles.h2),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Obx(() {
                        final added = cart.hasPackage(p);
                        return Builder(
                          builder: (btn) => Pressable(
                            onTap: () {
                              if (added) {
                                Get.toNamed(AppRoutes.cart);
                              } else {
                                FlyToCart.run(btn, icon: Icons.inventory_2_outlined);
                                cart.addPackage(p);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 56,
                              decoration: BoxDecoration(
                                color: added ? AppColors.success : AppColors.indigo,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(added ? Icons.check_rounded : Icons.add_shopping_cart_rounded, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(added ? 'In cart · View cart' : 'Add to cart', style: AppTextStyles.button.copyWith(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.package});
  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    final p = package;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -110,
            top: -60,
            child: Container(width: 260, height: 260, decoration: const BoxDecoration(color: AppColors.indigoRingA, shape: BoxShape.circle)),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HeaderIconButton(icon: Icons.arrow_back_rounded, semanticLabel: 'Back', dark: true, onTap: Get.back),
                      const Spacer(),
                      const _CartOnDark(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (p.savings > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.sun, borderRadius: BorderRadius.circular(8)),
                      child: Text('SAVE ${Formatters.rupees(p.savings)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.sunInk)),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.titleCase(p.displayName),
                    style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (p.tests.isNotEmpty) _HeroChip(icon: Icons.science_outlined, text: '${p.tests.length} tests'),
                      const _HeroChip(icon: Icons.bolt_rounded, text: 'Same-day report'),
                      const _HeroChip(icon: Icons.home_outlined, text: 'Home collection'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      );
}

/// White-on-indigo cart button with the count badge; also the landing
/// target for the fly-to-cart chip on this screen.
class _CartOnDark extends StatefulWidget {
  const _CartOnDark();

  @override
  State<_CartOnDark> createState() => _CartOnDarkState();
}

class _CartOnDarkState extends State<_CartOnDark> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    FlyToCart.addTarget(_key);
  }

  @override
  void dispose() {
    FlyToCart.removeTarget(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: 50,
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          HeaderIconButton(
            icon: Icons.shopping_cart_outlined,
            semanticLabel: 'Cart',
            dark: true,
            onTap: () => Get.toNamed(AppRoutes.cart),
          ),
          Positioned(top: -4, right: -2, child: CartBadge(cart: Get.find<CartService>(), borderColor: AppColors.indigo)),
        ],
      ),
    );
  }
}
