import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_book_models.dart';
import 'cost_book_buttons.dart';
import 'cost_book_card.dart';
import 'cost_book_palette.dart';

/// Provider summary: name, kind + status tags, sync/edit/delete actions,
/// then Region and Last Synced rows. The selected provider gets an orange
/// border — its entries are the ones listed below.
class ProviderCard extends StatelessWidget {
  final CostBookProviderModel provider;
  final bool selected;
  final bool syncing;
  final VoidCallback onSelect;
  final VoidCallback onSync;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.selected,
    required this.syncing,
    required this.onSelect,
    required this.onSync,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CostBookCard(
      onTap: onSelect,
      borderColor: selected ? AppColors.primaryOrange : null,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  provider.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CostBookPalette.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _tag(provider.kind.label, AppColors.primaryOrange, outlined: true),
              const SizedBox(width: 6),
              _tag(
                provider.isActive ? 'Active' : 'Inactive',
                provider.isActive ? CostBookPalette.activeFg : AppColors.textMuted,
                outlined: true,
              ),
              const Spacer(),
              CostBookIconAction(
                icon: Icons.sync_rounded,
                onTap: onSync,
                busy: syncing,
              ),
              const SizedBox(width: 6),
              CostBookIconAction(icon: Icons.edit_outlined, onTap: onEdit),
              const SizedBox(width: 6),
              CostBookIconAction(
                icon: Icons.delete_outline_rounded,
                onTap: onDelete,
                destructive: true,
              ),
            ],
          ),
          const Divider(height: 22, color: CostBookPalette.divider),
          _row('Region', provider.regionLabel),
          const SizedBox(height: 8),
          _row('Last Synced', provider.lastSyncedLabel),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color, {required bool outlined}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: outlined ? Border.all(color: color, width: 0.8) : null,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: CostBookPalette.ink,
          ),
        ),
      ],
    );
  }
}
