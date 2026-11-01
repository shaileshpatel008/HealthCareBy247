import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'pressable.dart';
import 'sheet_frame.dart';

class PickerOption<T> {
  const PickerOption({required this.value, required this.label, this.trailing});
  final T value;
  final String label;

  /// e.g. a price, shown on the right.
  final String? trailing;
}

/// Port of the RN `DropdownComponent` (searchable, single or multi select,
/// clearable) as a bottom sheet with a search field — used for area,
/// pincode, packages and tests on the booking form.
class PickerSheet {
  PickerSheet._();

  static Future<T?> single<T>({
    required String title,
    required List<PickerOption<T>> options,
    T? selected,
    String searchHint = 'Search',
  }) async {
    final result = await _open<T>(title: title, options: options, initial: {?selected}, multi: false, searchHint: searchHint);
    return result?.isEmpty ?? true ? null : result!.first;
  }

  /// Returns null when dismissed without "Done" (selection unchanged).
  static Future<List<T>?> multi<T>({
    required String title,
    required List<PickerOption<T>> options,
    required List<T> selected,
    String searchHint = 'Search',
  }) =>
      _open<T>(title: title, options: options, initial: selected.toSet(), multi: true, searchHint: searchHint);

  static Future<List<T>?> _open<T>({
    required String title,
    required List<PickerOption<T>> options,
    required Set<T> initial,
    required bool multi,
    required String searchHint,
  }) =>
      Get.bottomSheet<List<T>>(
        _PickerBody<T>(title: title, options: options, initial: initial, multi: multi, searchHint: searchHint),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        barrierColor: AppColors.ink.withValues(alpha: 0.45),
        enterBottomSheetDuration: const Duration(milliseconds: 280),
        exitBottomSheetDuration: const Duration(milliseconds: 220),
      );
}

class _PickerBody<T> extends StatefulWidget {
  const _PickerBody({required this.title, required this.options, required this.initial, required this.multi, required this.searchHint});

  final String title;
  final List<PickerOption<T>> options;
  final Set<T> initial;
  final bool multi;
  final String searchHint;

  @override
  State<_PickerBody<T>> createState() => _PickerBodyState<T>();
}

class _PickerBodyState<T> extends State<_PickerBody<T>> {
  late final Set<T> _selected = {...widget.initial};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final visible = q.isEmpty ? widget.options : widget.options.where((o) => o.label.toLowerCase().contains(q)).toList();
    final height = MediaQuery.of(context).size.height * 0.78;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: height,
        child: SheetFrame(
          title: widget.title,
          subtitle: widget.multi ? '${_selected.length} selected' : null,
          trailing: _selected.isEmpty
              ? null
              : TextButton(onPressed: () => setState(_selected.clear), child: const Text('Clear')),
          child: Column(
            children: [
              TextField(
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.indigo),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: visible.isEmpty
                    ? Center(child: Text('No matches for “$_query”', style: AppTextStyles.bodyMuted))
                    : ListView.separated(
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.line),
                        itemBuilder: (_, i) {
                          final o = visible[i];
                          final on = _selected.contains(o.value);
                          return InkWell(
                            onTap: () {
                              if (widget.multi) {
                                setState(() => on ? _selected.remove(o.value) : _selected.add(o.value));
                              } else {
                                Get.back(result: <T>[o.value]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: on ? AppColors.indigo : Colors.white,
                                      shape: widget.multi ? BoxShape.rectangle : BoxShape.circle,
                                      borderRadius: widget.multi ? BorderRadius.circular(7) : null,
                                      border: Border.all(color: on ? AppColors.indigo : AppColors.scrim, width: 2),
                                    ),
                                    child: on ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(o.label, style: AppTextStyles.titleSmall.copyWith(fontWeight: on ? FontWeight.w800 : FontWeight.w600))),
                                  if (o.trailing != null) Text(o.trailing!, style: AppTextStyles.label.copyWith(color: AppColors.ink2)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (widget.multi) ...[
                const SizedBox(height: 12),
                Pressable(
                  onTap: () => Get.back(result: _selected.toList()),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(18)),
                    child: Text(
                      _selected.isEmpty ? 'Done' : 'Done · ${_selected.length} selected',
                      style: AppTextStyles.button.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
