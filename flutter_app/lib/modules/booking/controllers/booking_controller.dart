import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/photo_picker_service.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/booking_request_model.dart';
import '../../../data/models/lab_test_model.dart';
import '../../../data/models/lookup_models.dart';
import '../../../data/models/package_model.dart';
import '../../../data/repositories/lab_repository.dart';
import '../../../routes/app_routes.dart';
import '../../booking_success/booking_success_args.dart';

/// `cart` = RN "Place Inquiry" (opened from the cart; package/test
/// selection *is* the cart, edits write back to it). `visit` = RN "Book
/// Visit" (opened from Home/menu; its own selection, cart untouched).
enum BookingMode { cart, visit }

/// Field ids, in on-screen order — used to scroll to the first error.
enum BookingField { name, mobile, email, address1, area, pincode, location, slot, selection }

/// Port of `PlaceInquery.js` / `BookAVisit.js`: same fields, same rules,
/// same `registration.php` request — with errors shown inline per field,
/// a banner counting them, a shake on each failed submit and a scroll to
/// the first problem (the RN screens scrolled and focused too).
class BookingController extends GetxController {
  BookingController(this.mode);

  final BookingMode mode;
  final CartService _cart = Get.find<CartService>();
  final LabRepository _repo = LabRepository.instance;

  // Patient & address
  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final address1Ctrl = TextEditingController();
  final address2Ctrl = TextEditingController();
  final nameFocus = FocusNode();
  final mobileFocus = FocusNode();
  final emailFocus = FocusNode();
  final address1Focus = FocusNode();

  final Rxn<OptionModel> area = Rxn<OptionModel>();
  final Rxn<OptionModel> pincode = Rxn<OptionModel>();
  final Rxn<Position> position = Rxn<Position>();
  final RxBool locating = false.obs;

  // Schedule
  final Rx<DateTime> date = _today().obs;
  final Rxn<TimeSlotModel> slot = Rxn<TimeSlotModel>();

  // What to test
  final RxList<PackageModel> packages = <PackageModel>[].obs;
  final RxList<LabTestModel> tests = <LabTestModel>[].obs;
  final RxList<File> prescriptions = <File>[].obs;

  // Lookups
  final RxList<OptionModel> areas = <OptionModel>[].obs;
  final RxList<OptionModel> pincodes = <OptionModel>[].obs;
  final RxList<TimeSlotModel> allSlots = <TimeSlotModel>[].obs;
  final RxList<PackageModel> allPackages = <PackageModel>[].obs;
  final RxList<LabTestModel> allTests = <LabTestModel>[].obs;
  final RxBool loading = true.obs;
  final RxnString loadError = RxnString();

  // Validation / submit state
  final RxMap<BookingField, String> errors = <BookingField, String>{}.obs;
  final RxBool submitted = false.obs;
  final RxInt attempts = 0.obs;
  final RxBool submitting = false.obs;

  /// Bumped on every keystroke so `Obx` sections re-read field validity.
  final RxInt edits = 0.obs;

  final Map<BookingField, GlobalKey> fieldKeys = {for (final f in BookingField.values) f: GlobalKey()};

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool get isCartMode => mode == BookingMode.cart;

  @override
  void onInit() {
    super.onInit();
    if (isCartMode) {
      packages.assignAll(_cart.packages);
      tests.assignAll(_cart.tests);
    }
    for (final c in [nameCtrl, mobileCtrl, emailCtrl, address1Ctrl]) {
      c.addListener(_onEdit);
    }
    loadLookups();
  }

