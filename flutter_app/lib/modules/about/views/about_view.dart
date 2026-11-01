import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';

/// Board 11 "About us" — the RN `Aboutus.js` content (who we are, vision,
/// mission, services, location), restyled.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ScreenHeader(title: 'About us'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Image.asset(AppAssets.logo, width: 64, height: 78, fit: BoxFit.contain),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('WHO WE ARE', style: AppTextStyles.overline),
                              const SizedBox(height: 2),
                              Text('Health Care 24×7 Pathology & Endocrine Laboratory', style: AppTextStyles.h3.copyWith(height: 1.25)),
                            ]),
                          ),
                        ]),
                        const SizedBox(height: 14),
                        Text(
                          'A fully automated and computerised pathology laboratory equipped with the latest and most modern '
                          'technologies. We are committed to providing comprehensive, high-quality and rapid-response laboratory '
                          'testing at affordable prices, for physicians, nursing homes, companies and institutions in Ahmedabad.',
                          style: AppTextStyles.body.copyWith(color: AppColors.ink2),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Since our inception we have kept adopting the latest advances in laboratory testing, aiming for '
                          'certified results with high precision and fast turnaround times.',
                          style: AppTextStyles.body.copyWith(color: AppColors.ink2),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(16)),
                          child: Row(children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: AppColors.indigo, shape: BoxShape.circle),
                              child: const Text('HF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 10),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Co-ordinator', style: AppTextStyles.caption),
                              Text('Dr. Hiral Bhavesh Faldu', style: AppTextStyles.titleSmall),
                            ]),
                          ]),
                        ),
                      ],
                    ),
                  ).staggerIn(0),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(28)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.visibility_outlined, color: Color(0xFFC9CBEE), size: 18),
                        const SizedBox(width: 8),
                        Text('OUR VISION', style: AppTextStyles.overline.copyWith(color: const Color(0xFFC9CBEE))),
                      ]),
                      const SizedBox(height: 8),
                      Text(
                        'To become a leading pathology laboratory for comprehensive diagnostic services.',
                        style: AppTextStyles.h3.copyWith(color: Colors.white, height: 1.4),
                      ),
                    ]),
                  ).staggerIn(1),
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('OUR MISSION', style: AppTextStyles.overline),
                      const SizedBox(height: 10),
                      for (final m in const [
                        'Accurate, precise diagnostic, prognostic and predictive testing, delivered promptly',
                        'High quality standards that patients and doctors trust',
                        'Integrity and commitment, always putting patients first',
                        'Affordable testing without compromising on quality',
                      ])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(m, style: AppTextStyles.body)),
                          ]),
                        ),
                    ]),
                  ).staggerIn(2),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.25,
                    children: const [
                      _Service(icon: Icons.visibility_outlined, title: 'Ocular pathology', note: 'Exclusive in Ahmedabad'),
                      _Service(icon: Icons.home_outlined, title: 'Home collection', note: 'With prior appointment'),
                      _Service(icon: Icons.bolt_rounded, title: 'Same-day reports', note: 'For most tests'),
                      _Service(icon: Icons.mail_outline_rounded, title: 'Reports delivered', note: 'Email, fax or courier'),
                    ],
                  ).staggerIn(3),
                  const SizedBox(height: 14),
                  Pressable(
                    scale: 0.98,
                    onTap: () {
                      Get.back();
                      Get.find<HomeController>().goTo(HomeTab.contact);
                    },
                    child: _Card(
                      child: Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.location_on_outlined, color: AppColors.indigo),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('First Floor, Aishwarya Complex', style: AppTextStyles.titleSmall),
                            Text('Jawahar Chowk – Isanpur Road, Maninagar', style: AppTextStyles.caption),
                          ]),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.ink2),
                      ]),
                    ),
                  ).staggerIn(4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)), child: child);
}

class _Service extends StatelessWidget {
  const _Service({required this.icon, required this.title, required this.note});
  final IconData icon;
  final String title;
  final String note;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.skySoft, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.skyInk, size: 20),
          ),
          const Spacer(),
          Text(title, style: AppTextStyles.titleSmall),
          Text(note, style: AppTextStyles.caption),
        ]),
      );
}
