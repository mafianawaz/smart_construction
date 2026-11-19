import 'package:get/get.dart';

import 'analytics/crm_analytics.dart';
import 'data/crm_mock_data.dart';
import 'models/crm_activity_models.dart';
import 'models/crm_models.dart';
import 'models/crm_sequence_models.dart';


/// State for the Customer Relationship Management screen.
///
/// Uses plain fields + `update()` (GetBuilder), matching `PricingLogic`.
class CrmLogic extends GetxController {
  CrmLogic({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  /// Injectable "now" so views and derived state agree (and tests can pin it).
  DateTime get now => _clock();

  // ── Shell ──
  CrmTab tab = CrmTab.organizations;

  // ── Data ──
  List<OrganizationModel> organizations = [];
  List<ContactModel> contacts = [];
  List<OpportunityModel> opportunities = [];

  /// Assignable owners (organization owners and opportunity assignees).
  List<String> owners = [];

  // ── Organizations filters ──
  String orgQuery = '';
  OrgType? orgTypeFilter;
  OrgStatus? orgStatusFilter;

  // ── Contacts filters ──
  String contactQuery = '';
  String? contactOrgFilter;

  // ── Pipeline filters ──
  String oppQuery = '';
  OpportunityStage? stageFilter;
  String? assigneeFilter;
  PipelineViewMode pipelineView = PipelineViewMode.board;

  // ── Tasks ──
  List<CrmTaskModel> tasks = [];

  /// Status filter; `null` means "All". Defaults to Open like the reference.
  TaskFilter? taskFilter = TaskFilter.open;

  // ── Calls ──
  List<CallLogModel> calls = [];
  String callQuery = '';
  CallOutcome? callOutcomeFilter;
  CallDirection? callDirectionFilter;
  String? callOwnerFilter;
  DateTime? callFrom;
  DateTime? callTo;

  // ── Quotes ──
  List<QuoteModel> quotes = [];

  // ── Reports ──
  ReportRange reportRange = ReportRange.last30;
  bool revenueForecastExpanded = true;

  // ── Sequences ──
  List<SequenceModel> sequences = [];
  SequenceScope sequenceScope = SequenceScope.mine;
  String sequenceQuery = '';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// SEAM: replace with parallel GETs to /crm/organizations, /crm/contacts,
  /// /crm/opportunities, /crm/owners. Keep `update()` at the end.
  void load() {
    owners = List<String>.of(CrmMockData.owners);
    organizations = CrmMockData.organizations();
    contacts = CrmMockData.contacts();
    opportunities = CrmMockData.opportunities();
    tasks = CrmMockData.tasks();
    calls = CrmMockData.calls();
    quotes = CrmMockData.quotes();
    sequences = CrmMockData.sequences();
    update();
  }

  // ───────────────────────── Navigation ─────────────────────────

  void setTab(CrmTab value) {
    if (tab == value) return;
    tab = value;
    update();
  }

  // ─────────────────── Organizations: derived ───────────────────

  int get totalOrgs => organizations.length;

  int get activeOnProjects =>
      organizations.where((o) => o.isActiveOnProjects).length;

  int get inactiveOrgs => organizations.where((o) => !o.isActive).length;

  /// Every compliance item that needs attention, paired with its org.
  List<ComplianceAlertEntry> get complianceAlerts {
    final entries = <ComplianceAlertEntry>[];
    for (final org in organizations) {
      for (final item in org.complianceItems) {
        if (item.needsAttention) {
          entries.add(
            ComplianceAlertEntry(organizationName: org.name, item: item),
          );
        }
      }
    }
    return entries;
  }

  /// NOTE: the reference shows "0" here while its alert banner lists one
  /// expired item. This is derived from the same data as the banner so the
  /// two can never disagree; see NOTES_CRM.md.
  int get complianceIssueCount => complianceAlerts.length;

  int get expiredAlertCount => complianceAlerts
      .where((a) => a.item.state == ComplianceItemState.expired)
      .length;

  bool get hasOrgFilters => orgTypeFilter != null || orgStatusFilter != null;

  List<OrganizationModel> get filteredOrganizations {
    final q = orgQuery.trim().toLowerCase();
    return organizations.where((o) {
      if (orgTypeFilter != null && o.type != orgTypeFilter) return false;
      if (orgStatusFilter != null && o.status != orgStatusFilter) return false;
      if (q.isEmpty) return true;
      return o.name.toLowerCase().contains(q) ||
          o.city.toLowerCase().contains(q) ||
          o.ownerLine.toLowerCase().contains(q) ||
          o.type.label.toLowerCase().contains(q) ||
          (o.category ?? '').toLowerCase().contains(q);
    }).toList();
  }

  OrganizationModel? organizationById(String id) {
    for (final o in organizations) {
      if (o.id == id) return o;
    }
    return null;
  }

  // ─────────────────── Organizations: actions ───────────────────

  void setOrgQuery(String value) {
    orgQuery = value;
    update();
  }

  void setOrgFilters({OrgType? type, OrgStatus? status}) {
    orgTypeFilter = type;
    orgStatusFilter = status;
    update();
  }

  void clearOrgFilters() => setOrgFilters();

  /// Creates (unknown id) or replaces (known id) an organization.
  /// SEAM: POST /crm/organizations  |  PUT /crm/organizations/{id}
  void saveOrganization(OrganizationModel org) {
    final index = organizations.indexWhere((o) => o.id == org.id);
    if (index == -1) {
      organizations = [org, ...organizations];
    } else {
      organizations = [...organizations]..[index] = org;
    }
    update();
  }

  /// SEAM: DELETE /crm/organizations/{id}
  /// Contacts/opportunities that referenced the org keep their text label.
  void deleteOrganization(String id) {
    organizations = organizations.where((o) => o.id != id).toList();
    update();
  }

  /// SEAM: PATCH /crm/organizations/{id} { owner }
  void assignOwner(String orgId, String? owner) {
    final org = organizationById(orgId);
    if (org == null) return;
    saveOrganization(org.copyWith(ownerName: owner, ownerRole: null));
  }

  String newOrganizationId() =>
      'org-${DateTime.now().microsecondsSinceEpoch}';

  // ───────────────────── Contacts: derived ─────────────────────

  /// Contacts whose birthday falls within the next 7 days (inclusive of today).
  List<ContactModel> get upcomingBirthdays {
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final result = <ContactModel>[];
    for (final c in contacts) {
      final b = c.birthday;
      if (b == null) continue;
      var next = DateTime(today.year, b.month, b.day);
      if (next.isBefore(today)) {
        next = DateTime(today.year + 1, b.month, b.day);
      }
      if (next.difference(today).inDays <= 7) result.add(c);
    }
    return result;
  }

  bool get hasContactFilters => contactOrgFilter != null;

  List<ContactModel> get filteredContacts {
    return contacts.where((c) {
      if (contactOrgFilter != null && c.organizationName != contactOrgFilter) {
        return false;
      }
      return c.matches(contactQuery);
    }).toList();
  }

  // ───────────────────── Contacts: actions ─────────────────────

  void setContactQuery(String value) {
    contactQuery = value;
    update();
  }

  void setContactOrgFilter(String? orgName) {
    contactOrgFilter = orgName;
    update();
  }

  // ───────────────────── Pipeline: derived ─────────────────────

  List<OpportunityModel> get _open =>
      opportunities.where((o) => o.stage.isOpen).toList();

  double get totalPipeline => _open.fold(0.0, (sum, o) => sum + o.value);

  double get weightedValue => _open.fold(0.0, (sum, o) => sum + o.weightedValue);

  int get openDeals => _open.length;

  /// Won / (Won + Lost), as a whole percent. 0 when nothing is closed yet.
  int get winRatePercent {
    final won =
        opportunities.where((o) => o.stage == OpportunityStage.won).length;
    final lost =
        opportunities.where((o) => o.stage == OpportunityStage.lost).length;
    final closed = won + lost;
    if (closed == 0) return 0;
    return ((won / closed) * 100).round();
  }

  List<OpportunityModel> get filteredOpportunities {
    return opportunities.where((o) {
      if (stageFilter != null && o.stage != stageFilter) return false;
      if (assigneeFilter != null && o.assigneeLabel != assigneeFilter) {
        return false;
      }
      return o.matches(oppQuery);
    }).toList();
  }

  List<OpportunityModel> opportunitiesIn(OpportunityStage stage) =>
      filteredOpportunities.where((o) => o.stage == stage).toList();

  int stageCount(OpportunityStage stage) => opportunitiesIn(stage).length;

  // ───────────────────── Pipeline: actions ─────────────────────

  void setOppQuery(String value) {
    oppQuery = value;
    update();
  }

  void setStageFilter(OpportunityStage? value) {
    stageFilter = value;
    update();
  }

  void setAssigneeFilter(String? value) {
    assigneeFilter = value;
    update();
  }

  void setPipelineView(PipelineViewMode mode) {
    if (pipelineView == mode) return;
    pipelineView = mode;
    update();
  }

  /// SEAM: POST /crm/opportunities
  void addOpportunity(OpportunityModel opportunity) {
    opportunities = [opportunity, ...opportunities];
    update();
  }

  String newOpportunityId() => 'opp-${DateTime.now().microsecondsSinceEpoch}';

  // ═════════════════════════════ Tasks ═════════════════════════════

  /// Tasks the status filter lets through: open before done, then by due date
  /// (undated last); ties keep list order (newest first).
  List<CrmTaskModel> get filteredTasks {
    final f = taskFilter;
    final order = {for (var i = 0; i < tasks.length; i++) tasks[i].id: i};
    final list = tasks.where((t) {
      if (f == TaskFilter.open) return !t.isDone;
      if (f == TaskFilter.completed) return t.isDone;
      return true;
    }).toList();
    list.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      final da = a.dueDate;
      final db = b.dueDate;
      if (da != null && db != null) {
        final byDate = da.compareTo(db);
        if (byDate != 0) return byDate;
      } else if (da != null) {
        return -1;
      } else if (db != null) {
        return 1;
      }
      return order[a.id]!.compareTo(order[b.id]!);
    });
    return list;
  }

