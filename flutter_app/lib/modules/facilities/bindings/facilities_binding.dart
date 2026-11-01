import 'package:get/get.dart';

import '../controllers/facilities_controller.dart';

class FacilitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacilitiesController>(() => FacilitiesController());
  }
}
