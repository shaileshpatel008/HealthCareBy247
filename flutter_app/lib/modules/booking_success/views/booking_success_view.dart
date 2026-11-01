import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/launcher_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/animated_check.dart';
import '../../../core/widgets/pressable.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../booking_success_args.dart';

/// Board 09 "Booking confirmed". Replaces the RN success alert ("Your
/// inquiry (ID: …) has been submitted successfully, our representative
/// will call you shortly.") with the same facts on a full screen.
class BookingSuccessView extends StatelessWidget {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.arguments as BookingSuccessArgs;
    final items = [...a.packageNames.map(Formatters.titleCase), ...a.testNames];
    final itemsText = items.isEmpty
        ? 'Prescription only (${a.prescriptionCount} photo${a.prescriptionCount == 1 ? '' : 's'})'
        : items.length == 1
            ? items.first
            : '${items.first} + ${items.length - 1} more';

    void home() => Get.offAllNamed(AppRoutes.home);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) home();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
            children: [
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: 112, height: 112, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle))
                          .animate(onPlay: (c) => c.repeat())
                          .scale(begin: const Offset(1, 1), end: const Offset(1.35, 1.35), duration: 2000.ms, curve: Curves.easeOut)
                          .fadeOut(begin: 0.5, duration: 2000.ms),
                      Container(
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        child: const Center(child: AnimatedCheck(size: 56, strokeWidth: 4.5, delay: Duration(milliseconds: 250))),
                      ).animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.easeOutBack).fadeIn(duration: 250.ms),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Text('Booking confirmed', textAlign: TextAlign.center, style: AppTextStyles.h1),
                  const SizedBox(height: 6),
                  if (a.bookingId.isNotEmpty)
                    Text.rich(
                      TextSpan(text: 'Booking ID ', style: AppTextStyles.bodyMuted.copyWith(fontSize: 14), children: [
                        TextSpan(text: '#${a.bookingId}', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 6),
                  Text(
                    'Thanks, ${a.name.split(' ').first}. Our representative will call +91 ${a.mobile} shortly to confirm.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    _Info(
                      icon: Icons.calendar_month_outlined,
                      label: 'Collection',
                      value: '${DateFormat('EEE, d MMM').format(a.date)} · ${a.slot.displayLabel}',
                    ),
                    const SizedBox(height: 14),
                    _Info(icon: Icons.location_on_outlined, label: 'Address', value: '${a.address}, ${a.pincode}'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: AppColors.line)),
                    Row(children: [
                      Expanded(child: Text(itemsText, style: AppTextStyles.body.copyWith(color: AppColors.ink2))),
                      if (a.amount > 0) Text(Formatters.rupees(a.amount), style: AppTextStyles.h3),
                    ]),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideY(begin: 0.15, curve: Curves.easeOutCubic),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What happens next', style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    const _Step(text: 'Booking received', state: _StepState.done, last: false),
                    const _Step(text: 'We call you to confirm the time', state: _StepState.current, last: false),
                    const _Step(text: 'Sample collected at your home', state: _StepState.todo, last: false),
                    _Step(text: a.prescriptionCount > 0 && items.isEmpty ? 'We book tests from your prescription' : 'Report sent to you', state: _StepState.todo, last: true),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms).slideY(begin: 0.15, curve: Curves.easeOutCubic),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Pressable(
                      onTap: LauncherService.confirmAndWhatsApp,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(18)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.indigo, size: 20),
                          const SizedBox(width: 8),
                          Text('Need help?', style: AppTextStyles.button.copyWith(color: AppColors.indigo, fontSize: 15)),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Pressable(
                      onTap: home,
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(18)),
                        child: Text('Back to home', style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 600.ms).fadeIn(duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.indigo, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.titleSmall),
            ]),
          ),
        ],
      );
}

enum _StepState { done, current, todo }

class _Step extends StatelessWidget {
  const _Step({required this.text, required this.state, required this.last});
  final String text;
  final _StepState state;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state == _StepState.done ? AppColors.success : Colors.white,
                border: Border.all(
                  color: switch (state) {
                    _StepState.done => AppColors.success,
                    _StepState.current => AppColors.indigo,
                    _StepState.todo => AppColors.scrim,
                  },
                  width: 2,
                ),
              ),
              child: switch (state) {
                _StepState.done => const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                _StepState.current => Center(
                    child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.indigo, shape: BoxShape.circle))
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.1, 1.1), duration: 800.ms),
                  ),
                _StepState.todo => null,
              },
            ),
            if (!last)
              Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 2), color: state == _StepState.done ? AppColors.success : AppColors.line)),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2, bottom: last ? 0 : 18),
              child: Text(
                text,
                style: AppTextStyles.body.copyWith(
                  fontWeight: state == _StepState.todo ? FontWeight.w500 : FontWeight.w700,
                  color: switch (state) {
                    _StepState.done => AppColors.ink,
                    _StepState.current => AppColors.indigo,
                    _StepState.todo => AppColors.ink2,
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
