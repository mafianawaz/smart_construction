import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/app_empty_filter.dart';
import 'logic.dart';
import 'widgets/shared_document_tile.dart';


/// "Shared Documents" — plans/drawings/charts shared by the contractor.
/// Matches reference Section 14.
class SharedDocumentsView extends StatelessWidget {
  const SharedDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(SharedDocumentsLogic(), tag: 'shared_documents');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Shared Documents',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('View documents shared by your contractor (read-only)',style: TextStyle(fontSize: 12,color: AppColors.textMuted),),
            SizedBox(height: 15,),
            if (!logic.hasDocuments)
              const AppEmptyState(
                icon: Icons.folder_shared_outlined,
                title: 'No documents shared yet',
                message:
                    'Documents will appear here once your contractor '
                    'shares them with you.',
                showButton: false,
              )
            else
              ...logic.documents.map(
                (doc) => SharedDocumentTile(
                  document: doc,
                  onDownload: () => logic.downloadDocument(doc),
                  onOpen: () => logic.openDocument(doc),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
