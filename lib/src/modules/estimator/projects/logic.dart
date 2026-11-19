import 'package:get/get.dart';
import 'package:smart_construction/src/modules/estimator/projects/project_detail/view.dart';

import 'data/projects_mock_data.dart';
import 'models/project_enums.dart';
import 'models/project_model.dart';

/// 0 = Table, 1 = Calendar, 2 = Map — matches the reference's 3-way toggle.
class ProjectsLogic extends GetxController {
  final selectedView = 0.obs;
  onViewChange(index) => selectedView.value = index;

  final projects = <ProjectModel>[].obs;
  final searchQuery = ''.obs;

  /// null = "All Statuses".
  final Rx<ProjectStatus?> statusFilter = Rx<ProjectStatus?>(null);

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects
    projects.assignAll(ProjectsMockData.allProjects());
  }

  void onSearch(value) => searchQuery.value = value.trim().toLowerCase();

  void setStatusFilter(ProjectStatus? status) => statusFilter.value = status;

  List<ProjectModel> get filteredProjects => projects
      .where((p) => p.matchesQuery(searchQuery.value))
      .where((p) => statusFilter.value == null || p.status == statusFilter.value)
      .toList();

  void openProject(ProjectModel project) => Get.to(
        () => ProjectDetailView(project: project),
        routeName: '/projects/${project.id}',
      );
}
