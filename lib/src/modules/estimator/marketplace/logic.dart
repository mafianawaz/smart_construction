import 'package:get/get.dart';

import 'data/marketplace_mock_data.dart';
import 'models/marketplace_models.dart';


class MarketplaceLogic extends GetxController {
  // ── Navigation state ──────────────────────────────────────────────
  final tabIndex = 0.obs;
  final equipmentSubIndex = 0.obs;

  MarketplaceTab get tab => MarketplaceTab.values[tabIndex.value];
  EquipmentSubTab get equipmentSub =>
      EquipmentSubTab.values[equipmentSubIndex.value];

  // ── Source data ───────────────────────────────────────────────────
  final contractors = <ContractorModel>[].obs;
  final talent = <TalentModel>[].obs;
  final crews = <CrewModel>[].obs;
  final equipment = <EquipmentModel>[].obs;
  final requests = <RentalRequestModel>[].obs;
  final pipeline = <PipelineCandidate>[].obs;
  final jobs = <JobOption>[];

  // ── Contractor filters ────────────────────────────────────────────
  final contractorQuery = ''.obs;
  final contractorTrade = 'All Trades'.obs;
  final contractorLocation = 'Location'.obs;
  final contractorRating = 'Any Rating'.obs;

  // ── Talent filters ────────────────────────────────────────────────
  final talentQuery = ''.obs;
  final talentTrade = 'All Trades'.obs;
  final talentAvailability = 'All Availability'.obs;
  final talentRating = 'Any Rating'.obs;
  final talentSort = 'Newest First'.obs;
  final talentLocation = ''.obs;
  final talentSkill = ''.obs;
  final talentCert = ''.obs;

  // ── Crew filters ──────────────────────────────────────────────────
  final crewQuery = ''.obs;
  final crewTrade = 'All Trades'.obs;
  final crewStatus = 'All Status'.obs;
  final crewFrom = Rxn<DateTime>();
  final crewTo = Rxn<DateTime>();

