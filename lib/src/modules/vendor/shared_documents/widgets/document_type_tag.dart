import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// Small muted tag used for a document's category ("OTHER") and format
/// ("PDF"). Not built on `PillChip`, since `PillChip`'s fixed `fontSize: 11`
/// and single-color styling reads larger/bolder than these compact tags in
/// the reference.
class DocumentTypeTag extends StatelessWidget {
  final String label;
  final Color color;

  const DocumentTypeTag({super.key, required this.label, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
