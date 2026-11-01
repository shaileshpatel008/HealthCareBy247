import 'package:intl/intl.dart';

/// `sysConfig.php` — contact numbers and links used by Call / WhatsApp /
/// Email / website actions across the app.
class ConfigModel {
  const ConfigModel({
    required this.callNumbers,
    required this.whatsAppNo,
    required this.email,
    required this.contactPerson,
    required this.website,
  });

  /// Raw `CallusNo`, e.g. "9537299801 / 9909464446".
  final String callNumbers;
  final String whatsAppNo;
  final String email;
  final String contactPerson;
  final String website;

  /// The RN tab bar dialled `CallusNo.split("/")[0]`.
  String get primaryCallNo => callNumbers.split('/').first.trim();

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        callNumbers: (json['CallusNo'] ?? '').toString().trim(),
        whatsAppNo: (json['WhatsAppNo'] ?? '').toString().trim(),
        email: (json['Email'] ?? '').toString().trim(),
        contactPerson: (json['ContactPerson'] ?? '').toString().trim(),
        website: (json['websitename'] ?? '').toString().trim(),
      );

  Map<String, dynamic> toJson() => {
        'CallusNo': callNumbers,
        'WhatsAppNo': whatsAppNo,
        'Email': email,
        'ContactPerson': contactPerson,
        'websitename': website,
      };
}

/// `newsletter.php` — home carousel slide.
class BannerModel {
  const BannerModel({required this.id, required this.content, required this.imageUrl, required this.opensPackages});

  final int id;
  final String content;
  final String imageUrl;

  /// `param == "Y"` → tapping the banner opens the package list.
  final bool opensPackages;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['NewsId'] is int ? json['NewsId'] as int : int.tryParse('${json['NewsId']}') ?? 0,
        content: (json['content'] ?? '').toString(),
        imageUrl: (json['preview_url'] ?? '').toString(),
        opensPackages: (json['param'] ?? '').toString().toUpperCase() == 'Y',
      );
}

/// `branches.php`.
class BranchModel {
  const BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phones,
    required this.pincode,
    required this.mapUrl,
    required this.mapUrlIos,
  });

  final int id;
  final String name;
  final String address;
  final List<String> phones;
  final String pincode;
  final String mapUrl;
  final String mapUrlIos;

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json['BranchId'] is int ? json['BranchId'] as int : int.tryParse('${json['BranchId']}') ?? 0,
        name: (json['Name'] ?? '').toString().trim(),
        address: (json['Address'] ?? '').toString().trim(),
        phones: [json['ContactNo_1'], json['ContactNo_2']]
            .map((p) => (p ?? '').toString().trim())
            .where((p) => p.isNotEmpty)
            .toList(),
        pincode: (json['Pincode'] ?? '').toString().trim(),
        mapUrl: (json['LocationURL'] ?? '').toString().trim(),
        mapUrlIos: (json['LocationURLIOS'] ?? '').toString().trim(),
      );
}

/// `timeSlot.php`.
class TimeSlotModel {
  const TimeSlotModel({required this.id, required this.label});

  final int id;

  /// As the API sends it, e.g. "07:00 - 07:30" (a few use " : " as the
  /// separator, e.g. "01:00 : 01:30"); posted back verbatim as `TimeSlot`.
  final String label;

  /// Start time in minutes after midnight, from the first HH:MM in the
  /// label. Null when the label can't be read (such a slot is always shown).
  int? get startMinutes {
    final m = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(label);
    if (m == null) return null;
    return int.parse(m.group(1)!) * 60 + int.parse(m.group(2)!);
  }

  /// "07:00 - 07:30" → "7:00 – 7:30 AM", for display only.
  String get displayLabel {
    final times = RegExp(r'(\d{1,2}):(\d{2})').allMatches(label).toList();
    if (times.length < 2) return label;
    final fmt = DateFormat('h:mm a');
    String t(RegExpMatch m) => fmt.format(DateTime(2000, 1, 1, int.parse(m.group(1)!) % 24, int.parse(m.group(2)!)));
    return '${t(times[0])} – ${t(times[1])}';
  }

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
        id: json['TimeSlotID'] is int ? json['TimeSlotID'] as int : int.tryParse('${json['TimeSlotID']}') ?? 0,
        label: (json['Slot'] ?? '').toString().trim(),
      );
}

/// A single-select dropdown entry (area / pincode).
class OptionModel {
  const OptionModel({required this.id, required this.label});
  final int id;
  final String label;

  factory OptionModel.area(Map<String, dynamic> json) => OptionModel(
        id: json['LocationID'] is int ? json['LocationID'] as int : int.tryParse('${json['LocationID']}') ?? 0,
        label: (json['LocationName'] ?? '').toString().trim(),
      );

  factory OptionModel.pincode(Map<String, dynamic> json) => OptionModel(
        id: json['PincodeID'] is int ? json['PincodeID'] as int : int.tryParse('${json['PincodeID']}') ?? 0,
        label: (json['PincodeNumber'] ?? '').toString().trim(),
      );

  @override
  bool operator ==(Object other) => other is OptionModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
