import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/clarification_model.dart';

class ClarificationTile extends StatelessWidget {
  final ClarificationModel clarification;

  const ClarificationTile({super.key, required this.clarification});

  static final _dateFormat = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ask',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(clarification.question, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            'Asked ${_dateFormat.format(clarification.askedAt)}',
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(height: 4),
          if (clarification.isAwaitingResponse)
            const Text(
              'Awaiting response...',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black38,
              ),
            )
          else ...[
            Text(
              clarification.response!,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(
              'Responded ${_dateFormat.format(clarification.respondedAt!)}',
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ],
      ),
    );
  }
}
