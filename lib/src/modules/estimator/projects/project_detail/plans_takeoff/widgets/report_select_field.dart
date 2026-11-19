import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Tappable "# Takeoff Quantity" select on the Reports tab. Opens a
/// bottom sheet of [options]; with none yet it says so. Local rather than
/// `CustomDropdown` because that widget's behavior with an empty item
/// list is unverified — flagged in NOTES_PROJECT_TABS.md.
class ReportSelectField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const ReportSelectField({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        if (options.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(28),
            child: Text(
              'No options available for this report yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          );
        }
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final o in options)
                ListTile(
                  title: Text(o, style: const TextStyle(fontSize: 13)),
                  trailing: o == value
                      ? Icon(Icons.check, color: AppColors.primaryOrange, size: 18)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(o),
                ),
            ],
          ),
        );
      },
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _open(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text('#',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primaryOrange)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                hasValue ? value! : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, color: hasValue ? Colors.black87 : Colors.grey.shade500),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
