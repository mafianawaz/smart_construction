import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../models/crm_sequence_models.dart';
import '../widgets/crm_action_button.dart';
import '../widgets/crm_blank_state.dart';
import '../widgets/crm_palette.dart';
import '../widgets/crm_search_field.dart';
import '../widgets/sequence_card.dart';
import 'sequence_form_view.dart';

/// Sequences tab: header + "+ New sequence", Library / My Sequences toggle,
/// search, then the sequence cards.
class SequencesTab extends StatelessWidget {
  final CrmLogic logic;

  const SequencesTab({super.key, required this.logic});

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _newSequence() async {
    final result = await Get.to<SequenceModel>(
      () => SequenceFormView(
        id: logic.newSequenceId(),
        owners: logic.owners,
        defaultOwner: logic.sequenceOwner,
      ),
    );
    if (result != null) logic.addSequence(result);
  }

  Future<void> _confirmDelete(BuildContext context, SequenceModel s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete sequence?'),
        content: Text('"${s.name}" will be removed. This can\'t be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: CrmPalette.danger),
            ),
          ),
        ],
      ),
    );
    if (ok == true) logic.deleteSequence(s.id);
  }

  @override
  Widget build(BuildContext context) {
    final isLibrary = logic.sequenceScope == SequenceScope.library;
    final list = logic.filteredSequences;

    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sequences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: CrmPalette.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Multi-step sales cadences for your CRM',
                    style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CrmActionButton(
              label: 'New sequence',
              icon: Icons.add,
              onTap: _newSequence,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ScopeChip(
              icon: Icons.widgets_outlined,
              label: 'Library',
              selected: isLibrary,
              onTap: () => logic.setSequenceScope(SequenceScope.library),
            ),
            const SizedBox(width: 8),
            _ScopeChip(
              icon: Icons.folder_outlined,
              label: 'My Sequences',
              selected: !isLibrary,
              onTap: () => logic.setSequenceScope(SequenceScope.mine),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CrmSearchField(
          hint: 'Search sequences...',
          initialValue: logic.sequenceQuery,
          onChanged: logic.setSequenceQuery,
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          _empty(context, isLibrary)
        else
          for (final s in list)
            SequenceCard(
              key: ValueKey(s.id),
              sequence: s,
              onDuplicate: () {
                logic.duplicateSequence(s.id);
                _toast(
                  context,
                  s.isTemplate
                      ? 'Template added to My Sequences as a draft.'
                      : 'Sequence duplicated as a draft.',
                );
              },
              onArchive:
                  s.isTemplate ? null : () => logic.toggleSequenceArchived(s.id),
              onDelete: s.isTemplate ? null : () => _confirmDelete(context, s),
              onStatusChanged: s.isTemplate
                  ? null
                  : (status) {
                      final ok = logic.setSequenceStatus(s.id, status);
                      if (!ok) {
                        _toast(context, 'Add at least one step before activating.');
                      }
                    },
            ),
      ],
    );
  }

  Widget _empty(BuildContext context, bool isLibrary) {
    final searching = logic.sequenceQuery.trim().isNotEmpty;
    if (searching) {
      return const CrmBlankState(
        icon: Icons.search_off,
        title: 'No matching sequences',
        message: 'Try a different search term.',
      );
    }
    if (isLibrary) {
      return const CrmBlankState(
        icon: Icons.widgets_outlined,
        title: 'Library is empty',
        message: 'Ready-made cadences will show up here.',
      );
    }
    return CrmBlankState(
      icon: Icons.repeat,
      title: 'No sequences yet',
      message: 'Create a cadence, or copy one from the Library.',
      buttonLabel: 'New sequence',
      onButton: _newSequence,
    );
  }
}

class _ScopeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ScopeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? CrmPalette.orange : CrmPalette.text;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? CrmPalette.orangeTint : CrmPalette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? CrmPalette.orange : CrmPalette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
