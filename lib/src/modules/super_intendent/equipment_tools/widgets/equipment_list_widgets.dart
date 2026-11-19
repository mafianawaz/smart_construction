import 'package:flutter/material.dart';
import '../data/equipment_format.dart';
import '../models/equipment_models.dart';
import 'equipment_palette.dart';

/// Search box with leading magnifier.
class EquipmentSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EquipmentSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13, color: SuperInEquipmentPalette.textDark),
      decoration: InputDecoration(
        hintText: 'Search equipment by name, code...',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: SuperInEquipmentPalette.textFaint,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: SuperInEquipmentPalette.textFaint,
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SuperInEquipmentPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SuperInEquipmentPalette.orange),
        ),
      ),
    );
  }
}

/// "All Status v" style pill that opens a menu. Index 0 is the "All" option.
class EquipmentFilterPill extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const EquipmentFilterPill({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => [
        for (var i = 0; i < options.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Text(
              options[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    i == selectedIndex ? FontWeight.w700 : FontWeight.w500,
                color: i == selectedIndex
                    ? SuperInEquipmentPalette.orange
                    : SuperInEquipmentPalette.textDark,
              ),
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedIndex == 0
                ? SuperInEquipmentPalette.border
                : SuperInEquipmentPalette.orange,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              options[selectedIndex],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SuperInEquipmentPalette.textDark,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: SuperInEquipmentPalette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

enum EquipmentMenuAction {
  viewDetails,
  markAvailable,
  markAssigned,
  markInRepair,
  delete,
}

/// One equipment row: type icon, name, "code · make model", tags, hours, menu.
class EquipmentCard extends StatelessWidget {
  final EquipmentItem item;
  final VoidCallback onTap;
  final ValueChanged<EquipmentMenuAction> onAction;

  const EquipmentCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: SuperInEquipmentPalette.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: SuperInEquipmentPalette.orangeSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.type.icon,
                    size: 22,
                    color: SuperInEquipmentPalette.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: SuperInEquipmentPalette.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: SuperInEquipmentPalette.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _Tag(
                            label: item.type.label,
                            background: SuperInEquipmentPalette.chipGrey,
                            foreground: SuperInEquipmentPalette.textDark,
                          ),
                          _Tag(
                            label: item.status.label,
                            background:
                            SuperInEquipmentPalette.statusSoft(item.status),
                            foreground:
                            SuperInEquipmentPalette.statusText(item.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        EquipmentFormat.hours(item.hours),
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: SuperInEquipmentPalette.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
                _CardMenu(status: item.status, onAction: onAction),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _CardMenu extends StatelessWidget {
  final EquipmentStatus status;
  final ValueChanged<EquipmentMenuAction> onAction;

  const _CardMenu({required this.status, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<EquipmentMenuAction>(
      onSelected: onAction,
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(
        Icons.more_horiz,
        size: 20,
        color: SuperInEquipmentPalette.textMuted,
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: EquipmentMenuAction.viewDetails,
          child: Text('View details'),
        ),
        if (status != EquipmentStatus.available)
          const PopupMenuItem(
            value: EquipmentMenuAction.markAvailable,
            child: Text('Mark available'),
          ),
        if (status != EquipmentStatus.assigned)
          const PopupMenuItem(
            value: EquipmentMenuAction.markAssigned,
            child: Text('Mark assigned'),
          ),
        if (status != EquipmentStatus.inRepair)
          const PopupMenuItem(
            value: EquipmentMenuAction.markInRepair,
            child: Text('Mark in repair'),
          ),
        const PopupMenuItem(
          value: EquipmentMenuAction.delete,
          child: Text(
            'Delete',
            style: TextStyle(color: SuperInEquipmentPalette.red),
          ),
        ),
      ],
    );
  }
}

/// Shown when the list (or the filtered list) is empty.
class EquipmentEmptyState extends StatelessWidget {
  final String message;

  const EquipmentEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 34,
            color: SuperInEquipmentPalette.textFaint,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: SuperInEquipmentPalette.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}
