import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../data/projects_mock_data.dart';
import 'detail_card.dart';

class CertifiedPayrollCard extends StatelessWidget {
  final String variant;
  final ValueChanged<String?> onChanged;

  const CertifiedPayrollCard({super.key, required this.variant, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Certified Payroll Form',
      subtitle: 'The default form used when generating certified payroll '
          'for this project. Choose the federal WH-347 or the appropriate '
          'state DOT variant.',
      children: [
        const Text('Form Variant', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        CustomDropdown<String>(
          value: variant,
          items: ProjectsMockData.payrollFormVariants,
          itemLabel: (item) => item,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
