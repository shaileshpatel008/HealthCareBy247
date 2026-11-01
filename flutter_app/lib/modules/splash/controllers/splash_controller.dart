import 'package:get/get.dart';

import '../../../core/services/update_service.dart';
import '../../../data/repositories/lab_repository.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _start();
  }

  Future<void> _start() async {
    // Warm the catalogue while the logo animates, so Home's popular
    // packages and the Tests tab open already filled. Failures are fine
    // here — each screen loads (and shows its own error) on its own.
    Future<void> warm() async {
      try {
        await Future.wait([LabRepository.instance.packages(), LabRepository.instance.tests()]).timeout(const Duration(seconds: 4));
      } catch (_) {}
    }

    await Future.wait([warm(), Future.delayed(const Duration(milliseconds: 1800))]);
    Get.offAllNamed(AppRoutes.home);
    // App.js ran the store-version check on launch; same here, once Home
    // is showing so the update sheet sits over real content.
    Future.delayed(const Duration(milliseconds: 600), UpdateService.checkOnce);
  }
}
