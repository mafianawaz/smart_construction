import 'package:flutter/material.dart';

import '../models/crm_sequence_models.dart';
import 'crm_palette.dart';

/// One sequence: name + status badge + action icons, description, stats line,
/// a short step timeline and the owner.
///
/// Library templates show only "use template"; your own sequences show
/// duplicate / archive / delete, and the status badge opens a status menu.
class SequenceCard extends StatelessWidget {
  final SequenceModel sequence;
  final VoidCallback onDuplicate;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final ValueChanged<SequenceStatus>? onStatusChanged;

  const SequenceCard({
    super.key,
    required this.sequence,
    required this.onDuplicate,
    this.onArchive,
    this.onDelete,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = sequence;
    final muted = s.isArchived;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Opacity(
        opacity: muted ? 0.7 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    s.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: CrmPalette.text,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (s.isTemplate)
                  const _StatusBadge(label: 'TEMPLATE', fill: CrmPalette.blueTint, text: CrmPalette.blue)
                else
                  _statusBadge(),
                const Spacer(),
                _IconAction(
                  icon: Icons.copy_outlined,
                  tooltip: s.isTemplate ? 'Use template' : 'Duplicate',
                  onTap: onDuplicate,
                ),
                if (onArchive != null)
                  _IconAction(
                    icon: s.isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                    tooltip: s.isArchived ? 'Restore' : 'Archive',
                    onTap: onArchive!,
                  ),
                if (onDelete != null)
                  _IconAction(
                    icon: Icons.delete_outline,
                    tooltip: 'Delete',
                    onTap: onDelete!,
                  ),
              ],
            ),
            if (s.description.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                s.description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: CrmPalette.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${s.steps.length} step${s.steps.length == 1 ? '' : 's'}'
              '  ·  ${s.activeCount} active'
              '  ·  ${s.totalEnrolled} total enrolled'
              '  ·  ${s.repliedCount} replied',
              style: const TextStyle(fontSize: 10.5, color: CrmPalette.textMuted),
            ),
            if (s.steps.isNotEmpty) ...[
              const SizedBox(height: 10),
              _StepTimeline(steps: s.steps),
            ],
            if (s.ownerName.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Owner: ${s.ownerName}',
                style: const TextStyle(fontSize: 10.5, color: CrmPalette.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusBadge() {
    Color fill;
    Color text;
    switch (sequence.status) {
      case SequenceStatus.draft:
        fill = CrmPalette.warnFill;
        text = CrmPalette.warnText;
        break;
      case SequenceStatus.active:
        fill = CrmPalette.successTint;
        text = CrmPalette.success;
        break;
      case SequenceStatus.paused:
        fill = CrmPalette.blueTint;
        text = CrmPalette.blue;
        break;
      case SequenceStatus.archived:
        fill = CrmPalette.chipFill;
        text = CrmPalette.textMuted;
        break;
    }
    final badge = _StatusBadge(
      label: sequence.status.label.toUpperCase(),
      fill: fill,
      text: text,
    );
    final callback = onStatusChanged;
    if (callback == null || sequence.isArchived) return badge;

    return PopupMenuButton<SequenceStatus>(
      tooltip: 'Change status',
      onSelected: callback,
      color: CrmPalette.surface,
      itemBuilder: (context) => [
        for (final status in [
          SequenceStatus.draft,
          SequenceStatus.active,
          SequenceStatus.paused,
        ])
          PopupMenuItem<SequenceStatus>(
            value: status,
            child: Text(
              status.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    status == sequence.status ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
      ],
      child: badge,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color fill;
  final Color text;

  const _StatusBadge({
    required this.label,
    required this.fill,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 17, color: CrmPalette.textMuted),
        ),
      ),
    );
  }
}

IconData _stepIcon(SequenceStepType type) {
  switch (type) {
    case SequenceStepType.email:
      return Icons.mail_outline;
    case SequenceStepType.call:
      return Icons.phone_outlined;
    case SequenceStepType.task:
      return Icons.check_circle_outline;
    case SequenceStepType.text:
      return Icons.sms_outlined;
  }
}

/// Compact "Day 0 · Email · Intro" list (max 4 rows, then "+n more").
class _StepTimeline extends StatelessWidget {
  final List<SequenceStep> steps;

  const _StepTimeline({required this.steps});

  static const _maxRows = 4;

  @override
  Widget build(BuildContext context) {
    var day = 0;
    final rows = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      day += steps[i].delayDays;
      if (i >= _maxRows) continue;
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Icon(_stepIcon(steps[i].type), size: 14, color: CrmPalette.orange),
              const SizedBox(width: 8),
              SizedBox(
                width: 42,
                child: Text(
                  'Day $day',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  steps[i].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5, color: CrmPalette.text),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (steps.length > _maxRows) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 22),
          child: Text(
            '+${steps.length - _maxRows} more',
            style: const TextStyle(fontSize: 10.5, color: CrmPalette.textMuted),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CrmPalette.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: rows),
    );
  }
}
