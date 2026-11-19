import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_palette.dart';
import 'scope_type_sheet.dart';

/// Operations → Scope Settings (Scope of Work Types).
class ScopeSettingsSection extends StatelessWidget {
  final CompanySettingsLogic logic;

  const ScopeSettingsSection({super.key, required this.logic});

  Future<void> _openSheet(BuildContext context, {ScopeTypeModel? item}) async {
    final result = await showModalBottomSheet<ScopeTypeModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScopeTypeSheet(
        initial: item,
        existingNames: logic.scopeNames(exceptId: item?.id),
      ),
    );
    if (result == null) return;
    if (item == null) {
      await logic.addScopeType(result);
    } else {
      await logic.updateScopeType(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scope of Work Types',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CsPalette.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Define scope categories for your organization',
                    style: TextStyle(fontSize: 10.5, color: CsPalette.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CsSmallButton(
              label: '+ Add Scope',
              onPressed: () => _openSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (logic.scopeTypes.isEmpty)
          const CsEmptyCard(
            icon: Icons.tune,
            title: 'No scope types yet',
            message: 'Add your first scope of work type above',
          )
        else
          for (final s in logic.scopeTypes) ...[
            _ScopeRow(
              item: s,
              onEdit: () => _openSheet(context, item: s),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _ScopeRow extends StatelessWidget {
  final ScopeTypeModel item;
  final VoidCallback onEdit;

  const _ScopeRow({required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CsPalette.border),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              item.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: CsPalette.text,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CsPalette.fieldFill,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: CsPalette.border),
            ),
            child: Text(
              item.unit,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: CsPalette.muted,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: CsPalette.muted,
            ),
          ),
        ],
      ),
    );
  }
}
