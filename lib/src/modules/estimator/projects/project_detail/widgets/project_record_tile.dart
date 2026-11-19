import 'package:flutter/material.dart';

/// Generic record row for the document tabs (RFIs, Transmittals,
/// Submittals, Warranty cases): "NUMBER - title", optional muted lines
/// and a wrap of badges. The references only show empty states for these
/// lists, so the populated layout mirrors the Punch List tile.
class ProjectRecordTile extends StatelessWidget {
  final String title;
  final List<String> lines;
  final List<Widget> badges;
  final VoidCallback? onTap;

  const ProjectRecordTile({
    super.key,
    required this.title,
    this.lines = const [],
    this.badges = const [],
    this.onTap,
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
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                for (final l in lines) ...[
                  const SizedBox(height: 3),
                  Text(l, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
                if (badges.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 6, children: badges),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
