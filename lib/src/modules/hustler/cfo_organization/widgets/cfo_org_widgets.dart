import 'package:flutter/material.dart';

import 'cfo_org_palette.dart';

/// Rounded white card with a hairline border.
class CfoOrgCard extends StatelessWidget {
  const CfoOrgCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderColor = CfoOrgPalette.border,
    this.fill = CfoOrgPalette.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class CfoOrgSectionTitle extends StatelessWidget {
  const CfoOrgSectionTitle(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CfoOrgPalette.text,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Back-arrow circle + centered title used by the pushed screens.
class CfoOrgHeaderBar extends StatelessWidget {
  const CfoOrgHeaderBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: CfoOrgPalette.border),
                ),
                child: const Icon(Icons.chevron_left,
                    size: 20, color: CfoOrgPalette.text),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: CfoOrgPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

class CfoOrgPrimaryButton extends StatelessWidget {
  const CfoOrgPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.height = 44,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CfoOrgPalette.orange,
          disabledBackgroundColor: CfoOrgPalette.orange.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CfoOrgOutlineButton extends StatelessWidget {
  const CfoOrgOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: CfoOrgPalette.orange,
        side: const BorderSide(color: CfoOrgPalette.orange),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13),
            const SizedBox(width: 6),
          ],
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Small coloured pill (status badges, org type tags).
class CfoOrgPill extends StatelessWidget {
  const CfoOrgPill({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.fontSize = 9,
    this.letterSpacing = 0.3,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final Color background;
  final double fontSize;
  final double letterSpacing;

  /// Optional hairline outline (e.g. the outlined VENDOR role pill).
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: foreground,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}

/// Label-on-top / big-value tile used in the Portfolio Summary grid.
class CfoOrgSummaryTile extends StatelessWidget {
  const CfoOrgSummaryTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: CfoOrgPalette.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: CfoOrgPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Value / title / subtitle tile used in the organization KPI grid.
class CfoOrgKpiTile extends StatelessWidget {
  const CfoOrgKpiTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final String value;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CfoOrgPalette.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: CfoOrgPalette.text)),
          Text(subtitle,
              style: const TextStyle(fontSize: 9, color: CfoOrgPalette.muted)),
        ],
      ),
    );
  }
}

/// Two-column grid built from rows (avoids nested scrollables / fixed ratios).
class CfoOrgTwoColumnGrid extends StatelessWidget {
  const CfoOrgTwoColumnGrid({super.key, required this.children, this.gap = 8});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final second = i + 1 < children.length ? children[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              SizedBox(width: gap),
              Expanded(child: second ?? const SizedBox.shrink()),
            ],
          ),
        ),
      );
      if (i + 2 < children.length) rows.add(SizedBox(height: gap));
    }
    return Column(children: rows);
  }
}

class CfoOrgEmptyState extends StatelessWidget {
  const CfoOrgEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: CfoOrgPalette.fieldFill,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: CfoOrgPalette.muted),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 11, color: CfoOrgPalette.muted, height: 1.4),
        ),
      ],
    );
  }
}

class CfoOrgField extends StatelessWidget {
  const CfoOrgField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.autofocus = false,
    this.maxLines = 1,
    this.neutralBorder = false,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool autofocus;

  /// 1 = single line. Greater values let the field grow up to that many lines.
  final int maxLines;

  /// Grey hairline instead of the orange emphasis border (optional fields).
  final bool neutralBorder;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: CfoOrgPalette.text)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          autofocus: autofocus,
          minLines: 1,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 12, color: CfoOrgPalette.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(fontSize: 12, color: CfoOrgPalette.muted),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                  color: hasError
                      ? CfoOrgPalette.red
                      : (neutralBorder
                          ? CfoOrgPalette.border
                          : CfoOrgPalette.orange)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                  color: hasError ? CfoOrgPalette.red : CfoOrgPalette.orange,
                  width: 1.4),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!,
              style: const TextStyle(fontSize: 10, color: CfoOrgPalette.red)),
        ],
      ],
    );
  }
}

class CfoOrgDropdownField<T> extends StatelessWidget {
  const CfoOrgDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: CfoOrgPalette.text)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: CfoOrgPalette.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: CfoOrgPalette.muted),
              style: const TextStyle(fontSize: 12, color: CfoOrgPalette.muted),
              items: [
                for (final item in items)
                  DropdownMenuItem<T>(value: item, child: Text(labelOf(item))),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Coming soon" panel for tabs the reference doesn't show.
class CfoOrgComingSoon extends StatelessWidget {
  const CfoOrgComingSoon({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: CfoOrgEmptyState(
        icon: Icons.hourglass_empty,
        message: '$title is coming soon.',
      ),
    );
  }
}
