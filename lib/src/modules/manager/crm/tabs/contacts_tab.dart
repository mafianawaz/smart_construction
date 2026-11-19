import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/contact_card.dart';
import '../widgets/crm_birthday_banner.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_palette.dart';
import '../widgets/crm_search_field.dart';
import 'crm_filter_sheets.dart';

/// Contacts tab (reference screen 4).
class ContactsTab extends StatelessWidget {
  final CrmLogic logic;

  const ContactsTab({super.key, required this.logic});

  // STUB: wire to url_launcher (tel: / mailto:) once the package is confirmed.
  void _stubAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final contacts = logic.filteredContacts;

    return ListView(
      children: [
        CrmBirthdayBanner(contacts: logic.upcomingBirthdays),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.people_outline, size: 18, color: CrmPalette.text),
            const SizedBox(width: 6),
            const Text(
              'All Contacts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: CrmPalette.text,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: CrmPalette.dark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${contacts.length}',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CrmSearchField(
          hint: 'Search by name, email, or organization...',
          initialValue: logic.contactQuery,
          onChanged: logic.setContactQuery,
          onFilterTap: () => showContactFilterSheet(context, logic),
          filterActive: logic.hasContactFilters,
        ),
        const SizedBox(height: 12),
        if (contacts.isEmpty)
          const CrmEmptyState(
            icon: Icons.people_outline,
            title: 'No contacts found',
            message: 'Try a different search or clear your filters.',
          )
        else
          for (final contact in contacts)
            ContactCard(
              key: ValueKey(contact.id),
              contact: contact,
              onCall: () => _stubAction(context, 'Calling ${contact.phone}…'),
              onEmail: () => _stubAction(context, 'Emailing ${contact.email}…'),
            ),
      ],
    );
  }
}
