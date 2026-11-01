import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../services/connectivity_service.dart';

/// Port of `NoInternetScreen`: full screen while the phone is offline; goes
/// away by itself the moment connectivity returns, or on "Try again".
class OfflineView extends StatelessWidget {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<ConnectivityService>();
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(34)),
                  child: const Icon(Icons.wifi_off_rounded, size: 46, color: AppColors.ink2),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: -6, duration: 1400.ms, curve: Curves.easeInOut),
                const SizedBox(height: 20),
                Text('You’re offline', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(
                  'Check Wi-Fi or mobile data. We’ll reconnect automatically.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: FilledButton.icon(
                    onPressed: service.recheck,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.06, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}
