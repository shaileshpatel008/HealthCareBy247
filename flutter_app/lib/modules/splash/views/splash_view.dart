import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_assets.dart';
import '../../../theme/app_colors.dart';

/// Board 01 "Splash": indigo field with soft circles, the logo in a white
/// tile that scales in with pulse rings behind it, name and tagline rising
/// in after it, three loading dots at the bottom.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: AppColors.indigo,
        body: Stack(
          children: [
            const Positioned(top: -170, right: -200, child: _Blob(size: 420, color: AppColors.indigoRingA)),
            const Positioned(bottom: -110, left: -140, child: _Blob(size: 300, color: AppColors.indigoRingB)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        for (final delay in [0, 1200])
                          Container(
                            width: 168,
                            height: 168,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat(), delay: delay.ms)
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.8, 1.8), duration: 2400.ms, curve: Curves.easeOut)
                              .fadeOut(begin: 0.5, duration: 2400.ms),
                        Container(
                          width: 148,
                          height: 148,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(48),
                            boxShadow: [BoxShadow(color: const Color(0xFF0B0C2E).withValues(alpha: 0.33), blurRadius: 48, offset: const Offset(0, 24))],
                          ),
                          child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                        )
                            .animate()
                            .scale(begin: const Offset(0.85, 0.85), duration: 700.ms, curve: Curves.easeOutCubic)
                            .fadeIn(duration: 500.ms),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Column(
                    children: [
                      const Text(
                        'Health Care Lab',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.6),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 260,
                        child: Text(
                          'Pathology & Endocrine Laboratory, open 24×7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ).animate(delay: 250.ms).fadeIn(duration: 600.ms).slideY(begin: 0.25, curve: Curves.easeOutCubic),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 64,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true), delay: (150 * i).ms)
                            .fade(begin: 0.3, end: 1, duration: 480.ms)
                            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 480.ms),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Maninagar, Ahmedabad', style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
