import 'package:get/get.dart';

import 'data/cost_book_mock_data.dart';
import 'models/cost_book_models.dart';


/// Drives the Cost Book screen: providers, the selected provider's entries
/// (with search) and the geo-factor list.
class CostBookLogic extends GetxController {
  final providers = <CostBookProviderModel>[].obs;
  final entries = <CostBookEntryModel>[].obs;
  final geoFactors = <GeoFactorModel>[].obs;

  final selectedProviderId = RxnString();
  final searchQuery = ''.obs;
  final syncingProviderId = RxnString();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  // The only place that touches mock data; swap for repository calls later.
  void _load() {
    providers.assignAll(CostBookMockData.providers());
    entries.assignAll(CostBookMockData.entries());
    geoFactors.assignAll(CostBookMockData.geoFactors());
    selectedProviderId.value = providers.isEmpty ? null : providers.first.id;
  }

  /// Entries of the selected provider that match the search box.
  List<CostBookEntryModel> get visibleEntries {
    final id = selectedProviderId.value;
    final q = searchQuery.value;
    return entries.where((e) => e.providerId == id && e.matches(q)).toList();
  }

  bool get hasProviders => providers.isNotEmpty;

  void selectProvider(String id) => selectedProviderId.value = id;

  void setSearch(String value) => searchQuery.value = value;

  // ── Providers ──────────────────────────────────────────────────────────

  /// Inserts a new provider or replaces the one with the same id.
  void saveProvider(CostBookProviderModel provider) {
    final i = providers.indexWhere((p) => p.id == provider.id);
    if (i == -1) {
      providers.add(provider);
      selectedProviderId.value ??= provider.id;
    } else {
      providers[i] = provider;
    }
  }

  void deleteProvider(String id) {
    providers.removeWhere((p) => p.id == id);
    entries.removeWhere((e) => e.providerId == id);
    if (selectedProviderId.value == id) {
      selectedProviderId.value = providers.isEmpty ? null : providers.first.id;
    }
  }

  /// Stub for POST /cost-book/providers/{id}/sync — stamps "now" after a
  /// short delay so the sync button has visible feedback.
  Future<void> syncProvider(String id) async {
    if (syncingProviderId.value != null) return;
    syncingProviderId.value = id;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final i = providers.indexWhere((p) => p.id == id);
    if (i != -1) providers[i] = providers[i].copyWith(lastSynced: DateTime.now());
    syncingProviderId.value = null;
  }

  // ── Geo factors ────────────────────────────────────────────────────────

  void saveGeoFactor(GeoFactorModel factor) {
    final i = geoFactors.indexWhere((g) => g.id == factor.id);
    if (i == -1) {
      geoFactors.add(factor);
    } else {
      geoFactors[i] = factor;
    }
  }

  void deleteGeoFactor(String id) => geoFactors.removeWhere((g) => g.id == id);
}
