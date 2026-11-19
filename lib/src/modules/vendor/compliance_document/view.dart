import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import 'document_details/view.dart';
import 'logic.dart';
import 'widgets/compliance_upload_card.dart';
import 'widgets/document_history_tile.dart';


/// "Compliance Documents" — required uploads (Certification of Insurance,
/// W-9) plus a scrollable Document History list. Matches the reference
/// design's Section 15, frames 1 & 2.
class ComplianceDocumentsView extends StatelessWidget {
  const ComplianceDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ComplianceLogic(), tag: 'compliance');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Compliance Documents',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Upload and manage your insurance certificates, W-'
              '9s, and other compliance documents required by '
              'contractors',style: TextStyle(fontSize: 12,color: AppColors.textMuted),),
            SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  child: ComplianceCard(
                    icon: AppIcons.safety,
                    title: 'Certification of Insurance',
                    subtitle: 'Need Attention',
                    subtitleColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ComplianceCard(
                    icon: AppIcons.docs,
                    title: 'W-9 Form',
                    subtitle: 'Not Uploaded',
                    subtitleColor: Colors.purple,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Document History',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'All compliance documents you\u2019ve submitted to enterprise.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            if (!logic.hasHistory)
              const AppEmptyState(
                icon: Icons.folder_open_outlined,
                title: 'No compliance documents uploaded yet',
                message:
                    'Upload your COI, W-9 and any other documents required '
                    'by contractors.',
                showButton: false,
              )
            else
              ...logic.documentHistory.map(
                (doc) => DocumentHistoryTile(
                  document: doc,
                  onTap: () => Get.to(() => DocumentDetailsView(document: doc)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
