import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/package_model.dart';
import '../../../data/repositories/lab_repository.dart';

/// Port of `BookAPackges.js`: `packageswithTest.php` list, search on the
/// package title, add / remove from the cart, open the tests inside it.
class PackagesController extends GetxController {
  final RxList<PackageModel> all = <PackageModel>[].obs;
  final RxBool loading = true.obs;
  final RxnString error = RxnString();
  final RxString query = ''.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    loading.value = all.isEmpty;
    error.value = null;
    try {
      all.assignAll(await LabRepository.instance.packages(refresh: refresh));
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  List<PackageModel> get visible {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((p) => p.displayName.toLowerCase().contains(q) || p.tests.any((t) => t.toLowerCase().contains(q))).toList();
  }

  /// Largest % off across all packages, for the header subtitle.
  int get maxDiscount => all.fold<int>(0, (m, p) => p.discountPercent > m ? p.discountPercent : m);

  void clearQuery() {
    searchController.clear();
    query.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
