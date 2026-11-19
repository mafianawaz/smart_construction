import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/custom_toggle_switch.dart';
import '../../../widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/client_filter.dart';
import 'widgets/client_organization_card.dart';
import 'widgets/client_stats_row.dart';

class EnrolledClientsView extends StatelessWidget {
  const EnrolledClientsView({super.key});

  static const _tag = 'enrolled_clients';

  @override
  Widget build(BuildContext context) {
    final EnrolledClientsLogic logic = Get.put(
      EnrolledClientsLogic(),
      tag: _tag,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppPrimaryBar(
        title: 'Enrolled Clients',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View contractor organizations that have enrolled to '
                'receive your pricing',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 15),
              ClientStatsRow(
                items: [
                  ClientStatItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Clients',
                    value: logic.totalCount,
                  ),
                  ClientStatItem(
                    icon: Icons.check_circle,
                    label: 'Active',
                    value: logic.activeCount,
                  ),
                  ClientStatItem(
                    icon: Icons.access_time_rounded,
                    label: 'Pending',
                    value: logic.pendingCount,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Client Organizations',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Contractors receiving your pricing submissions',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hintText: 'Search clients...',
                    leftIconPath: AppIcons.search,
                    onChange: logic.onSearchChanged,
                    isFilled: true,
                  ),
                  const SizedBox(height: 12),
                  PillTabGroup<ClientFilter>(
                    style: PillTabStyle.filled,
                    selectedValue: logic.selectedFilter.value,
                    onChanged: logic.onFilterChanged,
                    items: [
                      for (final filter in ClientFilter.values)
                        PillTabItem<ClientFilter>(
                          value: filter,
                          label: filter == ClientFilter.all
                              ? '${filter.label} (${logic.totalCount})'
                              : filter.label,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (logic.filteredClients.isEmpty)
                    const AppEmptyState(
                      title: 'No enrolled clients',
                      message: 'Contractor organizations will invite you to submit pricing',
                      showButton: false,
                    )
                  else
                    Column(
                      children: [
                        for (final client in logic.filteredClients) ...[
                          ClientOrganizationCard(client: client),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
