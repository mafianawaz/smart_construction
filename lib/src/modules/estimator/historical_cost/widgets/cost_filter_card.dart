import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';
import 'cost_colors.dart';
import 'cost_date_field.dart';
import 'cost_filter_dropdown.dart';

/// "Filter Cost Records" card shared by the Summary and Detailed tabs.
class CostFilterCard extends StatelessWidget {
  final HistoricalCostLogic logic;
  const CostFilterCard({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CostColors.border),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Filter Cost Records',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                if (logic.hasActiveFilters)
                  GestureDetector(
                    onTap: logic.clearFilters,
                    child: const Text('Clear',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _SearchField(onChanged: (v) => logic.searchQuery.value = v),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: CostFilterDropdown(
                  allLabel: 'All Trades',
                  value: logic.selectedTrade.value,
                  options: logic.trades,
                  onChanged: (v) => logic.selectedTrade.value = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CostFilterDropdown(
                  allLabel: 'All Categories',
                  value: logic.selectedCategory.value,
                  options: logic.categories,
                  onChanged: (v) => logic.selectedCategory.value = v,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: CostFilterDropdown(
                  allLabel: 'All Codes',
                  value: logic.selectedCode.value,
                  options: logic.codes,
                  onChanged: (v) => logic.selectedCode.value = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProjectTypeField(
                  onChanged: (v) => logic.projectTypeQuery.value = v,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: CostDateField(
                  value: logic.dateFrom.value,
                  onTap: () => logic.pickDate(isFrom: true),
                  onClear: () => logic.dateFrom.value = null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CostDateField(
                  value: logic.dateTo.value,
                  onTap: () => logic.pickDate(isFrom: false),
                  onClear: () => logic.dateTo.value = null,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search discriptions...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CostColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryOrange),
          ),
        ),
      ),
    );
  }
}

class _ProjectTypeField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _ProjectTypeField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'e.g., Commercial',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: CostColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryOrange),
          ),
        ),
      ),
    );
  }
}
