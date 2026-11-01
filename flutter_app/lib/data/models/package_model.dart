/// A health package from `packageswithTest.php`.
class PackageModel {
  const PackageModel({
    required this.packageId,
    required this.name,
    required this.title,
    required this.mrp,
    required this.price,
    required this.tests,
  });

  final int packageId;

  /// `Name` — what the booking API receives in its `Package` field.
  final String name;

  /// `Title` — what the RN list shows and searches on.
  final String title;

  /// `RoutingRate` (MRP before discount).
  final num mrp;

  /// `DiscountRate` (the price charged).
  final num price;

  final List<String> tests;

  num get savings => mrp > price ? mrp - price : 0;
  int get discountPercent => mrp > 0 && mrp > price ? ((mrp - price) * 100 / mrp).round() : 0;
  String get displayName => title.isNotEmpty ? title : name;

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    final rawTests = (json['Tests'] as List?) ?? const [];
    return PackageModel(
      packageId: json['PackageId'] is int ? json['PackageId'] as int : int.tryParse('${json['PackageId']}') ?? 0,
      name: (json['Name'] ?? '').toString().trim(),
      title: (json['Title'] ?? json['Name'] ?? '').toString().trim(),
      mrp: json['RoutingRate'] is num ? json['RoutingRate'] as num : num.tryParse('${json['RoutingRate']}') ?? 0,
      price: json['DiscountRate'] is num ? json['DiscountRate'] as num : num.tryParse('${json['DiscountRate']}') ?? 0,
      tests: rawTests
          .whereType<Map>()
          .map((t) => ((t['FullName'] ?? '').toString().trim().isNotEmpty ? t['FullName'] : t['Name']).toString().trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'PackageId': packageId,
        'Name': name,
        'Title': title,
        'RoutingRate': mrp,
        'DiscountRate': price,
        'Tests': tests.map((t) => {'Name': t}).toList(),
      };
}
