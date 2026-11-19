import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/account_settings_data.dart';
import 'models/account_settings_models.dart';

/// Single controller for the whole Account Settings module — same pattern
/// as Calculator's `CalculatorLogic`: one `GetxController`, one clearly
/// delimited region per tab, wired up once in [onInit] / [onClose].
class AccountSettingsLogic extends GetxController {
  // ============================================================
  // Tabs
  // ============================================================
  AccountSettingsTab selectedTab = AccountSettingsTab.profile;
  SkillsSubTab selectedSkillsSubTab = SkillsSubTab.skills;

  void changeTab(AccountSettingsTab tab) {
    if (selectedTab == tab) return;
    selectedTab = tab;
    update();
  }

  void changeSkillsSubTab(SkillsSubTab tab) {
    if (selectedSkillsSubTab == tab) return;
    selectedSkillsSubTab = tab;
    update();
  }

  // ============================================================
  // Profile
  // ============================================================
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  // Read-only, set by the org/role assignment elsewhere in the app.
  final TextEditingController roleController = TextEditingController();
  final TextEditingController accessLevelController = TextEditingController();

  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();
  final TextEditingController emergencyEmailController = TextEditingController();
  final TextEditingController emergencyAddressController = TextEditingController();
  final TextEditingController profileDescriptionController = TextEditingController();

  /// Placeholder for a picked avatar image path — wire up an image picker
  /// here when ready (`image_picker` package or similar).
  String? avatarImagePath;
  bool profileSaving = false;

  void pickAvatarImage() {
    // TODO: integrate image_picker; set avatarImagePath from the result.
    update();
  }

  Future<void> saveProfile() async {
    profileSaving = true;
    update();
    // TODO: PUT /account/profile with the fields above.
    await Future.delayed(const Duration(milliseconds: 600));
    profileSaving = false;
    update();
  }

  // ============================================================
  // Security
  // ============================================================
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  String? passwordError;
  bool passwordSaving = false;

  bool faceLockEnabled = true;
  bool twoFactorEnabled = true;

  void toggleCurrentPasswordVisible() {
    currentPasswordVisible = !currentPasswordVisible;
    update();
  }

  void toggleNewPasswordVisible() {
    newPasswordVisible = !newPasswordVisible;
    update();
  }

  void toggleConfirmPasswordVisible() {
    confirmPasswordVisible = !confirmPasswordVisible;
    update();
  }

  void toggleFaceLock(bool value) {
    faceLockEnabled = value;
    update();
    // TODO: PATCH /account/security { faceLockEnabled }
  }

  void toggleTwoFactor(bool value) {
    twoFactorEnabled = value;
    update();
    // TODO: PATCH /account/security { twoFactorEnabled }
  }

