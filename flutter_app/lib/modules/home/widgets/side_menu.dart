import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/config_service.dart';
import '../../../core/services/launcher_service.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/home_controller.dart';

/// Board 10 "Side menu" — port of `SideMenu.js`: logo, lab name (opens the
/// website, like the RN header did), email (mailto), then every menu entry
/// the RN drawer had (`MenuViewModel`) plus the redesign's extras.
class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final config = Get.find<ConfigService>();
    final cart = Get.find<CartService>();

    final primary = <_Entry>[
      _Entry(Icons.home_rounded, 'Home', () => c.goTo(HomeTab.home)),
      _Entry(Icons.science_outlined, 'Book a test', () => c.goTo(HomeTab.tests)),
      _Entry(Icons.inventory_2_outlined, 'Health packages', () => c.goTo(HomeTab.packages)),
      _Entry(Icons.calendar_month_outlined, 'Book a home visit', c.openBookVisit),
      _Entry(Icons.upload_file_rounded, 'Upload prescription', () => c.openRoute(AppRoutes.uploadPrescription)),
      _Entry(Icons.shopping_cart_outlined, 'My cart', () => c.openRoute(AppRoutes.cart), badge: true),
    ];
    final secondary = <_Entry>[
      _Entry(Icons.biotech_outlined, 'Facilities', () => c.openRoute(AppRoutes.facilities)),
      _Entry(Icons.precision_manufacturing_outlined, 'Instruments', () => c.openRoute(AppRoutes.facilities, arguments: 1)),
      _Entry(Icons.info_outline_rounded, 'About us', () => c.openRoute(AppRoutes.about)),
      _Entry(Icons.call_outlined, 'Contact us', () => c.goTo(HomeTab.contact)),
      _Entry(Icons.share_outlined, 'Share the app', () {
        c.closeMenu();
        LauncherService.shareApp();
      }),
    ];

    return Drawer(
      width: 308,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(32))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.logo, width: 48, height: 58, fit: BoxFit.contain),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: LauncherService.website,
                          child: Text('Health Care Lab', style: AppTextStyles.h3.copyWith(fontSize: 17)),
                        ),
                        Obx(() => GestureDetector(
                              onTap: LauncherService.email,
                              child: Text(
                                config.config.value.email,
                                style: AppTextStyles.caption.copyWith(color: AppColors.indigo, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ],
                    ),
                  ),
                  IconButton(onPressed: c.closeMenu, tooltip: 'Close menu', icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < primary.length; i++) _MenuTile(entry: primary[i], cart: cart).animate(delay: (40 * i).ms).fadeIn().slideX(begin: -0.08),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Divider(color: AppColors.line, height: 1)),
                    for (var i = 0; i < secondary.length; i++)
                      _MenuTile(entry: secondary[i], cart: cart).animate(delay: (40 * (i + primary.length)).ms).fadeIn().slideX(begin: -0.08),
                  ],
                ),
              ),
              Row(
                children: [
                  Pressable(
                    onTap: () async {
                      c.closeMenu();
                      await c.confirmExit();
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        const Icon(Icons.logout_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('Exit', style: AppTextStyles.label.copyWith(fontSize: 14)),
                      ]),
                    ),
                  ),
                  const Spacer(),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, s) => Text(s.hasData ? 'Version ${s.data!.version}' : '', style: AppTextStyles.caption),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Entry {
  _Entry(this.icon, this.label, this.onTap, {this.badge = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool badge;
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.entry, required this.cart});
  final _Entry entry;
  final CartService cart;

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Obx(() {
      // Read both observables on every build: GetX throws ("improper use
      // of GetX") for an Obx that reads none, which is what rows like
      // About us / Facilities did when the reads sat inside branches —
      // they rendered as error boxes in the drawer.
      final tab = home.tab.value;
      final cartCount = cart.items.length;
      // Highlight the entry for the tab that's showing.
      final isActive = switch (entry.label) {
        'Home' => tab == HomeTab.home,
        'Book a test' => tab == HomeTab.tests,
        'Health packages' => tab == HomeTab.packages,
        'Contact us' => tab == HomeTab.contact,
        _ => false,
      };
      return Pressable(
        onTap: entry.onTap,
        scale: 0.98,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: isActive ? AppColors.indigoSoft : Colors.transparent, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Icon(entry.icon, size: 21, color: isActive ? AppColors.indigo : AppColors.ink),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  entry.label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isActive ? AppColors.indigo : AppColors.ink,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              if (entry.badge && cartCount > 0)
                Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.sun, borderRadius: BorderRadius.circular(11)),
                  child: Text('$cartCount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.sunInk)),
                ),
            ],
          ),
        ),
      );
    });
  }
}
