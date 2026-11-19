import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/tm_mock_data.dart';
import 'models/tm_models.dart';
import 'widgets/tm_widgets.dart';


/// Controller for the Daily T&M Sheet screen.
///
/// `GetBuilder` + `update()` on plain fields (same as `PricingLogic`).
/// The caller deletes tagged instances at the navigation layer.
class TmLogic extends GetxController {
  // ------------------------------------------------------------ form state
  final crewController = TextEditingController();
  final companyRepController = TextEditingController();
  final clientRepController = TextEditingController();
  final weatherController = TextEditingController();
  final descriptionController = TextEditingController();

  List<TmProject> projects = [];
  TmProject? selectedProject;
  DateTime date = DateTime.now();

  bool isLoading = true;
  bool isSubmitting = false;

  /// Errors only show after the first submit attempt.
  bool showErrors = false;

  final Map<String, List<TmSheet>> _sheetsByProject = {};

  // -------------------------------------------------------------- derived
  List<TmSheet> get recentSheets {
    final id = selectedProject?.id;
    if (id == null) return const [];
    return _sheetsByProject[id] ?? const [];
  }

  int? get _crew => int.tryParse(crewController.text.trim());

  String? get crewError {
    if (!showErrors) return null;
    final c = _crew;
    if (c == null || c <= 0) return 'Enter a valid crew size';
    if (c > 999) return 'Crew size is too large';
    return null;
  }

  String? get companyRepError =>
      showErrors && companyRepController.text.trim().isEmpty ? 'Required' : null;

  String? get clientRepError =>
      showErrors && clientRepController.text.trim().isEmpty ? 'Required' : null;

  String? get descriptionError => showErrors && descriptionController.text.trim().isEmpty
      ? 'Describe the work performed'
      : null;

  bool get isValid {
    final c = _crew;
    return selectedProject != null &&
        c != null &&
        c > 0 &&
        c <= 999 &&
        companyRepController.text.trim().isNotEmpty &&
        clientRepController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
  }

  // ------------------------------------------------------------- lifecycle
  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    crewController.dispose();
    companyRepController.dispose();
    clientRepController.dispose();
    weatherController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// Replace with real API calls (see `TmMockData`).
  Future<void> load() async {
    isLoading = true;
    update();
    projects = TmMockData.projects();
    selectedProject = projects.isEmpty ? null : projects.first;
    final d = TmMockData.defaults();
    crewController.text = '${d.crewSize}';
    companyRepController.text = d.companyRep;
    clientRepController.text = d.clientRep;
    weatherController.text = d.weather;
    descriptionController.clear();
    date = DateTime.now();
    showErrors = false;
    _loadSheets();
    isLoading = false;
    update();
  }

  void _loadSheets() {
    final id = selectedProject?.id;
    if (id == null) return;
    _sheetsByProject.putIfAbsent(id, () => List.of(TmMockData.sheetsFor(id)));
  }

  // --------------------------------------------------------------- inputs
  void selectProject(TmProject? p) {
    if (p == null || p.id == selectedProject?.id) return;
    selectedProject = p;
    _loadSheets();
    update();
  }

  void setDate(DateTime d) {
    date = DateTime(d.year, d.month, d.day);
    update();
  }

  /// Text fields call this so error text clears as the user types.
  void onFieldChanged([String? _]) => update();

  // --------------------------------------------------------------- submit
  Future<void> submit() async {
    if (isSubmitting) return;
    showErrors = true;
    if (!isValid) {
      update();
      return;
    }
    isSubmitting = true;
    update();

    // POST /projects/{id}/tm-sheets (see TmMockData)
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final project = selectedProject!;
    final sheet = TmSheet(
      id: 'tm-${DateTime.now().microsecondsSinceEpoch}',
      projectId: project.id,
      date: date,
      crewSize: _crew!,
      companyRep: companyRepController.text.trim(),
      clientRep: clientRepController.text.trim(),
      weather: weatherController.text.trim(),
      description: descriptionController.text.trim(),
      submittedAt: DateTime.now(),
    );
    _sheetsByProject.putIfAbsent(project.id, () => []).insert(0, sheet);

    // Keep crew / reps / weather for the next sheet; clear only the narrative.
    descriptionController.clear();
    showErrors = false;
    isSubmitting = false;
    update();

    if (Get.context != null) {
      Get.snackbar(
        'Daily sheet submitted',
        project.label,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> pickDate(BuildContext context,) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date.isAfter(now) ? now : date,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: TmPalette.orange),
        ),
        child: child!,
      ),
    );
    if (picked != null) setDate(picked);
  }
}
