import 'package:flutter/material.dart';

import '../models/crm_models.dart';
import 'crm_palette.dart';

/// Peach "Birthdays" banner shown at the top of Organizations, Contacts and
/// Pipeline. Fed by `CrmLogic.upcomingBirthdays`.
class CrmBirthdayBanner extends StatelessWidget {
  final List<ContactModel> contacts;

  const CrmBirthdayBanner({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.orangeTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0C7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.cake_outlined,
              size: 20,
              color: CrmPalette.orange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Birthdays',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.text,
                  ),
                ),
                const SizedBox(height: 2),
                if (contacts.isEmpty)
                  const Text(
                    'No contacts have birthdays in the next 7 days.',
                    style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
                  )
                else
                  for (final c in contacts)
                    Text(
                      c.birthday == null
                          ? c.name
                          : '${c.name} · ${crmShortDate(c.birthday!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: CrmPalette.textMuted,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
