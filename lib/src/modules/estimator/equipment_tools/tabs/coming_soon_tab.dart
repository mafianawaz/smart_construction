import 'package:flutter/material.dart';

import '../widgets/equipment_history_card.dart';

/// Placeholder body for tabs whose design wasn't in the reference
/// (Preventative Maintenance, Documents). Reuses the empty history card.
class ComingSoonTab extends StatelessWidget {
  const ComingSoonTab({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return EquipmentHistoryCard(title: title, emptyMessage: message);
  }
}
