import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../utils/app_color.dart';
import '../data/marketplace_mock_data.dart';
import '../equipment_form/view.dart';
import '../logic.dart';
import '../models/marketplace_models.dart';
import '../widgets/marketplace_cards.dart';
import '../widgets/marketplace_primitives.dart';
import 'listing_details_view.dart';
import 'recruit_view.dart';
import 'talent_profile_view.dart';

// ─────────────────────────── Contractors ───────────────────────────

class ContractorsTab extends StatelessWidget {
  const ContractorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
         hintText: 'Search Contractors...',
         onChange: (v) => logic.contractorQuery.value = v!,
         leftIconPath: AppIcons.search,
        ),
        const SizedBox(height: 12),
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                FilterPillDropdown(
                  value: logic.contractorTrade.value,
                  defaultValue: 'All Trades',
                  items: MarketplaceMockData.trades,
                  onChanged: (v) => logic.contractorTrade.value = v,
                ),
                const SizedBox(width: 8),
                FilterPillDropdown(
                  value: logic.contractorLocation.value,
                  defaultValue: 'Location',
                  items: MarketplaceMockData.contractorLocations,
                  onChanged: (v) => logic.contractorLocation.value = v,
                ),
                const SizedBox(width: 8),
                FilterPillDropdown(
                  value: logic.contractorRating.value,
                  defaultValue: 'Any Rating',
                  items: MarketplaceMockData.ratings,
                  onChanged: (v) => logic.contractorRating.value = v,
                ),
              ]),
            )),
        Obx(() {
          final list = logic.filteredContractors;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultsHeading(
                  'Showing ${list.length} contractor${list.length == 1 ? '' : 's'}'),
              if (list.isEmpty)
                const _EmptyBlock('No contractors match your filters')
              else
                for (final c in list)
                  ContractorCard(
                    contractor: c,
                    onConnect: () => logic.connect(c),
                  ),
            ],
          );
        }),
      ],
    );
  }
}

// ─────────────────────────── Talent pool ───────────────────────────

class TalentPoolTab extends StatelessWidget {
  const TalentPoolTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MarketplacePalette.border),
          ),
          child: Obx(() => Column(
                children: [
                  CustomTextField(
                    hintText: 'Search Contractors...',
                    onChange: (v) => logic.talentQuery.value = v!,
                    leftIconPath: AppIcons.search,
                  ),
                  const SizedBox(height: 10),
                  _twoUp(
                    MarketplaceDropdown(
                      value: logic.talentTrade.value,
                      items: MarketplaceMockData.trades,
                      onChanged: (v) => logic.talentTrade.value = v,
                    ),
                    MarketplaceDropdown(
                      value: logic.talentAvailability.value,
                      items: MarketplaceMockData.availability,
                      onChanged: (v) => logic.talentAvailability.value = v,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _twoUp(
                    MarketplaceDropdown(
                      value: logic.talentRating.value,
                      items: MarketplaceMockData.ratings,
                      onChanged: (v) => logic.talentRating.value = v,
                    ),
                    MarketplaceDropdown(
                      value: logic.talentSort.value,
                      items: MarketplaceMockData.sortOptions,
                      onChanged: (v) => logic.talentSort.value = v,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _twoUp(
                    MarketplaceTextFilter(
                      hint: 'Location',
                      icon: Icons.location_on_outlined,
                      onChanged: (v) => logic.talentLocation.value = v,
                    ),
                    MarketplaceTextFilter(
                      hint: 'Filter by skill',
                      onChanged: (v) => logic.talentSkill.value = v,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MarketplaceTextFilter(
                    hint: 'Filter by Certifications',
                    onChanged: (v) => logic.talentCert.value = v,
                  ),
                ],
              )),
        ),
        const SizedBox(height: 12),
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                FilterPillDropdown(
                  value: logic.talentTrade.value,
                  defaultValue: 'All Trades',
                  items: MarketplaceMockData.trades,
                  onChanged: (v) => logic.talentTrade.value = v,
                ),
                const SizedBox(width: 8),
                FilterPillDropdown(
                  value: logic.talentRating.value,
                  defaultValue: 'Any Rating',
                  items: MarketplaceMockData.ratings,
                  onChanged: (v) => logic.talentRating.value = v,
                ),
              ]),
            )),
        Obx(() {
          final list = logic.filteredTalent;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultsHeading(
                  'Showing ${list.length} result${list.length == 1 ? '' : 's'}'),
              if (list.isEmpty)
                const _EmptyBlock('No talent matches your filters')
              else
                for (final t in list)
                  TalentCard(
                    talent: t,
                    onTap: () => Get.to(() => TalentProfileView(talent: t)),
                    onRecruit: () => Get.to(() => RecruitView(talent: t)),
                  ),
            ],
          );
        }),
      ],
    );
  }

  Widget _twoUp(Widget a, Widget b) => Row(children: [
        Expanded(child: a),
        const SizedBox(width: 10),
        Expanded(child: b),
      ]);
}

