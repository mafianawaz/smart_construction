import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic.dart';
import '../models/crm_models.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_palette.dart';

enum _OrgSection { info, contacts, compliance }

extension on _OrgSection {
  String get label {
    switch (this) {
      case _OrgSection.info:
        return 'Organization Info';
      case _OrgSection.contacts:
        return 'Contacts';
      case _OrgSection.compliance:
        return 'Compliance';
    }
  }
}

/// Opens the organization detail bottom sheet (reference screen 2).
Future<void> showOrganizationDetailsSheet(
  BuildContext context, {
  required String orgId,
  required void Function(OrganizationModel org) onEdit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => OrganizationDetailsSheet(orgId: orgId, onEdit: onEdit),
  );
}

/// Bottom sheet: name + Edit/Delete, type badge, section dropdown, owner and
/// address, related projects and specialties.
///
/// Reads the organization from [CrmLogic] by id so owner changes show
/// immediately and a deleted organization closes the sheet.
class OrganizationDetailsSheet extends StatefulWidget {
  final String orgId;
  final void Function(OrganizationModel org) onEdit;

  const OrganizationDetailsSheet({
    super.key,
    required this.orgId,
    required this.onEdit,
  });

  @override
  State<OrganizationDetailsSheet> createState() =>
      _OrganizationDetailsSheetState();
}

class _OrganizationDetailsSheetState extends State<OrganizationDetailsSheet> {
  _OrgSection _section = _OrgSection.info;

  Future<void> _confirmDelete(CrmLogic logic, OrganizationModel org) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete organization?'),
        content: Text(
          '"${org.name}" will be removed from your CRM. '
          'This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: CrmPalette.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      logic.deleteOrganization(org.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CrmLogic>(
      builder: (logic) {
        final org = logic.organizationById(widget.orgId);
        if (org == null) {
          return const SizedBox.shrink();
        }

        final maxHeight = MediaQuery.of(context).size.height * 0.88;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            decoration: const BoxDecoration(
              color: CrmPalette.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CrmPalette.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            org.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: CrmPalette.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CrmSmallButton(
                          label: 'Edit',
                          icon: Icons.edit_outlined,
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onEdit(org);
                          },
                        ),
                        const SizedBox(width: 6),
                        CrmSmallButton(
                          label: 'Delete',
                          icon: Icons.delete_outline,
                          filled: true,
                          color: CrmPalette.danger,
                          onTap: () => _confirmDelete(logic, org),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CrmBadge(label: org.type.label, color: org.type.color),
                    ),
                    const SizedBox(height: 14),
                    _SectionDropdown(
                      value: _section,
                      onChanged: (v) => setState(() => _section = v),
                    ),
                    const SizedBox(height: 14),
                    if (_section == _OrgSection.info)
                      _InfoSection(logic: logic, org: org)
                    else if (_section == _OrgSection.contacts)
                      _ContactsSection(logic: logic, org: org)
                    else
                      _ComplianceSection(org: org),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionDropdown extends StatelessWidget {
  final _OrgSection value;
  final ValueChanged<_OrgSection> onChanged;

  const _SectionDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_OrgSection>(
      onSelected: onChanged,
      color: CrmPalette.surface,
      itemBuilder: (context) => [
        for (final s in _OrgSection.values)
          PopupMenuItem<_OrgSection>(
            value: s,
            child: Text(s.label, style: const TextStyle(fontSize: 13)),
          ),
      ],
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: CrmPalette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CrmPalette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.label,
                style: const TextStyle(fontSize: 13, color: CrmPalette.text),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: CrmPalette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Organization Info ─────────────────────────

class _InfoSection extends StatelessWidget {
  final CrmLogic logic;
  final OrganizationModel org;

  const _InfoSection({required this.logic, required this.org});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _OwnerPicker(logic: logic, org: org)),
            const SizedBox(width: 12),
            Expanded(child: _AddressBox(org: org)),
          ],
        ),
        const SizedBox(height: 16),
        const _SubHeading(icon: Icons.folder_outlined, text: 'Related Projects'),
        const SizedBox(height: 8),
        if (org.relatedProjects.isEmpty)
          const Text(
            'No active projects linked to this organization.',
            style: TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
          )
        else
          for (final project in org.relatedProjects)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $project',
                style: const TextStyle(fontSize: 12, color: CrmPalette.text),
              ),
            ),
        const SizedBox(height: 16),
        const Text(
          'Specialties',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CrmPalette.text,
          ),
        ),
        const SizedBox(height: 8),
        if (org.specialties.isEmpty)
          const Text(
            'No specialties added.',
            style: TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in org.specialties)
                CrmBadge(label: s, color: CrmPalette.dark),
            ],
          ),
      ],
    );
  }
}

