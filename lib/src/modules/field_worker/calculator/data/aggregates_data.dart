import '../models/aggregates_models.dart';

/// Reference material options for the Aggregates calculator.
///
/// `defaultDensityTonsPerCuYd` is a typical mid-range figure used to
/// pre-fill the editable Density field — actual density varies with
/// moisture content and compaction, so treat these as starting points,
/// not guaranteed values.
class AggregatesData {
  static const materialOptions = <AggregateMaterialOption>[
    AggregateMaterialOption(id: 'gravel', label: 'Gravel', defaultDensityTonsPerCuYd: 1.4),
    AggregateMaterialOption(id: 'sand', label: 'Sand', defaultDensityTonsPerCuYd: 1.35),
    AggregateMaterialOption(
      id: 'crushed_stone',
      label: 'Crushed Stone',
      defaultDensityTonsPerCuYd: 1.5,
    ),
    AggregateMaterialOption(id: 'topsoil', label: 'Topsoil', defaultDensityTonsPerCuYd: 1.0),
    AggregateMaterialOption(id: 'mulch', label: 'Mulch', defaultDensityTonsPerCuYd: 0.4),
  ];

  /// Default matches the reference design (Gravel).
  static AggregateMaterialOption get defaultMaterial => materialOptions.first;
}
