import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rate_value_column.dart';

/// One employee row: name, email, role tag on the left, REG/OT on the right.
/// Rows are stacked inside a single `RatesCardShell` with dividers.
class EmployeeRateTile extends StatelessWidget {
  final EmployeeRateModel employee;

  const EmployeeRateTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: LaborRatesPalette.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                employee.email,
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              LaborTag(
                label: employee.role.tag,
                foreground: employee.role.foreground,
                background: employee.role.background,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        RateValueColumn(
          regularRate: employee.regularRate,
          overtimeRate: employee.overtimeRate,
        ),
      ],
    );
  }
}
