import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dispatch_models.dart';

/// Form state for the Assign Crew bottom sheet.
/// Closes via `Get.back(result:)` with an [AssignCrewResult], or null on cancel.
class AssignCrewLogic extends GetxController {
  AssignCrewLogic({
    required this.crew,
    required this.date,
    required this.projects,
    String? initialProjectId,
    String initialNotes = '',
  }) {
    projectId = initialProjectId;
    notesController = TextEditingController(text: initialNotes);
  }

  final Crew crew;
  final DateTime date;
  final List<DispatchProject> projects;

  late final TextEditingController notesController;
  String? projectId;
  bool submitted = false;

  String? get projectError =>
      submitted && projectId == null ? 'Select a project' : null;

  void setProject(String? id) {
    projectId = id;
    update();
  }

  void submit() {
    submitted = true;
    update();
    if (projectId == null) return;
    Get.back<AssignCrewResult>(
      result: AssignCrewResult(
        projectId: projectId!,
        notes: notesController.text.trim(),
      ),
    );
  }

  void cancel() => Get.back<AssignCrewResult>();

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
