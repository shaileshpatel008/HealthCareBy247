import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_dialog.dart';
import '../../../routes/app_routes.dart';
import '../../booking/controllers/booking_controller.dart';

/// The shell's tabs. Cart isn't a tab — the cart button in the nav opens
/// the Cart screen on top, like the header cart buttons do.
enum HomeTab { home, tests, packages, contact }

/// Port of the RN Drawer + bottom TabBar navigation in one place.
class HomeController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Rx<HomeTab> tab = HomeTab.home.obs;

  void openMenu() => scaffoldKey.currentState?.openDrawer();

  void closeMenu() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) Get.back();
  }

  void goTo(HomeTab t) {
    closeMenu();
    if (tab.value == t) return;
    FocusManager.instance.primaryFocus?.unfocus();
    tab.value = t;
  }

  void openBookVisit() {
    closeMenu();
    Get.toNamed(AppRoutes.booking, arguments: BookingMode.visit);
  }

  void openRoute(String route, {dynamic arguments}) {
    closeMenu();
    Get.toNamed(route, arguments: arguments);
  }

  /// Android back: close the menu, else return to the Home tab, else ask
  /// before leaving — the RN Home screen's "Exit Application?" prompt.
  Future<void> handleBack() async {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Get.back();
      return;
    }
    if (tab.value != HomeTab.home) {
      tab.value = HomeTab.home;
      return;
    }
    await confirmExit();
  }

  /// "Exit" in the side menu, and back on the Home tab.
  Future<void> confirmExit() async {
    final leave = await AppDialog.confirm(
      type: AppDialogType.neutral,
      icon: AppDialogIcon.exit,
      title: 'Leave the app?',
      message: 'Items in your cart will still be here next time.',
      confirmText: 'Exit',
      cancelText: 'Stay',
    );
    if (leave) SystemNavigator.pop();
  }
}
