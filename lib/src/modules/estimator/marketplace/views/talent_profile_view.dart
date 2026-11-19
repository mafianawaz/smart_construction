import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_appbar.dart';
import '../models/marketplace_models.dart';
import '../widgets/marketplace_primitives.dart';
import 'recruit_view.dart';

class TalentProfileView extends StatelessWidget {
  final TalentModel talent;
  const TalentProfileView({super.key, required this.talent});

  void _recruit() => Get.to(() => RecruitView(talent: talent));

  @override
  Widget build(BuildContext context) {
    final t = talent;
    return Scaffold(
      appBar: AppPrimaryBar(
        title: t.name,
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.headline,
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
            const SizedBox(height: 10),
            MarketplacePrimaryButton(
              label: 'Recruit',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: _recruit,
            ),
            const SizedBox(height: 16),
            const Text('Profile Details',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _DetailCard(
              title: 'About',
              subtitle: t.bio.isEmpty ? '' : t.name,
              tag: 'Desired Pay',
              value: t.rateLabel,
              onRecruit: _recruit,
            ),
            _DetailCard(
              title: 'Contact',
              subtitle: 'Email',
              tag: t.available ? 'Available' : 'Unavailable',
              value: t.email,
              onRecruit: _recruit,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String value;
  final VoidCallback onRecruit;
  const _DetailCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.value,
    required this.onRecruit,
  });

  @override
  Widget build(BuildContext context) {
    return MarketplaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w700)),
                    if (subtitle.isNotEmpty)
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryOrange)),
                  ],
                ),
              ),
              MarketplaceTag(tag),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 12)),
          const Divider(height: 20),
          InlineActionLink('Recruit', onTap: onRecruit),
        ],
      ),
    );
  }
}
