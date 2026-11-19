import 'package:flutter/material.dart';
import '../models/ai_review_models.dart';
import '../review_detail/logic.dart';
import 'aiq_basics.dart';
import 'aiq_palette.dart';

/// The Draft Review sheet body: header, meta, basis, typed draft form,
/// Basis panel, Input snapshot, Original vs Edited, correction reason, note,
/// "use as example" toggle and the action buttons.
///
/// Screen-agnostic: reads form state from [logic] and reports button taps
/// through callbacks, so the same panel can live in a modal sheet or inline.
class AiqReviewSheetPanel extends StatelessWidget {
  const AiqReviewSheetPanel({
    super.key,
    required this.logic,
    required this.onClose,
    required this.onAccept,
    required this.onSaveEdits,
    required this.onReject,
    required this.onSendToAttorney,
    required this.onOpenAudit,
  });

  final ReviewSheetLogic logic;
  final VoidCallback onClose;
  final VoidCallback onAccept;
  final VoidCallback onSaveEdits;
  final VoidCallback onReject;
  final VoidCallback onSendToAttorney;
  final VoidCallback onOpenAudit;

  ReviewItem get item => logic.item;

  @override
  Widget build(BuildContext context) {
    final basis = item.basis;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiqPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Review: ${item.title}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AiqPalette.text,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.close, size: 18, color: AiqPalette.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Meta
          AiqKvRow(
            label: 'Agent',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AiqAgentPill(agent: item.agent, expanded: false),
                const SizedBox(width: 8),
                AiqValueText(item.agent.roleName),
              ],
            ),
          ),
          AiqKvRow(
            label: 'Created',
            child: AiqValueText(AiqFormat.requested(item.requestedAt)),
          ),
          AiqKvRow(label: 'Type', child: AiqValueText(item.type.wire)),
          AiqKvRow(
            label: '\$',
            child: AiqValueText(AiqFormat.money(item.amountAtStake)),
          ),
          AiqKvRow(label: 'Project', child: AiqValueText(item.projectLong)),
          AiqKvRow(
            label: 'Gate',
            child: AiqValueText(item.humanGated ? 'Human gate' : 'Not gated'),
          ),
          const SizedBox(height: 8),

          // Agent tag + verification + basis summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AiqPalette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AiqTag(
                  text: item.agent.longLabel,
                  background: AiqPalette.agentBg,
                  foreground: AiqPalette.agentText,
                ),
                if (basis.needsHumanVerification) ...[
                  const SizedBox(height: 6),
                  const AiqTag(
                    text: 'Needs human verification',
                    background: AiqPalette.warnBg,
                    foreground: AiqPalette.warnText,
                  ),
                ],
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AiqPalette.text,
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Basis: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: basis.summary),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Legal framing (finance types)
          if (item.legalFraming) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AiqPalette.fillMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AiqPalette.border),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: AiqPalette.muted),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Legal framing: "Not legal advice. Review with counsel before sending."',
                      style: TextStyle(
                        fontSize: 12,
                        color: AiqPalette.text,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Typed draft form
          const SizedBox(height: 14),
          const Text(
            'Draft body (typed form, editable)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AiqPalette.text,
            ),
          ),
          const SizedBox(height: 8),
          for (final f in item.draftFields)
            AiqField(
              label: f.required ? '${f.label} *' : f.label,
              controller: logic.fieldControllers[f.id]!,
              readOnly: !f.editable,
              maxLines: f.kind == DraftFieldKind.multiline ? 4 : 1,
              minLines: f.kind == DraftFieldKind.multiline ? 3 : 1,
              keyboardType: f.kind == DraftFieldKind.amount
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : null,
            ),

          // Basis panel
          const SizedBox(height: 4),
          _BasisPanel(basis: basis, onOpenAudit: onOpenAudit),
          const SizedBox(height: 10),
          _InputSnapshot(
            basis: basis,
            open: logic.snapshotOpen,
            onToggle: logic.toggleSnapshot,
          ),

          // Original vs Edited
          const SizedBox(height: 14),
          const _FieldLabel('Original (AI draft)'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AiqPalette.fillMuted,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AiqPalette.border),
            ),
            child: Text(
              item.originalText,
              style: TextStyle(
                fontSize: 12.5,
                color: AiqPalette.muted,
                height: 1.35,
                decoration: logic.editedTextChanged
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AiqField(
            label: 'Edited',
            controller: logic.editedController,
            minLines: 2,
            maxLines: 5,
          ),

          // Correction reason
          const SizedBox(height: 2),
          const _FieldLabel('Correction reason (required on edit or reject) *'),
          for (final r in CorrectionReason.values)
            _ReasonChip(
              reason: r,
              selected: logic.reason == r,
              onTap: () => logic.setReason(r),
            ),
          const SizedBox(height: 12),

          // Note
          AiqField(
            label: 'Note (≤${ReviewSheetLogic.noteMaxLength} chars)',
            controller: logic.noteController,
            maxLength: ReviewSheetLogic.noteMaxLength,
          ),

          // Use as example
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Use as example for this company',
                  style: TextStyle(fontSize: 12.5, color: AiqPalette.text),
                ),
              ),
              Switch(
                value: logic.useAsExample,
                onChanged: logic.setUseAsExample,
                activeColor: Colors.white,
                activeTrackColor: AiqPalette.green,
              ),
              Text(
                logic.useAsExample ? 'On' : 'Off',
                style: const TextStyle(fontSize: 12, color: AiqPalette.text),
              ),
            ],
          ),

          if (logic.error != null) ...[
            const SizedBox(height: 4),
            Text(
              logic.error!,
              style: const TextStyle(fontSize: 12, color: AiqPalette.error),
            ),
          ],

          // Actions
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AiqButton(
                label: 'Accept',
                onPressed: onAccept,
                filled: true,
                expand: false,
              ),
              AiqButton(
                label: 'Save edits & accept',
                onPressed: onSaveEdits,
                expand: false,
              ),
              AiqButton(label: 'Reject', onPressed: onReject, expand: false),
              if (item.legalFraming)
                AiqButton(
                  label: 'Send to attorney review',
                  onPressed: onSendToAttorney,
                  expand: false,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Labelled text field used across the sheet.
class AiqField extends StatelessWidget {
  const AiqField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label),
          TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 12.5,
              color: readOnly ? AiqPalette.muted : AiqPalette.text,
              height: 1.35,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: readOnly ? AiqPalette.fillMuted : AiqPalette.card,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AiqPalette.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AiqPalette.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AiqPalette.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AiqPalette.muted),
      ),
    );
  }
}

