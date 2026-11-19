import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/lumber_framing_data.dart';
import '../models/lumber_framing_models.dart';


class LumberFramingLogic extends GetxController {
  LumberCalculatorMode selectedMode = LumberCalculatorMode.joistRafter;

  // ---- Joist / Rafter ----
  final TextEditingController spanLengthController = TextEditingController();
  SpacingOption joistSpacing = LumberFramingData.defaultSpacing;
  LumberSizeOption joistSize = LumberFramingData.defaultSize;

  // ---- Stud Calculator ----
  final TextEditingController wallLengthController = TextEditingController();
  final TextEditingController wallHeightController = TextEditingController();
  final TextEditingController cornerCountController = TextEditingController();
  final TextEditingController openingCountController = TextEditingController();
  SpacingOption studSpacing = LumberFramingData.defaultSpacing;

  // ---- Board Feet ----
  final TextEditingController thicknessController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // ---- Common Settings (shared across all three modes) ----
  final TextEditingController wasteFactorController = TextEditingController(text: '4');
  final TextEditingController unitPriceController = TextEditingController();

  final Map<String, String> results = {};

  void changeMode(LumberCalculatorMode mode) {
    if (selectedMode == mode) return;
    selectedMode = mode;
    _calculate();
  }

  void setJoistSpacing(SpacingOption? spacing) {
    joistSpacing = spacing ?? LumberFramingData.defaultSpacing;
    _calculate();
  }

  void setJoistSize(LumberSizeOption? size) {
    joistSize = size ?? LumberFramingData.defaultSize;
    _calculate();
  }

  void setStudSpacing(SpacingOption? spacing) {
    studSpacing = spacing ?? LumberFramingData.defaultSpacing;
    _calculate();
  }

  double get _wasteMultiplier => 1 + ((double.tryParse(wasteFactorController.text) ?? 0) / 100);

  void _calculate() {
    switch (selectedMode) {
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
    results.clear();
    final spanFt = double.tryParse(spanLengthController.text) ?? 0;
    if (spanFt <= 0) {
      update();
      return;
    }

    final pieceCount = ((spanFt * 12) / joistSpacing.inches).ceil() + 1;
    final piecesWithWaste = (pieceCount * _wasteMultiplier).ceil();
    final rimBandLinearFt = spanFt * 2; // rim/band board runs both long edges
    final totalLinearFt = piecesWithWaste * spanFt;
    final boardFeet =
        (joistSize.actualThicknessIn * joistSize.actualWidthIn * totalLinearFt) / 12;

    results['pieceCount'] = '$piecesWithWaste pcs';
    results['rimBandLinearFt'] = '${rimBandLinearFt.toStringAsFixed(1)} linear ft';
    results['boardFeet'] = '${boardFeet.toStringAsFixed(1)} bd ft';
    _applyCost(piecesWithWaste.toDouble());
  }

  void _calculateStuds() {
    results.clear();
    final wallLength = double.tryParse(wallLengthController.text) ?? 0;
    if (wallLength <= 0) {
      update();
      return;
    }

    final cornerCount = double.tryParse(cornerCountController.text) ?? 0;
    final openingCount = double.tryParse(openingCountController.text) ?? 0;

    final fieldStuds = ((wallLength * 12) / studSpacing.inches).ceil() + 1;
    // 3 studs per corner (a common "California corner") + 4 studs per
    // opening (2 king + 2 jack) — standard framing rules of thumb.
    final cornerStuds = (cornerCount * 3).round();
    final openingStuds = (openingCount * 4).round();
    final totalStuds = ((fieldStuds + cornerStuds + openingStuds) * _wasteMultiplier).ceil();

    // Single bottom plate + double top plate = 3x wall length of plate stock.
    final plateLinearFt = wallLength * 3;

    results['totalStuds'] = '$totalStuds pcs';
    results['plateLinearFt'] = '${plateLinearFt.toStringAsFixed(1)} linear ft';
    _applyCost(totalStuds.toDouble());
  }

  void _calculateBoardFeet() {
    results.clear();
    final thicknessIn = double.tryParse(thicknessController.text) ?? 0;
    final widthIn = double.tryParse(widthController.text) ?? 0;
    final lengthFt = double.tryParse(lengthController.text) ?? 0;
    final quantity = double.tryParse(quantityController.text) ?? 0;

    if (thicknessIn <= 0 || widthIn <= 0 || lengthFt <= 0 || quantity <= 0) {
      update();
      return;
    }

    final boardFeetPerPiece = (thicknessIn * widthIn * lengthFt) / 12;
    final totalBoardFeet = boardFeetPerPiece * quantity * _wasteMultiplier;

    results['boardFeetPerPiece'] = '${boardFeetPerPiece.toStringAsFixed(2)} bd ft/pc';
    results['totalBoardFeet'] = '${totalBoardFeet.toStringAsFixed(2)} bd ft';
    _applyCost(quantity);
  }

  void _applyCost(double pieceCount) {
    final unitPrice = double.tryParse(unitPriceController.text);
    if (unitPrice != null) {
      results['estimatedCost'] = '\$${(pieceCount * unitPrice).toStringAsFixed(2)}';
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    spanLengthController.addListener(_calculate);
    wallLengthController.addListener(_calculate);
    wallHeightController.addListener(_calculate);
    cornerCountController.addListener(_calculate);
    openingCountController.addListener(_calculate);
    thicknessController.addListener(_calculate);
    widthController.addListener(_calculate);
    lengthController.addListener(_calculate);
    quantityController.addListener(_calculate);
    wasteFactorController.addListener(_calculate);
    unitPriceController.addListener(_calculate);
  }

  @override
  void onClose() {
    for (final c in [
      spanLengthController,
      wallLengthController,
      wallHeightController,
      cornerCountController,
      openingCountController,
      thicknessController,
      widthController,
      lengthController,
      quantityController,
      wasteFactorController,
      unitPriceController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
