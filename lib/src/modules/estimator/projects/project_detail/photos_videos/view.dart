import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/project_empty_card.dart';
import '../widgets/project_action_button.dart';

/// Photos & Videos tab — orange "+ Upload" button over an empty card.
/// There is no media model yet (the reference only shows the empty state)
/// and no file-picker package is confirmed, so Upload shows a snackbar —
/// see NOTES_PUNCH_FIELD_OPS.md.
class PhotosVideosView extends StatelessWidget {
  final String projectId;
  const PhotosVideosView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        children: [
          ProjectActionButton(
            label: 'Upload',
            icon: Icons.add,
            // API: POST /projects/{id}/media (multipart)
            onPressed: () =>
                Get.snackbar('Upload', 'Photo and video upload is not wired up yet.'),
          ),
          const SizedBox(height: 12),
          const ProjectEmptyCard(
            icon: Icons.photo_library_outlined,
            message: 'No media uploaded yet.',
          ),
        ],
      ),
    );
  }
}
