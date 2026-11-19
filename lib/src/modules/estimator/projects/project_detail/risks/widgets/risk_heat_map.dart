import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../models/project_enums.dart';
import '../../../models/risk_model.dart';

/// 5×5 Probability × Impact matrix. Cell color is computed from the
/// score band, not counted risks per cell — the reference doesn't show
/// per-cell counts, just the colored grid, flagged in NOTES_PROJECTS.md.
class RiskHeatMap extends StatelessWidget {
  final List<RiskModel> openRisks;
  const RiskHeatMap({super.key, required this.openRisks});

  int _countAt(int probability, int impact) =>
      openRisks.where((r) => r.probability == probability && r.impact == impact).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Risk Register', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 2),
        Text('Identify, assess and track project risks',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(height: 10),
        Divider(color: AppColors.fieldBorder,),
        const SizedBox(height: 10),
        const Text('5×5 Risk Matrix', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 2),
        Text('Probability vs Impact (open risks only)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 26),
            for (var impact = 1; impact <= 5; impact++)
              Expanded(
                child: Center(
                  child: Text('$impact', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var probability = 5; probability >= 1; probability--)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text('P=$probability', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                for (var impact = 1; impact <= 5; impact++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2,),
                      child: AspectRatio(
                        aspectRatio: 1.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: RiskSeverityBandX.fromScore(probability * impact).color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: () {
                            final count = _countAt(probability, impact);
                            return count == 0
                                ? const SizedBox.shrink()
                                : Text('$count',
                                    style: const TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white));
                          }(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 15),
        Text(
          riskRatingScaleLabels.asMap().entries.take(3).map((e) => '${e.key + 1}: ${e.value}').join(' · '),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        Text(
          riskRatingScaleLabels.asMap().entries.skip(3).map((e) => '${e.key + 1}: ${e.value}').join(' · '),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
