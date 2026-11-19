import 'package:flutter/material.dart';

import '../models/crm_models.dart';
import 'crm_palette.dart';

/// Opportunity summary card. [compact] is used inside board tiles.
class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final bool compact;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final stageColor = opportunity.stage.color;
    return Container(
      margin: EdgeInsets.only(bottom: compact ? 6 : 10),
      padding: EdgeInsets.all(compact ? 8 : 12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity.title,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 11 : 13.5,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            opportunity.organizationName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 10 : 11.5,
              color: CrmPalette.textMuted,
            ),
          ),
          SizedBox(height: compact ? 4 : 8),
          Row(
            children: [
              Text(
                crmMoney(opportunity.value),
                style: TextStyle(
                  fontSize: compact ? 11 : 13,
                  fontWeight: FontWeight.w700,
                  color: CrmPalette.text,
                ),
              ),
              const Spacer(),
              if (!compact)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: stageColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    opportunity.stage.label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 13,
                  color: CrmPalette.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  opportunity.assigneeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Two-column grid of stage tiles (the "Board" view). Each tile shows the
/// stage label + count and, when populated, compact opportunity cards.
class PipelineBoard extends StatelessWidget {
  final List<OpportunityStage> stages;
  final List<OpportunityModel> Function(OpportunityStage) itemsFor;

  const PipelineBoard({
    super.key,
    required this.stages,
    required this.itemsFor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final tileWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final stage in stages)
              SizedBox(
                width: tileWidth,
                child: _StageTile(stage: stage, items: itemsFor(stage)),
              ),
          ],
        );
      },
    );
  }
}

class _StageTile extends StatelessWidget {
  final OpportunityStage stage;
  final List<OpportunityModel> items;

  const _StageTile({required this.stage, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CrmPalette.border),
      ),
      // Clip so the coloured top edge follows the rounded corners.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 3, color: stage.color),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: [
                  Text(
                    stage.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: CrmPalette.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${items.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: CrmPalette.textMuted,
                    ),
                  ),
                  if (items.isNotEmpty) const SizedBox(height: 8),
                  for (final item in items)
                    OpportunityCard(opportunity: item, compact: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
