import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_empty_filter.dart';
import 'logic.dart';
import 'models/cost_book_models.dart';
import 'provider_form/view.dart';
import 'region_form/view.dart';
import 'widgets/cost_book_buttons.dart';
import 'widgets/cost_book_header.dart';
import 'widgets/cost_book_section_heading.dart';
import 'widgets/entry_search_field.dart';
import 'widgets/entry_tile.dart';
import 'widgets/geo_factor_tile.dart';
import 'widgets/provider_card.dart';


/// Cost Book home: providers, the selected provider's entries, and geo
/// factors. Add/Edit flows are separate pushed routes that pop with the
/// finished model; this view hands it to the logic.
class CostBookView extends StatelessWidget {
  const CostBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(CostBookLogic());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CostBookHeader(title: 'Cost Book', onBack: Get.back),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  CostBookButton(
                    text: 'Add Provider',
                    icon: Icons.add_rounded,
                    onPressed: () => _openProviderForm(logic),
                  ),
                  const SizedBox(height: 18),
                  const CostBookSectionHeading(
                    title: 'Providers',
                    description:
                        'Configured cost-book sources for your organization',
                  ),
                  const SizedBox(height: 12),
                  _providers(logic),
                  const SizedBox(height: 22),
                  const CostBookSectionHeading(
                    title: 'Entries',
                    description:
                        'Search published unit cost line items for the selected provider',
                  ),
                  const SizedBox(height: 12),
                  EntrySearchField(onChanged: logic.setSearch),
                  const SizedBox(height: 12),
                  _entries(logic),
                  const SizedBox(height: 22),
                  CostBookSectionHeading(
                    title: 'Geo Factors',
                    description:
                        'Pre-applied multipliers during cost book lookups',
                    trailing: CostBookOutlineButton(
                      text: '+ Add Region',
                      onPressed: () => _openRegionForm(logic),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _geoFactors(logic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _providers(CostBookLogic logic) {
    return Obx(() {
      final items = logic.providers;
      if (items.isEmpty) {
        return const _EmptyBlock(message: 'No providers configured yet');
      }
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            ProviderCard(
              provider: items[i],
              selected: logic.selectedProviderId.value == items[i].id,
              syncing: logic.syncingProviderId.value == items[i].id,
              onSelect: () => logic.selectProvider(items[i].id),
              onSync: () => logic.syncProvider(items[i].id),
              onEdit: () => _openProviderForm(logic, initial: items[i]),
              onDelete: () => _confirmDelete(
                title: 'Delete provider?',
                body: 'This removes ${items[i].name} and its entries.',
                onConfirm: () => logic.deleteProvider(items[i].id),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _entries(CostBookLogic logic) {
    return Obx(() {
      // Touch every Rx input so Obx subscribes to all of them
      // (visibleEntries reads them too, but via a plain getter).
      final watched = [
        logic.entries.length,
        logic.searchQuery.value,
        logic.selectedProviderId.value,
      ];
      assert(watched.isNotEmpty);
      final items = logic.visibleEntries;
      if (items.isEmpty) {
        return _EmptyBlock(
          message: logic.hasProviders ? 'No entries found' : 'No provider selected',
        );
      }
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            EntryTile(entry: items[i]),
          ],
        ],
      );
    });
  }

  Widget _geoFactors(CostBookLogic logic) {
    return Obx(() {
      final items = logic.geoFactors;
      if (items.isEmpty) {
        return const _EmptyBlock(message: 'No regions defined yet');
      }
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            GeoFactorTile(
              factor: items[i],
              onEdit: () => _openRegionForm(logic, initial: items[i]),
              onDelete: () => _confirmDelete(
                title: 'Delete region?',
                body: 'Remove ${items[i].regionCode} from geo factors?',
                onConfirm: () => logic.deleteGeoFactor(items[i].id),
              ),
            ),
          ],
        ],
      );
    });
  }

  Future<void> _openProviderForm(
    CostBookLogic logic, {
    CostBookProviderModel? initial,
  }) async {
    final result = await Get.to<CostBookProviderModel>(
      () => ProviderFormView(initial: initial),
    );
    if (result != null) logic.saveProvider(result);
  }

  Future<void> _openRegionForm(
    CostBookLogic logic, {
    GeoFactorModel? initial,
  }) async {
    final result = await Get.to<GeoFactorModel>(
      () => RegionFormView(initial: initial),
    );
    if (result != null) logic.saveGeoFactor(result);
  }

  void _confirmDelete({
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        content: Text(body, style: const TextStyle(fontSize: 12)),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.redColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bordered empty-state block reused by all three lists.
class _EmptyBlock extends StatelessWidget {
  final String message;

  const _EmptyBlock({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: AppEmptyState(
        icon: Icons.info_outline_rounded,
        title: message,
        message: '',
        showButton: false,
      ),
    );
  }
}
