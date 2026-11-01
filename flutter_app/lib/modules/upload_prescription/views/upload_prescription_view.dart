import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_message.dart';
import '../../../core/widgets/prescription_strip.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/shake.dart';
import '../../../core/widgets/stagger.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/upload_prescription_controller.dart';

/// Board 08 "Upload prescription".
class UploadPrescriptionView extends GetView<UploadPrescriptionController> {
  const UploadPrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ScreenHeader(title: 'Upload prescription', subtitle: 'We’ll read it and call you back'),
            Expanded(
              child: Obx(() {
                c.edits.value;
                final photoError = c.errorFor(PrescriptionField.photos);
                return ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  children: [
                    Shake(
                      trigger: c.attempts.value,
                      enabled: photoError != null,
                      child: c.photos.isEmpty
                          ? _DropZone(onTap: c.addPhotos, error: photoError != null)
                          : Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                    const SizedBox(width: 8),
                                    Text('${c.photos.length} photo${c.photos.length == 1 ? '' : 's'} ready', style: AppTextStyles.title),
                                  ]),
                                  const SizedBox(height: 12),
                                  PrescriptionStrip(files: c.photos, onAdd: c.addPhotos, onRemove: c.removePhoto),
                                  const SizedBox(height: 8),
                                  Text('Tap a photo to view it full screen.', style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                    ).staggerIn(0),
                    FieldMessage(error: photoError),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Your name',
                            required: true,
                            controller: c.nameCtrl,
                            hint: 'Full name',
                            prefixIcon: Icons.person_outline_rounded,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                            error: c.errorFor(PrescriptionField.name),
                            isValid: c.isValid(PrescriptionField.name),
                            shakeTrigger: c.attempts.value,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Mobile number',
                            required: true,
                            controller: c.mobileCtrl,
                            hint: '10-digit number',
                            prefixText: '+91',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 10,
                            showCounter: true,
                            error: c.errorFor(PrescriptionField.mobile),
                            isValid: c.isValid(PrescriptionField.mobile),
                            shakeTrigger: c.attempts.value,
                          ),
                        ],
                      ),
                    ).staggerIn(1),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.infoSoft, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: AppColors.info),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('For a quick call-back', style: AppTextStyles.label.copyWith(color: AppColors.infoInk)),
                              const SizedBox(height: 4),
                              Text(
                                'Make sure the doctor’s name, date and test names are readable and the whole page is in the photo.',
                                style: AppTextStyles.caption.copyWith(color: AppColors.infoInk, fontSize: 13),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ).staggerIn(2),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Obx(() => Pressable(
              onTap: c.submitting.value ? null : c.submit,
              child: Container(
                height: 58,
                decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: c.submitting.value
                      ? const [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('Uploading…', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                        ]
                      : const [
                          Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Submit prescription', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                ),
              ),
            )),
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  const _DropZone({required this.onTap, required this.error});
  final VoidCallback onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: 0.98,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: error ? AppColors.errorField : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: error ? AppColors.error : const Color(0xFFB9BCE8), width: 2),
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(22)),
              child: const Icon(Icons.upload_file_rounded, color: AppColors.indigo, size: 32),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -6, duration: 1200.ms, curve: Curves.easeInOut),
            const SizedBox(height: 14),
            Text('Add a clear photo', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('Camera or gallery · up to 5 photos, 5 MB each', style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(16)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Add photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
