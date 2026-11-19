import 'package:flutter/material.dart';

import 'dispatch_palette.dart';

/// Display data for one row of the assignments list.
class AssignmentRowData {
  final Color color;
  final String crewName;
  final String projectName;
  final VoidCallback onTap;

  const AssignmentRowData({
    required this.color,
    required this.crewName,
    required this.projectName,
    required this.onTap,
  });
}

/// "Today's Assignments" card: coloured dot, crew name, "-> project".
/// Tapping a row re-opens the Assign Crew sheet for that crew.
class AssignmentsCard extends StatelessWidget {
  final String title;
  final List<AssignmentRowData> rows;

  const AssignmentsCard({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fill + shadow live on the same box so the shadow never tints the card.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: DispatchPalette.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: DispatchPalette.textDark,
                ),
              ),
            ),
            if (rows.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 22),
                child: Center(
                  child: Text(
                    'No crews assigned for this date.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: DispatchPalette.textFaint,
                    ),
                  ),
                ),
              )
            else
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: DispatchPalette.border),
                _AssignmentRow(data: rows[i]),
              ],
            if (rows.isNotEmpty) const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  final AssignmentRowData data;

  const _AssignmentRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: data.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 4,
              child: Text(
                data.crewName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DispatchPalette.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_right_alt,
                      size: 16,
                      color: DispatchPalette.textMuted,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        data.projectName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: DispatchPalette.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
