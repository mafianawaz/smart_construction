import 'pricing_category.dart';
import 'pricing_status.dart';

class PricingItemModel {
  final String id;
  final PricingCategory category;
  final String name;
  final String code;
  final String subCategory;
  final String unit;
  final String description;
  final double unitPrice;
  final int minimumOrder;
  final double deliveryFee;
  final int leadTimeDays;
  final PricingStatus status;
  final DateTime submittedAt;

  const PricingItemModel({
    required this.id,
    required this.category,
    required this.name,
    required this.code,
    required this.subCategory,
    required this.unit,
    required this.description,
    required this.unitPrice,
    required this.minimumOrder,
    required this.deliveryFee,
    required this.leadTimeDays,
    required this.status,
    required this.submittedAt,
  });

  PricingItemModel copyWith({
    String? name,
    String? code,
    String? subCategory,
    String? unit,
    String? description,
    double? unitPrice,
    int? minimumOrder,
    double? deliveryFee,
    int? leadTimeDays,
    PricingStatus? status,
  }) {
    return PricingItemModel(
      id: id,
      category: category,
      name: name ?? this.name,
      code: code ?? this.code,
      subCategory: subCategory ?? this.subCategory,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      status: status ?? this.status,
      submittedAt: submittedAt,
    );
  }

  // TODO(api): replace with PricingItemModel.fromJson when
  // GET /api/pricing-items is wired up. A resubmitted/edited item is
  // assumed to reset to `pending` server-side pending re-approval.
}
