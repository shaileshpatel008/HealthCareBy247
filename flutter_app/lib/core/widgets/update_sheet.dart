import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../services/launcher_service.dart';
import 'sheet_frame.dart';

/// "Update available" bottom sheet from the feedback board. Like the RN
/// `UpdateModal` it can't be dismissed — the only way forward is updating.
class UpdateSheet {
  UpdateSheet._();

  static Future<void> show({Future<void> Function()? onUpdate}) => Get.bottomSheet(
        PopScope(
          canPop: false,
          child: SheetFrame(
            title: 'Update available',
            subtitle: 'A newer version is on the store',
            trailing: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.system_update_rounded, color: AppColors.indigo),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Please update to continue using the app.', style: AppTextStyles.bodyMuted.copyWith(fontSize: 14)),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () async {
                    if (onUpdate != null) {
                      try {
                        await onUpdate();
                        return;
                      } catch (_) {
                        // Play's in-app flow unavailable — open the listing.
                      }
                    }
                    await LauncherService.openStore();
                  },
                  child: const Text('Update now'),
                ),
              ],
            ),
          ),
        ),
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        barrierColor: AppColors.ink.withValues(alpha: 0.55),
      );
}
