import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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

/// Board 02 "Home".
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.indigo,
        onRefresh: () => controller.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 130),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  HeaderIconButton(icon: Icons.menu_rounded, semanticLabel: 'Open menu', onTap: home.openMenu),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home collection across', style: AppTextStyles.caption),
                        Row(children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.indigo),
                          const SizedBox(width: 3),
                          Text('Ahmedabad', style: AppTextStyles.titleSmall),
                        ]),
                      ],
                    ),
                  ),
                  const CartIconButton(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Formatters.greeting(), style: AppTextStyles.bodyMuted.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Lab tests at home,\nreports the same day', style: AppTextStyles.display.copyWith(fontSize: 28)),
                ],
              ).staggerIn(0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Pressable(
                scale: 0.98,
                onTap: () {
                  home.goTo(HomeTab.tests);
                  Get.find<TestsController>().focusSearch();
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.indigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => Text(
                              controller.testCount.value > 0
                                  ? 'Search ${Formatters.roundDown(controller.testCount.value)}+ tests'
                                  : 'Search tests & packages',
                              style: AppTextStyles.body.copyWith(color: AppColors.ink2, fontSize: 15),
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(10)),
                        child: Text('Search', style: AppTextStyles.caption.copyWith(color: AppColors.indigo, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ).staggerIn(1),
            ),
            const SizedBox(height: 20),
            _BannerCarousel(controller: controller).staggerIn(2),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _QuickActions(controller: controller, home: home).staggerIn(3),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _PrescriptionCard().staggerIn(4),
            ),
            Obx(() => controller.popular.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _PopularPackages(packages: controller.popular, home: home).staggerIn(5),
                  )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: const _WhyUs().staggerIn(6),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: const _HelpRow().staggerIn(7),
            ),
          ],
        ),
      ),
    );
  }
}

/// `newsletter.php` banners: swipeable, auto-advancing, with the mockup's
/// stretched active dot. A banner with `param == "Y"` opens Packages.
class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({required this.controller});
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    final height = width * 0.52;
    return Obx(() {
      if (controller.bannersLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE6E8F1),
            highlightColor: const Color(0xFFF7F8FC),
            child: Container(height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
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
                      borderRadius: BorderRadius.circular(28),
                      child: CachedNetworkImage(
                        imageUrl: b.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(color: AppColors.indigoSoft),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.indigo,
                          padding: const EdgeInsets.all(22),
                          alignment: Alignment.centerLeft,
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

/// Bento grid: Book a test (tall), Health packages, Home visit.
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.controller, required this.home});
  final DashboardController controller;
  final HomeController home;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 228,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Pressable(
              onTap: () => home.goTo(HomeTab.tests),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.science_outlined, color: AppColors.indigo, size: 26),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Book a test', style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              controller.testCount.value == 0
                                  ? 'Single tests, priced individually'
                                  : '${controller.testCount.value} single tests${controller.lowestTestPrice.value == null ? '' : ' from ${Formatters.rupees(controller.lowestTestPrice.value!)}'}',
                              style: AppTextStyles.caption.copyWith(fontSize: 13),
                            )),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _Tile(
                    icon: Icons.inventory_2_outlined,
                    label: 'Health packages',
                    bg: AppColors.skySoft,
                    fg: AppColors.skyInk,
                    onTap: () => home.goTo(HomeTab.packages),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _Tile(
                    icon: Icons.calendar_month_outlined,
                    label: 'Home visit',
                    bg: AppColors.sunSoft,
                    fg: AppColors.sunSoftInk,
                    onTap: home.openBookVisit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.bg, required this.fg, required this.onTap});
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: fg, size: 24),
            Text(label, style: AppTextStyles.titleSmall.copyWith(color: fg, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
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

class _PopularPackages extends StatelessWidget {
  const _PopularPackages({required this.packages, required this.home});
  final List<PackageModel> packages;
  final HomeController home;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(child: Text('Popular packages', style: AppTextStyles.h3)),
              TextButton(onPressed: () => home.goTo(HomeTab.packages), child: const Text('See all')),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 178,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: packages.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = packages[i];
              return Pressable(
                scale: 0.97,
                onTap: () => Get.toNamed(AppRoutes.packageDetail, arguments: p),
                child: Container(
                  width: 210,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Badge(text: '${p.tests.length} TESTS', bg: AppColors.successSoft, fg: AppColors.success),
                          const Spacer(),
                          if (p.discountPercent > 0) _Badge(text: '${p.discountPercent}% OFF', bg: AppColors.sun, fg: AppColors.sunInk),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(Formatters.titleCase(p.displayName), style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(p.tests.take(4).join(', '), style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: Formatters.rupees(p.price), style: AppTextStyles.price.copyWith(fontSize: 17)),
                              if (p.mrp > p.price)
                                TextSpan(
                                  text: '  ${Formatters.rupees(p.mrp)}',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.muted, decoration: TextDecoration.lineThrough),
                                ),
                            ])),
                          ),
                          Obx(() {
                            final added = cart.hasPackage(p);
                            return Builder(
                              builder: (btnContext) => Pressable(
                                semanticLabel: added ? 'Remove ${p.displayName}' : 'Add ${p.displayName}',
                                onTap: () {
                                  if (added) {
                                    cart.removePackage(p);
                                    AppToast.info('${Formatters.titleCase(p.displayName)} removed from cart');
                                  } else {
                                    FlyToCart.run(btnContext, icon: Icons.inventory_2_outlined);
                                    cart.addPackage(p);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: added ? AppColors.successSoft : AppColors.indigo,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(added ? Icons.check_rounded : Icons.add_rounded, color: added ? AppColors.success : Colors.white, size: 20),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
      );
}

class _WhyUs extends StatelessWidget {
  const _WhyUs();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.schedule_rounded, 'Open 24×7'),
      (Icons.home_outlined, 'Home collection'),
      (Icons.bolt_rounded, 'Same-day reports'),
      (Icons.verified_user_outlined, 'Fully automated'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.1,
      children: [
        for (final (icon, label) in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Icon(icon, color: AppColors.indigo, size: 22),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: AppTextStyles.label)),
            ]),
          ),
      ],
    );
  }
}

/// The RN tab bar's "Call Us" and "WhatsApp" buttons, kept one tap away on
/// Home (the redesigned nav has Contact instead of them).
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
          child: _HelpButton(icon: Icons.chat_bubble_outline_rounded, label: 'WhatsApp', bg: AppColors.success, onTap: LauncherService.confirmAndWhatsApp),
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
