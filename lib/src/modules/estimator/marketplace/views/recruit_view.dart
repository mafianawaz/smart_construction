import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_appbar.dart';
import '../logic.dart';
import '../models/marketplace_models.dart';
import '../widgets/marketplace_primitives.dart';

/// "Recruit {name}" — assign to an optional job and add to hiring pipeline.
class RecruitView extends StatefulWidget {
  final TalentModel talent;
  const RecruitView({super.key, required this.talent});

  @override
  State<RecruitView> createState() => _RecruitViewState();
}

class _RecruitViewState extends State<RecruitView> {
  final MarketplaceLogic logic = Get.find<MarketplaceLogic>();
  static const _noJob = 'No Job';
  String _selected = _noJob;

  @override
  Widget build(BuildContext context) {
    final t = widget.talent;
    final options = [_noJob, ...logic.jobs.map((j) => j.title)];
    return Scaffold(
      appBar: AppPrimaryBar(
        title: t.name,
        showBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarketplaceCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recruit ${t.name}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Add this person to your hiring pipeline as a candidate',
                      style:
                          TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                  const SizedBox(height: 14),
                  const Text('Assign to job (optional)',
                      style:
                          TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  MarketplaceDropdown(
                    value: _selected,
                    items: options,
                    onChanged: (v) => setState(() => _selected = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            MarketplacePrimaryButton(
              label: 'Add to Pipeline',
              onPressed: () {
                final job =
                    logic.jobs.firstWhereOrNull((j) => j.title == _selected);
                logic.recruit(t, job);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
