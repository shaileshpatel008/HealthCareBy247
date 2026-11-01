import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'pressable.dart';

/// Skeleton loading cards (feedback board) — replaces the RN full-screen
/// `LoaderScreen` spinner while lists load.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6, this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 120)});

  final int count;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6E8F1),
      highlightColor: const Color(0xFFF7F8FC),
      period: const Duration(milliseconds: 1400),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, _) => Container(
          height: 76,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
          child: Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: 180, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 100, color: Colors.white),
                  ],
                ),
              ),
              Container(width: 64, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state: soft icon tile, title, one line, optional actions.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.actions = const []});

  final IconData icon;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(30)),
              child: Icon(icon, size: 42, color: AppColors.indigo),
            ),
            const SizedBox(height: 18),
            Text(title, textAlign: TextAlign.center, style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(fontSize: 14)),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: actions),
            ],
          ],
        ).animate().fadeIn(duration: 260.ms).scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOut),
      ),
    );
  }
}

/// Load failure with a retry — the RN screens showed a bare "Error: …".
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.errorSoft, shape: BoxShape.circle),
              child: const Icon(Icons.cloud_off_rounded, size: 38, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text('Couldn’t load this', style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(fontSize: 14)),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Try again')),
            ),
          ],
        ).animate().fadeIn(duration: 250.ms),
      ),
    );
  }
}

/// Small pill button used for empty-state and inline actions.
class SoftButton extends StatelessWidget {
  const SoftButton({super.key, required this.label, required this.onTap, this.icon, this.filled = false});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : AppColors.indigo;
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(color: filled ? AppColors.indigo : AppColors.indigoSoft, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 6)],
            Text(label, style: AppTextStyles.label.copyWith(color: fg, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
