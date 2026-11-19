import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/safety_models.dart';
import 'safety_palette.dart';

/// White rounded card with the soft shadow used across the hub.
class SafetyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SafetyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SafetyPalette.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: SafetyPalette.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: SafetyPalette.cardShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Bold section title with an optional muted subtitle.
class SafetySectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SafetySectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SafetyPalette.textDark,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 11.5,
              color: SafetyPalette.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// Lays children out two per row with equal heights per row.
class SafetyTwoColumnGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const SafetyTwoColumnGrid({
    super.key,
    required this.children,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final hasSecond = i + 1 < children.length;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              SizedBox(width: spacing),
              Expanded(child: hasSecond ? children[i + 1] : const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < children.length) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }
}

/// Dashboard stat card: icon, big value, label and optional coloured sub-label.
class SafetyIndicatorCard extends StatelessWidget {
  final SafetyIndicatorData data;

  const SafetyIndicatorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafetyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: SafetyPalette.orangeSoft,
              shape: BoxShape.circle,
            ),
            child: Center(child: SvgPicture.asset(data.icon, height: 18, color: SafetyPalette.orange)),
          ),
          const SizedBox(height: 10),
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SafetyPalette.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 11,
              height: 1.3,
              color: SafetyPalette.textMuted,
            ),
          ),
          if (data.subLabel != null) ...[
            const SizedBox(height: 3),
            Text(
              data.subLabel!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: SafetyPalette.toneColor(data.subTone),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Solid little tag: AT_RISK, OPEN, MEDIUM...
class SafetyTag extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const SafetyTag({
    super.key,
    required this.label,
    required this.background,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: foreground,
        ),
      ),
    );
  }
}

/// Soft rounded pill for module chips and OSHA classifications.
class SafetyTonePill extends StatelessWidget {
  final String label;
  final SafetyTone tone;
  final IconData? icon;

  const SafetyTonePill({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = SafetyPalette.toneColor(tone);
    final textColor = tone == SafetyTone.neutral
        ? SafetyPalette.textDark
        : tone == SafetyTone.warning
            ? const Color(0xFFB45309)
            : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: SafetyPalette.toneSoft(tone),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey inbox box shown when a list is empty.
class SafetyEmptyBox extends StatelessWidget {
  final String message;
  final IconData icon;

  const SafetyEmptyBox({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: SafetyPalette.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: SafetyPalette.textFaint),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: SafetyPalette.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}
