import 'project_enums.dart';

/// One Punch List item ("PLI-…" number, shown on the list tile and the
/// detail screen). Fields mirror the Add / Edit Punch Item form.
class PunchItemModel {
  final String id;
  final String number;
  final String title;
  final String? description;
  final String? location;
  final ProjectTrade trade;
  final PunchPriority priority;
  final PunchStatus status;
  final String? assigneeName;
  final String? assigneeEmail;
  final DateTime? dueDate;
  final DateTime createdAt;
  final String updateNotes;
  final int attachmentCount;

  const PunchItemModel({
    required this.id,
    required this.number,
    required this.title,
    this.description,
    this.location,
    this.trade = ProjectTrade.general,
    this.priority = PunchPriority.medium,
    this.status = PunchStatus.open,
    this.assigneeName,
    this.assigneeEmail,
    this.dueDate,
    required this.createdAt,
    this.updateNotes = '',
    this.attachmentCount = 0,
  });

  /// Only the fields the detail screen changes in place.
  PunchItemModel copyWith({
    PunchStatus? status,
    String? updateNotes,
    int? attachmentCount,
  }) {
    return PunchItemModel(
      id: id,
      number: number,
      title: title,
      description: description,
      location: location,
      trade: trade,
      priority: priority,
      status: status ?? this.status,
      assigneeName: assigneeName,
      assigneeEmail: assigneeEmail,
      dueDate: dueDate,
      createdAt: createdAt,
      updateNotes: updateNotes ?? this.updateNotes,
      attachmentCount: attachmentCount ?? this.attachmentCount,
    );
  }
}

/// A row under T&M Tracking -> Time Entries (date, hours, description).
class TmTimeEntryModel {
  final String id;
  final DateTime date;
  final double hours;
  final String description;
  final String? detail;
  final TimeApprovalStatus status;

  const TmTimeEntryModel({
    required this.id,
    required this.date,
    required this.hours,
    required this.description,
    this.detail,
    this.status = TimeApprovalStatus.pending,
  });
}

/// A row in Labor Hours -> Labor Hours (per employee per day).
class LaborEntryModel {
  final String id;
  final String employee;
  final ProjectTrade trade;
  final DateTime date;
  final double hours;
  final TimeApprovalStatus status;

  const LaborEntryModel({
    required this.id,
    required this.employee,
    required this.trade,
    required this.date,
    required this.hours,
    this.status = TimeApprovalStatus.pending,
  });
}

class SubcontractAssignmentModel {
  final String id;
  final String company;
  final String scope;
  final double contractAmount;

  const SubcontractAssignmentModel({
    required this.id,
    required this.company,
    required this.scope,
    required this.contractAmount,
  });
}

/// Equipment Plan (from the estimate / takeoff).
class PlannedEquipmentModel {
  final String id;
  final String name;
  final double quantity;
  final int days;

  const PlannedEquipmentModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.days,
  });
}

/// Assigned Equipment (currently on this project).
class AssignedEquipmentModel {
  final String id;
  final String name;
  final String? operatorName;
  final DateTime assignedOn;

  const AssignedEquipmentModel({
    required this.id,
    required this.name,
    this.operatorName,
    required this.assignedOn,
  });
}
