import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/facilities_controller.dart';

/// Board 12 "Facilities & instruments": a 24×7 banner, then a segmented
/// control switching between the lab's Facilities and Instruments pages.
class FacilitiesView extends GetView<FacilitiesController> {
  const FacilitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Our facilities'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(22)),
                child: Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.schedule_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Always available 24×7', style: AppTextStyles.title.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      Text('Fully automated, computerised lab', style: AppTextStyles.caption.copyWith(color: const Color(0xFFC9CBE0))),
                    ]),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(18)),
                child: TabBar(
                  controller: controller.tabs,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  labelColor: AppColors.ink,
                  unselectedLabelColor: AppColors.ink2,
                  labelStyle: AppTextStyles.label.copyWith(fontSize: 14),
                  splashBorderRadius: BorderRadius.circular(14),
                  tabs: const [Tab(height: 42, text: 'Facilities'), Tab(height: 42, text: 'Instruments')],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: controller.tabs,
                physics: const NeverScrollableScrollPhysics(),
                children: [_Page(index: 0), _Page(index: 1)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends GetView<FacilitiesController> {
  const _Page({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Obx(() {
          if (controller.failed[index]) {
            return ColoredBox(
              color: Colors.white,
              child: ErrorState(
                message: 'This page couldn’t load. Check your connection and try again.',
                onRetry: () => controller.reload(index),
              ),
            );
          }
          final p = controller.progress[index];
          return Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: Colors.white, child: WebViewWidget(controller: controller.pages[index]))),
              if (p < 100)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(value: p == 0 ? null : p / 100, minHeight: 3, backgroundColor: AppColors.indigoSoft),
                ),
              if (p < 30) const Positioned.fill(child: ColoredBox(color: Colors.white, child: SkeletonList(count: 5, padding: EdgeInsets.all(14)))),
            ],
          );
        }),
      ),
    );
  }
}