  /// Basic password-policy check: 8+ chars, upper, lower, digit, symbol.
  bool _meetsPasswordPolicy(String value) {
    final hasUpper = value.contains(RegExp(r'[A-Z]'));
    final hasLower = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSymbol = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]'));
    return value.length >= 8 && hasUpper && hasLower && hasDigit && hasSymbol;
  }

  Future<void> changePassword() async {
    final current = currentPasswordController.text;
    final next = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      passwordError = 'Please fill in all password fields';
      update();
      return;
    }
    if (!_meetsPasswordPolicy(next)) {
      passwordError = 'Password must include uppercase, lowercase, number, and special character';
      update();
      return;
    }
    if (next != confirm) {
      passwordError = 'New password and confirmation do not match';
      update();
      return;
    }

    passwordError = null;
    passwordSaving = true;
    update();
    // TODO: POST /account/change-password { current, next }
    await Future.delayed(const Duration(milliseconds: 600));
    passwordSaving = false;
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    update();
  }

  // ============================================================
  // Alerts
  // ============================================================
  bool failureAlertsEnabled = true;

  final Map<String, bool> channelToggles = {
    for (final c in AccountSettingsData.deliveryChannels) c.id: c.id != 'teams' && c.id != 'slack',
  };

  CrmReminderFrequency crmReminderFrequency = CrmReminderFrequency.off;
  bool integrationSyncEnabled = true;

  final Map<String, bool> inAppAlertToggles = {
    'swpppOverdue': true,
    'deadlineWarning': true,
    'dailyProgressLogged': false,
    'reminder': true,
  };

  bool alertsSaving = false;

  void toggleFailureAlerts(bool value) {
    failureAlertsEnabled = value;
    update();
  }

  void toggleChannel(String id, bool value) {
    channelToggles[id] = value;
    update();
  }

  void setCrmReminderFrequency(CrmReminderFrequency frequency) {
    crmReminderFrequency = frequency;
    update();
  }

  void toggleIntegrationSync(bool value) {
    integrationSyncEnabled = value;
    update();
  }

  void toggleInAppAlert(String key, bool value) {
    inAppAlertToggles[key] = value;
    update();
  }

  Future<void> saveAlertPreferences() async {
    alertsSaving = true;
    update();
    // TODO: PUT /account/notification-preferences with all toggles above.
    await Future.delayed(const Duration(milliseconds: 600));
    alertsSaving = false;
    update();
  }

  // ============================================================
  // Skills
  // ============================================================
  final TextEditingController skillSearchController = TextEditingController();
  final List<String> addedSkills = [];

  List<String> get filteredSkillSuggestions {
    final query = skillSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return AccountSettingsData.skillSuggestions
        .where((s) => s.toLowerCase().contains(query) && !addedSkills.contains(s))
        .toList();
  }

  void addSkill(skill) {
    final trimmed = skill.trim();
    if (trimmed.isEmpty || addedSkills.contains(trimmed)) return;
    addedSkills.add(trimmed);
    skillSearchController.clear();
    update();
    // TODO: POST /account/skills { skill: trimmed }
  }

  void removeSkill(String skill) {
    addedSkills.remove(skill);
    update();
    // TODO: DELETE /account/skills/{skill}
  }

  // ============================================================
  // Certifications
  // ============================================================
  final List<CertificationEntry> certifications = [];

  final TextEditingController newCertNameController = TextEditingController();

  final Rx<DateTime?> newCertIssueDate = Rx<DateTime?>(null);
  final Rx<DateTime?> newCertExpiryDate = Rx<DateTime?>(null);

  Future<void> pickNewCertificateDate(
      BuildContext context,
      ) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      newCertIssueDate.value ?? now,
      firstDate: DateTime(
        now.year - 1,
      ),
      lastDate: DateTime(
        now.year + 5,
      ),
    );

    if (picked == null) return;

    setNewCertIssueDate(picked);
  }

  Future<void> pickNewCertificateExpiryDate(BuildContext context,) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: newCertExpiryDate.value ?? newCertIssueDate.value ?? now,
      firstDate: newCertIssueDate.value ?? DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5,),
    );

    if (picked == null) return;

    setNewCertExpiryDate(picked);
  }
  String? newCertUploadedFileName;

  void setNewCertIssueDate(DateTime? date) {
    newCertIssueDate.value = date;
    update();
  }

  void setNewCertExpiryDate(DateTime? date) {
    newCertExpiryDate.value = date;
    update();
  }

  void pickCertificationFile() {
    // TODO: integrate file_picker; set newCertUploadedFileName from result.
    newCertUploadedFileName = 'certificate.pdf';
    update();
  }

  void addCertification() {
    final name = newCertNameController.text.trim();
    if (name.isEmpty) return;

    final entry = CertificationEntry(
      id: 'cert_${DateTime.now().microsecondsSinceEpoch}',
      issueDate: newCertIssueDate.value,
      expiryDate: newCertExpiryDate.value,
      uploadedFileName: newCertUploadedFileName,
    );
    entry.nameController.text = name;
    certifications.add(entry);

    newCertNameController.clear();
    newCertIssueDate.value = null;
    newCertExpiryDate.value = null;
    newCertUploadedFileName = null;
    update();
    // TODO: POST /account/certifications (multipart, with the uploaded file)
  }

  void removeCertification(String id) {
    CertificationEntry? entry;
    for (final c in certifications) {
      if (c.id == id) {
        entry = c;
        break;
      }
    }
    if (entry == null) return;
    certifications.remove(entry);
    entry.dispose();
    update();
    // TODO: DELETE /account/certifications/{id}
  }

  // ============================================================
  // Equipment
  // ============================================================
  final TextEditingController equipmentSearchController = TextEditingController();
  final List<String> addedEquipment = [];

  List<String> get filteredEquipmentSuggestions {
    final query = equipmentSearchController.text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return AccountSettingsData.equipmentSuggestions
        .where((e) => e.toLowerCase().contains(query) && !addedEquipment.contains(e))
        .toList();
  }

  void addEquipment(equipment) {
    final trimmed = equipment.trim();
    if (trimmed.isEmpty || addedEquipment.contains(trimmed)) return;
    addedEquipment.add(trimmed);
    equipmentSearchController.clear();
    update();
    // TODO: POST /account/equipment { equipment: trimmed }
  }

  void removeEquipment(String equipment) {
    addedEquipment.remove(equipment);
    update();
    // TODO: DELETE /account/equipment/{equipment}
  }

  // ============================================================
  // Privacy
  // ============================================================
  bool exportingData = false;
  bool requestingDeactivation = false;
  late List<ActivityLogEntry> activityLog;

  Future<void> exportAccountData() async {
    exportingData = true;
    update();
    // TODO: POST /account/export-data, then hand the returned file/URL to
    // the platform's share/download sheet.
    await Future.delayed(const Duration(seconds: 1));
    exportingData = false;
    update();
  }

  Future<void> requestAccountDeactivation() async {
    requestingDeactivation = true;
    update();
    // TODO: POST /account/deactivate — the caller (widget) is responsible
    // for confirming with the user before calling this.
    await Future.delayed(const Duration(milliseconds: 600));
    requestingDeactivation = false;
    update();
  }

  // ============================================================
  // Lifecycle
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    activityLog = AccountSettingsData.mockActivityLog(DateTime.now());
    skillSearchController.addListener(update);
    equipmentSearchController.addListener(update);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    organizationController.dispose();
    emergencyContactNameController.dispose();
    emergencyPhoneController.dispose();
    emergencyEmailController.dispose();
    emergencyAddressController.dispose();
    profileDescriptionController.dispose();

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    skillSearchController.dispose();
    newCertNameController.dispose();
    for (final entry in certifications) {
      entry.dispose();
    }
    equipmentSearchController.dispose();

    super.onClose();
  }
}