  void setTaskFilter(TaskFilter? value) {
    taskFilter = value;
    update();
  }

  /// SEAM: POST /crm/tasks
  void addTask(CrmTaskModel task) {
    tasks = [task, ...tasks];
    update();
  }

  /// SEAM: PATCH /crm/tasks/{id}  { isDone }
  void toggleTask(String id, bool isDone) {
    tasks = [
      for (final t in tasks) t.id == id ? t.copyWith(isDone: isDone) : t,
    ];
    update();
  }

  /// SEAM: DELETE /crm/tasks/{id}
  void deleteTask(String id) {
    tasks = tasks.where((t) => t.id != id).toList();
    update();
  }

  String newTaskId() => 'task-${DateTime.now().microsecondsSinceEpoch}';

  // ═════════════════════════════ Calls ═════════════════════════════

  /// Distinct owners found in the call log, for the "All owners" filter.
  List<String> get callOwners {
    final owners =
        calls.map((c) => c.owner).where((o) => o.isNotEmpty).toSet().toList();
    owners.sort();
    return owners;
  }

  bool get hasCallFilters =>
      callOutcomeFilter != null ||
      callDirectionFilter != null ||
      callOwnerFilter != null ||
      callFrom != null ||
      callTo != null;

  DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Newest first. The date range is inclusive on both ends (whole days).
  List<CallLogModel> get filteredCalls {
    final fromDay = callFrom == null ? null : _dayOf(callFrom!);
    final toDay = callTo == null ? null : _dayOf(callTo!);
    final list = calls.where((c) {
      if (callOutcomeFilter != null && c.outcome != callOutcomeFilter) {
        return false;
      }
      if (callDirectionFilter != null && c.direction != callDirectionFilter) {
        return false;
      }
      if (callOwnerFilter != null && c.owner != callOwnerFilter) return false;
      final day = _dayOf(c.dateTime);
      if (fromDay != null && day.isBefore(fromDay)) return false;
      if (toDay != null && day.isAfter(toDay)) return false;
      return c.matches(callQuery);
    }).toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  void setCallQuery(String value) {
    callQuery = value;
    update();
  }

  void setCallOutcomeFilter(CallOutcome? value) {
    callOutcomeFilter = value;
    update();
  }

  void setCallDirectionFilter(CallDirection? value) {
    callDirectionFilter = value;
    update();
  }

  void setCallOwnerFilter(String? value) {
    callOwnerFilter = value;
    update();
  }

  void setCallFrom(DateTime? value) {
    callFrom = value;
    update();
  }

  void setCallTo(DateTime? value) {
    callTo = value;
    update();
  }

  /// Resets every call filter (the search text is left alone).
  void clearCallFilters() {
    callOutcomeFilter = null;
    callDirectionFilter = null;
    callOwnerFilter = null;
    callFrom = null;
    callTo = null;
    update();
  }

  /// SEAM: POST /crm/calls
  /// The reference has no "log a call" UI; call this from wherever calls
  /// originate (e.g. the contact card's call button once `url_launcher` lands).
  void logCall(CallLogModel call) {
    calls = [call, ...calls];
    update();
  }

  String newCallId() => 'call-${DateTime.now().microsecondsSinceEpoch}';

  // ═════════════════════════════ Quotes ═════════════════════════════

  /// SEAM: POST /crm/quotes
  void addQuote(QuoteModel quote) {
    quotes = [quote, ...quotes];
    update();
  }

  /// SEAM: PATCH /crm/quotes/{id}  { status }
  void setQuoteStatus(String id, QuoteStatus status) {
    quotes = [
      for (final q in quotes) q.id == id ? q.copyWith(status: status) : q,
    ];
    update();
  }

  String newQuoteId() => 'quote-${DateTime.now().microsecondsSinceEpoch}';

  /// Placeholder numbering ("Q-0001"); the server should assign this.
  String nextQuoteNumber() =>
      'Q-${(quotes.length + 1).toString().padLeft(4, '0')}';

  // ═════════════════════════ Analytics & Reports ═════════════════════════

  /// Derived on demand from [opportunities]; cheap at CRM list sizes.
  /// SEAM: swap for GET /crm/analytics if the backend pre-aggregates.
  CrmAnalytics get analytics => CrmAnalytics(opportunities, now: now);

  void setReportRange(ReportRange value) {
    if (reportRange == value) return;
    reportRange = value;
    update();
  }

  void toggleRevenueForecast() {
    revenueForecastExpanded = !revenueForecastExpanded;
    update();
  }

  // ═════════════════════════════ Sequences ═════════════════════════════

  /// Default owner for new sequences.
  /// SEAM: replace with the signed-in user's name.
  String get sequenceOwner => owners.isNotEmpty ? owners.first : 'Me';

  /// Library templates, or the user's own sequences (archived ones last).
  List<SequenceModel> get filteredSequences {
    final library = sequenceScope == SequenceScope.library;
    final list = sequences
        .where((s) => s.isTemplate == library && s.matches(sequenceQuery))
        .toList();
    // Stable partition: archived to the bottom, order otherwise preserved.
    return [
      ...list.where((s) => !s.isArchived),
      ...list.where((s) => s.isArchived),
    ];
  }

  void setSequenceScope(SequenceScope value) {
    if (sequenceScope == value) return;
    sequenceScope = value;
    update();
  }

  void setSequenceQuery(String value) {
    sequenceQuery = value;
    update();
  }

  /// SEAM: POST /crm/sequences
  void addSequence(SequenceModel sequence) {
    sequences = [sequence, ...sequences];
    sequenceScope = SequenceScope.mine;
    update();
  }

  /// Copies any sequence (library template or your own) into My Sequences as
  /// a new draft. SEAM: POST /crm/sequences/{id}/duplicate
  void duplicateSequence(String id) {
    final source = sequences.firstWhereOrNull((s) => s.id == id);
    if (source == null) return;
    addSequence(
      source.asDraftCopy(id: newSequenceId(), owner: sequenceOwner),
    );
  }

  /// Returns false (and changes nothing) when activating a sequence that has
  /// no steps. SEAM: PATCH /crm/sequences/{id} { status }
  bool setSequenceStatus(String id, SequenceStatus status) {
    final source = sequences.firstWhereOrNull((s) => s.id == id);
    if (source == null) return false;
    if (status == SequenceStatus.active && source.steps.isEmpty) return false;
    sequences = [
      for (final s in sequences) s.id == id ? s.copyWith(status: status) : s,
    ];
    update();
    return true;
  }

  /// Archive <-> back to Draft.
  void toggleSequenceArchived(String id) {
    final source = sequences.firstWhereOrNull((s) => s.id == id);
    if (source == null) return;
    setSequenceStatus(
      id,
      source.isArchived ? SequenceStatus.draft : SequenceStatus.archived,
    );
  }

  /// SEAM: DELETE /crm/sequences/{id}
  void deleteSequence(String id) {
    sequences = sequences.where((s) => s.id != id).toList();
    update();
  }

  String newSequenceId() => 'seq-${DateTime.now().microsecondsSinceEpoch}';
}
