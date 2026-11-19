import 'package:flutter/material.dart';
import '../data/safety_format.dart';
import '../models/safety_models.dart';
import 'safety_common_widgets.dart';
import 'safety_palette.dart';

/// One safety observation. Red edge for at-risk, green for safe.
class ObservationCard extends StatelessWidget {
  final SafetyObservation observation;
  final VoidCallback? onClose;

  const ObservationCard({
    super.key,
    required this.observation,
    this.onClose,
  });

  Color get _edgeColor => observation.type == ObservationType.atRisk
      ? SafetyPalette.red
      : SafetyPalette.green;

  Color get _severityColor {
    switch (observation.severity) {
      case ObservationSeverity.low:
        return SafetyPalette.green;
      case ObservationSeverity.medium:
        return SafetyPalette.amber;
      case ObservationSeverity.high:
        return SafetyPalette.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = observation;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: SafetyPalette.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: _edgeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            SafetyFormat.date(o.date),
                            style: const TextStyle(
                              fontSize: 10,
                              color: SafetyPalette.textFaint,
                            ),
                          ),
                          const Spacer(),
                          SafetyTag(label: o.type.label, background: _edgeColor),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        o.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: SafetyPalette.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SafetyTag(
                        label: o.severity.label,
                        background: _severityColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        o.description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: SafetyPalette.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Observer: ${o.observer}',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: SafetyPalette.textFaint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SafetyTag(
                            label: o.status.label,
                            background: o.isOpen
                                ? SafetyPalette.green
                                : SafetyPalette.textFaint,
                          ),
                          const Spacer(),
                          if (o.isOpen && onClose != null)
                            _CloseButton(onTap: onClose!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: SafetyPalette.surfaceMuted,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: SafetyPalette.border),
        ),
        child: const Text(
          'Close',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: SafetyPalette.textDark,
          ),
        ),
      ),
    );
  }
}
