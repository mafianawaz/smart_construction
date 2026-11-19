import 'package:flutter/material.dart';

import 'crm_palette.dart';

/// Small grey tag ("Subcontractor", "Owner Rep" ...) used on cards.
class CrmTag extends StatelessWidget {
  final String label;

  const CrmTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CrmPalette.chipFill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: CrmPalette.text,
        ),
      ),
    );
  }
}

/// Solid rounded badge ("Vendor" in the sheet, "Primary" on contacts).
class CrmBadge extends StatelessWidget {
  final String label;
  final Color color;

  const CrmBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Compact button used for View / Edit / Delete / Add Opportunity.
class CrmSmallButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  /// Filled buttons use [color] as background with white text; outlined ones
  /// use a white background with dark text.
  final bool filled;
  final Color color;

  const CrmSmallButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.filled = false,
    this.color = CrmPalette.orange,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : CrmPalette.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? color : CrmPalette.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: filled ? color : CrmPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: foreground),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small two-option segmented control (Board | List).
class CrmSegmented extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CrmSegmented({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: CrmPalette.chipFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < options.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? CrmPalette.orange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: i == selectedIndex
                        ? Colors.white
                        : CrmPalette.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// "All Stages ⌄" style filter pill backed by a popup menu.
///
/// Index 0 in the menu is always the "all" entry (value `null`); the rest are
/// [options]. Reports `null` for "all".
class CrmDropdownPill<T> extends StatelessWidget {
  final String allLabel;
  final List<T> options;
  final String Function(T) labelOf;
  final T? value;
  final ValueChanged<T?> onChanged;

  /// Smaller height / padding / font for tight filter rows.
  final bool compact;

  const CrmDropdownPill({
    super.key,
    required this.allLabel,
    required this.options,
    required this.labelOf,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final current = value == null ? allLabel : labelOf(value as T);
    return PopupMenuButton<int>(
      onSelected: (index) => onChanged(index == 0 ? null : options[index - 1]),
      color: CrmPalette.surface,
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text(allLabel, style: const TextStyle(fontSize: 13)),
        ),
        for (var i = 0; i < options.length; i++)
          PopupMenuItem<int>(
            value: i + 1,
            child: Text(labelOf(options[i]), style: const TextStyle(fontSize: 13)),
          ),
      ],
      child: Container(
        height: compact ? 36 : 38,
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
        decoration: BoxDecoration(
          color: CrmPalette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CrmPalette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                current,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 11 : 12,
                  color: CrmPalette.text,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: compact ? 16 : 18,
              color: CrmPalette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Centred empty / "coming soon" panel.
class CrmEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const CrmEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: CrmPalette.textFaint),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: CrmPalette.textMuted),
          ),
        ],
      ),
    );
  }
}
