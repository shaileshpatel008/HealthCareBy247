import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../contact/views/contact_view.dart';
import '../../packages/views/packages_view.dart';
import '../../tests/views/tests_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/floating_nav.dart';
import '../widgets/side_menu.dart';
import 'dashboard_view.dart';

/// The shell: side menu + four tabs kept alive in an IndexedStack (so a
/// half-scrolled test list or a typed search survives switching tabs), the
/// visible one fading/sliding in, and the floating dark nav bar over all.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.handleBack();
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: const SideMenu(),
        drawerScrimColor: AppColors.ink.withValues(alpha: 0.55),
        body: Stack(
          children: [
            Obx(() {
              final index = controller.tab.value.index;
              return IndexedStack(
                index: index,
                children: [
                  for (var i = 0; i < HomeTab.values.length; i++)
                    _TabFade(
                      active: i == index,
                      child: switch (HomeTab.values[i]) {
                        HomeTab.home => const DashboardView(),
                        HomeTab.tests => const TestsView(),
                        HomeTab.packages => const PackagesView(),
                        HomeTab.contact => const ContactView(),
                      },
                    ),
                ],
              );
            }),
            const Positioned(left: 20, right: 20, bottom: 0, child: FloatingNav()),
          ],
        ),
      ),
    );
  }
}

/// Replays a short fade + rise each time its tab becomes the visible one.
class _TabFade extends StatefulWidget {
  const _TabFade({required this.active, required this.child});
  final bool active;
  final Widget child;

  @override
  State<_TabFade> createState() => _TabFadeState();
}

class _TabFadeState extends State<_TabFade> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 260), value: 1);

  @override
  void didUpdateWidget(_TabFade old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.015), end: Offset.zero).animate(curve),
        child: widget.child,
      ),
    );
  }
}
