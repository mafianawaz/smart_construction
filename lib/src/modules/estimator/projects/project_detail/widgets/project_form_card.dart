import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// White bordered card that groups form fields (the Create New Scope
/// Items / Record Usage / Add Location / line-item cards). Optional bold
/// [title] for sections such as "Labour".
class ProjectFormCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  const ProjectFormCard({
    super.key,
    this.title,
    required this.children,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }
}

/// Vertical gap between form fields.
const SizedBox projectFieldGap = SizedBox(height: 12);
