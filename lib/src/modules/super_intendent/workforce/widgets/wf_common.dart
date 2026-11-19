import 'package:flutter/material.dart';

import 'wf_palette.dart';

/// Screen title + "0 Proj" badge + subtitle.
class WfHeader extends StatelessWidget {
  const WfHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.projectCount,
    this.fontSize = 18,
  });

  final String title;
  final String subtitle;
  final int? projectCount;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: WfPalette.text,
                ),
              ),
            ),
            if (projectCount != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: WfPalette.fill,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$projectCount Proj',
                  style: const TextStyle(fontSize: 9, color: WfPalette.muted),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: WfPalette.muted),
        ),
      ],
    );
  }
}


/// Small pill dropdown for the Workers filter row ("Trade: All ▾").
class WfFilterChip extends StatelessWidget {
  const WfFilterChip({
    super.key,
    required this.display,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String display;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      initialValue: selected,
      offset: const Offset(0, 34),
      itemBuilder: (_) => [
        for (final o in options)
          PopupMenuItem<String>(
            value: o,
            height: 38,
            child: Text(o, style: const TextStyle(fontSize: 12)),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: WfPalette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: WfPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(display, style: const TextStyle(fontSize: 10.5, color: WfPalette.text)),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down, size: 14, color: WfPalette.muted),
          ],
        ),
      ),
    );
  }
}

/// Neutral rounded tag ("Electrical", "Financial", "Count").
class WfTag extends StatelessWidget {
  const WfTag(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: WfPalette.fill,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: WfPalette.border),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, color: WfPalette.muted)),
    );
  }
}

/// Soft green/amber/red status chip ("Active").
class WfStatusChip extends StatelessWidget {
  const WfStatusChip(this.label, {super.key, this.fg = WfPalette.success, this.bg = WfPalette.successBg});
  final String label;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

/// "● Active" text with a leading dot (Workers list card).
class WfDotStatus extends StatelessWidget {
  const WfDotStatus(this.label, {super.key, this.color = WfPalette.success});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

/// White bordered card with optional title + trailing icon.
class WfSectionCard extends StatelessWidget {
  const WfSectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.color = WfPalette.surface,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WfPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WfPalette.text,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}

/// Label on the left, bold value on the right.
class WfKvRow extends StatelessWidget {
  const WfKvRow(this.label, this.value, {super.key, this.valueColor = WfPalette.text});
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: WfPalette.muted)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c),
    );

InputDecoration wfInputDecoration(String hint, {bool error = false}) {
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 12, color: WfPalette.hint),
    filled: true,
    fillColor: WfPalette.fillSoft,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: _border(error ? WfPalette.danger : WfPalette.border),
    enabledBorder: _border(error ? WfPalette.danger : WfPalette.border),
    focusedBorder: _border(error ? WfPalette.danger : WfPalette.orange),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: WfPalette.text,
          ),
        ),
      );
}






// ── Number formatting ─────────────────────────────────────────────────

/// 10 → "10", 7.5 → "7.5".
String wfNum(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

/// 1250 → "1,250".
String wfThousands(int v) => v.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );

// ── Stat tiles ────────────────────────────────────────────────────────

/// Bordered tile: icon top-left, big value, muted label.
class WfStatTile extends StatelessWidget {
  const WfStatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor = WfPalette.text,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: [
              Icon(icon, size: 16, color: WfPalette.orange),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10.5, color: WfPalette.muted)),
        ],
      ),
    );
  }
}

/// Two-column grid of [WfStatTile]s (odd count leaves the last cell empty).
class WfStatGrid extends StatelessWidget {
  const WfStatGrid({super.key, required this.tiles});
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < tiles.length ? 10 : 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tiles[i]),
                const SizedBox(width: 10),
                Expanded(child: i + 1 < tiles.length ? tiles[i + 1] : const SizedBox()),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

// ── Dashed empty-state box ────────────────────────────────────────────

class WfDashedBox extends StatelessWidget {
  const WfDashedBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: WfPalette.fillSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WfPalette.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)),
      );
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
        d += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Progress bar + labelled value ─────────────────────────────────────

class WfProgressBar extends StatelessWidget {
  const WfProgressBar({super.key, required this.value, this.color = WfPalette.orange});

  /// 0..1
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: 6,
        backgroundColor: WfPalette.fill,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

/// Tiny uppercase label above a value ("TARGET" / "10").
class WfLabeledValue extends StatelessWidget {
  const WfLabeledValue(this.label, this.value, {super.key, this.valueColor = WfPalette.text});
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 8.5,
            letterSpacing: 0.4,
            color: WfPalette.muted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }
}
