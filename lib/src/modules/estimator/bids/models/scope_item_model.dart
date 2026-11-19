class ScopeItemModel {
  final String id;
  final String description;
  final double quantity;
  final String unit;
  final double? estimatedCost;

  /// True when this item came from the AI document analysis rather
  /// than being typed in by the user via "Add Custom Scope Item" /
  /// the Manual Bid Entry screen.
  final bool isAiSuggested;

  /// Whether the item is checked-in for the final bid. AI-suggested
  /// items default to included; the user can uncheck ones that don't
  /// apply before continuing to Bid Details.
  final bool isIncluded;

  const ScopeItemModel({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    this.estimatedCost,
    this.isAiSuggested = false,
    this.isIncluded = true,
  });

  ScopeItemModel copyWith({
    String? description,
    double? quantity,
    String? unit,
    double? estimatedCost,
    bool? isIncluded,
  }) {
    return ScopeItemModel(
      id: id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      isAiSuggested: isAiSuggested,
      isIncluded: isIncluded ?? this.isIncluded,
    );
  }

  String get qtyLabel {
    final q = quantity == quantity.roundToDouble()
        ? quantity.toInt().toString()
        : quantity.toString();
    return '$q $unit';
  }

  String get costLabel =>
      estimatedCost == null ? '—' : '\$${estimatedCost!.toStringAsFixed(2)}';
}
