import 'package:get/get.dart';

import 'data/executive_digest_mock_data.dart';
import 'models/executive_digest_models.dart';


/// Controller for [ExecutiveDigestView].
///
/// Uses plain fields + `update()` (GetBuilder), matching the Pricing /
/// Rollup / CFO modules.
class ExecutiveDigestLogic extends GetxController {
  DigestPeriod period = DigestPeriod.daily;
  List<DigestOrganization> organizations = [];
  bool isLoading = true;

  /// Reports keyed by `<orgId>|<period>`.
  final Map<String, DigestReport> _orgReports = {};

  /// Portfolio (cross-organization) reports keyed by period.
  final Map<DigestPeriod, DigestReport> _portfolioReports = {};

  /// `<orgId>|<period>` keys currently being generated.
  final Set<String> _generatingKeys = {};
  bool isGeneratingPortfolio = false;

  /// Organizations whose card the user collapsed. Cards open by default.
  final Set<String> _collapsedOrgIds = {};

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    organizations = await ExecutiveDigestMockData.fetchOrganizations();
    ExecutiveDigestMockData.seededDailyReports().forEach((orgId, report) {
      _orgReports[_key(orgId, DigestPeriod.daily)] = report;
    });
    isLoading = false;
    update();
  }

  // ---------------------------------------------------------------------------
  // Derived state
  // ---------------------------------------------------------------------------

  static String _key(String orgId, DigestPeriod p) => '$orgId|${p.name}';

  DigestReport? reportFor(DigestOrganization org) =>
      _orgReports[_key(org.id, period)];

  DigestReport? get portfolioReport => _portfolioReports[period];

  bool isGeneratingOrg(DigestOrganization org) =>
      _generatingKeys.contains(_key(org.id, period));

  /// True while any organization digest for the selected period is generating.
  bool get isGeneratingAny {
    final suffix = '|${period.name}';
    return _generatingKeys.any((k) => k.endsWith(suffix));
  }

  bool get hasAnyReport =>
      portfolioReport != null || organizations.any((o) => reportFor(o) != null);

  bool isExpanded(DigestOrganization org) =>
      !_collapsedOrgIds.contains(org.id);

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void selectPeriod(DigestPeriod value) {
    if (value == period) return;
    period = value;
    update();
  }

  void toggleExpanded(DigestOrganization org) {
    if (!_collapsedOrgIds.remove(org.id)) _collapsedOrgIds.add(org.id);
    update();
  }

  /// Top "Generate Now" / empty-state "Generate Digest": every organization.
  Future<void> generateAll() async {
    if (isGeneratingAny) return;
    await Future.wait(organizations.map((o) => _generateOrg(o, period)));
  }

  /// Per-organization "Generate Now" / "Generate Digest".
  Future<void> generateForOrg(DigestOrganization org) async {
    if (isGeneratingOrg(org)) return;
    await _generateOrg(org, period);
  }

  Future<void> generatePortfolio() async {
    if (isGeneratingPortfolio) return;
    final p = period;
    isGeneratingPortfolio = true;
    update();
    try {
      _portfolioReports[p] =
          await ExecutiveDigestMockData.generatePortfolio(organizations, p);
    } catch (_) {
      _showError('Could not generate the portfolio digest. Try again.');
    } finally {
      isGeneratingPortfolio = false;
      update();
    }
  }

  Future<void> _generateOrg(DigestOrganization org, DigestPeriod p) async {
    final key = _key(org.id, p);
    _generatingKeys.add(key);
    update();
    try {
      _orgReports[key] = await ExecutiveDigestMockData.generate(org, p);
    } catch (_) {
      _showError('Could not generate the digest for ${org.name}.');
    } finally {
      _generatingKeys.remove(key);
      update();
    }
  }

  void _showError(String message) {
    Get.snackbar('Digest failed', message, snackPosition: SnackPosition.BOTTOM);
  }
}
