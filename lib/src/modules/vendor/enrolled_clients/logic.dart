import 'package:get/get.dart';

import 'data/enrolled_clients_mock_data.dart';
import 'models/client_filter.dart';
import 'models/client_organization_model.dart';


class EnrolledClientsLogic extends GetxController {
  final RxList<ClientOrganizationModel> _allClients =
      <ClientOrganizationModel>[].obs;

  final Rx<ClientFilter> selectedFilter = ClientFilter.all.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO(API): Replace with GET /vendor/pricing/enrolled-clients
    _allClients.assignAll(EnrolledClientsMockData.getEnrolledClients());
  }

  int get totalCount => _allClients.length;

  int get activeCount =>
      _allClients.where((c) => c.status == ClientOrgStatus.active).length;

  int get pendingCount =>
      _allClients.where((c) => c.status == ClientOrgStatus.pending).length;

  List<ClientOrganizationModel> get filteredClients {
    Iterable<ClientOrganizationModel> result = _allClients;

    if (selectedFilter.value == ClientFilter.active) {
      result = result.where((c) => c.status == ClientOrgStatus.active);
    } else if (selectedFilter.value == ClientFilter.pending) {
      result = result.where((c) => c.status == ClientOrgStatus.pending);
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where(
        (c) =>
            c.name.toLowerCase().contains(query) ||
            c.code.toLowerCase().contains(query),
      );
    }

    return result.toList();
  }

  void onFilterChanged(ClientFilter filter) => selectedFilter.value = filter;

  void onSearchChanged(value) => searchQuery.value = value;
}
