import 'package:intl/intl.dart';

/// The three AI agents that produce drafts for review.
/// A2 "Project Controls" is confirmed by the reference; A1 / A3 role names
/// are placeholders (see NOTES_AI_REVIEW_QUEUE.md).
enum ReviewAgent {
  a1('A1', 'Estimating'),
  a2('A2', 'Project Controls'),
  a3('A3', 'Finance & Contracts');

  const ReviewAgent(this.code, this.roleName);
  final String code;
  final String roleName;

  /// "Agent 2 · Project Controls" style label used in the review sheet.
  String get longLabel => 'Agent ${code.substring(1)} · $roleName';
}

/// Every draft type the queue can hold, in the same order as the
/// "Item types" legend in the reference.
enum ReviewItemType {
  takeoffQty('TAKEOFF_QTY'),
  scopeChecklist('SCOPE_CHECKLIST'),
  coDraft('CO_DRAFT'),
  rfiDraft('RFI_DRAFT'),
  payAppDraft('PAY_APP_DRAFT'),
  collectionEmail('COLLECTION_EMAIL'),
  noticeLetter('NOTICE_LETTER'),
  photoHazardFlag('PHOTO_HAZARD_FLAG'),
  photoQualityFlag('PHOTO_QUALITY_FLAG'),
  timecardException('TIMECARD_EXCEPTION'),
  subDistress('SUB_DISTRESS'),
  oshaReport('OSHA_REPORT'),
  paymentHold('PAYMENT_HOLD'),
  jhaDraft('JHA_DRAFT'),
  toolboxTalk('TOOLBOX_TALK'),
  inspectionPlan('INSPECTION_PLAN'),
  procurementDate('PROCUREMENT_DATE'),
  rateUpdate('RATE_UPDATE');

  const ReviewItemType(this.wire);

  /// Wire / display name, e.g. `CO_DRAFT`.
  final String wire;

  /// Human-gated types can never be bulk accepted.
  bool get humanGated =>
      this == noticeLetter ||
      this == payAppDraft ||
      this == collectionEmail ||
      this == paymentHold;

  /// Finance types carry the "Not legal advice" framing and can be sent to
  /// attorney review.
  bool get isFinance =>
      this == coDraft ||
      this == payAppDraft ||
      this == collectionEmail ||
      this == noticeLetter ||
      this == paymentHold;
}

enum ReviewStatus {
  pending('Pending'),
  edited('Edited'),
  approved('Approved'),
  rejected('Rejected'),
  attorneyReview('Attorney review');

  const ReviewStatus(this.label);
  final String label;

  /// Items in these states still sit in the queue.
  bool get awaitingReview => this == pending || this == edited;
}

/// Reasons offered in the sheet (required on edit or reject).
enum CorrectionReason {
  wrongScope('wrong scope'),
  wrongPrice('wrong price'),
  alreadyCovered('already covered'),
  clientRelationship('client relationship'),
  wrongParty('wrong party'),
  other('other');

  const CorrectionReason(this.label);
  final String label;
}

enum AgeBucket {
  all('All'),
  underDay('< 1 d'),
  oneToTwoDays('1–2 d'),
  overTwoDays('> 2 d');

  const AgeBucket(this.label);
  final String label;

  bool matches(Duration age) {
    switch (this) {
      case AgeBucket.all:
        return true;
      case AgeBucket.underDay:
        return age.inHours < 24;
      case AgeBucket.oneToTwoDays:
        return age.inHours >= 24 && age.inMinutes <= 48 * 60;
      case AgeBucket.overTwoDays:
        return age.inMinutes > 48 * 60;
    }
  }
}

enum DraftFieldKind { text, amount, multiline, readOnly }

/// One field of a typed draft form.
class DraftField {
  const DraftField({
    required this.id,
    required this.label,
    required this.value,
    this.kind = DraftFieldKind.text,
    this.required = false,
  });

  final String id;
  final String label;
  final String value;
  final DraftFieldKind kind;
  final bool required;

