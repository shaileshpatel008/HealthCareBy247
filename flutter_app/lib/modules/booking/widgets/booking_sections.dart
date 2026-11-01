import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_message.dart';
import '../../../core/widgets/picker_sheet.dart';
import '../../../core/widgets/prescription_strip.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/shake.dart';
import '../../../data/models/lab_test_model.dart';
import '../../../data/models/lookup_models.dart';
import '../../../data/models/package_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/booking_controller.dart';

/// White rounded section card with an icon + title row.
class FormCard extends StatelessWidget {
  const FormCard({super.key, required this.title, required this.icon, required this.child, this.trailing});
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(icon, size: 20, color: AppColors.indigo),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w800))),
            ?trailing,
          ]),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// "N fields need your attention" — appears after a failed submit and
/// counts down as fields are fixed.
class ErrorBanner extends GetView<BookingController> {
  const ErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final n = controller.submitted.value ? controller.errors.length : 0;
      return AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: n == 0
            ? const SizedBox(width: double.infinity)
            : Container(
                key: ValueKey(controller.attempts.value),
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.errorSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3C6C6)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      n == 1 ? '1 field needs your attention' : '$n fields need your attention',
                      style: AppTextStyles.label.copyWith(color: AppColors.errorInk),
                    ),
                  ),
                ]),
              ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.3, curve: Curves.easeOut),
      );
    });
  }
}

