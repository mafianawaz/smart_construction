import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'crew_palette.dart';

/// "Workers" / "Equipment" block in the form: title + small outlined add
/// button, then either the muted empty box or the supplied rows.
class CrewLineSection extends StatelessWidget {
  final String title;
  final String addLabel;
  final String emptyMessage;
  final VoidCallback onAdd;
  final List<Widget> rows;

  const CrewLineSection({
    super.key,
    required this.title,
    required this.addLabel,
    required this.emptyMessage,
    required this.onAdd,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: CrewPalette.ink,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: onAdd,
              style: OutlinedButton.styleFrom(
                foregroundColor: CrewPalette.ink,
                side: const BorderSide(color: CrewPalette.cardBorder),
                minimumSize: const Size(0, 28),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                addLabel,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (rows.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: CrewPalette.iconBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CrewPalette.cardBorder),
            ),
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          )
        else
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            rows[i],
          ],
      ],
    );
  }
}

/// One added worker/equipment row: title, subtitle, cost and a remove icon.
class CrewLineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String cost;
  final VoidCallback onRemove;

  const CrewLineTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CrewPalette.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: CrewPalette.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            cost,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryOrange,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close_rounded,
              size: 16,
              color: CrewPalette.danger,
            ),
          ),
        ],
      ),
    );
  }
}
