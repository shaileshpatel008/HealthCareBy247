import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/lookup_models.dart';
import '../../../data/repositories/lab_repository.dart';

/// Port of `Contactus.js`: co-ordinator, `branches.php` list with one
/// branch expanded at a time.
class ContactController extends GetxController {
  final RxList<BranchModel> branches = <BranchModel>[].obs;
  final RxBool loading = true.obs;
  final RxnString error = RxnString();
  final RxnInt expanded = RxnInt();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    loading.value = branches.isEmpty;
    error.value = null;
    try {
      branches.assignAll(await LabRepository.instance.branches(refresh: refresh));
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  void toggle(int branchId) => expanded.value = expanded.value == branchId ? null : branchId;
}
