import 'package:flutter/material.dart';

import '../models/ai_review_models.dart';
import 'aiq_basics.dart';
import 'aiq_palette.dart';

/// One draft card in the queue (Type / Agent / Project / Title / $ at stake /
/// Requested / SLA / Gate ✓ / Status / Actions).
class AiqQueueCard extends StatelessWidget {
  const AiqQueueCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onToggleSelect,
    required this.onAccept,
    required this.onEdit,
    required this.onReject,
  });

  final ReviewItem item;
  final bool selected;
  final VoidCallback onToggleSelect;
  final VoidCallback onAccept;
  final VoidCallback onEdit;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiqPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: _SelectBox(
              selected: selected,
              disabled: item.humanGated,
              onTap: onToggleSelect,
            ),
          ),
          AiqKvRow(label: 'Type', child: AiqValueText(item.type.wire)),
          AiqKvRow(label: 'Agent', child: AiqAgentPill(agent: item.agent)),
          AiqKvRow(label: 'Project', child: AiqValueText(item.project)),
          AiqKvRow(label: 'Title', child: AiqValueText(item.title)),
          AiqKvRow(
            label: '\$ at stake',
            child: AiqValueText(AiqFormat.money(item.amountAtStake)),
          ),
          AiqKvRow(
            label: 'Requested',
            child: AiqValueText(AiqFormat.requested(item.requestedAt)),
          ),
          AiqKvRow(label: 'SLA', child: AiqValueText(AiqFormat.sla(item.slaHours))),
          AiqKvRow(
            label: 'Gate ✓',
            child: item.humanGated
                ? const Icon(Icons.check, size: 16, color: AiqPalette.text)
                : const SizedBox.shrink(),
          ),
          AiqKvRow(label: 'Status', child: AiqStatusPill(status: item.status)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 78,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Actions',
                    style: TextStyle(fontSize: 12, color: AiqPalette.muted),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AiqButton(label: 'Accept', onPressed: onAccept),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AiqButton(label: 'Edit', onPressed: onEdit),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AiqButton(label: 'Reject', onPressed: onReject),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Square bulk-select checkbox. Human-gated drafts render it muted: they can
/// never be bulk accepted (the tap is still forwarded so the view can explain).
class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final on = selected && !disabled;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: on
                ? AiqPalette.green
                : (disabled ? AiqPalette.fillMuted : AiqPalette.card),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: on
                  ? AiqPalette.green
                  : (disabled ? AiqPalette.border : AiqPalette.borderStrong),
            ),
          ),
          child: on
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
