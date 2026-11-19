import 'package:get/get.dart';

import 'data/daily_digest_mock_data.dart';
import 'models/daily_digest_models.dart';


/// Controller for the Daily Digest screen.
///
/// GetBuilder + update() on plain fields (same pattern as PricingLogic /
/// AiAgentsLogic). Create with
/// `GetBuilder<DailyDigestLogic>(init: DailyDigestLogic(), ...)`.
class DailyDigestLogic extends GetxController {
  DailyDigest? digest;
  bool isLoading = true;

  DateTime selectedDate = DailyDigestMockData.today;
  String selectedRole = DailyDigestMockData.ownRoleLabel;

  final Set<String> _acknowledged = <String>{};
  final Map<String, int> _snoozed = <String, int>{};

  @override
  void onInit() {
    super.onInit();
    load();
  }

  // ── derived state ──────────────────────────────────────────────────────

  bool get isAdmin => DailyDigestMockData.isAdmin;
  DateTime get today => DailyDigestMockData.today;
  DateTime get earliestDate =>
      today.subtract(const Duration(days: DailyDigestMockData.historyDays));
  List<String> get roleOptions => DailyDigestMockData.roleOptions;

  /// Items that haven't been snoozed away, in ranked order.
  List<DigestItem> get visibleItems {
    final d = digest;
    if (d == null) return const [];
    return d.items
        .where((i) => !_snoozed.containsKey(i.id))
        .toList(growable: false);
  }

  List<DigestConflict> get conflicts => digest?.conflicts ?? const [];

  /// The "37" in "Top 10 of 37" — drops by one per snoozed item.
  int get totalCount => (digest?.totalCount ?? 0) - _snoozed.length;

  /// The "10" in "Top 10 of 37" (never more than what's left).
  int get shownCount {
    final cap = digest?.roleCap ?? 0;
    return totalCount < cap ? totalCount : cap;
  }

  /// Cap reached → show the "See all N in AI Flags & Conflicts" link.
  bool get capReached => totalCount > (digest?.roleCap ?? 0);

  /// "Nothing needs you today" state.
  bool get isNothingToday => visibleItems.isEmpty && conflicts.isEmpty;

  bool isAcknowledged(String id) => _acknowledged.contains(id);

  // ── loading ────────────────────────────────────────────────────────────

  Future<void> load() async {
    isLoading = true;
    update();
    _acknowledged.clear();
    _snoozed.clear();
    digest = await DailyDigestMockData.fetchDigest(
      date: selectedDate,
      role: selectedRole,
    );
    isLoading = false;
    update();
  }

  Future<void> setDate(DateTime date) async {
    selectedDate = date;
    await load();
  }

  Future<void> setRole(String role) async {
    if (role == selectedRole) return;
    selectedRole = role;
    await load();
  }

  // ── item / conflict actions ────────────────────────────────────────────

  void acknowledge(String id) {
    if (_acknowledged.add(id)) update();
    // TODO(api): POST /ai-agents/flags/{id}/ack
  }

  /// Snooze options are 1 / 3 / 7 days.
  void snooze(DigestItem item, int days) {
    _snoozed[item.id] = days;
    update();
    // TODO(api): POST /ai-agents/flags/{id}/snooze  { days }
    Get.snackbar(
      'Snoozed',
      '"${item.title}" is hidden for $days day${days == 1 ? '' : 's'}.',
    );
  }

  void openItem(DigestItem item) {
    // TODO(nav): open the flag detail in AI Flags & Conflicts (G-05).
    Get.snackbar('Open', 'Flag detail (G-05) is not built yet.');
  }

  void openConflict(DigestConflict conflict) {
    // TODO(nav): open the conflict detail in AI Flags & Conflicts (G-05).
    Get.snackbar('Open', 'Conflict detail (G-05) is not built yet.');
  }

  void assign(String id) {
    // TODO(nav): assignee picker, then POST /ai-agents/flags/{id}/assign
    Get.snackbar('Assign', 'Assignee picker is not built yet.');
  }

  void openBasis(DigestItem item) {
    // TODO(nav): open the source record behind the citation.
    Get.snackbar('Basis', item.basis);
  }

  void updateProgress() {
    // TODO(nav): open the stale project's schedule → progress update.
    Get.snackbar('Update progress', 'Project progress update is not wired yet.');
  }

  void seeAllFlags() {
    // TODO(nav): push AI Flags & Conflicts (G-05).
    Get.snackbar('AI Flags & Conflicts', 'Screen (G-05) is not built yet.');
  }
}
