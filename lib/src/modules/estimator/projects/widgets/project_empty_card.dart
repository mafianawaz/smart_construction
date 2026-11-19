import 'package:flutter/material.dart';

/// Bordered card with a grey icon circle and one muted line — the empty
/// state used across the project tabs' reference screens ("No delays
/// reported for this project yet.", "No data to display", ...).
///
/// Optional [title] renders a bold heading above [message] ("No Reports
/// Yet" + hint). [bordered] = false drops the card chrome so it can sit
/// inside a `PanelCard`.
class ProjectEmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? title;
  final bool bordered;

  const ProjectEmptyCard({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.bordered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: bordered
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, size: 20, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          if (title != null) ...[
            Text(title!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: title == null ? 12 : 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