/// Full-width pill; selected = dark filled.
class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final CorrectionReason reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AiqPalette.ink : AiqPalette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AiqPalette.ink : AiqPalette.borderStrong,
            ),
          ),
          child: Text(
            reason.label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : AiqPalette.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _BasisPanel extends StatelessWidget {
  const _BasisPanel({required this.basis, required this.onOpenAudit});

  final ReviewBasis basis;
  final VoidCallback onOpenAudit;

  @override
  Widget build(BuildContext context) {
    Widget bullet(Widget child) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1, right: 8),
                child: Text('•', style: TextStyle(fontSize: 12)),
              ),
              Expanded(child: child),
            ],
          ),
        );

    const body = TextStyle(fontSize: 12, color: AiqPalette.text, height: 1.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AiqPalette.fillMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AiqPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basis panel',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AiqPalette.text,
            ),
          ),
          const SizedBox(height: 8),
          bullet(Text('Sources: ${basis.sourcesLine}', style: body)),
          bullet(
            Text(
              'Corpus citations: ${basis.corpusCitations.join('; ')}',
              style: body,
            ),
          ),
          bullet(
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Model: ${basis.modelLabel} · run ', style: body),
                GestureDetector(
                  onTap: onOpenAudit,
                  child: Text(
                    '${basis.runId} → ${basis.auditLogRef}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AiqPalette.orange,
                      decoration: TextDecoration.underline,
                      decorationColor: AiqPalette.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputSnapshot extends StatelessWidget {
  const _InputSnapshot({
    required this.basis,
    required this.open,
    required this.onToggle,
  });

  final ReviewBasis basis;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: AiqPalette.fillMuted,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AiqPalette.border),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '• Input snapshot (used / skipped)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AiqPalette.text,
                    ),
                  ),
                ),
                Icon(
                  open ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AiqPalette.muted,
                ),
              ],
            ),
          ),
        ),
        if (open)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AiqPalette.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AiqPalette.border),
            ),
            child: Text(
              'Used: ${basis.inputUsed} · Skipped: ${basis.inputSkipped}',
              style: const TextStyle(
                fontSize: 12,
                color: AiqPalette.muted,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}
