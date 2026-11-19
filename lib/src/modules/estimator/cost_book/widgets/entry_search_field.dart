import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'cost_book_palette.dart';

/// Search box under "Entries". Local stand-in for the shared search field.
class EntrySearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EntrySearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12, color: CostBookPalette.ink),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search by code or description...',
        hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
        prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CostBookPalette.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryOrange),
        ),
      ),
    );
  }
}