  // ── Equipment browse filters ──────────────────────────────────────
  final equipmentCity = ''.obs;
  final equipmentCategory = 'All Categories'.obs;
  final equipmentMinRate = ''.obs;
  final equipmentMaxRate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Replace with real API calls (see MarketplaceMockData comments).
    contractors.assignAll(MarketplaceMockData.contractors());
    talent.assignAll(MarketplaceMockData.talent());
    crews.assignAll(MarketplaceMockData.crews());
    equipment.assignAll(MarketplaceMockData.equipment());
    requests.assignAll(MarketplaceMockData.rentalRequests());
    jobs.addAll(MarketplaceMockData.jobs());
  }

  // ── Derived lists ─────────────────────────────────────────────────
  static double _minRating(String label) {
    switch (label) {
      case '4.0+':
        return 4.0;
      case '4.5+':
        return 4.5;
      default:
        return 0;
    }
  }

  static bool _isDefault(String v, String def) => v == def;

  List<ContractorModel> get filteredContractors {
    final q = contractorQuery.value.trim().toLowerCase();
    final min = _minRating(contractorRating.value);
    return contractors.where((c) {
      if (q.isNotEmpty &&
          !c.name.toLowerCase().contains(q) &&
          !c.description.toLowerCase().contains(q)) {
        return false;
      }
      if (!_isDefault(contractorTrade.value, 'All Trades') &&
          c.trade != contractorTrade.value) {
        return false;
      }
      if (!_isDefault(contractorLocation.value, 'Location') &&
          c.location != contractorLocation.value) {
        return false;
      }
      return c.rating >= min;
    }).toList();
  }

  List<TalentModel> get filteredTalent {
    final q = talentQuery.value.trim().toLowerCase();
    final loc = talentLocation.value.trim().toLowerCase();
    final skill = talentSkill.value.trim().toLowerCase();
    final cert = talentCert.value.trim().toLowerCase();
    final min = _minRating(talentRating.value);
    final list = talent.where((t) {
      if (q.isNotEmpty &&
          !t.name.toLowerCase().contains(q) &&
          !t.trade.toLowerCase().contains(q) &&
          !t.skills.any((s) => s.toLowerCase().contains(q))) {
        return false;
      }
      if (!_isDefault(talentTrade.value, 'All Trades') &&
          t.trade != talentTrade.value) {
        return false;
      }
      if (talentAvailability.value == 'Available' && !t.available) return false;
      if (talentAvailability.value == 'Unavailable' && t.available) return false;
      if (loc.isNotEmpty && !t.location.toLowerCase().contains(loc)) {
        return false;
      }
      if (skill.isNotEmpty &&
          !t.skills.any((s) => s.toLowerCase().contains(skill))) {
        return false;
      }
      if (cert.isNotEmpty &&
          !t.certifications.any((s) => s.toLowerCase().contains(cert))) {
        return false;
      }
      return t.rating >= min;
    }).toList();
    switch (talentSort.value) {
      case 'Rate: Low to High':
        list.sort((a, b) => a.rateMin.compareTo(b.rateMin));
        break;
      case 'Rate: High to Low':
        list.sort((a, b) => b.rateMax.compareTo(a.rateMax));
        break;
      default:
        list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    }
    return list;
  }

  List<CrewModel> get filteredCrews {
    final q = crewQuery.value.trim().toLowerCase();
    return crews.where((c) {
      if (q.isNotEmpty && !c.location.toLowerCase().contains(q)) return false;
      if (!_isDefault(crewTrade.value, 'All Trades') &&
          c.trade != crewTrade.value) {
        return false;
      }
      if (crewStatus.value == 'Available' && !c.available) return false;
      if (crewStatus.value == 'Unavailable' && c.available) return false;
      return true;
    }).toList();
  }

  /// Browse = everything that is not the user's own listing.
  List<EquipmentModel> get browseEquipment {
    final city = equipmentCity.value.trim().toLowerCase();
    final min = double.tryParse(equipmentMinRate.value.trim());
    final max = double.tryParse(equipmentMaxRate.value.trim());
    return equipment.where((e) {
      if (city.isNotEmpty && !e.location.toLowerCase().contains(city)) {
        return false;
      }
      if (!_isDefault(equipmentCategory.value, 'All Categories') &&
          e.category != equipmentCategory.value) {
        return false;
      }
      if (min != null && e.dailyRate < min) return false;
      if (max != null && e.dailyRate > max) return false;
      return e.isActive;
    }).toList();
  }

  List<EquipmentModel> get myListings => equipment
      .where((e) => e.ownerOrg == MarketplaceMockData.currentOrg)
      .toList();

  List<RentalRequestModel> get myRequests =>
      requests.where((r) => r.isMine).toList();

  List<RentalRequestModel> incomingFor(String equipmentId) => requests
      .where((r) => r.equipmentId == equipmentId && !r.isMine)
      .toList();

  EquipmentModel? equipmentById(String id) {
    for (final e in equipment) {
      if (e.id == id) return e;
    }
    return null;
  }

  // ── Mutations ─────────────────────────────────────────────────────
  void resetFiltersForTab() {
    switch (tab) {
      case MarketplaceTab.contractor:
        contractorQuery.value = '';
        contractorTrade.value = 'All Trades';
        contractorLocation.value = 'Location';
        contractorRating.value = 'Any Rating';
        break;
      default:
        break;
    }
  }

  void connect(ContractorModel c) {
    // POST /marketplace/contractors/{id}/connect
    Get.snackbar('Connection requested', 'Sent to ${c.name}');
  }

  /// POST /pipeline  { talentId, jobId? }
  void recruit(TalentModel t, JobOption? job) {
    pipeline.add(PipelineCandidate(
      talentId: t.id,
      talentName: t.name,
      jobId: job?.id,
    ));
    Get.snackbar('Added to pipeline', '${t.name} is now a candidate');
  }

  bool isInPipeline(String talentId) =>
      pipeline.any((p) => p.talentId == talentId);

  void saveListing(EquipmentModel model, {required bool isNew}) {
    // isNew ? POST /marketplace/equipment : PUT /marketplace/equipment/{id}
    if (isNew) {
      equipment.add(model);
    } else {
      final i = equipment.indexWhere((e) => e.id == model.id);
      if (i != -1) equipment[i] = model;
    }
  }

  void deleteListing(String id) {
    // DELETE /marketplace/equipment/{id}
    equipment.removeWhere((e) => e.id == id);
    requests.removeWhere((r) => r.equipmentId == id);
  }

  void respondToRequest(String requestId, RentalRequestStatus status) {
    // PATCH /marketplace/equipment/requests/{id}
    final i = requests.indexWhere((r) => r.id == requestId);
    if (i != -1) requests[i] = requests[i].copyWith(status: status);
  }
}
