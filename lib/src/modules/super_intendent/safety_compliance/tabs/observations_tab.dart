import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/observation_card.dart';
import '../widgets/safety_common_widgets.dart';
import '../widgets/safety_palette.dart';

/// Observations tab: header with "+ New Observation", then the list.
class SafetyObservationsTab extends StatelessWidget {
  final SafetyLogic logic;
  final VoidCallback onNewObservation;

  const SafetyObservationsTab({
    super.key,
    required this.logic,
    required this.onNewObservation,
  });

  @override
  Widget build(BuildContext context) {
    final items = logic.observations;
    return ListView(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Safety Observations',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SafetyPalette.textDark,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onNewObservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: SafetyPalette.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('+ New Observation'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (items.isEmpty)
          const SafetyEmptyBox(message: 'No observations recorded yet.')
        else
          for (var i = 0; i < items.length; i++) ...[
            ObservationCard(
              observation: items[i],
              onClose: () => logic.closeObservation(items[i].id),
            ),
            if (i != items.length - 1) const SizedBox(height: 12),
          ],
      ],
    );
  }
}
