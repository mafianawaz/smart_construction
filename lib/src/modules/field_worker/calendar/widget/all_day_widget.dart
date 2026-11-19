import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

class AllDayToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AllDayToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius:
      BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (value) {
                onChanged(value ?? false);
              },
              activeColor:
              AppColors.primaryOrange,
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(4),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'All Day Event',
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}