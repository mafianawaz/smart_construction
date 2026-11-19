import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/time_clock_mock_data.dart';
import 'models/time_clock_models.dart';


/// Controller for the Time Clock Management screen.
///
/// Uses `GetBuilder` + `update()` on plain fields (same pattern as
/// `PricingLogic` / `InventoryLogic`).
class TimeClockLogic extends GetxController {
  TimeClockLogic();

  // ---------------------------------------------------------------- state
  TimeClockTab currentTab = TimeClockTab.liveMonitoring;

  List<ActiveShift> _activeShifts = [];
  List<PendingShift> _pendingShifts = [];
  List<OvertimeRequest> _overtimeRequests = [];
  int pendingEntries = 0;

  bool isLoading = true;

  // Per-tab search (each tab keeps its own query + open/closed state).
  bool liveSearchOpen = false;
  bool shiftSearchOpen = false;
  String liveQuery = '';
  String shiftQuery = '';
  String otQuery = '';

  // --------------------------------------------------------------- derived
  int get activeCount => _activeShifts.length;
  int get pendingShiftCount => _pendingShifts.length;
  int get pendingOtCount => _overtimeRequests.length;
  int get totalPending => pendingShiftCount + pendingEntries + pendingOtCount;

  List<ActiveShift> get activeShifts {
    final q = liveQuery.trim().toLowerCase();
    if (q.isEmpty) return _activeShifts;
    return _activeShifts
        .where((s) =>
            s.employeeName.toLowerCase().contains(q) ||
            s.location.toLowerCase().contains(q) ||
            s.employeeId.toLowerCase().contains(q))
        .toList();
  }

  List<PendingShift> get pendingShifts {
    final q = shiftQuery.trim().toLowerCase();
    if (q.isEmpty) return _pendingShifts;
    return _pendingShifts
        .where((s) =>
            s.employeeName.toLowerCase().contains(q) ||
            s.projectLabel.toLowerCase().contains(q) ||
            s.employeeId.toLowerCase().contains(q))
        .toList();
  }

  List<OvertimeRequest> get overtimeRequests {
    final q = otQuery.trim().toLowerCase();
    if (q.isEmpty) return _overtimeRequests;
    return _overtimeRequests
        .where((r) =>
            r.employeeName.toLowerCase().contains(q) ||
            r.location.toLowerCase().contains(q))
        .toList();
  }

  // ------------------------------------------------------------- lifecycle
  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Replace with real API calls (see `TimeClockMockData`).
  Future<void> load() async {
    isLoading = true;
    update();
    _activeShifts = TimeClockMockData.activeShifts();
    _pendingShifts = TimeClockMockData.pendingShifts();
    _overtimeRequests = TimeClockMockData.overtimeRequests();
    pendingEntries = TimeClockMockData.pendingTimeEntryCount();
    isLoading = false;
    update();
  }

  // ------------------------------------------------------------------ tabs
  void selectTab(TimeClockTab tab) {
    if (tab == currentTab) return;
    currentTab = tab;
    update();
  }

  // ---------------------------------------------------------------- search
  void toggleLiveSearch() {
    liveSearchOpen = !liveSearchOpen;
    if (!liveSearchOpen) liveQuery = '';
    update();
  }

  void toggleShiftSearch() {
    shiftSearchOpen = !shiftSearchOpen;
    if (!shiftSearchOpen) shiftQuery = '';
    update();
  }

  void setLiveQuery(v) {
    liveQuery = v;
    update();
  }

  void setShiftQuery(v) {
    shiftQuery = v;
    update();
  }

  void setOtQuery(v) {
    otQuery = v;
    update();
  }

  // --------------------------------------------------------- shift actions
  PendingShift? _shiftById(String id) {
    for (final s in _pendingShifts) {
      if (s.id == id) return s;
    }
    return null;
  }

  void approveShift(String id) {
    final shift = _shiftById(id);
    if (shift == null) return;
    // POST /time-clock/shifts/{id}/approve
    _pendingShifts.removeWhere((s) => s.id == id);
    update();
    _toast('Shift approved', '${shift.employeeName} · ${shift.projectLabel}');
  }

  /// "Adapt": the supervisor corrects the punch times, which approves the
  /// shift with the adjusted values.
  void adaptShift(String id, DateTime clockIn, DateTime clockOut) {
    final shift = _shiftById(id);
    if (shift == null) return;
    // POST /time-clock/shifts/{id}/adjust { clockIn, clockOut }
    _pendingShifts.removeWhere((s) => s.id == id);
    update();
    final adjusted = shift.copyWith(clockIn: clockIn, clockOut: clockOut);
    _toast('Shift adjusted & approved',
        '${shift.employeeName} · ${adjusted.duration.inHours}h ${adjusted.duration.inMinutes.remainder(60)}m');
  }

  void rejectShift(String id, String reason) {
    final shift = _shiftById(id);
    if (shift == null) return;
    // POST /time-clock/shifts/{id}/reject { reason }
    _pendingShifts.removeWhere((s) => s.id == id);
    update();
    _toast('Shift rejected', shift.employeeName);
  }

  // ------------------------------------------------------------ OT actions
  void approveOvertime(String id) {
    final idx = _overtimeRequests.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _overtimeRequests.removeAt(idx);
    // POST /time-clock/overtime-requests/{id}/approve
    update();
    _toast('Overtime approved', '${r.employeeName} · +${r.overtimeHours.toStringAsFixed(1)}h');
  }

  void rejectOvertime(String id, String reason) {
    final idx = _overtimeRequests.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _overtimeRequests.removeAt(idx);
    // POST /time-clock/overtime-requests/{id}/reject { reason }
    update();
    _toast('Overtime rejected', r.employeeName);
  }

  // ------------------------------------------------------------ navigation
  /// Hook for the "Go to Time Entry Management" button. Not wired: swap in
  /// the real route (`Get.toNamed(...)`) once that page exists.
  void openTimeEntryManagement() {
    _toast('Time Entry Management', 'Route not wired yet');
  }

  void _toast(String title, String message) {
    if (Get.context == null) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
