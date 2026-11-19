import 'package:flutter/material.dart';

import '../models/ai_review_models.dart';
import 'aiq_palette.dart';

/// Breadcrumb + page title ("Projects › AI Review Queue" / "AI Review Queue").
class AiqHeader extends StatelessWidget {
  const AiqHeader({super.key, required this.crumbs, required this.title});

  final List<String> crumbs;
  final String title;

  @override
  Widget build(BuildContext context) {
    final crumbStyle = const TextStyle(fontSize: 11, color: AiqPalette.muted);
    final spans = <InlineSpan>[];
    for (var i = 0; i < crumbs.length; i++) {
      spans.add(TextSpan(text: crumbs[i]));
      if (i != crumbs.length - 1) spans.add(const TextSpan(text: '  ›  '));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: spans, style: crumbStyle)),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AiqPalette.text,
          ),
        ),
      ],
    );
  }
}

/// Number card in the 2×2 stats grid.
class AiqStatCard extends StatelessWidget {
  const AiqStatCard({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AiqPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AiqPalette.muted),
          ),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AiqPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dropdown-looking filter pill: "Agent: All ⌄".
class AiqFilterPill extends StatelessWidget {
  const AiqFilterPill({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = value != 'All';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF1E8) : AiqPalette.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AiqPalette.orange : AiqPalette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $value',
              style: const TextStyle(fontSize: 12, color: AiqPalette.text),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AiqPalette.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class AiqPickerOption<T> {
  const AiqPickerOption(this.label, this.value);
  final String label;
  final T value;
}

/// Bottom-sheet option picker. Returns the chosen option, or null when the
/// sheet was dismissed (so a `null` *value* can still mean "All").
Future<AiqPickerOption<T>?> showAiqPicker<T>(
  BuildContext context, {
  required String title,
  required List<AiqPickerOption<T>> options,
  required T selected,
}) {
  return showModalBottomSheet<AiqPickerOption<T>>(
    context: context,
    backgroundColor: AiqPalette.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AiqPalette.text,
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final o in options)
                      ListTile(
                        dense: true,
                        title: Text(
                          o.label,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: o.value == selected
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: AiqPalette.orange,
                              )
                            : null,
                        onTap: () => Navigator.of(ctx).pop(o),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Green "A2" tag. [expanded] stretches it across the value column (queue
/// card); otherwise it hugs its text (sheet).
class AiqAgentPill extends StatelessWidget {
  const AiqAgentPill({super.key, required this.agent, this.expanded = true});

  final ReviewAgent agent;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AiqTag(
      text: agent.code,
      background: AiqPalette.agentBg,
      foreground: AiqPalette.agentText,
      expanded: expanded,
    );
  }
}

/// Small rounded tag (agent pill, "Needs human verification", …).
class AiqTag extends StatelessWidget {
  const AiqTag({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
    this.expanded = false,
  });

  final String text;
  final Color background;
  final Color foreground;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

/// Outlined status pill ("Pending" / "Edited").
class AiqStatusPill extends StatelessWidget {
  const AiqStatusPill({super.key, required this.status});

  final ReviewStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AiqPalette.borderStrong),
      ),
      child: Text(
        status.label,
        style: const TextStyle(fontSize: 12, color: AiqPalette.text),
      ),
    );
  }
}

/// "Label    value" row used by queue cards, compact rows and the sheet.
class AiqKvRow extends StatelessWidget {
  const AiqKvRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 78,
  });

  final String label;
  final Widget child;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AiqPalette.muted),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        ],
      ),
    );
  }
}

class AiqValueText extends StatelessWidget {
  const AiqValueText(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AiqPalette.text,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

/// Rounded outlined button (Accept / Edit / Reject …). [filled] = orange.
class AiqButton extends StatelessWidget {
  const AiqButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 36,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          backgroundColor: filled ? AiqPalette.orange : AiqPalette.card,
          foregroundColor: filled ? Colors.white : AiqPalette.text,
          disabledForegroundColor: AiqPalette.faint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: filled ? AiqPalette.orange : AiqPalette.border,
            ),
          ),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Empty / no-match state.
class AiqEmptyState extends StatelessWidget {
  const AiqEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiqPalette.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 32, color: AiqPalette.faint),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AiqPalette.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AiqPalette.muted),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 14),
            AiqButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    );
  }
}
