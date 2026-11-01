import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_constants.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_toast.dart';
import '../widgets/photo_source_sheet.dart';

/// Prescription photos — port of the RN `UploadPrescriptionScreen` sheet
/// ("Choose From Photo Gallery" / "Take Photo") plus `launchCamera` /
/// `launchImageLibrary` with the same quality and count limits.
class PhotoPickerService {
  PhotoPickerService._();

  static final ImagePicker _picker = ImagePicker();

  /// Asks camera-or-gallery, then returns the new photos (possibly empty).
  /// [alreadyPicked] keeps the total at or under the 5-photo limit.
  static Future<List<File>> pick({int alreadyPicked = 0}) async {
    final remaining = AppConstants.maxPrescriptionImages - alreadyPicked;
    if (remaining <= 0) {
      AppToast.warning('You can add up to ${AppConstants.maxPrescriptionImages} photos.');
      return const [];
    }

    final source = await PhotoSourceSheet.show();
    if (source == null) return const [];

    try {
      final List<XFile> picked;
      if (source == ImageSource.camera) {
        final shot = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: AppConstants.imageQuality,
          maxWidth: 2000,
        );
        picked = shot == null ? const [] : [shot];
      } else {
        picked = await _picker.pickMultiImage(
          imageQuality: AppConstants.imageQuality,
          maxWidth: 2000,
          limit: remaining > 1 ? remaining : null,
        );
      }

      final files = <File>[];
      for (final x in picked.take(remaining)) {
        final file = File(x.path);
        if (await file.length() > AppConstants.maxImageBytes) {
          AppToast.error('${x.name} is larger than 5 MB. Choose a smaller photo.');
          continue;
        }
        files.add(file);
      }
      if (picked.length > remaining) {
        AppToast.warning('Only the first $remaining photo${remaining == 1 ? '' : 's'} were added (max ${AppConstants.maxPrescriptionImages}).');
      }
      return files;
    } catch (e) {
      final denied = '$e'.toLowerCase().contains('denied') || '$e'.toLowerCase().contains('permission');
      if (denied) {
        final open = await AppDialog.confirm(
          type: AppDialogType.warning,
          icon: AppDialogIcon.camera,
          title: source == ImageSource.camera ? 'Camera permission needed' : 'Photos permission needed',
          message: 'Allow access in Settings so you can add your prescription.',
          confirmText: 'Open settings',
        );
        // geolocator's helper opens this app's system settings page — the
        // same screen the camera/photos permissions live on.
        if (open) await Geolocator.openAppSettings();
      } else {
        AppToast.error('We couldn’t open the ${source == ImageSource.camera ? 'camera' : 'gallery'}. Please try again.');
      }
      return const [];
    }
  }
}
