import 'package:get/get.dart';

import '../controllers/upload_prescription_controller.dart';

class UploadPrescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadPrescriptionController>(() => UploadPrescriptionController());
  }
}
