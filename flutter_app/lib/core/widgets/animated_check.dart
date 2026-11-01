import 'package:flutter/material.dart';

/// The motion board's success tick: the circle pops in (handled by the
/// caller's container) and the check mark draws itself along its path.
class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key, this.size = 40, this.color = Colors.white, this.strokeWidth = 3.2, this.delay = Duration.zero});

  final double size;
  final Color color;
  final double strokeWidth;
  final Duration delay;

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay + const Duration(milliseconds: 180), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: CurvedAnimation(parent: _c, curve: Curves.easeOutCubic),
        builder: (_, _) => CustomPaint(
          painter: _CheckPainter(progress: Curves.easeOutCubic.transform(_c.value), color: widget.color, stroke: widget.strokeWidth),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.progress, required this.color, required this.stroke});

  final double progress;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Same geometry as the mockup's SVG tick: M4 12 l5 5 L20 6 on a 24 grid.
    final s = size.width / 24;
    final path = Path()
      ..moveTo(4 * s, 12 * s)
      ..lineTo(9 * s, 17 * s)
      ..lineTo(20 * s, 6 * s);
    final metric = path.computeMetrics().first;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress || old.color != color;
}
