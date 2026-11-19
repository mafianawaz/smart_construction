import 'package:flutter/material.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/field_ops_models.dart';
import '../../../widgets/project_badge.dart';

/// One row on the Punch List: number + title, a three-dot menu, and the
/// status / priority / trade badges. Tap opens the detail screen.
class PunchItemTile extends StatelessWidget {
  final PunchItemModel item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PunchItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.number} - ${item.title}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      if (item.location != null) ...[
                        const SizedBox(height: 3),
                        Text(item.location!,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ProjectBadge(
                              label: item.status.label,
                              background: item.status.background,
                              foreground: item.status.foreground),
                          ProjectBadge(
                              label: item.priority.label,
                              background: item.priority.background,
                              foreground: item.priority.foreground),
                          ProjectBadge(
                              label: item.trade.label,
                              background: Colors.grey.shade100,
                              foreground: Colors.grey.shade700),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert, size: 18, color: Colors.grey.shade600),
                  onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
