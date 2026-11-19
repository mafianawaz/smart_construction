import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/app_color.dart';
import '../models/compliance_document_model.dart';
import 'compliance_status_pill.dart';

/// One of the two required-upload slots at the top of the Compliance
/// Documents screen (Certification of Insurance / W-9 Form). Shows an
/// "Upload" action when empty, or the status pill once uploaded.
class ComplianceCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color subtitleColor;

  const ComplianceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.subtitleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    color: Colors.white,
                    height: 18,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
