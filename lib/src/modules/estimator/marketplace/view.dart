import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_toggle_switch.dart';
import 'logic.dart';
import 'models/marketplace_models.dart';
import 'views/marketplace_tabs.dart';
import 'widgets/marketplace_primitives.dart';


class MarketplaceView extends StatefulWidget {
  const MarketplaceView({super.key});

  @override
  State<MarketplaceView> createState() => _MarketplaceViewState();
}

class _MarketplaceViewState extends State<MarketplaceView> {
  late final MarketplaceLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.put(MarketplaceLogic());
  }

  @override
  void dispose() {
    Get.delete<MarketplaceLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppPrimaryBar(
        title: 'Marketplace',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover and connect with contractors, crews, and equipment providers in your network.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            Obx(() => CustomToggle(
                  options: MarketplaceTab.values.map((t) => t.label).toList(),
                  selectedIndex: logic.tabIndex.value,
                  onChanged: (i) => logic.tabIndex.value = i,
                )),
            const SizedBox(height: 12),
            Obx(() => MarketplaceInfoBanner(logic.tab.banner)),
            const SizedBox(height: 14),
            Obx(() {
              switch (logic.tab) {
                case MarketplaceTab.contractor:
                  return const ContractorsTab();
                case MarketplaceTab.talentPool:
                  return const TalentPoolTab();
                case MarketplaceTab.crews:
                  return const CrewsTab();
                case MarketplaceTab.equipmentRentals:
                  return const EquipmentTab();
              }
            }),
          ],
        ),
      ),
    );
  }
}
