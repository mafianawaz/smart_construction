import '../models/cost_book_models.dart';

/// Mock-data seam for the Cost Book feature.
class CostBookMockData {
  CostBookMockData._();

  // TODO(api): GET /cost-book/providers
  static List<CostBookProviderModel> providers() => [
        CostBookProviderModel(
          id: 'prov-rsi',
          name: 'RSI',
          kind: ProviderKind.mainFile,
          lastSynced: DateTime(2025, 6, 24, 17, 27),
        ),
      ];

  // TODO(api): GET /cost-book/providers/{providerId}/entries
  static List<CostBookEntryModel> entries() => const [
        CostBookEntryModel(
          id: 'ent-1',
          providerId: 'prov-rsi',
          code: '09290100100',
          unit: 'SF',
          description: 'Drywall, Diff Type X, Rodg, taped, finished',
          material: 0.58,
          labor: 1.33,
          equipment: 0.00,
          total: 1.90,
        ),
        CostBookEntryModel(
          id: 'ent-2',
          providerId: 'prov-rsi',
          code: '08111310000',
          unit: 'EA',
          description: 'Metal door, hollow metal, 3\'-0" x 7\'-0", painted',
          material: 295.00,
          labor: 99.00,
          equipment: 0.00,
          total: 395.80,
        ),
      ];

  // TODO(api): GET /cost-book/geo-factors
  static List<GeoFactorModel> geoFactors() => [
        GeoFactorModel(
          id: 'geo-chi',
          regionCode: 'JS-CHI',
          regionName: 'Chicago, IL',
          city: 'Chicago',
          state: 'IL',
          postalCode: '60601',
          materialMult: 1.313,
          laborMult: 1.260,
          equipmentMult: 1.000,
          totalMult: 1.000,
          asOf: DateTime(2026, 12, 8),
        ),
        GeoFactorModel(
          id: 'geo-hou',
          regionCode: 'JS-HOU',
          regionName: 'Houston, TX',
          city: 'Houston',
          state: 'TX',
          postalCode: '77002',
          materialMult: 0.953,
          laborMult: 0.670,
          equipmentMult: 0.960,
          totalMult: 1.000,
          asOf: DateTime(2026, 12, 8),
        ),
      ];
}
