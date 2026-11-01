import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Staggered list entrance from the motion board: each card rises 18 px and
/// fades in, 60 ms after the one above. Capped so a card far down a long
/// list (scrolled to later) doesn't wait seconds to appear.
extension StaggerIn on Widget {
  Widget staggerIn(int index, {int maxSteps = 8}) => animate(delay: (60 * (index < maxSteps ? index : maxSteps)).ms)
      .fadeIn(duration: 320.ms, curve: Curves.easeOut)
      .slideY(begin: 0.18, end: 0, duration: 320.ms, curve: Curves.easeOutCubic);
}
