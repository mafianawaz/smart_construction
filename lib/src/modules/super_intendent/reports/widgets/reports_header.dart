import 'package:flutter/material.dart';

import 'reports_palette.dart';

class ReportsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onAction;
  final IconData actionIcon;

  const ReportsHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onAction,
    this.actionIcon = Icons.save_alt_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ReportsPalette.card,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: ReportsPalette.fieldFill,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: ReportsPalette.textDark),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ReportsPalette.textDark,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: onAction == null
                ? null
                : InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ReportsPalette.fieldFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(actionIcon,
                          size: 18, color: ReportsPalette.textDark),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
