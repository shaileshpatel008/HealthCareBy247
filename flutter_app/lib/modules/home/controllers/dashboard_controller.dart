import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/lookup_models.dart';
import '../../../data/models/package_model.dart';
import '../../../data/repositories/lab_repository.dart';

/// Home tab: banner carousel (`newsletter.php`, auto-advancing every 3 s
/// like the RN Carousel) and the "Popular packages" row.
class DashboardController extends GetxController {
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxBool bannersLoading = true.obs;
  final RxInt bannerIndex = 0.obs;
  final PageController pageController = PageController(viewportFraction: 1);

  final RxList<PackageModel> popular = <PackageModel>[].obs;
  final RxInt testCount = 0.obs;
  final RxInt packageCount = 0.obs;
  final RxInt branchCount = 0.obs;
  final RxnNum lowestTestPrice = RxnNum();

  Timer? _autoPlay;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    await Future.wait([_loadBanners(), _loadCatalogue(refresh)]);
  }

  Future<void> _loadBanners() async {
    bannersLoading.value = banners.isEmpty;
    try {
      banners.assignAll(await LabRepository.instance.banners());
      _startAutoPlay();
    } on ApiException {
      // Carousel just hides; the rest of Home still works.
    } finally {
      bannersLoading.value = false;
    }
  }

  Future<void> _loadCatalogue(bool refresh) async {
    try {
      final packs = await LabRepository.instance.packages(refresh: refresh);
      // Biggest savings first — the offers worth showing on Home.
      final sorted = [...packs]..sort((a, b) => b.savings.compareTo(a.savings));
      popular.assignAll(sorted.where((p) => p.tests.isNotEmpty).take(8));
      final tests = await LabRepository.instance.tests(refresh: refresh);
      testCount.value = tests.length;
      packageCount.value = packs.length;
      // Branch count for the "lab in numbers" strip (branches.php).
      LabRepository.instance.branches(refresh: refresh).then((b) => branchCount.value = b.length).catchError((_) => 0);
      final rates = tests.map((t) => t.rate).where((r) => r > 0);
      lowestTestPrice.value = rates.isEmpty ? null : rates.reduce((a, b) => a < b ? a : b);
    } on ApiException {
      // Tabs show their own retry state.
    }
  }

  void _startAutoPlay() {
    _autoPlay?.cancel();
    if (banners.length < 2) return;
    _autoPlay = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients) return;
      final next = (bannerIndex.value + 1) % banners.length;
      pageController.animateToPage(next, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    });
  }

  void onBannerChanged(int i) => bannerIndex.value = i;

  @override
  void onClose() {
    _autoPlay?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
