import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'field_message.dart';
import 'shake.dart';

/// Form field from the Design system board: label above, rounded field,
/// indigo focus ring, red border + soft red fill + icon message on error,
/// green border + tick once valid. Shakes on each failed submit.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.required = false,
    this.optionalNote,
    this.error,
    this.isValid = false,
    this.shakeTrigger = 0,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onChanged,
    this.focusNode,
    this.showCounter = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool required;
  final String? optionalNote;
  final String? error;
  final bool isValid;
  final int shakeTrigger;
  final IconData? prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool showCounter;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;
    final borderColor = hasError ? AppColors.error : (widget.isValid ? AppColors.success : AppColors.line);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: borderColor, width: hasError || widget.isValid ? 2 : 1.5),
    );

    return Shake(
      trigger: widget.shakeTrigger,
      enabled: hasError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: widget.label,
              style: AppTextStyles.label,
              children: [
                if (widget.required) const TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
                if (widget.optionalNote != null)
                  TextSpan(text: ' ${widget.optionalNote}', style: AppTextStyles.caption.copyWith(color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: [
              ...?widget.inputFormatters,
              if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            maxLines: widget.maxLines,
            textCapitalization: widget.textCapitalization,
            autofillHints: widget.autofillHints,
            onChanged: (v) {
              widget.onChanged?.call(v);
              if (widget.showCounter) setState(() {});
            },
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
            decoration: InputDecoration(
              hintText: widget.hint,
              fillColor: hasError ? AppColors.errorField : AppColors.field,
              prefixIcon: widget.prefixIcon == null && widget.prefixText == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 14, right: 10),
                      child: widget.prefixText != null
                          ? Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(widget.prefixText!, style: AppTextStyles.titleSmall.copyWith(color: AppColors.ink2)),
                              Container(width: 1, height: 22, margin: const EdgeInsets.only(left: 10), color: AppColors.line),
                            ])
                          : Icon(widget.prefixIcon, size: 20, color: AppColors.muted),
                    ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: widget.showCounter && widget.maxLength != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Text('${widget.controller.text.length}/${widget.maxLength}', style: AppTextStyles.caption),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                      child: widget.isValid && !hasError
                          ? const Padding(
                              key: ValueKey('ok'),
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                            )
                          : const SizedBox(key: ValueKey('none'), width: 0),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              enabledBorder: border,
              border: border,
              focusedBorder: hasError
                  ? border
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.indigo, width: 2),
                    ),
            ),
          ),
          FieldMessage(error: widget.error),
        ],
      ),
    );
  }
}