// ─────────────────────────── Crews ───────────────────────────

class CrewsTab extends StatelessWidget {
  const CrewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MarketplacePalette.border),
          ),
          child: Obx(() => Column(
                children: [
                  CustomTextField(
                    hintText: 'Search Contractors...',
                    onChange: (v) => logic.crewQuery.value = v!,
                    leftIconPath: AppIcons.search,
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: MarketplaceDropdown(
                        value: logic.crewTrade.value,
                        items: MarketplaceMockData.trades,
                        onChanged: (v) => logic.crewTrade.value = v,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MarketplaceDropdown(
                        value: logic.crewStatus.value,
                        items: MarketplaceMockData.crewStatuses,
                        onChanged: (v) => logic.crewStatus.value = v,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: MarketplaceDateField(
                        value: logic.crewFrom.value,
                        onPicked: (d) => logic.crewFrom.value = d,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MarketplaceDateField(
                        value: logic.crewTo.value,
                        onPicked: (d) => logic.crewTo.value = d,
                      ),
                    ),
                  ]),
                ],
              )),
        ),
        Obx(() {
          final list = logic.filteredCrews;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultsHeading(
                  'Showing ${list.length} crew${list.length == 1 ? '' : 's'}'),
              if (list.isEmpty)
                const _EmptyBlock('No crews match your filters')
              else
                for (final c in list) CrewCard(crew: c),
            ],
          );
        }),
      ],
    );
  }
}

// ─────────────────────────── Equipment rentals ───────────────────────────

class EquipmentTab extends StatelessWidget {
  const EquipmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => MarketplaceSegmentBar(
              filled: true,
              labels: EquipmentSubTab.values.map((e) => e.label).toList(),
              selectedIndex: logic.equipmentSubIndex.value,
              onChanged: (i) => logic.equipmentSubIndex.value = i,
            )),
        const SizedBox(height: 12),
        Obx(() {
          switch (logic.equipmentSub) {
            case EquipmentSubTab.browse:
              return const _EquipmentBrowse();
            case EquipmentSubTab.myListing:
              return const _EquipmentMyListings();
            case EquipmentSubTab.myRequest:
              return const _EquipmentMyRequests();
          }
        }),
      ],
    );
  }
}

class _EquipmentBrowse extends StatelessWidget {
  const _EquipmentBrowse();

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MarketplacePalette.border),
          ),
          child: Column(children: [
            CustomTextField(
              hintText: 'Search by city...',
              onChange: (v) => logic.equipmentCity.value = v!,
              leftIconPath: AppIcons.search,
            ),
            const SizedBox(height: 10),
            Obx(() => CustomDropdown(
                  value: logic.equipmentCategory.value,
                  items: MarketplaceMockData.equipmentCategories,
                  itemLabel: (e) => e,
                  onChanged: (v) => logic.equipmentCategory.value = v!,
                )),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: CustomTextField(
                  hintText: 'Min \$/day',
                  keyboardType: TextInputType.number,
                  onChange: (v) => logic.equipmentMinRate.value = v!,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  hintText:  'Max \$/day',
                  keyboardType: TextInputType.number,
                  onChange: (v) => logic.equipmentMaxRate.value = v!,
                ),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final list = logic.browseEquipment;
          if (list.isEmpty) return const _EmptyBlock('No equipment found');
          return Column(
            children: [for (final e in list) EquipmentBrowseCard(item: e)],
          );
        }),
      ],
    );
  }
}

class _EquipmentMyListings extends StatelessWidget {
  const _EquipmentMyListings();

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final list = logic.myListings;
          if (list.isEmpty) {
            return const _EmptyBlock('You have no equipment listed yet');
          }
          return Column(children: [
            for (final e in list)
              MyListingTile(
                item: e,
                onTap: () => Get.to(() => ListingDetailsView(equipmentId: e.id)),
              ),
          ]);
        }),
        const SizedBox(height: 4),
        MarketplacePrimaryButton(
          label: 'List Equipment',
          icon: Icons.add,
          onPressed: () async {
            final result = await Get.to<EquipmentModel>(
                () => const EquipmentFormView());
            if (result != null) logic.saveListing(result, isNew: true);
          },
        ),
      ],
    );
  }
}

class _EquipmentMyRequests extends StatelessWidget {
  const _EquipmentMyRequests();

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MarketplaceLogic>();
    return Obx(() {
      final list = logic.myRequests;
      if (list.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MarketplacePalette.border),
          ),
          child: Column(children: [
            Icon(Icons.schedule, size: 34, color: AppColors.textMuted),
            const SizedBox(height: 10),
            Text('No rental requests yet',
                style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          ]),
        );
      }
      return Column(children: [
        for (final r in list) RentalRequestTile(request: r),
      ]);
    });
  }
}

class _EmptyBlock extends StatelessWidget {
  final String message;
  const _EmptyBlock(this.message);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(message,
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
        ),
      );
}
