import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/compliance_document_model.dart';
import 'compliance_status_pill.dart';

/// One row in the Document History list — icon, title + code, uploaded/
/// expires date, and a trailing status pill. Tapping opens the details
/// screen (image 3 in the reference).
class DocumentHistoryTile extends StatelessWidget {
  final ComplianceDocumentModel document;
  final VoidCallback onTap;

  const DocumentHistoryTile({
    super.key,
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = document.status == ComplianceDocStatus.expired;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.docs,
                      color: Colors.white,
                      height: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.fileName ?? document.type.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            document.type.code,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          CircleAvatar(
                            radius: 2,
                            backgroundColor: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isExpired
                                ? 'Uploaded ${document.formattedUploadedDate}'
                                : 'Expires ${document.formattedExpirationDate}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.fieldBorder),
            const SizedBox(height: 8),
            Align(
                alignment: Alignment.topRight,
                child: ComplianceStatusPill(status: document.status)),

          ],
        ),
      ),
    );
  }
}
