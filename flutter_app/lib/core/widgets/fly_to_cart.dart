import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Add-to-cart animation from the motion board: a small chip flies from the
/// tapped "Add" button along an arc into the cart button, shrinking as it
/// goes; the cart badge then bounces (see `CartIconButton`).
///
/// Every mounted cart button (header button, floating nav cart tab)
/// registers itself; the chip flies to the newest one that is actually on
/// screen, so it always lands on the cart the patient can see.
class FlyToCart {
  FlyToCart._();

  static final List<GlobalKey> _targets = [];

  static void addTarget(GlobalKey key) => _targets.add(key);
  static void removeTarget(GlobalKey key) => _targets.remove(key);

  static RenderBox? _visibleTarget() {
    for (final key in _targets.reversed) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      // A cart button on a route underneath the current one is still
      // mounted; TickerMode is off for those, so skip them.
      if (box != null && box.attached && TickerMode.valuesOf(ctx).enabled) return box;
    }
    return null;
  }

  static void run(BuildContext from, {IconData icon = Icons.water_drop_outlined}) {
    final overlay = Overlay.maybeOf(from, rootOverlay: true);
    final fromBox = from.findRenderObject() as RenderBox?;
    final toBox = _visibleTarget();
    if (overlay == null || fromBox == null || toBox == null || !fromBox.attached || !toBox.attached) return;

    final start = fromBox.localToGlobal(fromBox.size.center(Offset.zero));
    final end = toBox.localToGlobal(toBox.size.center(Offset.zero));

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FlyingChip(start: start, end: end, icon: icon, onDone: () => entry.remove()),
    );
    overlay.insert(entry);
  }
}

class _FlyingChip extends StatefulWidget {
  const _FlyingChip({required this.start, required this.end, required this.icon, required this.onDone});

  final Offset start;
  final Offset end;
  final IconData icon;
  final VoidCallback onDone;

  @override
  State<_FlyingChip> createState() => _FlyingChipState();
}

class _FlyingChipState extends State<_FlyingChip> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 560))
    ..forward().whenComplete(widget.onDone);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) {
          final t = Curves.easeInOutCubic.transform(_c.value);
          // Quadratic bezier with the control point lifted above both ends
          // so the chip arcs up and over into the cart.
          final control = Offset((widget.start.dx + widget.end.dx) / 2, (widget.start.dy < widget.end.dy ? widget.start.dy : widget.end.dy) - 120);
          final p = Offset(
            (1 - t) * (1 - t) * widget.start.dx + 2 * (1 - t) * t * control.dx + t * t * widget.end.dx,
            (1 - t) * (1 - t) * widget.start.dy + 2 * (1 - t) * t * control.dy + t * t * widget.end.dy,
          );
          final scale = 1 - 0.65 * t;
          return Stack(
            children: [
              Positioned(
                left: p.dx - 18,
                top: p.dy - 18,
                child: Opacity(
                  opacity: _c.value > 0.92 ? (1 - _c.value) / 0.08 : 1,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.indigo,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
