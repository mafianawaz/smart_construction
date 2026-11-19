import 'package:flutter/material.dart';

import '../../../../widgets/app_empty_filter.dart';


/// Placeholder for tabs that exist in the pill row but have no reference
/// screen yet (Salary Categories, Bucket Rates).
class ComingSoonTab extends StatelessWidget {
  final String tabLabel;

  const ComingSoonTab({super.key, required this.tabLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        icon: Icons.construction_rounded,
        title: tabLabel,
        message: 'This section has no design yet.',
      ),
    );
  }
}
