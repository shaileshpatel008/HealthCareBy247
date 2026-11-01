import 'package:get/get.dart';

import '../controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    final mode = Get.arguments is BookingMode ? Get.arguments as BookingMode : BookingMode.visit;
    Get.lazyPut<BookingController>(() => BookingController(mode));
  }
}
