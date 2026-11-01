import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../models/booking_request_model.dart';
import '../../models/lab_test_model.dart';
import '../../models/lookup_models.dart';
import '../../models/package_model.dart';

/// Every endpoint the RN app calls, one method each.
class LabRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<ConfigModel?> fetchConfig() async {
    final rows = await _getList(ApiConstants.sysConfig);
    return rows.isEmpty ? null : ConfigModel.fromJson(rows.first);
  }

  Future<List<BannerModel>> fetchBanners() async =>
      (await _getList(ApiConstants.newsletter)).map(BannerModel.fromJson).where((b) => b.imageUrl.isNotEmpty).toList();

  Future<List<LabTestModel>> fetchTests() async => (await _getList(ApiConstants.reports)).map(LabTestModel.fromJson).toList();

  Future<List<PackageModel>> fetchPackages() async =>
      (await _getList(ApiConstants.packages)).map(PackageModel.fromJson).toList();

  Future<List<TimeSlotModel>> fetchTimeSlots() async =>
      (await _getList(ApiConstants.timeSlots)).map(TimeSlotModel.fromJson).toList();

  Future<List<OptionModel>> fetchPincodes() async =>
      (await _getList(ApiConstants.pincodes)).map(OptionModel.pincode).toList();

  Future<List<OptionModel>> fetchAreas() async => (await _getList(ApiConstants.areas)).map(OptionModel.area).toList();

  Future<List<BranchModel>> fetchBranches() async => (await _getList(ApiConstants.branches)).map(BranchModel.fromJson).toList();

  /// Returns the inquiry id the server assigns (shown to the patient, as
  /// the RN alert did: "Your inquiry (ID: …) has been submitted").
  Future<String> submitBooking(BookingRequestModel request) async {
    final body = await _post(ApiConstants.registration, await request.toFormData());
    if ((body['status'] ?? '').toString().toLowerCase() == 'success') {
      return (body['id'] ?? '').toString();
    }
    throw ApiException((body['message'] ?? 'We couldn’t place your booking. Please try again.').toString());
  }

  /// `onlyPrescription.php`. The RN screen treated any parseable response
  /// as success; here a body with `status` other than "success" is an error.
  Future<void> submitPrescription({required String name, required String mobileNo, required List<File> images}) async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final map = <String, dynamic>{'MobileNo': mobileNo, 'Name': name};
    for (var i = 0; i < images.length; i++) {
      map['Prescription[$i]'] = await MultipartFile.fromFile(
        images[i].path,
        filename: 'image_${stamp}_$i.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      );
    }
    final body = await _post(ApiConstants.onlyPrescription, FormData.fromMap(map));
    final status = (body['status'] ?? 'success').toString().toLowerCase();
    if (status != 'success') {
      throw ApiException((body['message'] ?? 'Prescription submission failed. Please try again.').toString());
    }
  }

  Future<List<Map<String, dynamic>>> _getList(String path) async {
    try {
      final response = await _dio.get(path);
      final body = _decode(response.data);
      if ((body['status'] ?? '').toString().toLowerCase() != 'success') {
        throw ApiException('The lab’s server returned no data. Please try again.');
      }
      return ((body['data'] as List?) ?? const []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _post(String path, FormData data) async {
    try {
      final response = await _dio.post(path, data: data);
      return _decode(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// The PHP endpoints sometimes answer with a JSON string body (or a
  /// stray BOM / whitespace before it), so decode defensively.
  Map<String, dynamic> _decode(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final text = data.trim().replaceFirst('﻿', '');
      final start = text.indexOf('{');
      if (start >= 0) {
        final decoded = jsonDecode(text.substring(start));
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }
    }
    throw ApiException('The lab’s server sent an unexpected reply. Please try again.');
  }
}
