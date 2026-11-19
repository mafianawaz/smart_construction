import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../logic.dart';
import '../models/kpi_model.dart';
import '../widgets/kpi_widgets.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';

/// Performance → Rate Employee.
class RateEmployeeTab extends StatelessWidget {
  const RateEmployeeTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final kpis = logic.ratableKpis;
    return ListView(
      children: [
        QuickStatsPanel(
          activeKpis: logic.activeKpiCount,
          withTargets: logic.kpisWithTargets,
        ),
        const SizedBox(height: 12),
        WfSectionCard(
          title: 'Rate Employee by KPIs',
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Score employees against their assigned KPI targets',
                style: TextStyle(fontSize: 10.5, color: WfPalette.muted),
              ),
              const SizedBox(height: 12),
              CustomDropdown<RatingRole>(
                value: logic.selectedRole,
                items: logic.roles,
                itemLabel: (r) => r.display,
                onChanged: logic.setRole,
              ),
              const SizedBox(height: 12),
              if (kpis.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No active KPIs are assigned to this role yet.',
                    style: TextStyle(fontSize: 11, color: WfPalette.muted),
                  ),
                )
              else
                for (final k in kpis)
                  RateKpiCard(
                    template: k,
                    score: logic.scoreFor(k),
                    onChanged: (v) => logic.setScore(k, v),
                  ),
              CustomTextField(
                hintText: 'e.g. Q1 2026',
                controller: logic.periodController,
                isFilled: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Provide overall feedback...',
                controller: logic.feedbackController,
                maxLines: 4,
                isFilled: true,
              ),
              const SizedBox(height: 14),
              CustomButton(text: 'Submit Rating', onPressed: logic.submitRating),
            ],
          ),
        ),
      ],
    );
  }
}
