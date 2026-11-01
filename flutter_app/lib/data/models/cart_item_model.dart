import 'lab_test_model.dart';
import 'package_model.dart';

/// One cart line — either a test or a package, never both. Mirrors the RN
/// cart, which stored raw API objects and told them apart by whether
/// `ReportNo` or `PackageId` was set.
class CartItemModel {
  CartItemModel.test(LabTestModel this.test) : package = null;
  CartItemModel.package(PackageModel this.package) : test = null;

  final LabTestModel? test;
  final PackageModel? package;

  bool get isPackage => package != null;
  String get key => isPackage ? 'p${package!.packageId}' : 't${test!.reportNo}';
  String get title => isPackage ? package!.displayName : test!.name;

  /// What the patient pays for this line.
  num get price => isPackage ? package!.price : test!.rate;

  /// Pre-discount price (packages only differ).
  num get mrp => isPackage ? package!.mrp : test!.rate;

  Map<String, dynamic> toJson() => isPackage ? package!.toJson() : test!.toJson();

  static CartItemModel? fromJson(Map<String, dynamic> json) {
    if (json['PackageId'] != null) return CartItemModel.package(PackageModel.fromJson(json));
    if (json['ReportNo'] != null) return CartItemModel.test(LabTestModel.fromJson(json));
    return null;
  }
}
