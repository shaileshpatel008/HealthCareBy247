import 'dart:io';

import '../datasources/remote/lab_remote_datasource.dart';
import '../models/booking_request_model.dart';
import '../models/lab_test_model.dart';
import '../models/lookup_models.dart';
import '../models/package_model.dart';

/// Single entry point for lab data. Keeps the catalogue (tests, packages,
/// slots, areas, pincodes) in memory once loaded, so moving between Home,
/// Tests, Packages and the booking form doesn't refetch 600+ tests each
/// time — the RN screens re-requested on every focus. Pass `refresh: true`
/// (pull-to-refresh, retry) to go back to the server.
class LabRepository {
  LabRepository._();
  static final LabRepository instance = LabRepository._();

  final LabRemoteDataSource _remote = LabRemoteDataSource();

  List<LabTestModel>? _tests;
  List<PackageModel>? _packages;
  List<TimeSlotModel>? _slots;
  List<OptionModel>? _areas;
  List<OptionModel>? _pincodes;
  List<BranchModel>? _branches;

  Future<ConfigModel?> config() => _remote.fetchConfig();

  Future<List<BannerModel>> banners() => _remote.fetchBanners();

  Future<List<LabTestModel>> tests({bool refresh = false}) async =>
      (!refresh && _tests != null) ? _tests! : _tests = await _remote.fetchTests();

  Future<List<PackageModel>> packages({bool refresh = false}) async =>
      (!refresh && _packages != null) ? _packages! : _packages = await _remote.fetchPackages();

  Future<List<TimeSlotModel>> timeSlots({bool refresh = false}) async =>
      (!refresh && _slots != null) ? _slots! : _slots = await _remote.fetchTimeSlots();

  Future<List<OptionModel>> areas({bool refresh = false}) async {
    if (!refresh && _areas != null) return _areas!;
    final list = await _remote.fetchAreas();
    list.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    return _areas = list;
  }

  Future<List<OptionModel>> pincodes({bool refresh = false}) async {
    if (!refresh && _pincodes != null) return _pincodes!;
    final list = await _remote.fetchPincodes();
    list.sort((a, b) => a.label.compareTo(b.label));
    return _pincodes = list;
  }

  Future<List<BranchModel>> branches({bool refresh = false}) async =>
      (!refresh && _branches != null) ? _branches! : _branches = await _remote.fetchBranches();

  Future<String> submitBooking(BookingRequestModel request) => _remote.submitBooking(request);

  Future<void> submitPrescription({required String name, required String mobileNo, required List<File> images}) =>
      _remote.submitPrescription(name: name, mobileNo: mobileNo, images: images);
}
