import 'package:get/get.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/lab_test_model.dart';
import '../../data/models/package_model.dart';
import 'storage_service.dart';

/// Port of `CartContext`: the cart lives app-wide, survives restarts
/// (persisted on every change, same as the RN reducer's AsyncStorage
/// effect), and is read by Tests, Packages, Cart and the booking form.
class CartService extends GetxService {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  /// Bumped on every add so the cart badge can replay its bounce even when
  /// the count stays the same (remove + add).
  final RxInt addPulse = 0.obs;

  CartService init() {
    items.assignAll(StorageService.instance.cartItems.map(CartItemModel.fromJson).whereType<CartItemModel>());
    ever<List<CartItemModel>>(items, (list) => StorageService.instance.cartItems = list.map((e) => e.toJson()).toList());
    return this;
  }

  int get count => items.length;
  List<PackageModel> get packages => items.where((i) => i.isPackage).map((i) => i.package!).toList();
  List<LabTestModel> get tests => items.where((i) => !i.isPackage).map((i) => i.test!).toList();

  /// Bill summary — same arithmetic as `MyCartView.calculateTotalPrice`
  /// (tests at ReportRate, packages at DiscountRate), with MRP and savings
  /// broken out for the redesigned summary card.
  num get total => items.fold<num>(0, (sum, i) => sum + i.price);
  num get mrp => items.fold<num>(0, (sum, i) => sum + i.mrp);
  num get savings => mrp - total;

  bool hasTest(LabTestModel t) => items.any((i) => !i.isPackage && i.test!.reportNo == t.reportNo);
  bool hasPackage(PackageModel p) => items.any((i) => i.isPackage && i.package!.packageId == p.packageId);

  void addTest(LabTestModel t) {
    if (hasTest(t)) return;
    items.add(CartItemModel.test(t));
    addPulse.value++;
  }

  void addPackage(PackageModel p) {
    if (hasPackage(p)) return;
    items.add(CartItemModel.package(p));
    addPulse.value++;
  }

  void removeTest(LabTestModel t) => items.removeWhere((i) => !i.isPackage && i.test!.reportNo == t.reportNo);
  void removePackage(PackageModel p) => items.removeWhere((i) => i.isPackage && i.package!.packageId == p.packageId);
  void remove(CartItemModel item) => items.removeWhere((i) => i.key == item.key);

  /// The booking form edits the cart's selection in place (RN
  /// `updateAssingPackage` / `updateAssingTest` dispatched LOAD_CART).
  void replaceAll({required List<PackageModel> packages, required List<LabTestModel> tests}) {
    items.assignAll([...tests.map(CartItemModel.test), ...packages.map(CartItemModel.package)]);
  }

  void clear() => items.clear();
}
