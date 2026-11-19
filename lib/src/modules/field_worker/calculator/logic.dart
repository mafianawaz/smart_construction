import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/aggregates_data.dart';
import 'data/concrete_materials_data.dart';
import 'data/drywall_data.dart';
import 'data/geometry_data.dart';
import 'data/lumber_framing_data.dart';
import 'data/masonry_data.dart';
import 'data/paint_coating_data.dart';
import 'data/profit_margin_data.dart';
import 'data/roofing_data.dart';
import 'data/tiling_data.dart';
import 'data/unit_conversion_data.dart';
import 'models/aggregates_models.dart';
import 'models/calculator_models.dart';
import 'models/drywall_models.dart';
import 'models/geometry_models.dart';
import 'models/lumber_framing_models.dart';
import 'models/masonry_models.dart';
import 'models/paint_coating_models.dart';
import 'models/roofing_models.dart';
import 'models/tiling_models.dart';

/// Single shared controller for every Calculator category. Each category
/// owns a clearly-delimited region below (its own controllers, setters, and
/// a private `_calculateX()`), all wired up once in [onInit] and disposed
/// once in [onClose]. This keeps every category consistent with how Unit
/// Converter and Concrete & Materials were originally built, rather than
/// each category reaching for its own dedicated `GetxController`.
class CalculatorLogic extends GetxController {
  // ============================================================
  // Category (top-level)
  // ============================================================
  CalculatorCategory selectedCategory = CalculatorCategory.unitConverter;

  void changeCategory(CalculatorCategory category) {
    if (selectedCategory == category) return;
    selectedCategory = category;
    update();
  }

  // ============================================================
  // Unit Converter
  // ============================================================
  UnitConverterType selectedUnitType = UnitConverterType.length;
  final TextEditingController valueController = TextEditingController();
  UnitDefinition? fromUnit;
  UnitDefinition? toUnit;
  String convertedResult = '';

  void changeUnitType(UnitConverterType type) {
    if (selectedUnitType == type) return;
    selectedUnitType = type;
    valueController.clear();
    convertedResult = '';
    _resetUnitsForType();
    update();
  }

  void _resetUnitsForType() {
    final units = UnitConversionData.unitsFor(selectedUnitType);
    fromUnit = units.first;
    toUnit = units.length > 1 ? units[1] : units.first;
  }

  void setFromUnit(UnitDefinition? unit) {
    fromUnit = unit;
    _convert();
  }

  void setToUnit(UnitDefinition? unit) {
    toUnit = unit;
    _convert();
  }

  void swapUnits() {
    final temp = fromUnit;
    fromUnit = toUnit;
    toUnit = temp;
    _convert();
  }

  void _convert() {
    final raw = valueController.text.trim();
    final value = double.tryParse(raw);
    if (value == null || fromUnit == null || toUnit == null) {
      convertedResult = '';
      update();
      return;
    }
    final baseValue = value * fromUnit!.factorToBase;
    final result = baseValue / toUnit!.factorToBase;
    convertedResult = _formatNumber(result);
    update();
  }

  // ============================================================
  // Concrete & Materials
  // ============================================================
  ConcreteMaterialType selectedConcreteType = ConcreteMaterialType.singleArea;
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController depthController = TextEditingController();
  final TextEditingController wasteFactorController = TextEditingController(text: '10');

  bool concreteEnabled = true;
  final Map<String, bool> additionalToggles = {
    for (final opt in ConcreteMaterialsData.additionalOptions) opt.key: false,
  };
  final Map<String, String> concreteResults = {};

  void changeConcreteType(ConcreteMaterialType type) {
    if (selectedConcreteType == type) return;
    selectedConcreteType = type;
    _calculateConcrete();
  }

  void toggleConcrete(bool value) {
    concreteEnabled = value;
    _calculateConcrete();
  }

  void toggleAdditionalOption(String key, bool value) {
    additionalToggles[key] = value;
    _calculateConcrete();
  }

  void _calculateConcrete() {
    final length = double.tryParse(lengthController.text) ?? 0;
    final width = double.tryParse(widthController.text) ?? 0;
    final depthInches = double.tryParse(depthController.text) ?? 0;
    final waste = double.tryParse(wasteFactorController.text) ?? 0;

    concreteResults.clear();

    final areaSqFt = length * width;
    if (areaSqFt > 0) {
      concreteResults['area'] = '${_formatNumber(areaSqFt)} sq ft';
    }

    if (concreteEnabled && areaSqFt > 0 && depthInches > 0) {
      final volumeCuFt = areaSqFt * (depthInches / 12);
      final volumeWithWaste = volumeCuFt * (1 + waste / 100);
      final volumeCuYd = volumeWithWaste / 27;
      concreteResults['concreteVolume'] =
          '${_formatNumber(volumeWithWaste)} cu ft  (${_formatNumber(volumeCuYd)} cu yd)';
    }

    if (areaSqFt > 0) {
      additionalToggles.forEach((key, enabled) {
        if (enabled) {
          final line = ConcreteMaterialsData.estimate(key, areaSqFt, depthInches);
          if (line.isNotEmpty) concreteResults[key] = line;
        }
      });
    }

    update();
  }

  // ============================================================
  // Masonry
  // ============================================================
  final TextEditingController masonryWallLengthController = TextEditingController();
  final TextEditingController masonryWallHeightController = TextEditingController();
  final TextEditingController masonryUnitPriceController = TextEditingController();
  final TextEditingController masonryMortarPriceController = TextEditingController();

  MasonryUnitType masonrySelectedUnitType = MasonryData.unitTypes.first;
  MortarJointOption masonrySelectedJoint = MasonryData.defaultJoint;

  final List<MasonryOpening> masonryOpenings = [];
  final Map<String, String> masonryResults = {};

  void masonrySetUnitType(MasonryUnitType? type) {
    masonrySelectedUnitType = type ?? MasonryData.unitTypes.first;
    _calculateMasonry();
  }

  void masonrySetJoint(MortarJointOption? joint) {
    masonrySelectedJoint = joint ?? MasonryData.defaultJoint;
    _calculateMasonry();
  }

