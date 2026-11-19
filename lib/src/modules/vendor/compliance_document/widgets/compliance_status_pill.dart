import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/compliance_document_model.dart';

/// Dot-prefixed status pill, following the same pattern as Purchase Orders'
/// `PoStatusPill` / Enrolled Clients' `_StatusDotPill` — `PillChip` has no
/// icon/dot slot so this stays a standalone widget rather than a variant.
class ComplianceStatusPill extends StatelessWidget {
  final ComplianceDocStatus status;

  const ComplianceStatusPill({super.key, required this.status});

  Color get _color {
    switch (status) {
      case ComplianceDocStatus.active:
      case ComplianceDocStatus.valid:
        return AppColors.statusChip;
      case ComplianceDocStatus.notUploaded:
      case ComplianceDocStatus.expired:
        return AppColors.redColor;
      case ComplianceDocStatus.delayed:
        return AppColors.primaryOrangeDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         SvgPicture.asset(
             status.label == 'Valid'
             ? AppIcons.tickCircle
             : AppIcons.danger,
         color: status.label == 'Valid' ? Colors.green : Colors.red,
         height: 13),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
