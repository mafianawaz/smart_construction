import 'package:flutter/material.dart';

import '../models/kpi_model.dart';
import 'wf_common.dart';
import 'wf_palette.dart';

/// KPI template card in the KPI Library (edit + delete icons).
class KpiTemplateCard extends StatelessWidget {
  const KpiTemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
  });

  final KpiTemplate template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = template;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WfPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
              ),
              _IconAction(icon: Icons.edit_outlined, onTap: onEdit),
              const SizedBox(width: 8),
              _IconAction(icon: Icons.delete_outline, onTap: onDelete),
            ],
          ),
          if (t.description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              t.description,
              style: const TextStyle(fontSize: 10.5, color: WfPalette.muted),
            ),
          ],
          const SizedBox(height: 6),
          WfTag(t.category.label),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _Stat('Unit', t.unit)),
              Expanded(child: _Stat('Direction', '→ ${t.direction.shortLabel}')),
              Expanded(
                child: _Stat(
                  'Status',
                  t.status.label,
                  color: t.isActive ? WfPalette.success : WfPalette.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(icon, size: 15, color: WfPalette.muted),
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.color = WfPalette.text});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: WfPalette.muted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

/// Grey "Quick Stats" panel (Active KPIs / With Targets).
class QuickStatsPanel extends StatelessWidget {
  const QuickStatsPanel({super.key, required this.activeKpis, required this.withTargets});
  final int activeKpis;
  final int withTargets;

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int value, CrossAxisAlignment align) => Expanded(
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: WfPalette.muted)),
              const SizedBox(height: 2),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: WfPalette.text,
                ),
              ),
            ],
          ),
        );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.fill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: WfPalette.text),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              cell('Active KPIs', activeKpis, CrossAxisAlignment.start),
              cell('With Targets', withTargets, CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }
}

/// One scorable KPI inside the Rate Employee card: tags, 0–10 slider, %.
class RateKpiCard extends StatelessWidget {
  const RateKpiCard({
    super.key,
    required this.template,
    required this.score,
    required this.onChanged,
  });

  final KpiTemplate template;
  final double score;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final pct = (score / 10 * 100).round();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.fillSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WfPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  template.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
              ),
              Icon(
                template.direction == KpiDirection.higherIsBetter
                    ? Icons.trending_up
                    : Icons.trending_down,
                size: 16,
                color: WfPalette.success,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [WfTag(template.category.label), WfTag(template.unit.isEmpty ? 'Count' : _cap(template.unit))],
          ),
          const SizedBox(height: 8),
          Text(
            'Score ${score.toStringAsFixed(score % 1 == 0 ? 0 : 1)} - 10',
            style: const TextStyle(fontSize: 9.5, color: WfPalette.muted),
          ),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    activeTrackColor: WfPalette.orange,
                    inactiveTrackColor: WfPalette.border,
                    thumbColor: WfPalette.orange,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  ),
                  child: Slider(
                    value: score,
                    min: 0,
                    max: 10,
                    divisions: 20,
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(
                width: 34,
                child: Text(
                  '$pct%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 10, color: WfPalette.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
