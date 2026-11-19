import 'package:flutter/material.dart';

import '../models/crm_activity_models.dart';
import 'crm_activity_style.dart';
import 'crm_palette.dart';

/// One logged call: bold date/time, then Direction / Outcome / Duration /
/// Number / Owner / Notes as label-value rows (reference screen 2).
class CallLogCard extends StatelessWidget {
  final CallLogModel call;

  const CallLogCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final isOut = call.direction == CallDirection.outbound;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            crmDateTime(call.dateTime),
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
          const SizedBox(height: 10),
          _Row(
            label: 'Direction',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _value(call.direction.label),
                const SizedBox(width: 6),
                Icon(
                  isOut ? Icons.phone_forwarded : Icons.phone_callback,
                  size: 14,
                  color: CrmPalette.textMuted,
                ),
              ],
            ),
          ),
          _Row(
            label: 'Outcome',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: call.outcome.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    call.outcome.label.toLowerCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _Row(label: 'Duration', child: _value(call.durationLabel)),
          _Row(label: 'Number', child: _value(call.number)),
          _Row(label: 'Owner', child: _value(call.owner)),
          _Row(
            label: 'Notes',
            child: _value(call.notes.isEmpty ? '—' : call.notes),
            isLast: true,
          ),
        ],
      ),
    );
  }

  static Widget _value(String text) => Text(
        text,
        style: const TextStyle(fontSize: 11.5, color: CrmPalette.text),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isLast;

  const _Row({required this.label, required this.child, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
