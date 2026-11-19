import 'package:flutter/material.dart';

import 'cs_palette.dart';

/// App bar: back arrow + centred title.
class CsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const CsHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: CsPalette.text),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CsPalette.text,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Rounded pill used for the section switcher and the sub-tabs.
class CsPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  /// Dimmed text/icon when unselected (sub-tab rows in the reference).
  final bool subtle;

  const CsPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.subtle = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected
        ? Colors.white
        : (subtle ? CsPalette.hint : CsPalette.text);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: icon == null ? 14 : 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected ? CsPalette.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? CsPalette.orange : CsPalette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Text tabs with an orange underline (Benchmarks | Cost Analytics).
class CsUnderlineTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CsUnderlineTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CsPalette.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(right: 22),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: i == selectedIndex
                          ? CsPalette.orange
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: i == selectedIndex
                        ? CsPalette.orange
                        : CsPalette.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stat tile. [centered] gives the lock-count look; default is left-aligned.
class CsStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? caption;
  final bool centered;

  const CsStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.caption,
    this.iconColor = CsPalette.orange,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: align,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (centered)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.1),
                border: Border.all(color: iconColor.withOpacity(0.35)),
              ),
              child: Icon(icon, size: 14, color: iconColor),
            )
          else
            Icon(icon, size: 18, color: iconColor),
          if (centered) ...[
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: CsPalette.muted),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: centered ? 20 : 18,
              fontWeight: FontWeight.w700,
              color: CsPalette.text,
            ),
          ),
          if (!centered) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: CsPalette.text,
              ),
            ),
          ],
          if (caption != null) ...[
            const SizedBox(height: 2),
            Text(
              caption!,
              style: const TextStyle(fontSize: 9, color: CsPalette.hint),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bordered empty-state card.
class CsEmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const CsEmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 34, color: CsPalette.hint),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: CsPalette.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: CsPalette.muted),
          ),
        ],
      ),
    );
  }
}

class CsSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const CsSearchField({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: CsPalette.hint),
        prefixIcon: const Icon(Icons.search, size: 16, color: CsPalette.hint),
        prefixIconConstraints: const BoxConstraints(minWidth: 34),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CsPalette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CsPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CsPalette.orange),
        ),
      ),
    );
  }
}

/// Dropdown-style filter pill (popup menu). [expand] fills its parent width.
class CsFilterPill extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final bool expand;

  const CsFilterPill({
    super.key,
    required this.value,
    required this.options,
    required this.onSelected,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      itemBuilder: (_) => [
        for (final o in options)
          PopupMenuItem<String>(
            value: o,
            child: Text(o, style: const TextStyle(fontSize: 12)),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CsPalette.border),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: CsPalette.text),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: CsPalette.muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small orange call-to-action ("+ Add Leave Type", "+ Lock Report").
class CsSmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CsSmallButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CsPalette.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Bottom-sheet chrome: drag handle, title, close button.
class CsSheetScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const CsSheetScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CsPalette.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CsPalette.text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.cancel_outlined,
                        size: 20,
                        color: CsPalette.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Labelled text input used inside the sheets.
class CsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;

  const CsField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: CsPalette.text),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            errorText: errorText,
            hintStyle: const TextStyle(fontSize: 12, color: CsPalette.hint),
            filled: true,
            fillColor: CsPalette.fieldFill,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CsPalette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CsPalette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: CsPalette.orange),
            ),
          ),
        ),
      ],
    );
  }
}

/// Cancel (outlined) + primary (orange) button pair for sheets.
class CsSheetActions extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;

  const CsSheetActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: CsPalette.muted,
            side: const BorderSide(color: CsPalette.border),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onPrimary,
          style: ElevatedButton.styleFrom(
            backgroundColor: CsPalette.orange,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            primaryLabel,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
