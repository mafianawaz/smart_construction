import 'package:flutter/material.dart';
import '../logic.dart';
import '../models/crm_models.dart';
import '../widgets/crm_form_fields.dart';
import '../widgets/crm_palette.dart';

/// Filter bottom sheet for the Organizations list (type + status).
/// Layout is this module's own design; the reference only shows the funnel icon.
Future<void> showOrgFilterSheet(BuildContext context, CrmLogic logic) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OrgFilterSheet(logic: logic),
  );
}

/// Filter bottom sheet for the Contacts list (organization).
Future<void> showContactFilterSheet(BuildContext context, CrmLogic logic) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ContactFilterSheet(logic: logic),
  );
}

class _SheetFrame extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _SheetFrame({
    required this.title,
    required this.child,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: CrmPalette.text,
              ),
            ),
            const SizedBox(height: 14),
            Flexible(child: SingleChildScrollView(child: child)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CrmPalette.text,
                      side: const BorderSide(color: CrmPalette.border),
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CrmPrimaryButton(text: 'Apply', onPressed: onApply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;

  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CrmPalette.textMuted,
        ),
      ),
    );
  }
}

/// Wrap of single-select chips with a leading "All" chip (value null).
class _ChipGroup<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T?> onChanged;

  const _ChipGroup({
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, bool isSelected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? CrmPalette.orange : CrmPalette.chipFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? CrmPalette.orange : CrmPalette.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : CrmPalette.text,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip('All', selected == null, () => onChanged(null)),
        for (final option in options)
          chip(labelOf(option), selected == option, () => onChanged(option)),
      ],
    );
  }
}

// ───────────────────────── Organizations ─────────────────────────

class _OrgFilterSheet extends StatefulWidget {
  final CrmLogic logic;

  const _OrgFilterSheet({required this.logic});

  @override
  State<_OrgFilterSheet> createState() => _OrgFilterSheetState();
}

class _OrgFilterSheetState extends State<_OrgFilterSheet> {
  late OrgType? _type = widget.logic.orgTypeFilter;
  late OrgStatus? _status = widget.logic.orgStatusFilter;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Filter organizations',
      onReset: () {
        widget.logic.clearOrgFilters();
        Navigator.of(context).pop();
      },
      onApply: () {
        widget.logic.setOrgFilters(type: _type, status: _status);
        Navigator.of(context).pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GroupLabel('Type'),
          _ChipGroup<OrgType>(
            options: OrgType.values,
            labelOf: (t) => t.label,
            selected: _type,
            onChanged: (v) => setState(() => _type = v),
          ),
          const SizedBox(height: 16),
          const _GroupLabel('Status'),
          _ChipGroup<OrgStatus>(
            options: OrgStatus.values,
            labelOf: (s) => s.label,
            selected: _status,
            onChanged: (v) => setState(() => _status = v),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Contacts ───────────────────────────

class _ContactFilterSheet extends StatefulWidget {
  final CrmLogic logic;

  const _ContactFilterSheet({required this.logic});

  @override
  State<_ContactFilterSheet> createState() => _ContactFilterSheetState();
}

class _ContactFilterSheetState extends State<_ContactFilterSheet> {
  late String? _org = widget.logic.contactOrgFilter;

  @override
  Widget build(BuildContext context) {
    // Only organizations that actually have contacts are useful here.
    final orgNames = widget.logic.contacts
        .map((c) => c.organizationName)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();

    return _SheetFrame(
      title: 'Filter contacts',
      onReset: () {
        widget.logic.setContactOrgFilter(null);
        Navigator.of(context).pop();
      },
      onApply: () {
        widget.logic.setContactOrgFilter(_org);
        Navigator.of(context).pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GroupLabel('Organization'),
          _ChipGroup<String>(
            options: orgNames,
            labelOf: (n) => n,
            selected: _org,
            onChanged: (v) => setState(() => _org = v),
          ),
        ],
      ),
    );
  }
}
