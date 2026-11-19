import 'package:flutter/material.dart';

import '../models/crm_models.dart';
import 'crm_controls.dart';
import 'crm_palette.dart';

/// Contact row with an orange left accent, detail lines and call / mail actions.
class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onCall;
  final VoidCallback onEmail;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onCall,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: CrmPalette.orange),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              contact.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: CrmPalette.text,
                              ),
                            ),
                          ),
                          if (contact.isPrimary) ...[
                            const SizedBox(width: 8),
                            const _PrimaryBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      _Line(label: 'Role', value: contact.role),
                      _Line(
                        label: 'Organization',
                        value: contact.organizationName,
                      ),
                      _Line(label: 'Owner', value: contact.ownerLabel),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mail_outline,
                              size: 13,
                              color: CrmPalette.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                contact.email.isEmpty ? '—' : contact.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: CrmPalette.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _Line(label: 'Phone', value: contact.phoneLabel),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _CircleAction(
                            icon: Icons.phone_outlined,
                            enabled: contact.phone.trim().isNotEmpty,
                            onTap: onCall,
                          ),
                          const SizedBox(width: 8),
                          _CircleAction(
                            icon: Icons.mail_outline,
                            enabled: contact.email.trim().isNotEmpty,
                            onTap: onEmail,
                          ),
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

class _PrimaryBadge extends StatelessWidget {
  const _PrimaryBadge();

  @override
  Widget build(BuildContext context) =>
      const CrmBadge(label: 'Primary', color: CrmPalette.dark);
}

class _Line extends StatelessWidget {
  final String label;
  final String value;

  const _Line({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value.isEmpty ? '—' : value,
              style: const TextStyle(color: CrmPalette.text),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CircleAction({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CrmPalette.border),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? CrmPalette.text : CrmPalette.textFaint,
        ),
      ),
    );
  }
}
