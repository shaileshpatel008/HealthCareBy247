import 'package:get/get.dart';

import '../../contact/controllers/contact_controller.dart';
import '../../packages/controllers/packages_controller.dart';
import '../../tests/controllers/tests_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';

/// The shell hosts four tabs at once (IndexedStack), so all four
/// controllers live as long as the shell does.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<DashboardController>(DashboardController());
    Get.lazyPut<TestsController>(() => TestsController(), fenix: true);
    Get.lazyPut<PackagesController>(() => PackagesController(), fenix: true);
    Get.lazyPut<ContactController>(() => ContactController(), fenix: true);
  }
}
