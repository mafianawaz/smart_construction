import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/create_bid_mock_data.dart';
import '../logic.dart';
import '../models/bid_draft_model.dart';
import '../models/create_bid_enums.dart';
import '../models/scope_item_model.dart';
import '../views/ai_document_analysis_view.dart';
import '../views/bid_details_review_view.dart';
import '../views/confirm_scope_view.dart';
import '../views/manual_bid_entry_view.dart';
import '../views/review_scope_items_view.dart';
import '../views/upload_documents_view.dart';

/// Route names for every wizard screen. All start with [kWizardPrefix]
/// so [CreateBidLogic._popWizard] can unwind the whole flow with one
/// `Get.until`, no matter how many screens the user has stacked or
/// backed out of.
const String kWizardPrefix = '/create-bid';
const String kRouteInfo = '$kWizardPrefix/info';
const String kRouteUpload = '$kWizardPrefix/upload';
const String kRouteAiScan = '$kWizardPrefix/ai-scan';
const String kRouteConfirmScope = '$kWizardPrefix/confirm-scope';
const String kRouteManualEntry = '$kWizardPrefix/manual-entry';
const String kRouteReviewScope = '$kWizardPrefix/review-scope';
const String kRouteDetails = '$kWizardPrefix/details';

/// Owns both Create Bid flows (see [CreateBidFlow]). One instance lives
/// for the whole wizard; [CreateBidWizard.start] puts it and the root
/// screen's dispose deletes it.
///
/// AI flow:     Details -> Upload -> AI Scan -> Scope (Create Bid)
/// Manual flow: Info -> Scope -> Details (Create Bid)
///
/// Every method marked `// API:` is a mock-data seam.
class CreateBidLogic extends GetxController {
  final Rx<CreateBidFlow> flow = CreateBidFlow.ai.obs;
  final Rx<AiAnalysisStatus> aiStatus = AiAnalysisStatus.idle.obs;

  final RxnString uploadedFileName = RxnString();
  final RxList<ScopeItemModel> scopeItems = <ScopeItemModel>[].obs;
  final RxBool isSubmitting = false.obs;

  /// Demo switch so the failed state can be shown on demand. A real
  /// implementation just lets the request throw.
  bool forceAiFailure = false;

  // Bid Details
  final bidNameCtrl = TextEditingController();
  final Rx<DateTime?> bidDate = Rx<DateTime?>(null);

  // CRM Integration (Details step, manual flow)
  final RxnString crmContactOrg = RxnString();
  final RxnString crmOrgStatus = RxnString();

  // Client details
  final orgNameCtrl = TextEditingController();
  final contactNameCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final estimatedAmountCtrl = TextEditingController();

  // Project location
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final locationNotesCtrl = TextEditingController();
  final keywordsCtrl = TextEditingController();

  // Manual Bid Entry step
  final manualScopeCtrl = TextEditingController();

  // Inline "Add Custom Scope Item" row
  final quickDescCtrl = TextEditingController();
  final quickQtyCtrl = TextEditingController();
  final quickUnitCtrl = TextEditingController();

  int get aiSuggestedCount => scopeItems.where((i) => i.isAiSuggested).length;
  int get selectedCount => scopeItems.where((i) => i.isIncluded).length;
  bool get hasScopeItems => scopeItems.isNotEmpty;

  BidEntryMethod get entryMethod =>
      flow.value == CreateBidFlow.ai && aiStatus.value == AiAnalysisStatus.success
          ? BidEntryMethod.aiDocuments
          : BidEntryMethod.manual;

  // ---- Navigation helpers -------------------------------------------

  void _push(Widget page, String route) =>
      Get.to(() => page, routeName: route);

  void _popWizard() =>
      Get.until((r) => !(r.settings.name ?? '').startsWith(kWizardPrefix));

  /// Leaves the wizard from any step (used by the close/cancel paths).
  void cancelWizard() => _popWizard();

  // ---- Validation -----------------------------------------------------

  /// Same rule for both flows; the AI flow checks it when leaving the
  /// Details step, the manual flow when pressing Create Bid.
  List<String> get missingRequired {
    final missing = <String>[];
    if (bidNameCtrl.text.trim().isEmpty) missing.add('Bid Name');
    if (orgNameCtrl.text.trim().isEmpty) missing.add('Client Name');
    if (contactEmailCtrl.text.trim().isEmpty) missing.add('Contact Email');
    if (addressCtrl.text.trim().isEmpty) missing.add('Address');
    return missing;
  }

  bool _validateOrWarn() {
    final missing = missingRequired;
    if (missing.isEmpty) return true;
    Get.snackbar('Missing details', 'Please fill in: ${missing.join(', ')}');
    return false;
  }

  // ---- Bid Date / CRM ---------------------------------------------------

  void setBidDate(DateTime d) => bidDate.value = d;

  // API: GET /crm/contacts/{id}
  void useSavedContact() {
    final c = CreateBidMockData.savedContact();
    orgNameCtrl.text = c[0];
    contactNameCtrl.text = c[1];
    contactEmailCtrl.text = c[2];
    contactPhoneCtrl.text = c[3];
  }

  // ---- AI flow ------------------------------------------------------------

  /// Details -> Upload
  void continueFromInfo() {
    if (!_validateOrWarn()) return;
    _push(const UploadDocumentsView(), kRouteUpload);
  }

  /// Stand-in for a file picker result. Wire to `file_picker` (or the
  /// package the app settles on) — flagged in NOTES_BIDS.md.
  void pickDocument() {
    uploadedFileName.value = 'bid_documents.pdf';
  }