  Future<void> loadLookups({bool refresh = false}) async {
    loading.value = true;
    loadError.value = null;
    try {
      final results = await Future.wait([
        _repo.areas(refresh: refresh),
        _repo.pincodes(refresh: refresh),
        _repo.timeSlots(refresh: refresh),
        _repo.packages(refresh: refresh),
        _repo.tests(refresh: refresh),
      ]);
      areas.assignAll(results[0] as List<OptionModel>);
      pincodes.assignAll(results[1] as List<OptionModel>);
      allSlots.assignAll(results[2] as List<TimeSlotModel>);
      allPackages.assignAll(results[3] as List<PackageModel>);
      allTests.assignAll(results[4] as List<LabTestModel>);
    } on ApiException catch (e) {
      loadError.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  void _onEdit() {
    edits.value++;
    if (submitted.value) _revalidate();
  }

  // ---------- derived ----------

  /// RN `getUpcomingTimeSlots`: for today, only slots that haven't started.
  /// (The RN parser read the minutes as NaN, so it compared hours only;
  /// this compares the actual start time.)
  List<TimeSlotModel> get availableSlots {
    final d = date.value;
    if (d != _today()) return allSlots;
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    return allSlots.where((s) => (s.startMinutes ?? 24 * 60) > nowMinutes).toList();
  }

  num get total => packages.fold<num>(0, (s, p) => s + p.price) + tests.fold<num>(0, (s, t) => s + t.rate);

  int get itemCount => packages.length + tests.length;

  // ---------- field actions ----------

  void setArea(OptionModel? v) {
    area.value = v;
    _onEdit();
  }

  void setPincode(OptionModel? v) {
    pincode.value = v;
    _onEdit();
  }

  Future<void> captureLocation() async {
    if (locating.value) return;
    locating.value = true;
    try {
      final p = await LocationService.currentPosition();
      if (p != null) {
        position.value = p;
        AppToast.success('Location added');
        _onEdit();
      }
    } finally {
      locating.value = false;
    }
  }

  /// Changing the date clears the slot (RN did the same on `date` change).
  void setDate(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    if (day == date.value) return;
    date.value = day;
    slot.value = null;
    _onEdit();
  }

  void setSlot(TimeSlotModel s) {
    slot.value = s;
    _onEdit();
  }

  void setPackages(List<PackageModel> v) {
    packages.assignAll(v);
    _syncCart();
    _onEdit();
  }

  void setTests(List<LabTestModel> v) {
    tests.assignAll(v);
    _syncCart();
    _onEdit();
  }

  void removePackage(PackageModel p) => setPackages(packages.where((x) => x.packageId != p.packageId).toList());
  void removeTest(LabTestModel t) => setTests(tests.where((x) => x.reportNo != t.reportNo).toList());

  /// Place-Inquiry mode keeps the cart in step with the form
  /// (`updateAssingPackage` / `updateAssingTest` → LOAD_CART).
  void _syncCart() {
    if (isCartMode) _cart.replaceAll(packages: packages, tests: tests);
  }

  Future<void> addPrescriptions() async {
    final files = await PhotoPickerService.pick(alreadyPicked: prescriptions.length);
    if (files.isEmpty) return;
    prescriptions.addAll(files);
    AppToast.success('${files.length} photo${files.length == 1 ? '' : 's'} added');
    _onEdit();
  }

  void removePrescription(int i) {
    prescriptions.removeAt(i);
    _onEdit();
  }

  // ---------- validation ----------

  /// RN `SubmitVisit` rules, in on-screen order, with plain-language
  /// messages that say what to fix.
  Map<BookingField, String> _validate() {
    final e = <BookingField, String>{};
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      e[BookingField.name] = 'Enter the patient’s full name';
    } else if (name.length < 3) {
      e[BookingField.name] = 'Name must be at least 3 letters';
    }
    final mobile = mobileCtrl.text.trim();
    if (mobile.isEmpty) {
      e[BookingField.mobile] = 'Enter your mobile number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      e[BookingField.mobile] = 'Enter a valid 10-digit mobile number';
    }
    final email = emailCtrl.text.trim();
    if (email.isNotEmpty && !RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$').hasMatch(email)) {
      e[BookingField.email] = 'Enter a valid email address';
    }
    if (address1Ctrl.text.trim().length < 5) {
      e[BookingField.address1] = address1Ctrl.text.trim().isEmpty
          ? 'Enter the address for sample collection'
          : 'Add house no., street and a landmark';
    }
    if (area.value == null) e[BookingField.area] = 'Choose your area';
    if (pincode.value == null) e[BookingField.pincode] = 'Choose your pincode';
    if (position.value == null) e[BookingField.location] = 'Share your location so our team can find you';
    if (slot.value == null) e[BookingField.slot] = 'Choose an appointment time';
    if (packages.isEmpty && tests.isEmpty && prescriptions.isEmpty) {
      e[BookingField.selection] = 'Add at least one test or package, or upload a prescription';
    }
    return e;
  }

  void _revalidate() => errors.assignAll(_validate());

  /// Whether a field should show its green "valid" state.
  bool isValid(BookingField f) {
    edits.value; // subscribe
    if (!submitted.value) {
      // Before the first submit, only mark text fields once they hold a
      // value that passes — no red until the patient tries to continue.
      final ok = !_validate().containsKey(f);
      return ok &&
          switch (f) {
            BookingField.name => nameCtrl.text.trim().isNotEmpty,
            BookingField.mobile => mobileCtrl.text.isNotEmpty,
            BookingField.email => emailCtrl.text.trim().isNotEmpty,
            BookingField.address1 => address1Ctrl.text.trim().isNotEmpty,
            _ => false,
          };
    }
    return !errors.containsKey(f) &&
        switch (f) {
          BookingField.email => emailCtrl.text.trim().isNotEmpty,
          _ => true,
        };
  }

  String? errorFor(BookingField f) => submitted.value ? errors[f] : null;

  // ---------- submit ----------

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    submitted.value = true;
    _revalidate();
    if (errors.isNotEmpty) {
      attempts.value++;
      _scrollToFirstError();
      return;
    }
    await _send();
  }

