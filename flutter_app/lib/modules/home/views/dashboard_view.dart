import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/launcher_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/cart_icon_button.dart';
import '../../../core/widgets/fly_to_cart.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../data/models/package_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../tests/controllers/tests_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';

/// Home, approved direction "Option C · Immersive hero" (Home Screen
/// Options canvas): dark brand hero with the logo and a bold promise, round
/// quick actions floating over its edge, the lab in real numbers, the live
/// offer carousel, a 2-column package grid and one-tap Call / WhatsApp.
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status-bar icons over the dark hero.
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: RefreshIndicator(
        color: AppColors.indigo,
        edgeOffset: MediaQuery.of(context).padding.top,
        onRefresh: () => controller.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 130),
          children: [
            // The quick-action card overlaps the hero's bottom edge by
            // ~52 px. It's positioned inside the Stack's own bounds (the
            // hero is padded at the bottom to make room) so the whole card
            // stays tappable — a Positioned hanging outside a Stack draws
            // but doesn't receive taps.
            Stack(
              children: [
                Padding(padding: const EdgeInsets.only(bottom: 62), child: _Hero(home: home, controller: controller)),
                Positioned(left: 16, right: 16, bottom: 0, child: _QuickActions(home: home).staggerIn(2)),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _Numbers(controller: controller).staggerIn(3),
            ),
            const SizedBox(height: 20),
            _BannerCarousel(controller: controller).staggerIn(4),
            Obx(() => controller.popular.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    child: _PackageGrid(packages: controller.popular.take(4).toList(), home: home).staggerIn(5),
                  )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: _PrescriptionCard().staggerIn(6),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _HelpRow(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.home, required this.controller});
  final HomeController home;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -170,
            top: -120,
            child: Container(width: 360, height: 360, decoration: const BoxDecoration(color: AppColors.indigo, shape: BoxShape.circle)),
          ),
          Positioned(
            left: -90,
            bottom: -80,
            child: Container(width: 200, height: 200, decoration: const BoxDecoration(color: AppColors.indigoDark, shape: BoxShape.circle)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 12, 20, 86),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HeaderIconButton(icon: Icons.menu_rounded, semanticLabel: 'Open menu', dark: true, onTap: home.openMenu),
                    const Spacer(),
                    HeaderIconButton(
                      icon: Icons.call_outlined,
                      semanticLabel: 'Call the lab',
                      dark: true,
                      onTap: () => LauncherService.confirmAndCall(),
                    ),
                    const SizedBox(width: 10),
                    const CartIconButton(dark: true),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat())
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.6, 1.6), duration: 2400.ms, curve: Curves.easeOut)
                              .fadeOut(begin: 0.45, duration: 2400.ms),
                          Container(
                            width: 84,
                            height: 84,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                            child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PATHOLOGY & ENDOCRINE LAB',
                              style: AppTextStyles.overline.copyWith(color: const Color(0xFFA9B4FF), letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          Text('Health Care 24×7', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ).staggerIn(0),
                const SizedBox(height: 22),
                Text(
                  'Lab tests at your\ndoor, day or night.',
                  style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 34, height: 1.08),
                ).staggerIn(1),
                const SizedBox(height: 22),
                Pressable(
                  scale: 0.98,
                  semanticLabel: 'Search tests and packages',
                  onTap: () {
                    home.goTo(HomeTab.tests);
                    Get.find<TestsController>().focusSearch();
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Text(
                                controller.testCount.value > 0
                                    ? 'Search ${Formatters.roundDown(controller.testCount.value)}+ tests & packages'
                                    : 'Search tests & packages',
                                style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 15),
                              )),
                        ),
                      ],
                    ),
                  ),
                ).staggerIn(1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Four round actions on a white card floating over the hero's edge.
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.home});
  final HomeController home;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.science_outlined, 'Tests', AppColors.indigo, Colors.white, () => home.goTo(HomeTab.tests)),
      (Icons.inventory_2_outlined, 'Packages', AppColors.sky, Colors.white, () => home.goTo(HomeTab.packages)),
      (Icons.calendar_month_outlined, 'Home visit', AppColors.sun, AppColors.sunInk, home.openBookVisit),
      (Icons.upload_file_rounded, 'Prescription', AppColors.success, Colors.white, () => Get.toNamed(AppRoutes.uploadPrescription)),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.12), blurRadius: 36, offset: const Offset(0, 18))],
      ),
      child: Row(
        children: [
          for (final (icon, label, bg, fg, onTap) in items)
            Expanded(
              child: Pressable(
                onTap: onTap,
                semanticLabel: label,
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                      child: Icon(icon, color: fg, size: 25),
                    ),
                    const SizedBox(height: 8),
                    Text(label, style: AppTextStyles.label.copyWith(fontSize: 12.5)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// "The lab in numbers" — counted from the live API, never hard-coded.
class _Numbers extends StatelessWidget {
  const _Numbers({required this.controller});
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = [
        (controller.testCount.value, 'single tests'),
        (controller.packageCount.value, 'health packages'),
        (controller.branchCount.value, 'branches'),
      ];
      return Row(
        children: [
          for (final (i, (n, label)) in stats.indexed) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: n.toDouble()),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Text(
                        n == 0 ? '–' : '${v.round()}',
                        style: AppTextStyles.h2.copyWith(color: AppColors.indigo, fontSize: 24),
                      ),
                    ),
                    Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}

/// `newsletter.php` banners: swipeable, auto-advancing every 3 s, stretched
/// active dot. A banner with `param == "Y"` opens Packages.
class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({required this.controller});
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    final height = width * 0.5;
    return Obx(() {
      if (controller.bannersLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE6E8F1),
            highlightColor: const Color(0xFFF7F8FC),
            child: Container(height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26))),
          ),
        );
      }
      if (controller.banners.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          SizedBox(
            height: height,
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.banners.length,
              onPageChanged: controller.onBannerChanged,
              itemBuilder: (_, i) {
                final b = controller.banners[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pressable(
                    scale: 0.98,
                    onTap: b.opensPackages ? () => Get.find<HomeController>().goTo(HomeTab.packages) : null,
                    semanticLabel: b.content.replaceAll('\r\n', '. '),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: CachedNetworkImage(
                        imageUrl: b.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(color: AppColors.indigoSoft),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.indigo,
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.bottomLeft,
                          child: Text(b.content, style: AppTextStyles.h3.copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < controller.banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.bannerIndex.value == i ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.bannerIndex.value == i ? AppColors.indigo : AppColors.scrim,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ],
      );
    });
  }
}

/// Two-column package grid — biggest savings first.
class _PackageGrid extends StatelessWidget {
  const _PackageGrid({required this.packages, required this.home});
  final List<PackageModel> packages;
  final HomeController home;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Popular packages', style: AppTextStyles.h3)),
            TextButton(onPressed: () => home.goTo(HomeTab.packages), child: const Text('See all')),
          ],
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: packages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 168,
          ),
          itemBuilder: (_, i) {
            final p = packages[i];
            return Pressable(
              scale: 0.97,
              onTap: () => Get.toNamed(AppRoutes.packageDetail, arguments: p),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      _Badge(text: '${p.tests.length} TESTS', bg: AppColors.successSoft, fg: AppColors.success),
                      const Spacer(),
                      if (p.discountPercent > 0) _Badge(text: '${p.discountPercent}%', bg: AppColors.sun, fg: AppColors.sunInk),
                    ]),
                    const SizedBox(height: 10),
                    Text(
                      Formatters.titleCase(p.displayName),
                      style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.mrp > p.price)
                                Text(Formatters.rupees(p.mrp),
                                    style: AppTextStyles.caption.copyWith(color: AppColors.muted, decoration: TextDecoration.lineThrough)),
                              Text(Formatters.rupees(p.price), style: AppTextStyles.price.copyWith(fontSize: 16)),
                            ],
                          ),
                        ),
                        Obx(() {
                          final added = cart.hasPackage(p);
                          return Builder(
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
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: added ? AppColors.successSoft : AppColors.indigo,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(added ? Icons.check_rounded : Icons.add_rounded,
                                    color: added ? AppColors.success : Colors.white, size: 19),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
        child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
      );
}

/// "Have a prescription?" → the prescription-only upload (Home's
/// "Upload Prescription" tile in the RN app).
class _PrescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: 0.98,
      onTap: () => Get.toNamed(AppRoutes.uploadPrescription),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFB9BCE8), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.upload_file_rounded, color: AppColors.indigo),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Have a prescription?', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('Upload a photo, we’ll call you to book the tests', style: AppTextStyles.caption.copyWith(fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.ink2),
          ],
        ),
      ),
    );
  }
}

/// The RN tab bar's "Call Us" and "WhatsApp", one tap away on Home.
class _HelpRow extends StatelessWidget {
  const _HelpRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HelpButton(icon: Icons.call_outlined, label: 'Call us', bg: AppColors.indigo, onTap: () => LauncherService.confirmAndCall()),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HelpButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'WhatsApp',
            bg: AppColors.success,
            onTap: LauncherService.confirmAndWhatsApp,
          ),
        ),
      ],
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.icon, required this.label, required this.bg, required this.onTap});
  final IconData icon;
  final String label;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        child: Container(
          height: 54,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
}