  bool get editable => kind != DraftFieldKind.readOnly;
}

/// Everything the "Basis panel" and "Input snapshot" sections show.
class ReviewBasis {
  const ReviewBasis({
    required this.summary,
    required this.sourcesLine,
    required this.corpusCitations,
    required this.modelLabel,
    required this.runId,
    required this.auditLogRef,
    required this.inputUsed,
    required this.inputSkipped,
    this.needsHumanVerification = false,
  });

  /// One-line "Basis:" text under the agent tag.
  final String summary;
  final String sourcesLine;
  final List<String> corpusCitations;
  final String modelLabel;
  final String runId;
  final String auditLogRef;
  final String inputUsed;
  final String inputSkipped;
  final bool needsHumanVerification;
}

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.type,
    required this.agent,
    required this.project,
    this.projectFull,
    required this.title,
    required this.shortTitle,
    required this.amountAtStake,
    required this.requestedAt,
    required this.slaHours,
    required this.requester,
    required this.draftFields,
    required this.originalText,
    required this.basis,
    this.status = ReviewStatus.pending,
    this.correctionReason,
    this.note,
    this.useAsExample,
    this.editedText,
  });

  final String id;
  final ReviewItemType type;
  final ReviewAgent agent;

  /// Short project name used on queue cards.
  final String project;

  /// Longer name used in the sheet ("Riverside Medical Office"), if different.
  final String? projectFull;
  final String title;

  /// Compact-row title ("Prelim notice — NJ").
  final String shortTitle;
  final double amountAtStake;
  final DateTime requestedAt;
  final int slaHours;
  final String requester;
  final List<DraftField> draftFields;

  /// The AI's original text for the primary field (the "Original (AI draft)"
  /// box in the sheet).
  final String originalText;
  final ReviewBasis basis;
  final ReviewStatus status;
  final CorrectionReason? correctionReason;
  final String? note;
  final bool? useAsExample;
  final String? editedText;

  bool get humanGated => type.humanGated;
  bool get legalFraming => type.isFinance;
  String get projectLong => projectFull ?? project;

  ReviewItem copyWith({
    ReviewStatus? status,
    List<DraftField>? draftFields,
    CorrectionReason? correctionReason,
    String? note,
    bool? useAsExample,
    String? editedText,
  }) {
    return ReviewItem(
      id: id,
      type: type,
      agent: agent,
      project: project,
      projectFull: projectFull,
      title: title,
      shortTitle: shortTitle,
      amountAtStake: amountAtStake,
      requestedAt: requestedAt,
      slaHours: slaHours,
      requester: requester,
      draftFields: draftFields ?? this.draftFields,
      originalText: originalText,
      basis: basis,
      status: status ?? this.status,
      correctionReason: correctionReason ?? this.correctionReason,
      note: note ?? this.note,
      useAsExample: useAsExample ?? this.useAsExample,
      editedText: editedText ?? this.editedText,
    );
  }
}

enum ReviewAction { accept, saveEditsAccept, reject, sendToAttorney }

/// What the sheet hands back to the queue logic.
class ReviewDecision {
  const ReviewDecision({
    required this.action,
    this.reason,
    this.note,
    this.useAsExample = false,
    this.editedFields = const {},
    this.editedText,
  });

  final ReviewAction action;
  final CorrectionReason? reason;
  final String? note;
  final bool useAsExample;

  /// field id → new value (only fields that actually changed).
  final Map<String, String> editedFields;
  final String? editedText;
}

/// Display formatting shared by cards, rows and the sheet.
class AiqFormat {
  const AiqFormat._();

  static final NumberFormat _money =
      NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);

  static String money(double v) => _money.format(v);

  /// "Oct 12 06:02"
  static String requested(DateTime d) =>
      DateFormat('MMM d HH:mm', 'en_US').format(d);

  /// "4 h left" under a day, "1 d" / "2 d" from a day up.
  static String sla(int hours) =>
      hours < 24 ? '$hours h left' : '${hours ~/ 24} d';
}