  void _scrollToFirstError() {
    final first = BookingField.values.firstWhere(errors.containsKey);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctx = fieldKeys[first]?.currentContext;
      if (ctx != null) {
        await Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic, alignment: 0.15);
      }
      switch (first) {
        case BookingField.name:
          nameFocus.requestFocus();
        case BookingField.mobile:
          mobileFocus.requestFocus();
        case BookingField.email:
          emailFocus.requestFocus();
        case BookingField.address1:
          address1Focus.requestFocus();
        default:
          break;
      }
    });
  }

  Future<void> _send() async {
    submitting.value = true;
    final request = BookingRequestModel(
      name: nameCtrl.text.trim(),
      mobileNo: mobileCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      address1: address1Ctrl.text.trim(),
      address2: address2Ctrl.text.trim(),
      area: area.value!.label,
      pincode: pincode.value!.label,
      latitude: position.value!.latitude,
      longitude: position.value!.longitude,
      date: date.value,
      timeSlot: slot.value!.label,
      packageNames: packages.map((p) => p.name).toList(),
      testNames: tests.map((t) => t.name).toList(),
      amount: total,
      prescriptions: prescriptions.toList(),
    );
    try {
      final id = await _repo.submitBooking(request);
      final args = BookingSuccessArgs(
        bookingId: id,
        name: request.name,
        mobile: request.mobileNo,
        date: request.date,
        slot: slot.value!,
        address: [request.address1, request.address2, request.area].where((s) => s.isNotEmpty).join(', '),
        pincode: request.pincode,
        packageNames: packages.map((p) => p.displayName).toList(),
        testNames: request.testNames,
        prescriptionCount: request.prescriptions.length,
        amount: request.amount,
      );
      // RN: on success → CLEAR_CART (Place Inquiry) and back to Home.
      if (isCartMode) _cart.clear();
      Get.offNamedUntil(AppRoutes.bookingSuccess, (r) => r.settings.name == AppRoutes.home, arguments: args);
    } on ApiException catch (e) {
      final retry = await AppDialog.confirm(
        type: AppDialogType.error,
        title: 'Booking didn’t go through',
        message: '${e.message}${isCartMode ? ' Your cart is saved.' : ''}',
        confirmText: 'Try again',
      );
      if (retry) await _send();
    } finally {
      submitting.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [nameCtrl, mobileCtrl, emailCtrl, address1Ctrl, address2Ctrl]) {
      c.dispose();
    }
    for (final f in [nameFocus, mobileFocus, emailFocus, address1Focus]) {
      f.dispose();
    }
    super.onClose();
  }
}