class _SubHeading extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SubHeading({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: CrmPalette.textMuted),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CrmPalette.text,
          ),
        ),
      ],
    );
  }
}

class _OwnerPicker extends StatelessWidget {
  final CrmLogic logic;
  final OrganizationModel org;

  const _OwnerPicker({required this.logic, required this.org});

  @override
  Widget build(BuildContext context) {
    final owner = org.ownerName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Owner',
          style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
        ),
        const SizedBox(height: 6),
        // '' stands for "Unassigned" because popup values can't be null.
        PopupMenuButton<String>(
          onSelected: (v) => logic.assignOwner(org.id, v.isEmpty ? null : v),
          color: CrmPalette.surface,
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: '',
              child: Text('Unassigned', style: TextStyle(fontSize: 13)),
            ),
            for (final o in logic.owners)
              PopupMenuItem<String>(
                value: o,
                child: Text(o, style: const TextStyle(fontSize: 13)),
              ),
          ],
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: CrmPalette.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CrmPalette.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CrmPalette.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    owner == null ? '–' : crmInitials(owner),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    org.ownerLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.15,
                      color: CrmPalette.text,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: CrmPalette.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressBox extends StatelessWidget {
  final OrganizationModel org;

  const _AddressBox({required this.org});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CrmPalette.chipFill,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            org.addressLabel,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.3,
              color: CrmPalette.text,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Contacts section ───────────────────────────

class _ContactsSection extends StatelessWidget {
  final CrmLogic logic;
  final OrganizationModel org;

  const _ContactsSection({required this.logic, required this.org});

  @override
  Widget build(BuildContext context) {
    final contacts =
        logic.contacts.where((c) => c.organizationName == org.name).toList();
    if (contacts.isEmpty) {
      return const CrmEmptyState(
        icon: Icons.people_outline,
        title: 'No contacts',
        message: 'No contacts are linked to this organization yet.',
      );
    }
    return Column(
      children: [
        for (final c in contacts)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CrmPalette.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CrmPalette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: CrmPalette.text,
                        ),
                      ),
                    ),
                    if (c.isPrimary) ...[
                      const SizedBox(width: 8),
                      const CrmBadge(label: 'Primary', color: CrmPalette.dark),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  [c.role, c.email].where((s) => s.isNotEmpty).join(' · '),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────── Compliance section ───────────────────────────

class _ComplianceSection extends StatelessWidget {
  final OrganizationModel org;

  const _ComplianceSection({required this.org});

  @override
  Widget build(BuildContext context) {
    if (org.complianceItems.isEmpty) {
      return const CrmEmptyState(
        icon: Icons.verified_outlined,
        title: 'No compliance items',
        message: 'Nothing is being tracked for this organization.',
      );
    }
    return Column(
      children: [
        for (final item in org.complianceItems)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CrmPalette.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CrmPalette.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CrmPalette.text,
                    ),
                  ),
                ),
                CrmBadge(
                  label: _stateLabel(item.state),
                  color: _stateColor(item.state),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static String _stateLabel(ComplianceItemState s) {
    switch (s) {
      case ComplianceItemState.valid:
        return 'Valid';
      case ComplianceItemState.expiringSoon:
        return 'Expiring soon';
      case ComplianceItemState.expired:
        return 'Expired';
    }
  }

  static Color _stateColor(ComplianceItemState s) {
    switch (s) {
      case ComplianceItemState.valid:
        return CrmPalette.success;
      case ComplianceItemState.expiringSoon:
        return CrmPalette.amber;
      case ComplianceItemState.expired:
        return CrmPalette.danger;
    }
  }
}
