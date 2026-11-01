import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Inline field message: slides down under the field with an icon. Error
/// (red, alert icon) takes priority over success (green, tick).
class FieldMessage extends StatelessWidget {
  const FieldMessage({super.key, this.error, this.success});

  final String? error;
  final String? success;

  @override
  Widget build(BuildContext context) {
    final text = error ?? success;
    final isError = error != null;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topLeft,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : TweenAnimationBuilder<double>(
              key: ValueKey(text),
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 220),
              builder: (_, t, child) => Opacity(opacity: t, child: Transform.translate(offset: Offset(0, -4 * (1 - t)), child: child)),
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isError ? Icons.error_outline_rounded : Icons.check_rounded,
                      size: 15,
                      color: isError ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isError ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
