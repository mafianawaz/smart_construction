import 'package:get/get.dart';

import '../../data/quality_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/quality_models.dart';

/// Owns the Inspections tab: the Inspections card (Pending / Passed /
/// Failed) and the Material Testing card (Pending / In Progress / Passed /
/// Failed), each with its own status + type filters. The references show no
/// way to create either kind of record, so both lists are read-only mock
/// data for now. Put with `tag: projectId`.
class InspectionsLogic extends GetxController {
  final String projectId;
  InspectionsLogic(this.projectId);

  // API: GET /projects/{id}/inspections
  late final RxList<InspectionModel> inspections =
      QualityMockData.inspections(projectId).obs;

  // API: GET /projects/{id}/material-tests
  late final RxList<MaterialTestModel> materialTests =
      QualityMockData.materialTests(projectId).obs;

  final Rxn<InspectionStatus> inspectionStatus = Rxn<InspectionStatus>();
  final Rxn<InspectionType> inspectionType = Rxn<InspectionType>();
  final Rxn<MaterialTestStatus> testStatus = Rxn<MaterialTestStatus>();
  final Rxn<MaterialTestType> testType = Rxn<MaterialTestType>();

  /// Counts ignore the filters, so the tiles always show the full totals.
  int inspectionCount(InspectionStatus s) => inspections.where((i) => i.status == s).length;
  int testCount(MaterialTestStatus s) => materialTests.where((t) => t.status == s).length;

  /// Call inside an `Obx`.
  List<InspectionModel> get filteredInspections => inspections
      .where((i) => inspectionStatus.value == null || i.status == inspectionStatus.value)
      .where((i) => inspectionType.value == null || i.type == inspectionType.value)
      .toList();

  List<MaterialTestModel> get filteredTests => materialTests
      .where((t) => testStatus.value == null || t.status == testStatus.value)
      .where((t) => testType.value == null || t.type == testType.value)
      .toList();
}
