import 'package:flutter/material.dart';

enum EquipmentStatus { available, assigned, inRepair }

extension EquipmentStatusX on EquipmentStatus {
  String get label {
    switch (this) {
      case EquipmentStatus.available:
        return 'Available';
      case EquipmentStatus.assigned:
        return 'Assigned';
      case EquipmentStatus.inRepair:
        return 'In Repair';
    }
  }
}

enum EquipmentType {
  heavyEquipment,
  vehicle,
  powerTool,
  handTool,
  trailer,
  attachment,
  other,
}

extension EquipmentTypeX on EquipmentType {
  String get label {
    switch (this) {
      case EquipmentType.heavyEquipment:
        return 'Heavy Equipment';
      case EquipmentType.vehicle:
        return 'Vehicle';
      case EquipmentType.powerTool:
        return 'Power Tool';
      case EquipmentType.handTool:
        return 'Hand Tool';
      case EquipmentType.trailer:
        return 'Trailer';
      case EquipmentType.attachment:
        return 'Attachment';
      case EquipmentType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentType.heavyEquipment:
        return Icons.local_shipping_outlined;
      case EquipmentType.vehicle:
        return Icons.directions_car_outlined;
      case EquipmentType.powerTool:
        return Icons.construction;
      case EquipmentType.handTool:
        return Icons.handyman_outlined;
      case EquipmentType.trailer:
        return Icons.rv_hookup;
      case EquipmentType.attachment:
        return Icons.settings_outlined;
      case EquipmentType.other:
        return Icons.inventory_2_outlined;
    }
  }
}

enum DepreciationMethod { straightLine, decliningBalance, unitsOfProduction }

extension DepreciationMethodX on DepreciationMethod {
  String get label {
    switch (this) {
      case DepreciationMethod.straightLine:
        return 'Straight Line';
      case DepreciationMethod.decliningBalance:
        return 'Declining Balance';
      case DepreciationMethod.unitsOfProduction:
        return 'Units of Production';
    }
  }
}

/// What the Add New Equipment form hands back. The list controller turns it
/// into an [EquipmentItem] (assigning id + code), which is the part the
/// backend will own.
class EquipmentDraft {
  final String name;
  final EquipmentType type;
  final double currentHours;
  final String make;
  final String model;
  final int? year;
  final String serialNumber;
  final String vin;
  final String licensePlate;
  final double purchasePrice;
  final String homeLocation;
  final DepreciationMethod? depreciationMethod;
  final int? usefulLifeYears;
  final double salvageValue;
  final DateTime? inServiceDate;
  final String description;
  final String notes;

  const EquipmentDraft({
    required this.name,
    required this.type,
    this.currentHours = 0,
    this.make = '',
    this.model = '',
    this.year,
    this.serialNumber = '',
    this.vin = '',
    this.licensePlate = '',
    this.purchasePrice = 0,
    this.homeLocation = '',
    this.depreciationMethod,
    this.usefulLifeYears,
    this.salvageValue = 0,
    this.inServiceDate,
    this.description = '',
    this.notes = '',
  });
}

class EquipmentItem {
  final String id;
  final String code; // EQ-0001
  final EquipmentDraft details;
  final EquipmentStatus status;

  const EquipmentItem({
    required this.id,
    required this.code,
    required this.details,
    this.status = EquipmentStatus.available,
  });

  String get name => details.name;
  EquipmentType get type => details.type;
  double get hours => details.currentHours;
  double get purchasePrice => details.purchasePrice;

  /// "EQ-0002 · Caterpillar 299D" (make/model omitted when blank).
  String get subtitle {
    final makeModel = '${details.make} ${details.model}'.trim();
    return makeModel.isEmpty ? code : '$code · $makeModel';
  }

  EquipmentItem copyWith({EquipmentStatus? status}) {
    return EquipmentItem(
      id: id,
      code: code,
      details: details,
      status: status ?? this.status,
    );
  }
}
