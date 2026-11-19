import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';


enum PurchaseOrderStatus { approved, pending, rejected, delivered }

extension PurchaseOrderStatusX on PurchaseOrderStatus {
  String get label {
    switch (this) {
      case PurchaseOrderStatus.approved:
        return 'Approved';
      case PurchaseOrderStatus.pending:
        return 'Pending';
      case PurchaseOrderStatus.rejected:
        return 'Rejected';
      case PurchaseOrderStatus.delivered:
        return 'Delivered';
    }
  }

  // NOTE: AppColors.success is unconfirmed (see overview notes) — using it
  // here for the Approved/Delivered states. Swap for the confirmed field
  // name once verified against the real theme file.
  Color get color {
    switch (this) {
      case PurchaseOrderStatus.approved:
      case PurchaseOrderStatus.delivered:
        return AppColors.statusChip;
      case PurchaseOrderStatus.pending:
        return AppColors.primaryOrangeDark;
      case PurchaseOrderStatus.rejected:
        return AppColors.redColor;
    }
  }

  String get icon {
    switch (this) {
      case PurchaseOrderStatus.approved:
      case PurchaseOrderStatus.delivered:
        return AppIcons.tickCircle;
      case PurchaseOrderStatus.pending:
        return AppIcons.progress;
      case PurchaseOrderStatus.rejected:
        return AppIcons.progress;
    }
  }
}

class PurchaseOrderModel {
  final String id;
  final String poNumber;
  final PurchaseOrderStatus status;
  final String contractorOrgName;
  final String projectName;
  final DateTime issuedDate;
  final int lineItemsCount;
  final double totalValue;
  final DateTime createdDate;
  final DateTime expectedDeliveryDate;

  const PurchaseOrderModel({
    required this.id,
    required this.poNumber,
    required this.status,
    required this.contractorOrgName,
    required this.projectName,
    required this.issuedDate,
    required this.lineItemsCount,
    required this.totalValue,
    required this.createdDate,
    required this.expectedDeliveryDate,
  });

  PurchaseOrderModel copyWith({
    PurchaseOrderStatus? status,
  }) {
    return PurchaseOrderModel(
      id: id,
      poNumber: poNumber,
      status: status ?? this.status,
      contractorOrgName: contractorOrgName,
      projectName: projectName,
      issuedDate: issuedDate,
      lineItemsCount: lineItemsCount,
      totalValue: totalValue,
      createdDate: createdDate,
      expectedDeliveryDate: expectedDeliveryDate,
    );
  }
}
