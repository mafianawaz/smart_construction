// Models for the CRM Tasks, Calls and Quotes tabs. Pure Dart (no Flutter
// imports) so they stay API-ready.

// ─────────────────────────────── Tasks ───────────────────────────────

enum TaskPriority { low, medium, high }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

/// Status filter for the task list. `null` in the logic means "All".
enum TaskFilter { open, completed }

extension TaskFilterX on TaskFilter {
  String get label => this == TaskFilter.open ? 'Open' : 'Completed';
}

class CrmTaskModel {
  final String id;
  final String title;
  final String notes;
  final DateTime? dueDate;
  final TaskPriority priority;
  final bool isDone;
  final String? organizationName;
  final String? assignee;

  const CrmTaskModel({
    required this.id,
    required this.title,
    this.notes = '',
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.isDone = false,
    this.organizationName,
    this.assignee,
  });

  String get assigneeLabel => assignee ?? 'Unassigned';

  /// Overdue = has a due date before today and is not done.
  bool isOverdue(DateTime now) {
    final due = dueDate;
    if (isDone || due == null) return false;
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(due.year, due.month, due.day).isBefore(today);
  }

  CrmTaskModel copyWith({bool? isDone}) {
    return CrmTaskModel(
      id: id,
      title: title,
      notes: notes,
      dueDate: dueDate,
      priority: priority,
      isDone: isDone ?? this.isDone,
      organizationName: organizationName,
      assignee: assignee,
    );
  }
}

// ─────────────────────────────── Calls ───────────────────────────────

enum CallDirection { outbound, inbound }

extension CallDirectionX on CallDirection {
  /// Short label used on the call card ("Out" / "In").
  String get label => this == CallDirection.outbound ? 'Out' : 'In';

  /// Long label used in the filter menu.
  String get menuLabel =>
      this == CallDirection.outbound ? 'Outbound' : 'Inbound';
}

enum CallOutcome { connected, voicemail, noAnswer, busy, wrongNumber }

extension CallOutcomeX on CallOutcome {
  /// Title case; the card pill lower-cases it to match the reference.
  String get label {
    switch (this) {
      case CallOutcome.connected:
        return 'Connected';
      case CallOutcome.voicemail:
        return 'Voicemail';
      case CallOutcome.noAnswer:
        return 'No answer';
      case CallOutcome.busy:
        return 'Busy';
      case CallOutcome.wrongNumber:
        return 'Wrong number';
    }
  }
}

class CallLogModel {
  final String id;
  final DateTime dateTime;
  final CallDirection direction;
  final CallOutcome outcome;
  final int durationSeconds;
  final String number;
  final String owner;
  final String notes;

  const CallLogModel({
    required this.id,
    required this.dateTime,
    required this.direction,
    required this.outcome,
    required this.durationSeconds,
    required this.number,
    required this.owner,
    this.notes = '',
  });

  /// "3:00" — minutes:seconds.
  String get durationLabel {
    final minutes = durationSeconds ~/ 60;
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return notes.toLowerCase().contains(q) ||
        number.toLowerCase().contains(q) ||
        owner.toLowerCase().contains(q);
  }
}

// ─────────────────────────────── Quotes ───────────────────────────────

enum QuoteStatus { draft, sent, accepted, declined }

extension QuoteStatusX on QuoteStatus {
  String get label {
    switch (this) {
      case QuoteStatus.draft:
        return 'Draft';
      case QuoteStatus.sent:
        return 'Sent';
      case QuoteStatus.accepted:
        return 'Accepted';
      case QuoteStatus.declined:
        return 'Declined';
    }
  }
}

class QuoteLineItem {
  final String description;
  final double quantity;
  final double unitPrice;

  const QuoteLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class QuoteModel {
  final String id;

  /// Human-readable number, e.g. "Q-0001". Server-assigned once the API lands.
  final String number;
  final String title;
  final String organizationName;
  final QuoteStatus status;
  final List<QuoteLineItem> lineItems;
  final DateTime? validUntil;
  final String notes;

  const QuoteModel({
    required this.id,
    required this.number,
    required this.title,
    required this.organizationName,
    this.status = QuoteStatus.draft,
    this.lineItems = const [],
    this.validUntil,
    this.notes = '',
  });

  double get total => lineItems.fold(0.0, (sum, item) => sum + item.total);

  QuoteModel copyWith({QuoteStatus? status}) {
    return QuoteModel(
      id: id,
      number: number,
      title: title,
      organizationName: organizationName,
      status: status ?? this.status,
      lineItems: lineItems,
      validUntil: validUntil,
      notes: notes,
    );
  }
}
