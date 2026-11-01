import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../core/widgets/state_views.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_sections.dart';

/// Boards 06 "Patient details" and 07 "Book a home visit" — one form.
class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: c.isCartMode ? 'Patient details' : 'Book a home visit',
              subtitle: c.isCartMode ? 'Step 2 of 2 · Home collection' : 'We come to you for sample collection',
            ),
            if (c.isCartMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Row(children: [
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(3)))),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(height: 6, decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(3)))
                        .animate()
                        .scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 500.ms, curve: Curves.easeOutCubic),
                  ),
                ]),
              ),
            Expanded(
              child: Obx(() {
                if (c.loading.value) return const SkeletonList(count: 5);
                if (c.loadError.value != null) {
                  return ErrorState(message: c.loadError.value!, onRetry: () => c.loadLookups(refresh: true));
                }
                return ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                  children: [
                    const ErrorBanner().staggerIn(0),
                    _PatientSection(c: c).staggerIn(1),
                    const SizedBox(height: 14),
                    AddressSection(c: c).staggerIn(2),
                    const SizedBox(height: 14),
                    ScheduleSection(c: c).staggerIn(3),
                    const SizedBox(height: 14),
                    SelectionSection(c: c).staggerIn(4),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SubmitBar(c: c),
    );
  }
}

class _PatientSection extends StatelessWidget {
  const _PatientSection({required this.c});
  final BookingController c;

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: 'Patient',
      icon: Icons.person_outline_rounded,
      child: Obx(() {
        c.edits.value;
        return Column(
          children: [
            KeyedSubtree(
              key: c.fieldKeys[BookingField.name],
              child: AppTextField(
                label: 'Full name',
                required: true,
                controller: c.nameCtrl,
                focusNode: c.nameFocus,
                hint: 'As on ID proof',
                prefixIcon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                // RN filtered the name to letters and spaces as you typed.
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                error: c.errorFor(BookingField.name),
                isValid: c.isValid(BookingField.name),
                shakeTrigger: c.attempts.value,
              ),
            ),
            const SizedBox(height: 14),
            KeyedSubtree(
              key: c.fieldKeys[BookingField.mobile],
              child: AppTextField(
                label: 'Mobile number',
                required: true,
                controller: c.mobileCtrl,
                focusNode: c.mobileFocus,
                hint: '10-digit number',
                prefixText: '+91',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                showCounter: true,
                error: c.errorFor(BookingField.mobile),
                isValid: c.isValid(BookingField.mobile),
                shakeTrigger: c.attempts.value,
              ),
            ),
            const SizedBox(height: 14),
            KeyedSubtree(
              key: c.fieldKeys[BookingField.email],
              child: AppTextField(
                label: 'Email',
                optionalNote: '(for your report)',
                controller: c.emailCtrl,
                focusNode: c.emailFocus,
                hint: 'name@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                error: c.errorFor(BookingField.email),
                isValid: c.isValid(BookingField.email),
                shakeTrigger: c.attempts.value,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.c});
  final BookingController c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.08), blurRadius: 30, offset: const Offset(0, -10))],
      ),
      child: Obx(() {
        final busy = c.submitting.value;
        final n = c.itemCount;
        return Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n == 0
                      ? (c.prescriptions.isEmpty ? 'No tests yet' : 'Prescription only')
                      : '$n item${n == 1 ? '' : 's'}',
                  style: AppTextStyles.caption,
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(end: c.total.toDouble()),
                  duration: const Duration(milliseconds: 400),
                  builder: (_, v, _) => Text(Formatters.rupees(v.round()), style: AppTextStyles.h2),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Pressable(
                onTap: busy ? null : c.submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 56,
                  decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(18)),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: busy
                        ? const Row(
                            key: ValueKey('busy'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)),
                              SizedBox(width: 10),
                              Text('Booking…', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                            ],
                          )
                        : const Row(
                            key: ValueKey('idle'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Confirm booking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
