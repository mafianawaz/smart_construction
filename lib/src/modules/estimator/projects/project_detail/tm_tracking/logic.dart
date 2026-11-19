import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/field_ops_models.dart';

/// Owns the T&M Tracking tab. Time entries live in `ProjectWorkStore`.
/// T&M Work Tickets and the legacy Daily Sheets only have empty-state
/// references, so they have no model yet. Put with `tag: projectId`.
class TmTrackingLogic extends GetxController {
  final String projectId;
  TmTrackingLogic(this.projectId);

  RxList<TmTimeEntryModel> get timeEntries => ProjectWorkStore.to.tmTimeEntries(projectId);

  /// Newest first. Call inside an `Obx`.
  List<TmTimeEntryModel> get sortedEntries =>
      timeEntries.toList()..sort((a, b) => b.date.compareTo(a.date));
}
