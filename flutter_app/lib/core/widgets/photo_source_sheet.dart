import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'pressable.dart';
import 'sheet_frame.dart';

/// Port of the RN `UploadPrescriptionScreen` sheet — "Select Photo Option":
/// Take Photo / Choose From Photo Gallery / Cancel — restyled as a
/// bottom sheet that rises over a dimmed screen.
class PhotoSourceSheet {
  PhotoSourceSheet._();

  static Future<ImageSource?> show() => Get.bottomSheet<ImageSource>(
        SheetFrame(
          title: 'Add prescription photo',
          subtitle: 'JPG or PNG, up to 5 MB each',
          child: Row(
            children: [
              Expanded(child: _Option(icon: Icons.photo_camera_outlined, label: 'Take photo', primary: true, source: ImageSource.camera)),
              const SizedBox(width: 12),
              Expanded(child: _Option(icon: Icons.photo_library_outlined, label: 'Gallery', primary: false, source: ImageSource.gallery)),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        barrierColor: AppColors.ink.withValues(alpha: 0.45),
        enterBottomSheetDuration: const Duration(milliseconds: 280),
        exitBottomSheetDuration: const Duration(milliseconds: 220),
      );
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.label, required this.primary, required this.source});

  final IconData icon;
  final String label;
  final bool primary;
  final ImageSource source;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => Get.back(result: source),
      child: Container(
        height: 96,
        decoration: BoxDecoration(color: primary ? AppColors.indigo : AppColors.indigoSoft, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? Colors.white : AppColors.indigo, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.titleSmall.copyWith(color: primary ? Colors.white : AppColors.indigo)),
          ],
        ),
      ),
    );
  }
}
