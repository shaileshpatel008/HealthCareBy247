import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/lab_test_model.dart';
import '../../../data/repositories/lab_repository.dart';

/// Filter chips built from the API's `Collaction` (sample) field — the
/// sample a test needs is real data, so filtering on it needs no invented
/// categories.
enum SampleFilter {
  all('All'),
  serum('Serum'),
  edta('EDTA blood'),
  urine('Urine'),
  other('Other');

  const SampleFilter(this.label);
  final String label;

  bool matches(String sample) {
    final s = sample.toUpperCase();
    return switch (this) {
      SampleFilter.all => true,
      SampleFilter.serum => s.contains('SERUM'),
      SampleFilter.edta => s.contains('EDTA'),
      SampleFilter.urine => s.contains('URINE'),
      SampleFilter.other => !s.contains('SERUM') && !s.contains('EDTA') && !s.contains('URINE'),
    };
  }
}

/// Port of `BookATest.js`: `reportsinfo.php` list, search by name, add /
/// remove from the shared cart.
class TestsController extends GetxController {
  final RxList<LabTestModel> all = <LabTestModel>[].obs;
  final RxBool loading = true.obs;
  final RxnString error = RxnString();
  final RxString query = ''.obs;
  final Rx<SampleFilter> filter = SampleFilter.all.obs;

  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    loading.value = all.isEmpty;
    error.value = null;
    try {
      all.assignAll(await LabRepository.instance.tests(refresh: refresh));
    } on ApiException catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  List<LabTestModel> get visible {
    final q = query.value.trim().toLowerCase();
    return all.where((t) => filter.value.matches(t.sample) && (q.isEmpty || t.name.toLowerCase().contains(q))).toList();
  }

  void setQuery(String v) => query.value = v;

  void clearQuery() {
    searchController.clear();
    query.value = '';
  }

  /// Home's search bar jumps here with the keyboard up.
  void focusSearch() => Future.delayed(const Duration(milliseconds: 320), searchFocus.requestFocus);

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    super.onClose();
  }
}
