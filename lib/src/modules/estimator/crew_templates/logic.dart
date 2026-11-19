import 'package:get/get.dart';

import 'data/crew_mock_data.dart';
import 'models/crew_models.dart';


/// List screen state. Add/Edit happen on a pushed route that pops with the
/// finished template; the view hands it to [saveTemplate].
class CrewTemplatesLogic extends GetxController {
  final templates = <CrewTemplateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // The only place that touches mock data; swap for a repository later.
    templates.assignAll(CrewMockData.templates());
  }

  void saveTemplate(CrewTemplateModel template) {
    final i = templates.indexWhere((t) => t.id == template.id);
    if (i == -1) {
      templates.add(template);
    } else {
      templates[i] = template;
    }
  }

  void deleteTemplate(String id) => templates.removeWhere((t) => t.id == id);
}
