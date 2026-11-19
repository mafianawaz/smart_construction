import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'detail_card.dart';

class AutoChangeOrdersCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final TextEditingController thresholdController;
  final VoidCallback onSave;

  const AutoChangeOrdersCard({
    super.key,
    required this.enabled,
    required this.onToggle,
    required this.thresholdController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Auto Change Orders from Plan Revisions',
      subtitle: 'Automatically generate draft change orders when takeoff '
          'sheets are superseded with quantity/cost changes.',
      children: [
        Divider(color: AppColors.fieldBorder,),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Enable Auto-Generation',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Switch(
              value: enabled,
              activeColor: AppColors.primaryOrange,
              onChanged: onToggle,
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(color: AppColors.fieldBorder,),
        const SizedBox(height: 10),
        const Text('Cost Threshold (\$)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Minimum absolute cost delta to trigger a change order. Set to '
            '0 to always create.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: '0.00',
                controller: thresholdController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: AppColors.fieldBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }
}
