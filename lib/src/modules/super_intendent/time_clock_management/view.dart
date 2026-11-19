import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import 'data/tc_format.dart';
import 'logic.dart';
import 'models/time_clock_models.dart';
import 'widgets/tc_cards.dart';
import 'widgets/tc_common.dart';
import 'widgets/tc_header_and_stats.dart';
import 'widgets/tc_palette.dart';
import 'widgets/tc_sheets.dart';


/// Time Clock Management screen (supervisor / manager side).
///
/// Controller is created here with `Get.put`; if the caller wants a tagged
/// instance, pass [tag] and delete it at the navigation layer.
class TimeClockManagementView extends StatelessWidget {
  const TimeClockManagementView({super.key, this.tag});

  final String? tag;

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(TimeClockLogic(), tag: tag);
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Time Clock Management',
        subtitle: 'Monitor active shifts,approve time,and manage adjustments',
        showBackButton: true,
        centerTitle: true,
      ),
      body: GetBuilder<TimeClockLogic>(
        tag: tag,
        builder: (_) {
          return RefreshIndicator(
            color: TcPalette.orange,
            onRefresh: logic.load,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TcStatGrid(
                      active: logic.activeCount,
                      pendingShifts: logic.pendingShiftCount,
                      pendingEntries: logic.pendingEntries,
                      totalPending: logic.totalPending,
                    ),
                    const SizedBox(height: 14),
                    TcTabBar(
                      current: logic.currentTab,
                      onChanged: logic.selectTab,
                      badges: {
                        TimeClockTab.shiftApprovals: (count: logic.pendingShiftCount, color: TcPalette.red),
                        TimeClockTab.otRequests: (count: logic.pendingOtCount, color: TcPalette.orange),
                      },
                    ),
                    SizedBox(height: 15,),
                    if (logic.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator(color: TcPalette.orange)),
                      )
                    else
                      _body(context, logic),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, TimeClockLogic logic) {
    switch (logic.currentTab) {
      case TimeClockTab.liveMonitoring:
        return _live(logic);
      case TimeClockTab.shiftApprovals:
        return _shifts(context, logic);
      case TimeClockTab.timeEntry:
        return TimeEntryRedirectCard(onGo: logic.openTimeEntryManagement);
      case TimeClockTab.otRequests:
        return _overtime(context, logic);
    }
  }

  // ------------------------------------------------------- Live Monitoring
  Widget _live(TimeClockLogic logic) {
    final items = logic.activeShifts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcSectionHeader(
          title: 'Active Shifts',
          count: logic.activeCount,
          onSearchTap: logic.toggleLiveSearch,
          searchOpen: logic.liveSearchOpen,
        ),
          if (logic.liveSearchOpen) ...[
            const SizedBox(height: 12),
            CustomTextField(
              hintText: 'Search employee in project...',
              onChange: logic.setLiveQuery,
              leftIconPath: AppIcons.search,
              isFilled: true,
            ),
          ],
          const SizedBox(height: 12),
        if (items.isEmpty)
          TcEmptyBlock(
            icon: Icons.access_time,
            title: logic.liveQuery.isEmpty ? 'No active shifts' : 'No matches',
            message: logic.liveQuery.isEmpty
                ? 'Nobody is clocked in right now.'
                : 'Try a different name or project.',
          )
        else ...[
          const Divider(height: 1, color: TcPalette.border),
          for (final s in items) ActiveShiftTile(shift: s),
        ],
      ],
    );
  }

  // ------------------------------------------------------ Shift Approvals
  Widget _shifts(BuildContext context, TimeClockLogic logic) {
    final items = logic.pendingShifts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcSectionHeader(
          title: 'Pending Approvals',
          count: logic.pendingShiftCount,
          onSearchTap: logic.toggleShiftSearch,
          searchOpen: logic.shiftSearchOpen,
        ),
        if (logic.shiftSearchOpen) ...[
          const SizedBox(height: 12),
          CustomTextField(
            hintText: 'Search employee in project...',
            onChange: logic.setShiftQuery,
            leftIconPath: AppIcons.search,
            isFilled: true,
          ),
        ],
        const SizedBox(height: 12),
        if (items.isEmpty)
          TcEmptyBlock(
            icon: Icons.task_alt,
            title: logic.shiftQuery.isEmpty ? 'All caught up' : 'No matches',
            message: logic.shiftQuery.isEmpty
                ? 'There are no shifts waiting for approval.'
                : 'Try a different name or project.',
          )
        else
          for (final s in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PendingShiftCard(
                key: ValueKey(s.id),
                shift: s,
                onApprove: () => logic.approveShift(s.id),
                onAdapt: () async {
                  final res = await showAdaptShiftSheet(context, s);
                  if (res != null) logic.adaptShift(s.id, res.clockIn, res.clockOut);
                },
                onReject: () async {
                  final reason = await showRejectDialog(
                    context,
                    title: 'Reject shift?',
                    subject: '${s.employeeName} · ${s.projectLabel}',
                  );
                  if (reason != null) logic.rejectShift(s.id, reason);
                },
              ),
            ),
      ],
    );
  }

  // ----------------------------------------------------------- OT Requests
  Widget _overtime(BuildContext context, TimeClockLogic logic) {
    final items = logic.overtimeRequests;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcSectionHeader(
          title: 'Pending Overtime Requests',
          count: logic.pendingOtCount,
          leadingIcon: Icons.schedule,
          countInline: true,
        ),
        const SizedBox(height: 12),
        CustomTextField(
           hintText: 'Search by name or project...',
           onChange: logic.setOtQuery,
          leftIconPath: AppIcons.search,
          isFilled: true,
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          TcEmptyBlock(
            icon: Icons.more_time,
            title: logic.otQuery.isEmpty ? 'No overtime requests' : 'No matches',
            message: logic.otQuery.isEmpty
                ? 'Overtime requests will show up here.'
                : 'Try a different name or project.',
          )
        else
          for (final r in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OvertimeRequestCard(
                key: ValueKey(r.id),
                request: r,
                onApprove: () => logic.approveOvertime(r.id),
                onReject: () async {
                  final reason = await showRejectDialog(
                    context,
                    title: 'Reject overtime?',
                    subject: '${r.employeeName} · ${TcFormat.overtime(r.overtimeHours)} OT',
                  );
                  if (reason != null) logic.rejectOvertime(r.id, reason);
                },
              ),
            ),
      ],
    );
  }
}
