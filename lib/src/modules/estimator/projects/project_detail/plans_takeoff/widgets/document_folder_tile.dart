import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../../../../utils/app_icons.dart';
import '../../../models/takeoff_models.dart';

/// One row of the Plans document tree: chevron, orange folder icon (or a
/// blue book for the Libraries entry), name, and a file-count badge.
/// Expanding shows the files, or "No files".
class DocumentFolderTile extends StatelessWidget {
  final DocumentFolderModel folder;
  final bool expanded;
  final VoidCallback onToggle;

  const DocumentFolderTile({
    super.key,
    required this.folder,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isLibrary = folder.kind == DocumentFolderKind.library;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.fieldBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  Icon(expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      size: 18, color: Colors.grey.shade700),
                  const SizedBox(width: 6),
                  SvgPicture.asset(
                    isLibrary ? AppIcons.assigned : AppIcons.projects,
                    height: 18,
                    color: isLibrary ? const Color(0xFF2B6CB0) : AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(folder.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  _CountBadge(count: folder.count),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 10, right: 4),
              child: folder.files.isEmpty
                  ? Text('No files',
                      style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final f in folder.files)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(Icons.insert_drive_file_outlined,
                                    size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(f.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11)),
                                ),
                                if (f.sizeLabel.isNotEmpty)
                                  Text(f.sizeLabel,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('$count',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
    );
  }
}