  void masonryAddOpening() {
    final opening = MasonryOpening();
    opening.widthController.addListener(_calculateMasonry);
    opening.heightController.addListener(_calculateMasonry);
    masonryOpenings.add(opening);
    update();
  }

  void masonryRemoveOpening(MasonryOpening opening) {
    masonryOpenings.remove(opening);
    opening.dispose();
    _calculateMasonry();
  }

  void _calculateMasonry() {
    final wallLength = double.tryParse(masonryWallLengthController.text) ?? 0;
    final wallHeight = double.tryParse(masonryWallHeightController.text) ?? 0;
    final grossArea = wallLength * wallHeight;

    double openingsArea = 0;
    for (final opening in masonryOpenings) {
      openingsArea += opening.areaSqFt;
    }

    final netArea = grossArea - openingsArea;
    masonryResults.clear();

    if (netArea <= 0) {
      update();
      return;
    }

    masonryResults['netArea'] = '${netArea.toStringAsFixed(2)} sq ft';

    // Face area of one unit including its mortar joint on two sides.
    final joint = masonrySelectedJoint.thicknessIn;
    final unitFaceAreaSqFt =
        ((masonrySelectedUnitType.lengthIn + joint) * (masonrySelectedUnitType.heightIn + joint)) /
            144;

    final unitsNeeded = unitFaceAreaSqFt > 0 ? (netArea / unitFaceAreaSqFt).ceil() : 0;
    masonryResults['units'] = '$unitsNeeded ${masonrySelectedUnitType.pluralLabel}';

    final bagsNeeded = masonrySelectedUnitType.unitsPerBag > 0
        ? (unitsNeeded / masonrySelectedUnitType.unitsPerBag).ceil()
        : 0;
    masonryResults['mortarBags'] = '$bagsNeeded bag(s)';

    final unitPrice = double.tryParse(masonryUnitPriceController.text);
    final mortarPrice = double.tryParse(masonryMortarPriceController.text);
    if (unitPrice != null || mortarPrice != null) {
      final cost = (unitsNeeded * (unitPrice ?? 0)) + (bagsNeeded * (mortarPrice ?? 0));
      masonryResults['estimatedCost'] = '\$${cost.toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Lumber & Framing
  // ============================================================
  LumberCalculatorMode lumberSelectedMode = LumberCalculatorMode.joistRafter;

  // Joist / Rafter
  final TextEditingController lumberSpanLengthController = TextEditingController();
  SpacingOption lumberJoistSpacing = LumberFramingData.defaultSpacing;
  LumberSizeOption lumberJoistSize = LumberFramingData.defaultSize;

  // Stud Calculator
  final TextEditingController lumberWallLengthController = TextEditingController();
  final TextEditingController lumberWallHeightController = TextEditingController();
  final TextEditingController lumberCornerCountController = TextEditingController();
  final TextEditingController lumberOpeningCountController = TextEditingController();
  SpacingOption lumberStudSpacing = LumberFramingData.defaultSpacing;

  // Board Feet
  final TextEditingController lumberThicknessController = TextEditingController();
  final TextEditingController lumberWidthController = TextEditingController();
  final TextEditingController lumberLengthController = TextEditingController();
  final TextEditingController lumberQuantityController = TextEditingController();

  // Common Settings (shared across all three modes)
  final TextEditingController lumberWasteFactorController = TextEditingController(text: '4');
  final TextEditingController lumberUnitPriceController = TextEditingController();

  final Map<String, String> lumberResults = {};

  void lumberChangeMode(LumberCalculatorMode mode) {
    if (lumberSelectedMode == mode) return;
    lumberSelectedMode = mode;
    _calculateLumber();
  }

  void lumberSetJoistSpacing(SpacingOption? spacing) {
    lumberJoistSpacing = spacing ?? LumberFramingData.defaultSpacing;
    _calculateLumber();
  }

  void lumberSetJoistSize(LumberSizeOption? size) {
    lumberJoistSize = size ?? LumberFramingData.defaultSize;
    _calculateLumber();
  }

  void lumberSetStudSpacing(SpacingOption? spacing) {
    lumberStudSpacing = spacing ?? LumberFramingData.defaultSpacing;
    _calculateLumber();
  }

  double get _lumberWasteMultiplier =>
      1 + ((double.tryParse(lumberWasteFactorController.text) ?? 0) / 100);

  void _calculateLumber() {
    switch (lumberSelectedMode) {
      case LumberCalculatorMode.joistRafter:
        _calculateJoistRafter();
        break;
      case LumberCalculatorMode.studCalculator:
        _calculateStuds();
        break;
      case LumberCalculatorMode.boardFeet:
        _calculateBoardFeet();
        break;
    }
  }

  void _calculateJoistRafter() {
    lumberResults.clear();
    final spanFt = double.tryParse(lumberSpanLengthController.text) ?? 0;
    if (spanFt <= 0) {
      update();
      return;
    }

    final pieceCount = ((spanFt * 12) / lumberJoistSpacing.inches).ceil() + 1;
    final piecesWithWaste = (pieceCount * _lumberWasteMultiplier).ceil();
    final rimBandLinearFt = spanFt * 2; // rim/band board runs both long edges
    final totalLinearFt = piecesWithWaste * spanFt;
    final boardFeet =
        (lumberJoistSize.actualThicknessIn * lumberJoistSize.actualWidthIn * totalLinearFt) / 12;

    lumberResults['pieceCount'] = '$piecesWithWaste pcs';
    lumberResults['rimBandLinearFt'] = '${rimBandLinearFt.toStringAsFixed(1)} linear ft';
    lumberResults['boardFeet'] = '${boardFeet.toStringAsFixed(1)} bd ft';
    _applyLumberCost(piecesWithWaste.toDouble());
  }

  void _calculateStuds() {
    lumberResults.clear();
    final wallLength = double.tryParse(lumberWallLengthController.text) ?? 0;
    if (wallLength <= 0) {
      update();
      return;
    }

    final cornerCount = double.tryParse(lumberCornerCountController.text) ?? 0;
    final openingCount = double.tryParse(lumberOpeningCountController.text) ?? 0;

    final fieldStuds = ((wallLength * 12) / lumberStudSpacing.inches).ceil() + 1;
    // 3 studs per corner ("California corner") + 4 studs per opening
    // (2 king + 2 jack) — standard framing rules of thumb.
    final cornerStuds = (cornerCount * 3).round();
    final openingStuds = (openingCount * 4).round();
    final totalStuds = ((fieldStuds + cornerStuds + openingStuds) * _lumberWasteMultiplier).ceil();

    // Single bottom plate + double top plate = 3x wall length of plate stock.
    final plateLinearFt = wallLength * 3;

    lumberResults['totalStuds'] = '$totalStuds pcs';
    lumberResults['plateLinearFt'] = '${plateLinearFt.toStringAsFixed(1)} linear ft';
    _applyLumberCost(totalStuds.toDouble());
  }

  void _calculateBoardFeet() {
    lumberResults.clear();
    final thicknessIn = double.tryParse(lumberThicknessController.text) ?? 0;
    final widthIn = double.tryParse(lumberWidthController.text) ?? 0;
    final lengthFt = double.tryParse(lumberLengthController.text) ?? 0;
    final quantity = double.tryParse(lumberQuantityController.text) ?? 0;

    if (thicknessIn <= 0 || widthIn <= 0 || lengthFt <= 0 || quantity <= 0) {
      update();
      return;
    }

    final boardFeetPerPiece = (thicknessIn * widthIn * lengthFt) / 12;
    final totalBoardFeet = boardFeetPerPiece * quantity * _lumberWasteMultiplier;

    lumberResults['boardFeetPerPiece'] = '${boardFeetPerPiece.toStringAsFixed(2)} bd ft/pc';
    lumberResults['totalBoardFeet'] = '${totalBoardFeet.toStringAsFixed(2)} bd ft';
    _applyLumberCost(quantity);
  }

  void _applyLumberCost(double pieceCount) {
    final unitPrice = double.tryParse(lumberUnitPriceController.text);
    if (unitPrice != null) {
      lumberResults['estimatedCost'] = '\$${(pieceCount * unitPrice).toStringAsFixed(2)}';
    }
    update();
  }

  // ============================================================
  // Roofing
  // ============================================================
  final TextEditingController roofingBuildingLengthController = TextEditingController();
  final TextEditingController roofingBuildingWidthController = TextEditingController();
  final TextEditingController roofingOverhangController = TextEditingController();
  RoofPitchOption roofingSelectedPitch = RoofingData.defaultPitch;
  RoofMaterialOption roofingSelectedMaterial = RoofingData.defaultMaterial;
  final TextEditingController roofingWasteFactorController = TextEditingController(text: '10');
  final TextEditingController roofingUnitPriceController = TextEditingController();

  final Map<String, String> roofingResults = {};

  void roofingSetPitch(RoofPitchOption? pitch) {
    roofingSelectedPitch = pitch ?? RoofingData.defaultPitch;
    _calculateRoofing();
  }

  void roofingSetMaterial(RoofMaterialOption? material) {
    roofingSelectedMaterial = material ?? RoofingData.defaultMaterial;
    _calculateRoofing();
  }

  void _calculateRoofing() {
    roofingResults.clear();
    final buildingLength = double.tryParse(roofingBuildingLengthController.text) ?? 0;
    final buildingWidth = double.tryParse(roofingBuildingWidthController.text) ?? 0;
    if (buildingLength <= 0 || buildingWidth <= 0) {
      update();
      return;
    }

    final overhangFt = (double.tryParse(roofingOverhangController.text) ?? 0) / 12;
    final waste = double.tryParse(roofingWasteFactorController.text) ?? 0;

    // Placeholder: assumes a simple gable roof — ridge runs the full
    // building length, footprint grows evenly on all sides by the overhang.
    final footprintLength = buildingLength + (2 * overhangFt);
    final footprintWidth = buildingWidth + (2 * overhangFt);
    final footprintArea = footprintLength * footprintWidth;

    final pitchRatio = roofingSelectedPitch.riseIn / 12;
    final pitchMultiplier = math.sqrt(1 + (pitchRatio * pitchRatio));
    final roofArea = footprintArea * pitchMultiplier * (1 + waste / 100);
    final roofingSquares = roofArea / 100;

    final unitsNeeded = (roofingSquares * roofingSelectedMaterial.unitsPerSquare).ceil();
    final underlaymentRolls = (roofArea / RoofingData.underlaymentSqFtPerRoll).ceil();
    final ridgeCapLinearFt = footprintLength;
    final dripEdgeLinearFt = 2 * (footprintLength + footprintWidth);

    roofingResults['roofArea'] = '${roofArea.toStringAsFixed(2)} sq ft';
    roofingResults['roofingSquares'] = roofingSquares.toStringAsFixed(2);
    roofingResults['materialUnits'] =
        '$unitsNeeded ${roofingSelectedMaterial.pluralLabel} (${roofingSelectedMaterial.label})';
    roofingResults['underlaymentRolls'] = '$underlaymentRolls roll(s)';
    roofingResults['ridgeCapLinearFt'] = '${ridgeCapLinearFt.toStringAsFixed(1)} linear ft';
    roofingResults['dripEdgeLinearFt'] = '${dripEdgeLinearFt.toStringAsFixed(1)} linear ft';

    final unitPrice = double.tryParse(roofingUnitPriceController.text);
    if (unitPrice != null) {
      roofingResults['estimatedCost'] = '\$${(roofingSquares * unitPrice).toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Tiling & Flooring
  // ============================================================
  final TextEditingController tilingAreaLengthController = TextEditingController();
  final TextEditingController tilingAreaWidthController = TextEditingController();
  TileSizeOption tilingSelectedTileSize = TilingData.defaultTileSize;
  GroutJointOption tilingSelectedGroutJoint = TilingData.defaultGroutJoint;
  TilePatternOption tilingSelectedPattern = TilingData.defaultPattern;
  final TextEditingController tilingWasteFactorController = TextEditingController(text: '10');
  final TextEditingController tilingPricePerTileController = TextEditingController();
  final TextEditingController tilingPricePerBoxController = TextEditingController();
  final TextEditingController tilingTilesPerBoxController = TextEditingController();

  final Map<String, String> tilingResults = {};

  void tilingSetTileSize(TileSizeOption? size) {
    tilingSelectedTileSize = size ?? TilingData.defaultTileSize;
    _calculateTiling();
  }

  void tilingSetGroutJoint(GroutJointOption? joint) {
    tilingSelectedGroutJoint = joint ?? TilingData.defaultGroutJoint;
    _calculateTiling();
  }

  void tilingSetPattern(TilePatternOption? pattern) {
    tilingSelectedPattern = pattern ?? TilingData.defaultPattern;
    _calculateTiling();
  }

  void _calculateTiling() {
    tilingResults.clear();
    final length = double.tryParse(tilingAreaLengthController.text) ?? 0;
    final width = double.tryParse(tilingAreaWidthController.text) ?? 0;
    final area = length * width;
    if (area <= 0) {
      update();
      return;
    }

    final waste = double.tryParse(tilingWasteFactorController.text) ?? 0;
    final totalWastePercent = waste + tilingSelectedPattern.extraWastePercent;

    final tilesNeeded =
        (area * (1 + totalWastePercent / 100) / tilingSelectedTileSize.areaSqFt).ceil();

    // Placeholder: grout coverage scales roughly linearly with joint width
    // relative to a 1/8" baseline — verify against your grout spec.
    final jointFactor = tilingSelectedGroutJoint.thicknessIn / TilingData.baselineJointIn;
    final groutBags = (area / TilingData.baselineGroutSqFtPerBag * jointFactor).ceil();

    tilingResults['area'] = '${area.toStringAsFixed(2)} sq ft';
    tilingResults['tilesNeeded'] = '$tilesNeeded tile(s)';
    tilingResults['groutBags'] = '$groutBags bag(s)';

    double? cost;
    final tilesPerBox = double.tryParse(tilingTilesPerBoxController.text);
    final pricePerBox = double.tryParse(tilingPricePerBoxController.text);
    final pricePerTile = double.tryParse(tilingPricePerTileController.text);

    if (tilesPerBox != null && tilesPerBox > 0) {
      final boxesNeeded = (tilesNeeded / tilesPerBox).ceil();
      tilingResults['boxesNeeded'] = '$boxesNeeded box(es)';
      if (pricePerBox != null) cost = boxesNeeded * pricePerBox;
    }
    if (cost == null && pricePerTile != null) {
      cost = tilesNeeded * pricePerTile;
    }
    if (cost != null) {
      tilingResults['estimatedCost'] = '\$${cost.toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Drywall
  // ============================================================
  final TextEditingController drywallRoomLengthController = TextEditingController();
  final TextEditingController drywallRoomWidthController = TextEditingController();
  final TextEditingController drywallWallHeightController = TextEditingController();
  final TextEditingController drywallWasteFactorController = TextEditingController(text: '10');
  bool drywallIncludeCeiling = true;
  DrywallSheetSizeOption drywallSelectedSheetSize = DrywallData.defaultSheetSize;
  final TextEditingController drywallDoorsCountController = TextEditingController();
  final TextEditingController drywallWindowsCountController = TextEditingController();
  final TextEditingController drywallPricePerSheetController = TextEditingController();

  final Map<String, String> drywallResults = {};

  void drywallSetIncludeCeiling(bool value) {
    drywallIncludeCeiling = value;
    _calculateDrywall();
  }

  void drywallSetSheetSize(DrywallSheetSizeOption? size) {
    drywallSelectedSheetSize = size ?? DrywallData.defaultSheetSize;
    _calculateDrywall();
  }

  void _calculateDrywall() {
    drywallResults.clear();
    final roomLength = double.tryParse(drywallRoomLengthController.text) ?? 0;
    final roomWidth = double.tryParse(drywallRoomWidthController.text) ?? 0;
    final wallHeight = double.tryParse(drywallWallHeightController.text) ?? 0;
    if (roomLength <= 0 || roomWidth <= 0 || wallHeight <= 0) {
      update();
      return;
    }

    final waste = double.tryParse(drywallWasteFactorController.text) ?? 0;
    final doors = double.tryParse(drywallDoorsCountController.text) ?? 0;
    final windows = double.tryParse(drywallWindowsCountController.text) ?? 0;

    final perimeter = 2 * (roomLength + roomWidth);
    final grossWallArea = perimeter * wallHeight;
    final openingsDeduction =
        (doors * DrywallData.doorAreaSqFt) + (windows * DrywallData.windowAreaSqFt);
    final netWallArea = (grossWallArea - openingsDeduction).clamp(0, double.infinity);
    final ceilingArea = drywallIncludeCeiling ? roomLength * roomWidth : 0.0;
    final totalArea = netWallArea + ceilingArea;

    final sheetsNeeded =
        (totalArea * (1 + waste / 100) / drywallSelectedSheetSize.areaSqFt).ceil();

    drywallResults['wallArea'] = '${netWallArea.toStringAsFixed(2)} sq ft';
    if (drywallIncludeCeiling) {
      drywallResults['ceilingArea'] = '${ceilingArea.toStringAsFixed(2)} sq ft';
    }
    drywallResults['totalArea'] = '${totalArea.toStringAsFixed(2)} sq ft';
    drywallResults['sheetsNeeded'] = '$sheetsNeeded sheet(s)';

    final pricePerSheet = double.tryParse(drywallPricePerSheetController.text);
    if (pricePerSheet != null) {
      drywallResults['estimatedCost'] = '\$${(sheetsNeeded * pricePerSheet).toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Paint & Coating
  // ============================================================
  final TextEditingController paintRoomLengthController = TextEditingController();
  final TextEditingController paintRoomWidthController = TextEditingController();
  final TextEditingController paintWallHeightController = TextEditingController();
  bool paintIncludeCeiling = true;
  int paintSelectedCoats = PaintCoatingData.defaultCoats;
  PaintCoverageOption paintSelectedCoverage = PaintCoatingData.defaultCoverage;
  final TextEditingController paintDoorsCountController = TextEditingController();
  final TextEditingController paintWindowsCountController = TextEditingController();
  final TextEditingController paintPricePerGallonController = TextEditingController();

  final Map<String, String> paintResults = {};

  void paintSetIncludeCeiling(bool value) {
    paintIncludeCeiling = value;
    _calculatePaint();
  }

  void paintSetCoats(int? coats) {
    paintSelectedCoats = coats ?? PaintCoatingData.defaultCoats;
    _calculatePaint();
  }

  void paintSetCoverage(PaintCoverageOption? coverage) {
    paintSelectedCoverage = coverage ?? PaintCoatingData.defaultCoverage;
    _calculatePaint();
  }

  void _calculatePaint() {
    paintResults.clear();
    final roomLength = double.tryParse(paintRoomLengthController.text) ?? 0;
    final roomWidth = double.tryParse(paintRoomWidthController.text) ?? 0;
    final wallHeight = double.tryParse(paintWallHeightController.text) ?? 0;
    if (roomLength <= 0 || roomWidth <= 0 || wallHeight <= 0) {
      update();
      return;
    }

    final doors = double.tryParse(paintDoorsCountController.text) ?? 0;
    final windows = double.tryParse(paintWindowsCountController.text) ?? 0;

    final perimeter = 2 * (roomLength + roomWidth);
    final grossWallArea = perimeter * wallHeight;
    final openingsDeduction =
        (doors * PaintCoatingData.doorAreaSqFt) + (windows * PaintCoatingData.windowAreaSqFt);
    final netWallArea = (grossWallArea - openingsDeduction).clamp(0, double.infinity);
    final ceilingArea = paintIncludeCeiling ? roomLength * roomWidth : 0.0;
    final paintableArea = netWallArea + ceilingArea;
    final areaWithCoats = paintableArea * paintSelectedCoats;

    final gallonsNeeded = (areaWithCoats / paintSelectedCoverage.sqFtPerGallon).ceil();

    paintResults['paintableArea'] = '${paintableArea.toStringAsFixed(2)} sq ft';
    paintResults['gallonsNeeded'] = '$gallonsNeeded gal';

    final pricePerGallon = double.tryParse(paintPricePerGallonController.text);
    if (pricePerGallon != null) {
      paintResults['estimatedCost'] = '\$${(gallonsNeeded * pricePerGallon).toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Aggregates
  // ============================================================
  final TextEditingController aggregatesLengthController = TextEditingController();
  final TextEditingController aggregatesWidthController = TextEditingController();
  final TextEditingController aggregatesDepthController = TextEditingController();
  final TextEditingController aggregatesWasteFactorController = TextEditingController(text: '10');
  AggregateMaterialOption aggregatesSelectedMaterial = AggregatesData.defaultMaterial;
  final TextEditingController aggregatesDensityController =
      TextEditingController(text: AggregatesData.defaultMaterial.defaultDensityTonsPerCuYd.toString());
  final TextEditingController aggregatesPricePerTonController = TextEditingController();
  final TextEditingController aggregatesPricePerCubicYardController = TextEditingController();

  final Map<String, String> aggregatesResults = {};

  void aggregatesSetMaterial(AggregateMaterialOption? material) {
    aggregatesSelectedMaterial = material ?? AggregatesData.defaultMaterial;
    // Refresh the density field with this material's typical value — still
    // editable afterwards if the user has a lab-tested figure to use instead.
    aggregatesDensityController.text = aggregatesSelectedMaterial.defaultDensityTonsPerCuYd.toString();
    _calculateAggregates();
  }

  void _calculateAggregates() {
    aggregatesResults.clear();
    final length = double.tryParse(aggregatesLengthController.text) ?? 0;
    final width = double.tryParse(aggregatesWidthController.text) ?? 0;
    final depthInches = double.tryParse(aggregatesDepthController.text) ?? 0;
    if (length <= 0 || width <= 0 || depthInches <= 0) {
      update();
      return;
    }

    final waste = double.tryParse(aggregatesWasteFactorController.text) ?? 0;
    final density =
        double.tryParse(aggregatesDensityController.text) ?? aggregatesSelectedMaterial.defaultDensityTonsPerCuYd;

    final areaSqFt = length * width;
    final volumeCuFt = areaSqFt * (depthInches / 12) * (1 + waste / 100);
    final volumeCuYd = volumeCuFt / 27;
    final weightTons = volumeCuYd * density;

    aggregatesResults['volume'] =
        '${volumeCuFt.toStringAsFixed(2)} cu ft  (${volumeCuYd.toStringAsFixed(2)} cu yd)';
    aggregatesResults['weight'] = '${weightTons.toStringAsFixed(2)} tons';

    final pricePerTon = double.tryParse(aggregatesPricePerTonController.text);
    final pricePerCubicYard = double.tryParse(aggregatesPricePerCubicYardController.text);
    if (pricePerTon != null) {
      aggregatesResults['estimatedCost'] = '\$${(weightTons * pricePerTon).toStringAsFixed(2)}';
    } else if (pricePerCubicYard != null) {
      aggregatesResults['estimatedCost'] =
          '\$${(volumeCuYd * pricePerCubicYard).toStringAsFixed(2)}';
    }

    update();
  }

  // ============================================================
  // Geometry
  // ============================================================
  GeometryShape geometrySelectedShape = GeometryShape.rectangle;
  final Map<String, String> geometryResults = {};

  void geometryChangeShape(GeometryShape shape) {
    if (geometrySelectedShape == shape) return;
    geometrySelectedShape = shape;
    _calculateGeometry();
  }

  // Rectangle
  final TextEditingController geoRectLengthController = TextEditingController();
  final TextEditingController geoRectWidthController = TextEditingController();

  // Triangle
  TriangleModeOption geoTriangleMode = GeometryData.defaultTriangleMode;
  final TextEditingController geoTriBaseController = TextEditingController();
  final TextEditingController geoTriHeightController = TextEditingController();
  final TextEditingController geoTriSideAController = TextEditingController();
  final TextEditingController geoTriSideBController = TextEditingController();
  final TextEditingController geoTriSideCController = TextEditingController();

  void geometrySetTriangleMode(TriangleModeOption? mode) {
    geoTriangleMode = mode ?? GeometryData.defaultTriangleMode;
    _calculateGeometry();
  }

  // Circle
  final TextEditingController geoCircleRadiusController = TextEditingController();
  final TextEditingController geoCircleDiameterController = TextEditingController();

  // Slope
  final TextEditingController geoSlopeRiseController = TextEditingController();
  final TextEditingController geoSlopeRunController = TextEditingController();

  void _calculateGeometry() {
    switch (geometrySelectedShape) {
      case GeometryShape.rectangle:
        _calculateRectangle();
        break;
      case GeometryShape.triangle:
        _calculateTriangle();
        break;
      case GeometryShape.circle:
        _calculateCircle();
        break;
      case GeometryShape.slope:
        _calculateSlope();
        break;
    }
  }

  void _calculateRectangle() {
    geometryResults.clear();
    final length = double.tryParse(geoRectLengthController.text) ?? 0;
    final width = double.tryParse(geoRectWidthController.text) ?? 0;
    if (length <= 0 || width <= 0) {
      update();
      return;
    }
    geometryResults['area'] = '${(length * width).toStringAsFixed(2)} sq ft';
    geometryResults['perimeter'] = '${(2 * (length + width)).toStringAsFixed(2)} ft';
    update();
  }

  void _calculateTriangle() {
    geometryResults.clear();
    switch (geoTriangleMode.mode) {
      case TriangleMode.rightTwoSides:
      case TriangleMode.baseHeight:
        final base = double.tryParse(geoTriBaseController.text) ?? 0;
        final height = double.tryParse(geoTriHeightController.text) ?? 0;
        if (base <= 0 || height <= 0) {
          update();
          return;
        }
        geometryResults['area'] = '${(0.5 * base * height).toStringAsFixed(2)} sq ft';
        if (geoTriangleMode.mode == TriangleMode.rightTwoSides) {
          final hypotenuse = math.sqrt((base * base) + (height * height));
          geometryResults['hypotenuse'] = '${hypotenuse.toStringAsFixed(2)} ft';
          geometryResults['perimeter'] = '${(base + height + hypotenuse).toStringAsFixed(2)} ft';
        }
        break;
      case TriangleMode.threeSides:
        final a = double.tryParse(geoTriSideAController.text) ?? 0;
        final b = double.tryParse(geoTriSideBController.text) ?? 0;
        final c = double.tryParse(geoTriSideCController.text) ?? 0;
        if (a <= 0 || b <= 0 || c <= 0) {
          update();
          return;
        }
        // Triangle inequality — three sides that can't form a triangle.
        if (a + b <= c || a + c <= b || b + c <= a) {
          geometryResults['error'] = 'These three sides cannot form a triangle';
          update();
          return;
        }
        final s = (a + b + c) / 2;
        final area = math.sqrt(s * (s - a) * (s - b) * (s - c));
        geometryResults['area'] = '${area.toStringAsFixed(2)} sq ft';
        geometryResults['perimeter'] = '${(a + b + c).toStringAsFixed(2)} ft';
        break;
    }
    update();
  }

  void _calculateCircle() {
    geometryResults.clear();
    final radiusInput = double.tryParse(geoCircleRadiusController.text);
    final diameterInput = double.tryParse(geoCircleDiameterController.text);

    double? radius;
    if (radiusInput != null && radiusInput > 0) {
      radius = radiusInput;
    } else if (diameterInput != null && diameterInput > 0) {
      radius = diameterInput / 2;
    }

    if (radius == null) {
      update();
      return;
    }

    geometryResults['diameter'] = '${(radius * 2).toStringAsFixed(2)} ft';
    geometryResults['area'] = '${(math.pi * radius * radius).toStringAsFixed(2)} sq ft';
    geometryResults['circumference'] = '${(2 * math.pi * radius).toStringAsFixed(2)} ft';
    update();
  }

  void _calculateSlope() {
    geometryResults.clear();
    final rise = double.tryParse(geoSlopeRiseController.text) ?? 0;
    final run = double.tryParse(geoSlopeRunController.text) ?? 0;
    if (run <= 0) {
      update();
      return;
    }

    final slopePercent = (rise / run) * 100;
    final angleDegrees = math.atan(rise / run) * (180 / math.pi);

    geometryResults['slopePercent'] = '${slopePercent.toStringAsFixed(1)}%';
    geometryResults['angle'] = '${angleDegrees.toStringAsFixed(1)}°';
    geometryResults['pitch'] = _nearestRoofPitchLabel(rise, run);
    update();
  }

  /// Expresses a rise/run ratio as the closest standard roofing pitch
  /// (reusing [RoofingData.pitchOptions]) — a familiar way for a builder to
  /// read a slope, e.g. "≈ 6/12".
  String _nearestRoofPitchLabel(double rise, double run) {
    final riseIn12 = (rise / run) * 12;
    var closest = RoofingData.pitchOptions.first;
    var smallestDiff = (closest.riseIn - riseIn12).abs();
    for (final option in RoofingData.pitchOptions) {
      final diff = (option.riseIn - riseIn12).abs();
      if (diff < smallestDiff) {
        closest = option;
        smallestDiff = diff;
      }
    }
    final isExact = smallestDiff < 0.05;
    return isExact ? closest.label : '≈ ${closest.label}';
  }

  // ============================================================
  // Profit Margin
  // ============================================================
  final TextEditingController pmMaterialCostController = TextEditingController();
  final TextEditingController pmLaborCostController = TextEditingController();
  final TextEditingController pmEquipmentCostController = TextEditingController();
  final TextEditingController pmSubcontractorCostController = TextEditingController();
  final TextEditingController pmOverheadCostController = TextEditingController();
  double pmDesiredMargin = 20;
  final TextEditingController pmQuantityController = TextEditingController();
  String? pmSelectedUnit;

  final Map<String, String> pmResults = {};

  void pmSetMargin(double value) {
    pmDesiredMargin = value;
    _calculateProfitMargin();
  }

  void pmSetUnit(String? unit) {
    pmSelectedUnit = unit;
    _calculateProfitMargin();
  }

  void _calculateProfitMargin() {
    pmResults.clear();
    final material = double.tryParse(pmMaterialCostController.text) ?? 0;
    final labor = double.tryParse(pmLaborCostController.text) ?? 0;
    final equipment = double.tryParse(pmEquipmentCostController.text) ?? 0;
    final subcontractor = double.tryParse(pmSubcontractorCostController.text) ?? 0;
    final overhead = double.tryParse(pmOverheadCostController.text) ?? 0;
    final totalCost = material + labor + equipment + subcontractor + overhead;
    if (totalCost <= 0) {
      update();
      return;
    }

    // Margin = profit as a % of the *selling price* (not of cost — that's
    // Markup, next section). Clamped below 100% to avoid a divide-by-zero
    // or negative price as the slider approaches full margin.
    final marginFraction = (pmDesiredMargin / 100).clamp(0, 0.95);
    final sellingPrice = totalCost / (1 - marginFraction);
    final profitAmount = sellingPrice - totalCost;

    pmResults['totalCost'] = '\$${totalCost.toStringAsFixed(2)}';
    pmResults['profitAmount'] = '\$${profitAmount.toStringAsFixed(2)}';
    pmResults['bidPrice'] = '\$${sellingPrice.toStringAsFixed(2)}';

    final quantity = double.tryParse(pmQuantityController.text);
    if (quantity != null && quantity > 0) {
      final perUnit = sellingPrice / quantity;
      final unitSuffix = pmSelectedUnit != null ? ' / ${pmSelectedUnit!}' : ' / unit';
      pmResults['pricePerUnit'] = '\$${perUnit.toStringAsFixed(2)}$unitSuffix';
    }

    update();
  }

  // ============================================================
  // Markup
  // ============================================================
  final TextEditingController mkMaterialCostController = TextEditingController();
  final TextEditingController mkLaborCostController = TextEditingController();
  final TextEditingController mkEquipmentCostController = TextEditingController();
  final TextEditingController mkSubcontractorCostController = TextEditingController();
  final TextEditingController mkConsumableCostController = TextEditingController();
  double mkOverheadPercent = 20;
  double mkProfitPercent = 20;

  final Map<String, String> mkResults = {};

  void mkSetOverheadPercent(double value) {
    mkOverheadPercent = value;
    _calculateMarkup();
  }

  void mkSetProfitPercent(double value) {
    mkProfitPercent = value;
    _calculateMarkup();
  }

  void _calculateMarkup() {
    mkResults.clear();
    final material = double.tryParse(mkMaterialCostController.text) ?? 0;
    final labor = double.tryParse(mkLaborCostController.text) ?? 0;
    final equipment = double.tryParse(mkEquipmentCostController.text) ?? 0;
    final subcontractor = double.tryParse(mkSubcontractorCostController.text) ?? 0;
    final consumable = double.tryParse(mkConsumableCostController.text) ?? 0;
    final directCost = material + labor + equipment + subcontractor + consumable;
    if (directCost <= 0) {
      update();
      return;
    }

    // Markup = overhead % and profit % each applied on top of cost,
    // compounding — distinct from Profit Margin's "% of selling price".
    final overheadAmount = directCost * (mkOverheadPercent / 100);
    final costWithOverhead = directCost + overheadAmount;
    final profitAmount = costWithOverhead * (mkProfitPercent / 100);
    final finalBidPrice = costWithOverhead + profitAmount;

    mkResults['directCost'] = '\$${directCost.toStringAsFixed(2)}';
    mkResults['overheadAmount'] = '\$${overheadAmount.toStringAsFixed(2)}';
    mkResults['profitAmount'] = '\$${profitAmount.toStringAsFixed(2)}';
    mkResults['finalBidPrice'] = '\$${finalBidPrice.toStringAsFixed(2)}';

    update();
  }

  // ============================================================
  // Labor Cost
  // ============================================================
  final TextEditingController lcHourlyRateController = TextEditingController();
  final TextEditingController lcWorkersController = TextEditingController();
  final TextEditingController lcHoursPerDayController = TextEditingController();
  final TextEditingController lcDaysController = TextEditingController();
  final TextEditingController lcOvertimeHoursController = TextEditingController();
  double lcBenefitsBurdenRate = 20;

  final Map<String, String> lcResults = {};

  void lcSetBurdenRate(double value) {
    lcBenefitsBurdenRate = value;
    _calculateLaborCost();
  }

  void _calculateLaborCost() {
    lcResults.clear();
    final rate = double.tryParse(lcHourlyRateController.text) ?? 0;
    final workers = double.tryParse(lcWorkersController.text) ?? 0;
    final hoursPerDay = double.tryParse(lcHoursPerDayController.text) ?? 0;
    final days = double.tryParse(lcDaysController.text) ?? 0;
    if (rate <= 0 || workers <= 0 || hoursPerDay <= 0 || days <= 0) {
      update();
      return;
    }

    final overtimeHoursPerDay = double.tryParse(lcOvertimeHoursController.text) ?? 0;

    final regularHours = hoursPerDay * days * workers;
    final regularCost = regularHours * rate;
    final overtimeHours = overtimeHoursPerDay * days * workers;
    final overtimeCost = overtimeHours * rate * 1.5;
    final baseCost = regularCost + overtimeCost;
    final burdenAmount = baseCost * (lcBenefitsBurdenRate / 100);
    final totalCost = baseCost + burdenAmount;

    lcResults['regularCost'] = '\$${regularCost.toStringAsFixed(2)}';
    if (overtimeCost > 0) {
      lcResults['overtimeCost'] = '\$${overtimeCost.toStringAsFixed(2)}';
    }
    lcResults['burdenAmount'] = '\$${burdenAmount.toStringAsFixed(2)}';
    lcResults['totalLaborCost'] = '\$${totalCost.toStringAsFixed(2)}';

    update();
  }

  // ============================================================
  // Shared helpers
  // ============================================================
  String _formatNumber(double value) => value.toStringAsFixed(2);

  @override
  void onInit() {
    super.onInit();
    _resetUnitsForType();

    valueController.addListener(_convert);

    for (final c in [lengthController, widthController, depthController, wasteFactorController]) {
      c.addListener(_calculateConcrete);
    }

    for (final c in [
      masonryWallLengthController,
      masonryWallHeightController,
      masonryUnitPriceController,
      masonryMortarPriceController,
    ]) {
      c.addListener(_calculateMasonry);
    }

    for (final c in [
      lumberSpanLengthController,
      lumberWallLengthController,
      lumberWallHeightController,
      lumberCornerCountController,
      lumberOpeningCountController,
      lumberThicknessController,
      lumberWidthController,
      lumberLengthController,
      lumberQuantityController,
      lumberWasteFactorController,
      lumberUnitPriceController,
    ]) {
      c.addListener(_calculateLumber);
    }

    for (final c in [
      roofingBuildingLengthController,
      roofingBuildingWidthController,
      roofingOverhangController,
      roofingWasteFactorController,
      roofingUnitPriceController,
    ]) {
      c.addListener(_calculateRoofing);
    }

    for (final c in [
      tilingAreaLengthController,
      tilingAreaWidthController,
      tilingWasteFactorController,
      tilingPricePerTileController,
      tilingPricePerBoxController,
      tilingTilesPerBoxController,
    ]) {
      c.addListener(_calculateTiling);
    }

    for (final c in [
      drywallRoomLengthController,
      drywallRoomWidthController,
      drywallWallHeightController,
      drywallWasteFactorController,
      drywallDoorsCountController,
      drywallWindowsCountController,
      drywallPricePerSheetController,
    ]) {
      c.addListener(_calculateDrywall);
    }

    for (final c in [
      paintRoomLengthController,
      paintRoomWidthController,
      paintWallHeightController,
      paintDoorsCountController,
      paintWindowsCountController,
      paintPricePerGallonController,
    ]) {
      c.addListener(_calculatePaint);
    }

    for (final c in [
      aggregatesLengthController,
      aggregatesWidthController,
      aggregatesDepthController,
      aggregatesWasteFactorController,
      aggregatesDensityController,
      aggregatesPricePerTonController,
      aggregatesPricePerCubicYardController,
    ]) {
      c.addListener(_calculateAggregates);
    }

    for (final c in [geoRectLengthController, geoRectWidthController]) {
      c.addListener(_calculateGeometry);
    }
    for (final c in [
      geoTriBaseController,
      geoTriHeightController,
      geoTriSideAController,
      geoTriSideBController,
      geoTriSideCController,
    ]) {
      c.addListener(_calculateGeometry);
    }
    for (final c in [geoCircleRadiusController, geoCircleDiameterController]) {
      c.addListener(_calculateGeometry);
    }
    for (final c in [geoSlopeRiseController, geoSlopeRunController]) {
      c.addListener(_calculateGeometry);
    }

    for (final c in [
      pmMaterialCostController,
      pmLaborCostController,
      pmEquipmentCostController,
      pmSubcontractorCostController,
      pmOverheadCostController,
      pmQuantityController,
    ]) {
      c.addListener(_calculateProfitMargin);
    }

    for (final c in [
      mkMaterialCostController,
      mkLaborCostController,
      mkEquipmentCostController,
      mkSubcontractorCostController,
      mkConsumableCostController,
    ]) {
      c.addListener(_calculateMarkup);
    }

    for (final c in [
      lcHourlyRateController,
      lcWorkersController,
      lcHoursPerDayController,
      lcDaysController,
      lcOvertimeHoursController,
    ]) {
      c.addListener(_calculateLaborCost);
    }
  }

  @override
  void onClose() {
    valueController.dispose();

    for (final c in [lengthController, widthController, depthController, wasteFactorController]) {
      c.dispose();
    }

    for (final c in [
      masonryWallLengthController,
      masonryWallHeightController,
      masonryUnitPriceController,
      masonryMortarPriceController,
    ]) {
      c.dispose();
    }
    for (final opening in masonryOpenings) {
      opening.dispose();
    }

    for (final c in [
      lumberSpanLengthController,
      lumberWallLengthController,
      lumberWallHeightController,
      lumberCornerCountController,
      lumberOpeningCountController,
      lumberThicknessController,
      lumberWidthController,
      lumberLengthController,
      lumberQuantityController,
      lumberWasteFactorController,
      lumberUnitPriceController,
    ]) {
      c.dispose();
    }

    for (final c in [
      roofingBuildingLengthController,
      roofingBuildingWidthController,
      roofingOverhangController,
      roofingWasteFactorController,
      roofingUnitPriceController,
    ]) {
      c.dispose();
    }

    for (final c in [
      tilingAreaLengthController,
      tilingAreaWidthController,
      tilingWasteFactorController,
      tilingPricePerTileController,
      tilingPricePerBoxController,
      tilingTilesPerBoxController,
    ]) {
      c.dispose();
    }

    for (final c in [
      drywallRoomLengthController,
      drywallRoomWidthController,
      drywallWallHeightController,
      drywallWasteFactorController,
      drywallDoorsCountController,
      drywallWindowsCountController,
      drywallPricePerSheetController,
    ]) {
      c.dispose();
    }

    for (final c in [
      paintRoomLengthController,
      paintRoomWidthController,
      paintWallHeightController,
      paintDoorsCountController,
      paintWindowsCountController,
      paintPricePerGallonController,
    ]) {
      c.dispose();
    }

    for (final c in [
      aggregatesLengthController,
      aggregatesWidthController,
      aggregatesDepthController,
      aggregatesWasteFactorController,
      aggregatesDensityController,
      aggregatesPricePerTonController,
      aggregatesPricePerCubicYardController,
    ]) {
      c.dispose();
    }

    for (final c in [
      geoRectLengthController,
      geoRectWidthController,
      geoTriBaseController,
      geoTriHeightController,
      geoTriSideAController,
      geoTriSideBController,
      geoTriSideCController,
      geoCircleRadiusController,
      geoCircleDiameterController,
      geoSlopeRiseController,
      geoSlopeRunController,
    ]) {
      c.dispose();
    }

    for (final c in [
      pmMaterialCostController,
      pmLaborCostController,
      pmEquipmentCostController,
      pmSubcontractorCostController,
      pmOverheadCostController,
      pmQuantityController,
    ]) {
      c.dispose();
    }

    for (final c in [
      mkMaterialCostController,
      mkLaborCostController,
      mkEquipmentCostController,
      mkSubcontractorCostController,
      mkConsumableCostController,
    ]) {
      c.dispose();
    }

    for (final c in [
      lcHourlyRateController,
      lcWorkersController,
      lcHoursPerDayController,
      lcDaysController,
      lcOvertimeHoursController,
    ]) {
      c.dispose();
    }

    super.onClose();
  }
}
