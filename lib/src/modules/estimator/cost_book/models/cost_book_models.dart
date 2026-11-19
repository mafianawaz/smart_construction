import 'package:intl/intl.dart';

/// Where a cost book's numbers come from. The Provider Kind dropdown defaults
/// to BUILTIN; the other two values are guesses (see NOTES_COST_BOOK.md).
enum ProviderKind {
  builtin('BUILTIN'),
  mainFile('MAIN_FILE'),
  externalApi('EXTERNAL_API');

  const ProviderKind(this.label);
  final String label;

  /// External providers are the ones that need an endpoint + key env var.
  bool get needsApi => this == ProviderKind.externalApi;
}

/// A configured cost-book source (e.g. RSI / RSMeans).
class CostBookProviderModel {
  final String id;
  final String name;
  final ProviderKind kind;
  final String apiEndpoint;
  final String apiKeyEnvVar;
  final String defaultRegion;
  final String notes;
  final bool isActive;
  final DateTime? lastSynced;

  const CostBookProviderModel({
    required this.id,
    required this.name,
    required this.kind,
    this.apiEndpoint = '',
    this.apiKeyEnvVar = '',
    this.defaultRegion = '',
    this.notes = '',
    this.isActive = true,
    this.lastSynced,
  });

  CostBookProviderModel copyWith({
    String? name,
    ProviderKind? kind,
    String? apiEndpoint,
    String? apiKeyEnvVar,
    String? defaultRegion,
    String? notes,
    bool? isActive,
    DateTime? lastSynced,
  }) {
    return CostBookProviderModel(
      id: id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      apiKeyEnvVar: apiKeyEnvVar ?? this.apiKeyEnvVar,
      defaultRegion: defaultRegion ?? this.defaultRegion,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  /// "—" when no default region is set, as in the design.
  String get regionLabel => defaultRegion.isEmpty ? '—' : defaultRegion;

  String get lastSyncedLabel => lastSynced == null
      ? 'Never'
      : DateFormat('MMM d, yyyy h:mm a').format(lastSynced!);
}

/// One published unit-cost line item. `total` is its own field because the
/// design's totals are not a plain MAT+LABOR+EQUIP sum.
class CostBookEntryModel {
  final String id;
  final String providerId;
  final String code;
  final String unit;
  final String description;
  final double material;
  final double labor;
  final double equipment;
  final double total;

  const CostBookEntryModel({
    required this.id,
    required this.providerId,
    required this.code,
    required this.unit,
    required this.description,
    required this.material,
    required this.labor,
    required this.equipment,
    required this.total,
  });

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return code.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q);
  }
}

/// Per-region multipliers applied during cost book lookups.
class GeoFactorModel {
  final String id;
  final String regionCode;
  final String regionName;
  final String city;
  final String state;
  final String postalCode;
  final double materialMult;
  final double laborMult;
  final double equipmentMult;
  final double totalMult;
  final DateTime asOf;

  const GeoFactorModel({
    required this.id,
    required this.regionCode,
    required this.regionName,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.materialMult,
    required this.laborMult,
    required this.equipmentMult,
    required this.totalMult,
    required this.asOf,
  });

  /// "JS-CHI — Chicago, IL"
  String get title => '$regionCode — $regionName';

  /// "Chicago, IL" (falls back gracefully when city/state are blank).
  String get locationLabel {
    final parts = [city, state].where((p) => p.trim().isNotEmpty).toList();
    return parts.join(', ');
  }
}

final NumberFormat _usd = NumberFormat.currency(symbol: '\$');

String formatCost(double value) => _usd.format(value);

/// Multipliers always show three decimals (1.313, 1.000).
String formatMult(double value) => value.toStringAsFixed(3);

final DateFormat _fieldDate = DateFormat('MM/dd/yyyy');

String formatFieldDate(DateTime d) => _fieldDate.format(d);