/// A tappable "field" that opens a picker (area, pincode) — same look and
/// error/valid states as [AppTextField].
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
    this.error,
    this.shakeTrigger = 0,
    this.required = true,
    this.busy = false,
  });

  final String label;
  final String? value;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final String? error;
  final int shakeTrigger;
  final bool required;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final ok = value != null && !hasError;
    return Shake(
      trigger: shakeTrigger,
      enabled: hasError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(text: label, style: AppTextStyles.label, children: [
            if (required) const TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
          ])),
          const SizedBox(height: 6),
          Pressable(
            scale: 0.98,
            onTap: busy ? null : onTap,
            semanticLabel: '$label: ${value ?? placeholder}',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: hasError ? AppColors.errorField : AppColors.field,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasError ? AppColors.error : (ok ? AppColors.success : AppColors.line),
                  width: hasError || ok ? 2 : 1.5,
                ),
              ),
              child: Row(children: [
                Icon(icon, size: 20, color: AppColors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value == null ? AppColors.muted : AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (busy)
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Icon(ok ? Icons.check_rounded : Icons.expand_more_rounded, color: ok ? AppColors.success : AppColors.ink2),
              ]),
            ),
          ),
          FieldMessage(error: error),
        ],
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({super.key, required this.c});
  final BookingController c;

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: 'Where should we come?',
      icon: Icons.location_on_outlined,
      child: Obx(() {
        c.edits.value;
        final pos = c.position.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KeyedSubtree(
              key: c.fieldKeys[BookingField.address1],
              child: AppTextField(
                label: 'Address',
                required: true,
                controller: c.address1Ctrl,
                focusNode: c.address1Focus,
                hint: 'House no., building, street',
                prefixIcon: Icons.home_outlined,
                textCapitalization: TextCapitalization.sentences,
                autofillHints: const [AutofillHints.streetAddressLine1],
                error: c.errorFor(BookingField.address1),
                isValid: c.isValid(BookingField.address1),
                shakeTrigger: c.attempts.value,
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Address line 2',
              optionalNote: '(landmark)',
              controller: c.address2Ctrl,
              hint: 'Near…',
              prefixIcon: Icons.signpost_outlined,
              textCapitalization: TextCapitalization.sentences,
              autofillHints: const [AutofillHints.streetAddressLine2],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeyedSubtree(
                    key: c.fieldKeys[BookingField.area],
                    child: PickerField(
                      label: 'Area',
                      value: c.area.value?.label,
                      placeholder: 'Select area',
                      icon: Icons.map_outlined,
                      error: c.errorFor(BookingField.area),
                      shakeTrigger: c.attempts.value,
                      onTap: () async {
                        final v = await PickerSheet.single<OptionModel>(
                          title: 'Select area',
                          searchHint: 'Search area',
                          selected: c.area.value,
                          options: [for (final a in c.areas) PickerOption(value: a, label: a.label)],
                        );
                        if (v != null) c.setArea(v);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KeyedSubtree(
                    key: c.fieldKeys[BookingField.pincode],
                    child: PickerField(
                      label: 'Pincode',
                      value: c.pincode.value?.label,
                      placeholder: 'Select',
                      icon: Icons.pin_drop_outlined,
                      error: c.errorFor(BookingField.pincode),
                      shakeTrigger: c.attempts.value,
                      onTap: () async {
                        final v = await PickerSheet.single<OptionModel>(
                          title: 'Select pincode',
                          searchHint: 'Search pincode',
                          selected: c.pincode.value,
                          options: [for (final p in c.pincodes) PickerOption(value: p, label: p.label)],
                        );
                        if (v != null) c.setPincode(v);
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (c.pincode.value != null) const FieldMessage(success: 'Home collection available here'),
            const SizedBox(height: 14),
            KeyedSubtree(
              key: c.fieldKeys[BookingField.location],
              child: Shake(
                trigger: c.attempts.value,
                enabled: c.errorFor(BookingField.location) != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(TextSpan(text: 'Visit location', style: AppTextStyles.label, children: const [
                      TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
                    ])),
                    const SizedBox(height: 6),
                    Pressable(
                      scale: 0.98,
                      onTap: c.captureLocation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 52,
                        decoration: BoxDecoration(
                          color: pos != null ? AppColors.successSoft : AppColors.indigoSoft,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: c.errorFor(BookingField.location) != null ? AppColors.error : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (c.locating.value)
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
                            else
                              Icon(pos != null ? Icons.check_circle_rounded : Icons.my_location_rounded,
                                  size: 19, color: pos != null ? AppColors.success : AppColors.indigo),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                c.locating.value
                                    ? 'Finding your location…'
                                    : pos != null
                                        ? 'Location added · ${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}'
                                        : 'Use my current location',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.label.copyWith(fontSize: 14, color: pos != null ? AppColors.successInk : AppColors.indigo),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FieldMessage(error: c.errorFor(BookingField.location)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Date strip (next 14 days + a calendar for later dates) and the
/// `timeSlot.php` slots for that date, past slots hidden for today.
class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, required this.c});
  final BookingController c;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(14, (i) => DateTime(today.year, today.month, today.day + i));
    return KeyedSubtree(
      key: c.fieldKeys[BookingField.slot],
      child: FormCard(
        title: 'When?',
        icon: Icons.calendar_month_outlined,
        trailing: Obx(() => Text(DateFormat('MMMM yyyy').format(c.date.value), style: AppTextStyles.label.copyWith(color: AppColors.indigo))),
        child: Obx(() {
          c.edits.value;
          final slots = c.availableSlots;
          final selectedDay = c.date.value;
          final slotError = c.errorFor(BookingField.slot);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 78,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    if (i == days.length) {
                      return Pressable(
                        semanticLabel: 'Pick another date',
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDay,
                            firstDate: days.first,
                            lastDate: days.first.add(const Duration(days: 90)),
                          );
                          if (picked != null) c.setDate(picked);
                        },
                        child: Container(
                          width: 62,
                          decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.edit_calendar_outlined, color: AppColors.indigo),
                        ),
                      );
                    }
                    final d = days[i];
                    final on = d == selectedDay;
                    return Pressable(
                      onTap: () => c.setDate(d),
                      semanticLabel: DateFormat('EEEE d MMMM').format(d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 62,
                        decoration: BoxDecoration(
                          color: on ? AppColors.indigo : AppColors.field,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: on ? AppColors.indigo : AppColors.line),
                          boxShadow: on ? [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6))] : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(i == 0 ? 'Today' : DateFormat('EEE').format(d),
                                style: TextStyle(fontSize: 12, color: on ? Colors.white70 : AppColors.ink2, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('${d.day}', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: on ? Colors.white : AppColors.ink)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (!days.contains(selectedDay)) ...[
                const SizedBox(height: 8),
                Text('Selected: ${DateFormat('EEE, d MMM yyyy').format(selectedDay)}', style: AppTextStyles.label.copyWith(color: AppColors.indigo)),
              ],
              const SizedBox(height: 16),
              Text.rich(TextSpan(text: 'Appointment time', style: AppTextStyles.label, children: const [
                TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
              ])),
              const SizedBox(height: 8),
              Shake(
                trigger: c.attempts.value,
                enabled: slotError != null,
                child: slots.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.warningSoft, borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          const Icon(Icons.schedule_rounded, color: AppColors.warning, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('No slots left today. Please pick another date.', style: AppTextStyles.label.copyWith(color: AppColors.warningInk)),
                          ),
                        ]),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final s in slots)
                            _SlotChip(
                              label: s.displayLabel,
                              selected: c.slot.value?.id == s.id,
                              error: slotError != null,
                              onTap: () => c.setSlot(s),
                            ),
                        ],
                      ),
              ),
              FieldMessage(error: slotError),
            ],
          );
        }),
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.label, required this.selected, required this.error, required this.onTap});
  final String label;
  final bool selected;
  final bool error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.indigo : AppColors.field,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.indigo : (error ? const Color(0xFFF3C6C6) : AppColors.line), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? Colors.white : AppColors.ink),
        ),
      ),
    );
  }
}

