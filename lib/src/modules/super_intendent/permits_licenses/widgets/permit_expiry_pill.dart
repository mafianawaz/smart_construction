import 'package:flutter/material.dart';

import '../models/permit_models.dart';
import 'permits_palette.dart';

/// Coloured "5 days" pill; colour is driven by [PermitModel.urgency].
class PermitExpiryPill extends StatelessWidget {
  final PermitModel permit;

  const PermitExpiryPill({super.key, required this.permit});

  @override
  Widget build(BuildContext context) {
    final c = PermitsPalette.urgency(permit.urgency());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        permit.daysLabel(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: c.fg,
        ),
      ),
    );
  }
}
