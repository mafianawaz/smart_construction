import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class CustomToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CustomToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.background
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}