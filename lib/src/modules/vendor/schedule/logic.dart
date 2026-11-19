import 'package:get/get.dart';

import 'data/schedule_mock_data.dart';
import 'models/schedule_event_model.dart';


/// Controller for [ScheduleView]. Owns the scheduled events list and the
/// derived Upcoming/In Progress/Complete counts shown in the stat row.
class ScheduleLogic extends GetxController {
  final RxList<ScheduleEventModel> events = <ScheduleEventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    events.assignAll(ScheduleMockData.scheduledEvents());
  }

  bool get hasEvents => events.isNotEmpty;

  int get upcomingCount =>
      events.where((e) => e.status == ScheduleEventStatus.upcoming).length;

  int get inProgressCount =>
      events.where((e) => e.status == ScheduleEventStatus.inProgress).length;

  int get completedCount =>
      events.where((e) => e.status == ScheduleEventStatus.completed).length;
}
