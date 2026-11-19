import '../../../../widgets/pill_tab_group.dart';
import '../models/calculator_models.dart';

/// Conversion factors and unit lists for the Unit Converter category.
///
/// Every unit stores `factorToBase`: the multiplier that converts 1 unit
/// into that type's base unit (meters / sq meters / cubic meters). Any
/// value can then be converted from unit A to unit B via:
///
/// ```dart
/// final result = value * unitA.factorToBase / unitB.factorToBase;
/// ```
class UnitConversionData {
  static List<PillTabItem<UnitConverterType>> get typeTabs => const [
        PillTabItem(value: UnitConverterType.length, label: 'Length'),
        PillTabItem(value: UnitConverterType.area, label: 'Area'),
        PillTabItem(value: UnitConverterType.volume, label: 'Volume'),
      ];

  static List<UnitDefinition> unitsFor(UnitConverterType type) {
    switch (type) {
      case UnitConverterType.length:
        return _lengthUnits;
      case UnitConverterType.area:
        return _areaUnits;
      case UnitConverterType.volume:
        return _volumeUnits;
    }
  }

  // Base unit: meters
  static const _lengthUnits = <UnitDefinition>[
    UnitDefinition(id: 'ft', label: 'Feet', factorToBase: 0.3048),
    UnitDefinition(id: 'm', label: 'Meters', factorToBase: 1),
    UnitDefinition(id: 'in', label: 'Inches', factorToBase: 0.0254),
    UnitDefinition(id: 'yd', label: 'Yards', factorToBase: 0.9144),
    UnitDefinition(id: 'cm', label: 'Centimeters', factorToBase: 0.01),
  ];

  // Base unit: square meters
  static const _areaUnits = <UnitDefinition>[
    UnitDefinition(id: 'sqft', label: 'Sq Feet', factorToBase: 0.09290304),
    UnitDefinition(id: 'sqm', label: 'Sq Meters', factorToBase: 1),
    UnitDefinition(id: 'sqyd', label: 'Sq Yards', factorToBase: 0.83612736),
    UnitDefinition(id: 'acre', label: 'Acres', factorToBase: 4046.8564224),
  ];

  // Base unit: cubic meters
  static const _volumeUnits = <UnitDefinition>[
    UnitDefinition(id: 'cuft', label: 'Cubic Feet', factorToBase: 0.0283168),
    UnitDefinition(id: 'cum', label: 'Cubic Meters', factorToBase: 1),
    UnitDefinition(id: 'cuyd', label: 'Cubic Yards', factorToBase: 0.764555),
    UnitDefinition(id: 'l', label: 'Liters', factorToBase: 0.001),
    UnitDefinition(id: 'gal', label: 'Gallons (US)', factorToBase: 0.00378541),
  ];
}