/// Packages, tests and prescription photos — at least one of the three
/// is required (RN "Please select at least a package, test, or upload your
/// prescription!").
class SelectionSection extends StatelessWidget {
  const SelectionSection({super.key, required this.c});
  final BookingController c;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: c.fieldKeys[BookingField.selection],
      child: Obx(() {
        c.edits.value;
        final err = c.errorFor(BookingField.selection);
        return Shake(
          trigger: c.attempts.value,
          enabled: err != null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: err != null ? AppColors.error : Colors.transparent, width: 2),
            ),
            child: FormCard(
              title: 'Tests & packages',
              icon: Icons.science_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SelectRow(
                    label: c.packages.isEmpty ? 'Select packages' : 'Packages (${c.packages.length})',
                    icon: Icons.inventory_2_outlined,
                    onTap: () async {
                      final v = await PickerSheet.multi<PackageModel>(
                        title: 'Select packages',
                        searchHint: 'Search packages',
                        selected: c.allPackages.where((p) => c.packages.any((x) => x.packageId == p.packageId)).toList(),
                        options: [
                          for (final p in c.allPackages)
                            PickerOption(value: p, label: Formatters.titleCase(p.displayName), trailing: Formatters.rupees(p.price)),
                        ],
                      );
                      if (v != null) c.setPackages(v);
                    },
                  ),
                  for (final p in c.packages)
                    _SelectedItem(title: Formatters.titleCase(p.displayName), price: p.price, onRemove: () => c.removePackage(p)),
                  const SizedBox(height: 10),
                  _SelectRow(
                    label: c.tests.isEmpty ? 'Select tests' : 'Tests (${c.tests.length})',
                    icon: Icons.water_drop_outlined,
                    onTap: () async {
                      final v = await PickerSheet.multi<LabTestModel>(
                        title: 'Select tests',
                        searchHint: 'Search tests',
                        selected: c.allTests.where((t) => c.tests.any((x) => x.reportNo == t.reportNo)).toList(),
                        options: [for (final t in c.allTests) PickerOption(value: t, label: t.name, trailing: Formatters.rupees(t.rate))],
                      );
                      if (v != null) c.setTests(v);
                    },
                  ),
                  for (final t in c.tests) _SelectedItem(title: t.name, price: t.rate, onRemove: () => c.removeTest(t)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: AppColors.line)),
                  Row(children: [
                    const Icon(Icons.description_outlined, size: 20, color: AppColors.indigo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c.prescriptions.isEmpty ? 'Prescription (optional)' : 'Prescription (${c.prescriptions.length})',
                        style: AppTextStyles.label,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  if (c.prescriptions.isEmpty)
                    Pressable(
                      scale: 0.98,
                      onTap: c.addPrescriptions,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.field,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFB9BCE8), width: 1.5),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.upload_file_rounded, color: AppColors.indigo),
                          const SizedBox(width: 8),
                          Text('Upload prescription', style: AppTextStyles.label.copyWith(color: AppColors.indigo, fontSize: 14)),
                        ]),
                      ),
                    )
                  else
                    PrescriptionStrip(files: c.prescriptions, onAdd: c.addPrescriptions, onRemove: c.removePrescription),
                  FieldMessage(error: err),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        scale: 0.98,
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Icon(icon, size: 20, color: AppColors.indigo),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: AppTextStyles.label.copyWith(color: AppColors.indigo, fontSize: 14))),
            const Icon(Icons.add_rounded, color: AppColors.indigo),
          ]),
        ),
      );
}

class _SelectedItem extends StatelessWidget {
  const _SelectedItem({required this.title, required this.price, required this.onRemove});
  final String title;
  final num price;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(children: [
          const Icon(Icons.check_rounded, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
          Text(Formatters.rupees(price), style: AppTextStyles.label),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Remove $title',
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.ink2),
          ),
        ]),
      ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.05);
}
