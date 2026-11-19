import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_color.dart';


/// Local literals for colours not (yet) in AppColors. Flagged in notes.
class MarketplacePalette {
  MarketplacePalette._();
  static const Color border = Color(0xFFE5E7EB);
  static const Color tagBg = Color(0xFFF1F2F4);
  static const Color tagText = Color(0xFF4B5563);
  static const Color pendingBg = Color(0xFFFEF3C7);
  static const Color pendingText = Color(0xFFB45309);
  static const Color approvedBg = Color(0xFFDCFCE7);
  static const Color approvedText = Color(0xFF15803D);
  static const Color declinedBg = Color(0xFFFEE2E2);
  static const Color declinedText = Color(0xFFB91C1C);
  static const Color star = Color(0xFFF59E0B);
}

/// Scrollable segmented bar. [filled] = orange track with white selected
/// segment (equipment sub-tabs); otherwise a light track with white selected
/// segment (main marketplace tabs).
class MarketplaceSegmentBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool filled;
  final bool scrollable;

  const MarketplaceSegmentBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.filled = false,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      for (var i = 0; i < labels.length; i++) _seg(i),
    ];
    final row = scrollable
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: items),
          )
        : Row(children: [for (final w in items) Expanded(child: w)]);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: filled ? AppColors.primaryOrange : AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: filled
            ? null
            : Border.all(color: MarketplacePalette.border),
      ),
      child: row,
    );
  }

  Widget _seg(int i) {
    final selected = i == selectedIndex;
    final unselectedText = filled ? Colors.white : AppColors.textMuted;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(i),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: scrollable ? 14 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          labels[i],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.black : unselectedText,
          ),
        ),
      ),
    );
  }
}

class MarketplaceInfoBanner extends StatelessWidget {
  final String text;
  const MarketplaceInfoBanner(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
      ),
    );
  }
}

/// White rounded card shell used by every list item.
class MarketplaceCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const MarketplaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MarketplacePalette.border),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MarketplaceTag extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? foreground;
  const MarketplaceTag(this.label, {super.key, this.background, this.foreground});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? MarketplacePalette.tagBg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: foreground ?? MarketplacePalette.tagText,
        ),
      ),
    );
  }
}

/// Orange "Connect →" / "Recruit →" style inline action.
class InlineActionLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const InlineActionLink(this.label, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange)),
          const SizedBox(width: 3),
          Icon(Icons.arrow_forward, size: 12, color: AppColors.primaryOrange),
        ],
      ),
    );
  }
}

/// Outlined search field with leading icon.
class MarketplaceSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final bool showIcon;
  const MarketplaceSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: _outlined(
        hint,
        prefix: showIcon
            ? Icon(Icons.search, size: 18, color: AppColors.textMuted)
            : null,
      ),
    );
  }
}

InputDecoration _outlined(String hint, {Widget? prefix, Widget? suffix}) {
  OutlineInputBorder b() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MarketplacePalette.border),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
    prefixIcon: prefix,
    suffixIcon: suffix,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: b(),
    border: b(),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primaryOrange),
    ),
  );
}

/// Plain text filter box (Location / Filter by skill / certifications).
class MarketplaceTextFilter extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  const MarketplaceTextFilter({
    super.key,
    required this.hint,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: _outlined(
        hint,
        prefix: icon == null
            ? null
            : Icon(icon, size: 16, color: AppColors.textMuted),
      ),
    );
  }
}

/// Dropdown rendered like a text field — used for form + filter grids.
class MarketplaceDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? hint;
  const MarketplaceDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final safe = items.contains(value) ? value : null;
    return DropdownButtonFormField<String>(
      value: safe,
      isExpanded: true,
      isDense: true,
      icon: Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
      decoration: _outlined(hint ?? ''),
      style: const TextStyle(fontSize: 13, color: Colors.black),
      hint: Text(hint ?? '',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
      items: [
        for (final i in items)
          DropdownMenuItem(
            value: i,
            child: Text(i, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

/// Compact pill dropdown for the horizontal filter row. Orange when active.
class FilterPillDropdown extends StatelessWidget {
  final String value;
  final String defaultValue;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const FilterPillDropdown({
    super.key,
    required this.value,
    required this.defaultValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active = value != defaultValue;
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 12, right: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryOrange : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: active ? AppColors.primaryOrange : MarketplacePalette.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 16, color: active ? Colors.white : Colors.black),
          dropdownColor: Colors.white,
          selectedItemBuilder: (_) => [
            for (final i in items)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(i,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : Colors.black)),
              ),
          ],
          items: [
            for (final i in items)
              DropdownMenuItem(
                value: i,
                child: Text(i, style: const TextStyle(fontSize: 13)),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

/// dd/mm/yyyy picker field.
class MarketplaceDateField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;
  const MarketplaceDateField({
    super.key,
    required this.value,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final text =
        value == null ? 'dd/mm/yyyy' : DateFormat('dd/MM/yyyy').format(value!);
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MarketplacePalette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 13,
                      color: value == null ? AppColors.textMuted : Colors.black)),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 15, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class ResultsHeading extends StatelessWidget {
  final String text;
  const ResultsHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      );
}

/// Orange-bordered primary button used where CustomButton's API is uncertain
/// to carry an icon. Prefer CustomButton for plain text buttons.
class MarketplacePrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  const MarketplacePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)],
            Text(label,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
