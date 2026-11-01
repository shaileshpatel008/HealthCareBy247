import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // `put`, not `lazyPut`: the view never reads the controller, so a lazy
    // factory would never run and the redirect would never fire.
    Get.put<SplashController>(SplashController());
  }
}
