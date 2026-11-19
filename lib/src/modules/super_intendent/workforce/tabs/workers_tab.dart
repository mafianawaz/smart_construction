import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../logic.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';
import '../widgets/worker_widgets.dart';
import 'worker_details_view.dart';

/// Workers tab: search, Trade / Role / Type filters, count, worker cards.
class WorkersTab extends StatelessWidget {
  const WorkersTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final list = logic.filteredWorkers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Search by name or email...',
          controller: logic.workerSearch,
          onChange: logic.setWorkerSearch,
          leftIconPath: AppIcons.search,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              WfFilterChip(
                display: logic.tradeDisplay,
                options: logic.tradeOptions,
                selected: logic.tradeFilter,
                onSelected: logic.setTradeFilter,
              ),
              const SizedBox(width: 8),
              WfFilterChip(
                display: logic.roleDisplay,
                options: logic.roleOptions,
                selected: logic.roleFilter,
                onSelected: logic.setRoleFilter,
              ),
              const SizedBox(width: 8),
              WfFilterChip(
                display: logic.typeDisplay,
                options: logic.typeOptions,
                selected: logic.typeFilter,
                onSelected: logic.setTypeFilter,
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Text(
          '${list.length} worker${list.length == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 13, color: WfPalette.text),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: list.isEmpty
              ? const AppEmptyState(
                  icon: Icons.people_outline,
                  title: 'No workers found',
                  message: 'Try a different search or clear a filter.',
                  showButton: false,
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => WorkerCard(
                    worker: list[i],
                    onTap: () => Get.to(() => WorkerDetailsView(worker: list[i])),
                  ),
                ),
        ),
      ],
    );
  }
}