  /// Upload -> AI Scan
  void goToAiAnalysis() {
    _push(const AiDocumentAnalysisView(), kRouteAiScan);
    analyzeDocuments(forceFail: forceAiFailure);
  }

  /// "Skip AI Analysis" on Upload, "Skip To Scope" on AI Scan.
  void skipToScope() {
    aiStatus.value = AiAnalysisStatus.skipped;
    _push(const ConfirmScopeView(), kRouteConfirmScope);
  }

  // API: POST /bids/analyze-documents (multipart: uploadedFileName)
  Future<void> analyzeDocuments({bool forceFail = false}) async {
    aiStatus.value = AiAnalysisStatus.analyzing;
    try {
      final items = await CreateBidMockData.simulateAnalysis(
        forceFail: forceFail,
      );
      scopeItems.assignAll(items);
      aiStatus.value = AiAnalysisStatus.success;
      // Only advance if the user is still looking at the AI Scan screen.
      if (Get.currentRoute == kRouteAiScan) {
        Get.off(() => const ConfirmScopeView(), routeName: kRouteConfirmScope);
      }
    } catch (_) {
      aiStatus.value = AiAnalysisStatus.failed;
    }
  }

  void retryAnalysis() => analyzeDocuments(forceFail: forceAiFailure);

  /// AI Scan failure -> "Manual Entry": switch to the manual flow.
  void switchToManualFlow() {
    flow.value = CreateBidFlow.manual;
    _push(const ManualBidEntryView(), kRouteManualEntry);
  }

  // ---- Manual flow ----------------------------------------------------

  /// Manual Bid Entry -> Review Scope Items. A typed scope description
  /// becomes one scope item; the user can split/edit it on the next screen.
  void submitManualEntry({required String projectName}) {
    if (projectName.isNotEmpty) bidNameCtrl.text = projectName;
    final text = manualScopeCtrl.text.trim();
    if (text.isNotEmpty) {
      scopeItems.add(
        ScopeItemModel(
          id: 'scope_${DateTime.now().microsecondsSinceEpoch}',
          description: text,
          quantity: 1,
          unit: 'lot',
        ),
      );
      manualScopeCtrl.clear();
    }
    _push(const ReviewScopeItemsView(), kRouteReviewScope);
  }

  void skipManualEntry() {
    _push(const ReviewScopeItemsView(), kRouteReviewScope);
  }

  /// Review Scope Items -> Bid Details
  void continueToDetails() {
    _push(const BidDetailsReviewView(), kRouteDetails);
  }

  // ---- Scope items (both flows) -----------------------------------------

  void toggleScopeItemIncluded(String id) {
    final index = scopeItems.indexWhere((i) => i.id == id);
    if (index == -1) return;
    scopeItems[index] =
        scopeItems[index].copyWith(isIncluded: !scopeItems[index].isIncluded);
  }

  void editScopeItem(ScopeItemModel updated) {
    final index = scopeItems.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    scopeItems[index] = updated;
  }

  void removeScopeItem(String id) {
    scopeItems.removeWhere((i) => i.id == id);
  }

  /// Inline add from the "+" row: description + qty + unit.
  void addQuickScopeItem() {
    final desc = quickDescCtrl.text.trim();
    if (desc.isEmpty) return;
    final unit = quickUnitCtrl.text.trim();
    scopeItems.add(
      ScopeItemModel(
        id: 'scope_${DateTime.now().microsecondsSinceEpoch}',
        description: desc,
        quantity: double.tryParse(quickQtyCtrl.text.trim()) ?? 1,
        unit: unit.isEmpty ? 'lot' : unit,
      ),
    );
    quickDescCtrl.clear();
    quickQtyCtrl.clear();
    quickUnitCtrl.clear();
  }

  // ---- Create Bid (last step of either flow) -----------------------------

  // API: POST /bids
  Future<void> createBid() async {
    if (isSubmitting.value || !_validateOrWarn()) return;
    isSubmitting.value = true;

    final draft = BidDraftModel(
      entryMethod: entryMethod,
      uploadedFileName: uploadedFileName.value,
      scopeItems: scopeItems.toList(),
      bidName: bidNameCtrl.text.trim(),
      bidDate: bidDate.value,
      crmContactOrg: crmContactOrg.value,
      crmOrgStatus: crmOrgStatus.value,
      orgName: orgNameCtrl.text.trim(),
      contactName: contactNameCtrl.text.trim(),
      contactEmail: contactEmailCtrl.text.trim(),
      contactPhone: contactPhoneCtrl.text.trim(),
      estimatedAmount: double.tryParse(
        estimatedAmountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), ''),
      ),
      address: addressCtrl.text.trim(),
      city: cityCtrl.text.trim(),
      state: stateCtrl.text.trim(),
      locationNotes: locationNotesCtrl.text.trim(),
      textToTextKeywords: keywordsCtrl.text.trim(),
    );

    try {
      final id = await CreateBidMockData.submitBid();
      if (Get.isRegistered<EstimatorBidLogic>()) {
        Get.find<EstimatorBidLogic>().addBid(draft.toBid(id));
      }
      _popWizard();
      Get.snackbar(
        'Bid created',
        '"${draft.bidName}" was saved as a draft.',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      bidNameCtrl,
      orgNameCtrl,
      contactNameCtrl,
      contactEmailCtrl,
      contactPhoneCtrl,
      estimatedAmountCtrl,
      addressCtrl,
      cityCtrl,
      stateCtrl,
      locationNotesCtrl,
      keywordsCtrl,
      manualScopeCtrl,
      quickDescCtrl,
      quickQtyCtrl,
      quickUnitCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
