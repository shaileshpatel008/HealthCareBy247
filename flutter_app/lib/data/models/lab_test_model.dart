/// A single test from `reportsinfo.php`.
class LabTestModel {
  const LabTestModel({required this.reportNo, required this.name, required this.rate, required this.sample});

  final int reportNo;
  final String name;
  final num rate;

  /// The API's `Collaction` field — the sample needed, e.g. "1 CC SERUM".
  final String sample;

  factory LabTestModel.fromJson(Map<String, dynamic> json) => LabTestModel(
        reportNo: _asInt(json['ReportNo']),
        name: (json['ReportName'] ?? '').toString().trim(),
        rate: _asNum(json['ReportRate']),
        sample: (json['Collaction'] ?? '').toString().trim(),
      );

  /// Same keys as the API so carts saved by this model round-trip exactly.
  Map<String, dynamic> toJson() => {'ReportNo': reportNo, 'ReportName': name, 'ReportRate': rate, 'Collaction': sample};
}

int _asInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
num _asNum(dynamic v) => v is num ? v : num.tryParse('$v') ?? 0;
