import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import 'pressable.dart';

/// Picked prescription photos — port of the RN horizontal preview strip:
/// tap a photo to see it full screen, ✕ to remove it, "+" to add more
/// (until the 5-photo limit).
class PrescriptionStrip extends StatelessWidget {
  const PrescriptionStrip({super.key, required this.files, required this.onAdd, required this.onRemove});

  final List<File> files;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: files.length + (files.length < AppConstants.maxPrescriptionImages ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          if (i == files.length) {
            return Pressable(
              onTap: onAdd,
              semanticLabel: 'Add another photo',
              child: Container(
                width: 88,
                decoration: BoxDecoration(
                  color: AppColors.indigoSoft,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFB9BCE8), width: 1.5),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.indigo, size: 30),
              ),
            );
          }
          return SizedBox(
            width: 88,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Pressable(
                    onTap: () => FullImageViewer.open(files, i),
                    semanticLabel: 'View photo ${i + 1}',
                    child: Hero(
                      tag: files[i].path,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(files[i], fit: BoxFit.cover, cacheWidth: 300),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Pressable(
                    onTap: () => onRemove(i),
                    semanticLabel: 'Remove photo ${i + 1}',
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: AppColors.ink.withValues(alpha: 0.75), shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
        },
      ),
    );
  }
}

/// Port of the RN "Full Image Modal": swipe between photos, pinch to zoom.
class FullImageViewer extends StatelessWidget {
  const FullImageViewer({super.key, required this.files, required this.initialIndex});

  final List<File> files;
  final int initialIndex;

  static void open(List<File> files, int index) => Get.to(
        () => FullImageViewer(files: files, initialIndex: index),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 220),
        fullscreenDialog: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: files.length,
            itemBuilder: (_, i) => InteractiveViewer(
              maxScale: 4,
              child: Center(child: Hero(tag: files[i].path, child: Image.file(files[i]))),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: Get.back,
                    tooltip: 'Close',
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  if (files.length > 1)
                    Text('${files.length} photos', style: AppTextStyles.label.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
