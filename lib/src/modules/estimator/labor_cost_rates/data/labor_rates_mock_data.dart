import '../models/labor_rates_models.dart';

/// Mock-data seam for the Labor Cost Rates feature.
/// Every method marks the HTTP call that replaces it.
class LaborRatesMockData {
  LaborRatesMockData._();

  // TODO(api): GET /labor-rates/employees
  static List<EmployeeRateModel> employeeRates() => const [
        EmployeeRateModel(
          id: 'emp-1',
          name: 'Site Superintendent',
          email: 'super@realco.com',
          role: EmployeeRateRole.superintendent,
        ),
        EmployeeRateModel(
          id: 'emp-2',
          name: 'Field Worker',
          email: 'worker@realco.com',
          role: EmployeeRateRole.fieldWorker,
          regularRate: 18.00,
          overtimeRate: 45.00,
        ),
        EmployeeRateModel(
          id: 'emp-3',
          name: 'Office Manager',
          email: 'office@realco.com',
          role: EmployeeRateRole.manager,
        ),
      ];

  // TODO(api): GET /labor-rates/job-classifications
  static List<JobClassificationModel> jobClassifications() => const [
        JobClassificationModel(
          id: 'cls-1',
          name: 'Foreman',
          description:
              'Crew leader/supervisor responsible for managing work...',
          code: 'FORE',
          regularRate: 45.00,
          overtimeRate: 67.50,
        ),
        JobClassificationModel(
          id: 'cls-2',
          name: 'Journeyman',
          description: 'Fully trained and certified skilled tradesperson',
          code: 'JOUR',
          regularRate: 45.00,
          overtimeRate: 67.50,
        ),
      ];

  // TODO(api): GET /labor-rates/assignments
  // Empty on purpose: the reference design only shows the empty state.
  static List<EmployeeAssignmentModel> employeeAssignments() => const [];

  // TODO(api): GET /labor-rates/prevailing-wages
  static List<PrevailingWageModel> prevailingWages() => [
        PrevailingWageModel(
          id: 'pw-1',
          projectName: 'Downtown Town House Build',
          classificationName: 'Foreman',
          effectiveDate: DateTime(2026, 2, 4),
          baseWage: 45.00,
        ),
        PrevailingWageModel(
          id: 'pw-2',
          projectName: 'Downtown Town House Build',
          classificationName: 'Foreman',
          effectiveDate: DateTime(2026, 2, 4),
          baseWage: 45.00,
        ),
      ];

  /// The Figma frames only show the empty states for the three newer tabs.
  /// Flip to `true` to preview the populated cards while checking layout.
  static const bool showSampleData = false;

  // TODO(api): GET /labor-rates/salary-categories
  static List<SalaryCategoryModel> salaryCategories() => !showSampleData
      ? const []
      : const [
          SalaryCategoryModel(
            id: 'sal-1',
            name: 'Skilled Trade',
            description: 'Journeyman-level field staff',
            annualSalary: 93600,
          ),
          SalaryCategoryModel(
            id: 'sal-2',
            name: 'Site Management',
            description: 'Superintendents and project leads',
            annualSalary: 124800,
          ),
        ];

  // TODO(api): GET /labor-rates/burden-rates
  static List<BurdenRateModel> burdenRates() => !showSampleData
      ? const []
      : const [
          BurdenRateModel(
            id: 'bur-1',
            name: 'Standard Field Burden',
            components: [
              BurdenComponentModel(
                  label: 'FICA / Medicare',
                  category: BurdenCategory.taxes,
                  percent: 7.65),
              BurdenComponentModel(
                  label: 'Health Benefits',
                  category: BurdenCategory.benefits,
                  percent: 8.00),
              BurdenComponentModel(
                  label: "Workers' Comp",
                  category: BurdenCategory.insurance,
                  percent: 6.50),
              BurdenComponentModel(
                  label: 'General Overhead',
                  category: BurdenCategory.overhead,
                  percent: 10.00),
            ],
          ),
        ];

  // TODO(api): GET /labor-rates/cost-assignments
  static List<CostAssignmentModel> costAssignments() => !showSampleData
      ? const []
      : const [
          CostAssignmentModel(
            id: 'ca-1',
            employeeName: 'Field Worker',
            salaryCategoryName: 'Skilled Trade',
            burdenRateName: 'Standard Field Burden',
            baseHourly: 45.00,
            burdenPercent: 32.15,
          ),
        ];
}
