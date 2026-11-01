import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Error shake from the motion board: replays a short decaying horizontal
/// shake every time [trigger] changes (the form bumps it per failed submit).
class Shake extends StatefulWidget {
  const Shake({super.key, required this.trigger, required this.enabled, required this.child});

  final int trigger;
  final bool enabled;
  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  @override
  void didUpdateWidget(Shake old) {
    super.didUpdateWidget(old);
    if (widget.enabled && widget.trigger != old.trigger) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) {
        final t = _c.value;
        final dx = math.sin(t * math.pi * 8) * 8 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}
