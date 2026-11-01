import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/config_service.dart';
import '../../../core/services/launcher_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/stagger.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/models/lookup_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/contact_controller.dart';

/// Board 13 "Contact us": quick Call / WhatsApp / Email (the RN tab bar's
/// Call Us + WhatsApp and the side menu's email), the co-ordinator, and
/// every branch from `branches.php` with map and call actions.
class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Get.find<ConfigService>();
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: 'How can we help?',
            subtitle: 'We’re available 24×7',
            leading: HeaderLeading.menu,
            onLeading: Get.find<HomeController>().openMenu,
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.indigo,
              onRefresh: () => controller.load(refresh: true),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Quick(
                          icon: Icons.call_outlined,
                          label: 'Call',
                          bg: AppColors.indigo,
                          fg: Colors.white,
                          onTap: () => LauncherService.confirmAndCall(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Quick(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'WhatsApp',
                          bg: AppColors.success,
                          fg: Colors.white,
                          onTap: LauncherService.confirmAndWhatsApp,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Quick(icon: Icons.mail_outline_rounded, label: 'Email', bg: Colors.white, fg: AppColors.ink, onTap: LauncherService.email),
                      ),
                    ],
                  ).staggerIn(0),
                  const SizedBox(height: 14),
                  Obx(() {
                    final cfg = config.config.value;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: AppColors.indigo, shape: BoxShape.circle),
                              child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Co-ordinator', style: AppTextStyles.caption),
                                Text(cfg.contactPerson.isEmpty ? 'Dr. Hiral Bhavesh Faldu' : cfg.contactPerson, style: AppTextStyles.titleSmall),
                              ]),
                            ),
                          ]),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: AppColors.line)),
                          _LinkRow(icon: Icons.call_outlined, text: cfg.callNumbers, onTap: () => LauncherService.confirmAndCall()),
                          _LinkRow(icon: Icons.mail_outline_rounded, text: cfg.email, onTap: LauncherService.email),
                          _LinkRow(icon: Icons.language_rounded, text: cfg.website.replaceAll(RegExp(r'^https?://|/$'), ''), onTap: LauncherService.website),
                        ],
                      ),
                    );
                  }).staggerIn(1),
                  const SizedBox(height: 20),
                  Obx(() => Row(children: [
                        Expanded(child: Text('Our branches', style: AppTextStyles.h3)),
                        if (controller.branches.isNotEmpty) Text('${controller.branches.length} in Ahmedabad', style: AppTextStyles.caption),
                      ])),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.loading.value) {
                      return const SizedBox(height: 300, child: SkeletonList(count: 4, padding: EdgeInsets.zero));
                    }
                    if (controller.error.value != null) {
                      return SizedBox(
                        height: 300,
                        child: ErrorState(message: controller.error.value!, onRetry: () => controller.load(refresh: true)),
                      );
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < controller.branches.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _BranchCard(
                              branch: controller.branches[i],
                              open: controller.expanded.value == controller.branches[i].id,
                              onToggle: () => controller.toggle(controller.branches[i].id),
                            ).staggerIn(i + 2),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({required this.icon, required this.label, required this.bg, required this.fg, required this.onTap});
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg == Colors.white ? AppColors.indigoSoft : Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: bg == Colors.white ? AppColors.indigo : fg, size: 22),
            ),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyles.label.copyWith(color: fg, fontSize: 14, fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.icon, required this.text, required this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Icon(icon, size: 18, color: AppColors.indigo),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.ink2),
          ]),
        ),
      );
}

/// Port of the RN branch accordion: name row; expanded → address with a
/// map button, then each phone number (tap → call confirmation).
class _BranchCard extends StatelessWidget {
  const _BranchCard({required this.branch, required this.open, required this.onToggle});
  final BranchModel branch;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final b = branch;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: open ? AppColors.indigo : Colors.transparent, width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.store_mall_directory_outlined, color: AppColors.indigo, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(Formatters.titleCase(b.name), style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                    if (b.pincode.isNotEmpty) Text('Ahmedabad · ${b.pincode}', style: AppTextStyles.caption),
                  ]),
                ),
                AnimatedRotation(
                  turns: open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(Icons.expand_more_rounded, color: AppColors.ink2),
                ),
              ]),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: !open
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Divider(height: 1, color: AppColors.line),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: AppColors.indigo),
                            const SizedBox(width: 8),
                            Expanded(child: Text(b.address, style: AppTextStyles.body.copyWith(color: AppColors.ink2))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Action(
                              icon: Icons.near_me_outlined,
                              label: 'Directions',
                              onTap: () => LauncherService.openMap(address: b.address, mapUrl: b.mapUrl, mapUrlIos: b.mapUrlIos),
                            ),
                            for (final phone in b.phones)
                              _Action(icon: Icons.call_outlined, label: phone, onTap: () => LauncherService.confirmAndCall(phone)),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.indigoSoft, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: AppColors.indigo),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.label.copyWith(color: AppColors.indigo)),
          ]),
        ),
      );
}
