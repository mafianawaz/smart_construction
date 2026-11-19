import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// One entry in [TaskStatusFilterBar] — a label plus the count shown in
/// parentheses.
class TaskStatusFilterOption {
  final String label;
  final int count;

  const TaskStatusFilterOption({required this.label, required this.count});
}

/// Horizontal, scrollable chip row for filtering the task list by
/// status. Takes a flat list of options so the number/order of filters
/// isn't hard-coded.
class TaskStatusFilterBar extends StatelessWidget {
  final List<TaskStatusFilterOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TaskStatusFilterBar({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedIndex == i ? AppColors.primaryOrange : const Color(0xFFF6F7F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${options[i].label} (${options[i].count})',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selectedIndex == i ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}