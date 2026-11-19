import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/location_models.dart';
import 'add_location_view.dart';

/// Owns the Location tab. Locations live in `ProjectWorkStore`.
/// Put with `tag: projectId`.
class LocationLogic extends GetxController {
  final String projectId;
  LocationLogic(this.projectId);

  RxList<LocationModel> get locations => ProjectWorkStore.to.locations(projectId);

  /// Ordered Building -> Floor -> Room -> Zone, then by name. Reads
  /// [locations] — call inside an `Obx`.
  List<LocationModel> get orderedLocations {
    final list = locations.toList();
    list.sort((a, b) {
      final byLevel = a.level.index.compareTo(b.level.index);
      return byLevel != 0 ? byLevel : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }

  void openAddLocation() => Get.to(
        () => AddLocationView(projectId: projectId),
        routeName: '/location/add',
      );
}
