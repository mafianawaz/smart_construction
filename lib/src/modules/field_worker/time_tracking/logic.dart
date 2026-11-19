import 'package:get/get.dart';

import 'models/mock_data.dart';
import 'models/time_tracking_models.dart';


/// Owns all data/business state for the Clock In screen. Tagged per
/// instance (same convention as AppCalendar) so nothing collides if this
/// screen is ever mounted more than once at a time.
class TimeTrackingController extends GetxController {
  final String instanceTag;
  TimeTrackingController({required this.instanceTag});

  final Rx<ProjectOption?> selectedProject = Rx<ProjectOption?>(null);
  final Rx<CostCodeOption?> selectedCostCode = Rx<CostCodeOption?>(null);
  final Rx<GpsStatus> gpsStatus = GpsStatus.unknown.obs;
  final RxBool isClockedIn = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxList<ProjectOption> projects = <ProjectOption>[].obs;
  final RxList<CostCodeOption> costCodes = <CostCodeOption>[].obs;
  final RxList<ShiftEntry> shiftHistory = <ShiftEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Mock data is the API seam — replace with a repository call once the
    // backend lands. See NOTES_TIME_TRACKING.md.
    projects.assignAll(TimeTrackingMockData.projects());
    shiftHistory.assignAll(TimeTrackingMockData.shiftHistory());
    _checkGpsStatus();
  }

  Future<void> _checkGpsStatus() async {
    gpsStatus.value = GpsStatus.checking;
    // TODO: replace with a real location-permission check.
    await Future.delayed(const Duration(milliseconds: 400));
    gpsStatus.value = GpsStatus.unavailable;
  }

  void retryGpsCheck() => _checkGpsStatus();

  void selectProject(ProjectOption? project) {
    selectedProject.value = project;
    selectedCostCode.value = null;
    costCodes.assignAll(
      project == null ? const [] : TimeTrackingMockData.costCodesForProject(project.id),
    );
  }

  void selectCostCode(CostCodeOption? costCode) => selectedCostCode.value = costCode;

  bool get canClockIn => selectedProject.value != null && !isClockedIn.value;

  Future<void> clockIn() async {
    if (!canClockIn) return;
    isSubmitting.value = true;
    // TODO: call clock-in API with selectedProject / selectedCostCode.
    await Future.delayed(const Duration(milliseconds: 500));
    isClockedIn.value = true;
    isSubmitting.value = false;
  }

  @override
  void onClose() {
    // Tagged controllers must be explicitly deleted by whoever put them,
    // matching the AppCalendar disposal pattern. Left here as a reminder;
    // the actual Get.delete call belongs wherever this screen is popped.
    super.onClose();
  }
}
