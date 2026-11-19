import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Top-level pill tabs of the Labor Cost Rates screen, in design order.
/// The row scrolls horizontally, so all seven live in one enum.
/// Order merges the three Figma frames: Cost Assignments sits before Prevailing
/// Wage, which is followed by Salary Categories and Bucket Rate.
enum LaborRatesTab {
  employeeRates('Employee Rates'),
  jobClassifications('Job Classifications'),
  employeeAssignments('Employee Assignments'),
  costAssignments('Cost Assignments'),
  prevailingWage('Prevailing Wage'),
  salaryCategories('Salary Categories'),
  bucketRates('Bucket Rate');

  const LaborRatesTab(this.label);
  final String label;
}

/// Role tag shown under each employee on the Employee Rates tab.
enum EmployeeRateRole {
  superintendent('SUPERINTENDENT', Color(0xFF2F5BEA), Color(0xFFEAF0FF)),
  fieldWorker('FIELD_WORKER', Color(0xFFF26A1B), Color(0xFFFFEFE5)),
  manager('MANAGER', Color(0xFF1E9E5A), Color(0xFFE6F7EE));

  const EmployeeRateRole(this.tag, this.foreground, this.background);
  final String tag;
  final Color foreground;
  final Color background;
}

/// Base hourly rates for one employee. A null rate renders as "not set".
class EmployeeRateModel {
  final String id;
  final String name;
  final String email;
  final EmployeeRateRole role;
  final double? regularRate;
  final double? overtimeRate;

  const EmployeeRateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.regularRate,
    this.overtimeRate,
  });
}

class JobClassificationModel {
  final String id;
  final String name;
  final String description;

  /// Short code shown as the tag above the rates (e.g. FORE, JOUR).
  final String code;
  final double regularRate;
  final double overtimeRate;
  final bool isActive;

  const JobClassificationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.regularRate,
    required this.overtimeRate,
    this.isActive = true,
  });
}

/// Links an employee to a job classification. The empty state is the only
/// designed state for this tab; this model is the seam for the populated one.
class EmployeeAssignmentModel {
  final String id;
  final String employeeName;
  final String classificationName;
  final bool isPrimary;

  const EmployeeAssignmentModel({
    required this.id,
    required this.employeeName,
    required this.classificationName,
    this.isPrimary = false,
  });
}

/// A project-specific prevailing wage definition.
class PrevailingWageModel {
  final String id;
  final String projectName;
  final String classificationName;
  final DateTime effectiveDate;
  final double baseWage;
  final double healthAndWelfare;
  final double pension;
  final double vacationHoliday;
  final double training;
  final double overtimeMultiplier;

  const PrevailingWageModel({
    required this.id,
    required this.projectName,
    required this.classificationName,
    required this.effectiveDate,
    required this.baseWage,
    this.healthAndWelfare = 0,
    this.pension = 0,
    this.vacationHoliday = 0,
    this.training = 0,
    this.overtimeMultiplier = 1.5,
  });

  double get fringeTotal =>
      healthAndWelfare + pension + vacationHoliday + training;

  double get totalRate => baseWage + fringeTotal;

  String get effectiveLabel => DateFormat('yyyy-MM-dd').format(effectiveDate);

  String get multiplierLabel => '${overtimeMultiplier.toStringAsFixed(2)}x';
}

/// Annual salary category used to derive an hourly base cost.
class SalaryCategoryModel {
  final String id;
  final String name;
  final String description;
  final double annualSalary;

  /// Paid hours per year used to turn the salary into an hourly rate.
  final int hoursPerYear;
  final bool isActive;

  const SalaryCategoryModel({
    required this.id,
    required this.name,
    required this.annualSalary,
    this.description = '',
    this.hoursPerYear = 2080,
    this.isActive = true,
  });

  double get hourlyRate => hoursPerYear == 0 ? 0 : annualSalary / hoursPerYear;
}

/// Groups the burden components the design lists: taxes, benefits,
/// insurance and overhead.
enum BurdenCategory {
  taxes('Taxes'),
  benefits('Benefits'),
  insurance('Insurance'),
  overhead('Overhead');

  const BurdenCategory(this.label);
  final String label;
}

class BurdenComponentModel {
  final String label;
  final BurdenCategory category;

  /// Percentage of base pay, e.g. 7.65 for 7.65%.
  final double percent;

  const BurdenComponentModel({
    required this.label,
    required this.category,
    required this.percent,
  });
}

/// A named burden-rate profile made of percentage components.
class BurdenRateModel {
  final String id;
  final String name;
  final List<BurdenComponentModel> components;
  final bool isActive;

  const BurdenRateModel({
    required this.id,
    required this.name,
    required this.components,
    this.isActive = true,
  });

  double get totalPercent =>
      components.fold(0.0, (sum, c) => sum + c.percent);

  /// Percent subtotal for one category (0 when the category has no rows).
  double percentFor(BurdenCategory category) => components
      .where((c) => c.category == category)
      .fold(0.0, (sum, c) => sum + c.percent);

  String get totalLabel => '${totalPercent.toStringAsFixed(2)}%';
}

/// Ties an employee to a salary category and a burden profile so a fully
/// burdened hourly cost can be calculated.
class CostAssignmentModel {
  final String id;
  final String employeeName;
  final String salaryCategoryName;
  final String burdenRateName;
  final double baseHourly;
  final double burdenPercent;

  const CostAssignmentModel({
    required this.id,
    required this.employeeName,
    required this.salaryCategoryName,
    required this.burdenRateName,
    required this.baseHourly,
    required this.burdenPercent,
  });

  double get burdenedHourly => baseHourly * (1 + burdenPercent / 100);
}

final NumberFormat _usd = NumberFormat.currency(symbol: '\$');

/// `45` -> `$45.00`
String formatUsd(double value) => _usd.format(value);
