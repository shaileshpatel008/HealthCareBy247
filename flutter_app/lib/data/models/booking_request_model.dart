import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

/// Body of `registration.php` — the exact multipart fields
/// `PlaceInquery.js` / `BookAVisit.js` send.
class BookingRequestModel {
  const BookingRequestModel({
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.address1,
    required this.address2,
    required this.area,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.timeSlot,
    required this.packageNames,
    required this.testNames,
    required this.amount,
    required this.prescriptions,
  });

  final String name;
  final String mobileNo;
  final String email;
  final String address1;
  final String address2;
  final String area;
  final String pincode;
  final double latitude;
  final double longitude;
  final DateTime date;
  final String timeSlot;
  final List<String> packageNames;
  final List<String> testNames;
  final num amount;
  final List<File> prescriptions;

  Future<FormData> toFormData() async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final map = <String, dynamic>{
      'MobileNo': mobileNo,
      'Name': name,
      'Address1': address1,
      'Address2': address2,
      'Email': email,
      'TimeSlot': timeSlot,
      'Latitude': latitude.toString(),
      'Longitude': longitude.toString(),
      'RegDate': DateFormat('yyyy-MM-dd').format(date),
      'Area': area,
      'Pincode': pincode,
      'Amount': amount.toString(),
      // RN sent these only when non-empty (BookAVisit) — same here.
      if (packageNames.isNotEmpty) 'Package': packageNames.join(','),
      if (testNames.isNotEmpty) 'Test': testNames.join(','),
    };
    for (var i = 0; i < prescriptions.length; i++) {
      map['Prescription[$i]'] = await MultipartFile.fromFile(
        prescriptions[i].path,
        filename: 'prescription_${stamp}_$i.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      );
    }
    return FormData.fromMap(map);
  }
}
