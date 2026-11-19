import 'project_enums.dart';

/// Request for Information ("RFI-0001").
class RfiModel {
  final String id;
  final String number;
  final String subject;
  final String question;
  final PunchPriority priority;
  final RfiCategory category;
  final RfiStatus status;
  final String? assignedTo;
  final String? subcontractor;
  final String? drawingReference;
  final String? specReference;
  final DateTime? dateRequired;
  final String? impactDescription;
  final bool costImpact;
  final bool scheduleImpact;
  final DateTime createdAt;

  const RfiModel({
    required this.id,
    required this.number,
    required this.subject,
    required this.question,
    this.priority = PunchPriority.medium,
    this.category = RfiCategory.none,
    this.status = RfiStatus.open,
    this.assignedTo,
    this.subcontractor,
    this.drawingReference,
    this.specReference,
    this.dateRequired,
    this.impactDescription,
    this.costImpact = false,
    this.scheduleImpact = false,
    required this.createdAt,
  });
}

/// Document transmittal ("TR-0001").
class TransmittalModel {
  final String id;
  final String number;
  final String subject;
  final String? description;
  final TransmittalDocType? documentType;
  final String? revisionNumber;
  final List<String> recipients;
  final String? notes;
  final List<String> notifyEmails;
  final TransmittalStatus status;
  final DateTime createdAt;

  const TransmittalModel({
    required this.id,
    required this.number,
    required this.subject,
    this.description,
    this.documentType,
    this.revisionNumber,
    this.recipients = const [],
    this.notes,
    this.notifyEmails = const [],
    this.status = TransmittalStatus.draft,
    required this.createdAt,
  });
}

/// Submittal ("SUB-0001").
class SubmittalModel {
  final String id;
  final String number;
  final String subject;
  final String? description;
  final SubmittalType type;
  final SubmittalPhase phase;
  final String? specSection;
  final String? documentCategory;
  final DateTime? dateRequired;
  final SubmittalStatus status;
  final DateTime createdAt;

  const SubmittalModel({
    required this.id,
    required this.number,
    required this.subject,
    this.description,
    this.type = SubmittalType.contractor,
    this.phase = SubmittalPhase.construction,
    this.specSection,
    this.documentCategory,
    this.dateRequired,
    this.status = SubmittalStatus.pending,
    required this.createdAt,
  });

  /// Past its required date and not yet approved / rejected.
  bool get isOverdue =>
      dateRequired != null &&
      (status == SubmittalStatus.pending || status == SubmittalStatus.underReview) &&
      dateRequired!.isBefore(DateTime.now());
}

/// One row of the Project Closeout checklist.
class CloseoutItemModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final CloseoutItemStatus status;
  final String? signedOffBy;

  const CloseoutItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.status = CloseoutItemStatus.pending,
    this.signedOffBy,
  });

  CloseoutItemModel copyWith({CloseoutItemStatus? status, String? signedOffBy}) =>
      CloseoutItemModel(
        id: id,
        category: category,
        title: title,
        description: description,
        status: status ?? this.status,
        signedOffBy: signedOffBy ?? this.signedOffBy,
      );
}

/// Warranty / defect case ("WC-0001").
class WarrantyCaseModel {
  final String id;
  final String number;
  final String title;
  final WarrantyType type;
  final PunchPriority priority;
  final WarrantyStatus status;
  final String? description;
  final String? location;
  final String? assignedTo;
  final String? responsibility;
  final String? reporterEmail;
  final DateTime? reportedDate;
  final DateTime? targetResolution;
  final double? estimatedCost;
  final DateTime createdAt;

  const WarrantyCaseModel({
    required this.id,
    required this.number,
    required this.title,
    this.type = WarrantyType.defect,
    this.priority = PunchPriority.medium,
    this.status = WarrantyStatus.open,
    this.description,
    this.location,
    this.assignedTo,
    this.responsibility,
    this.reporterEmail,
    this.reportedDate,
    this.targetResolution,
    this.estimatedCost,
    required this.createdAt,
  });
}

class MaintenanceLogModel {
  final String id;
  final String title;
  final MaintenanceType type;
  final DateTime date;
  final double cost;

  const MaintenanceLogModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.cost = 0,
  });
}

class MaintenanceScheduleModel {
  final String id;
  final String title;
  final String frequency;
  final DateTime? nextDue;

  const MaintenanceScheduleModel({
    required this.id,
    required this.title,
    required this.frequency,
    this.nextDue,
  });
}
