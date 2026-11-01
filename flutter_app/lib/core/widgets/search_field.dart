import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Search box with the indigo focus ring and a clear (✕) button — the RN
/// screens' search row with its clear-text icon.
class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.controller, required this.hint, required this.onChanged, required this.onClear, this.focusNode});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final FocusNode? focusNode;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.search,
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {});
      },
      style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: widget.hint,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.indigo),
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  widget.onClear();
                  setState(() {});
                },
                icon: const Icon(Icons.close_rounded, color: AppColors.ink2),
              ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.indigo, width: 2)),
      ),
    );
  }
}
