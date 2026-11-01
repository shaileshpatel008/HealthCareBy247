import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/services/photo_picker_service.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/repositories/lab_repository.dart';

enum PrescriptionField { photos, name, mobile }

/// Port of Home's "Upload Prescription" → `SubmitPrescriptions.js`: photos
/// + name + mobile to `onlyPrescription.php`, with the RN messages
/// ("Your prescription submitted successfully. We will get back to you
/// soon." / "Prescription submission failed").
class UploadPrescriptionController extends GetxController {
  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final RxList<File> photos = <File>[].obs;
  final RxMap<PrescriptionField, String> errors = <PrescriptionField, String>{}.obs;
  final RxBool submitted = false.obs;
  final RxInt attempts = 0.obs;
  final RxBool submitting = false.obs;
  final RxInt edits = 0.obs;

  @override
  void onInit() {
    super.onInit();
    for (final c in [nameCtrl, mobileCtrl]) {
      c.addListener(_onEdit);
    }
  }

  void _onEdit() {
    edits.value++;
    if (submitted.value) errors.assignAll(_validate());
  }

  Future<void> addPhotos() async {
    final files = await PhotoPickerService.pick(alreadyPicked: photos.length);
    if (files.isEmpty) return;
    photos.addAll(files);
    _onEdit();
  }

  void removePhoto(int i) {
    photos.removeAt(i);
    _onEdit();
  }

  /// RN `validateInputs`.
  Map<PrescriptionField, String> _validate() {
    final e = <PrescriptionField, String>{};
    if (photos.isEmpty) e[PrescriptionField.photos] = 'Add at least one photo of your prescription';
    if (nameCtrl.text.trim().isEmpty) e[PrescriptionField.name] = 'Enter your name';
    final m = mobileCtrl.text.trim();
    if (m.isEmpty) {
      e[PrescriptionField.mobile] = 'Enter your mobile number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(m)) {
      e[PrescriptionField.mobile] = 'Enter a valid 10-digit mobile number';
    }
    return e;
  }

  String? errorFor(PrescriptionField f) => submitted.value ? errors[f] : null;

  bool isValid(PrescriptionField f) {
    edits.value;
    final filled = switch (f) {
      PrescriptionField.name => nameCtrl.text.trim().isNotEmpty,
      PrescriptionField.mobile => mobileCtrl.text.isNotEmpty,
      PrescriptionField.photos => photos.isNotEmpty,
    };
    return filled && !_validate().containsKey(f);
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    submitted.value = true;
    errors.assignAll(_validate());
    if (errors.isNotEmpty) {
      attempts.value++;
      return;
    }
    submitting.value = true;
    try {
      await LabRepository.instance.submitPrescription(
        name: nameCtrl.text.trim(),
        mobileNo: mobileCtrl.text.trim(),
        images: photos.toList(),
      );
      submitting.value = false;
      await AppDialog.show(
        type: AppDialogType.success,
        title: 'Prescription sent',
        message: 'Your prescription was submitted successfully. We will get back to you soon on +91 ${mobileCtrl.text.trim()}.',
        buttonText: 'Done',
        barrierDismissible: false,
      );
      Get.back();
    } on ApiException catch (e) {
      submitting.value = false;
      final retry = await AppDialog.confirm(
        type: AppDialogType.error,
        title: 'Prescription submission failed',
        message: e.message,
        confirmText: 'Try again',
      );
      if (retry) await submit();
    } catch (_) {
      submitting.value = false;
      AppToast.error('Prescription submission failed. Please try again.');
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    mobileCtrl.dispose();
    super.onClose();
  }
}
