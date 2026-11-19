import '../models/report_models.dart';

/// Mock seam for the Reports screen.
///
/// Replace the two `// TODO(api)` methods with real HTTP calls; the logic layer
/// only talks to this class.
class ReportsMockData {
  ReportsMockData._();

  static const List<ReportType> reportTypes = [
    ReportType(
        id: 'takeoff_quantity',
        label: 'Takeoff Quantity',
        group: ReportGroup.takeoff),
    ReportType(
        id: 'takeoff_summary',
        label: 'Takeoff Summary',
        group: ReportGroup.takeoff),
    ReportType(
        id: 'measurements_by_takeoff',
        label: 'Measurements By Takeoff',
        group: ReportGroup.takeoff),
    ReportType(
        id: 'item_list', label: 'Item List', group: ReportGroup.takeoff),
    ReportType(
        id: 'item_cost', label: 'Item Cost', group: ReportGroup.takeoff),
    ReportType(
        id: 'item_cost_by_type',
        label: 'Item Cost By Type',
        group: ReportGroup.takeoff),
    ReportType(
        id: 'item_cost_by_takeoff',
        label: 'Item Cost By Takeoff',
        group: ReportGroup.takeoff),
    ReportType(
        id: 'estimate_summary',
        label: 'Estimate Summary',
        group: ReportGroup.estimate),
    ReportType(
        id: 'cost_breakdown',
        label: 'Cost Breakdown',
        group: ReportGroup.estimate),
  ];

  static const List<ReportProject> projects = [
    ReportProject(id: 'p1', name: 'Riverside Plaza'),
    ReportProject(id: 'p2', name: 'Downtown Tower'),
    ReportProject(id: 'p3', name: 'Oak Street Renovation'),
    ReportProject(id: 'p4', name: 'Harbor View Apartments'),
  ];

  // TODO(api): GET /reports/projects
  static List<ReportProject> fetchProjects() => projects;

  // TODO(api): GET /reports/{reportId}?projectId=&range=
  // Returns null when no project is selected (screen shows the empty state).
  // The mock ignores `filters.range`.
  static ReportTableModel? fetchReport(ReportType type, ReportFilters filters) {
    if (filters.projectId == null) return null;

    switch (type.id) {
      case 'takeoff_quantity':
        return const ReportTableModel(
          columns: ['Item', 'Unit', 'Quantity', 'Location'],
          rows: [
            ['Concrete Slab 4"', 'SF', '12,400', 'Level 1'],
            ['Rebar #5', 'LF', '8,250', 'Level 1'],
            ['CMU Block 8"', 'EA', '3,180', 'Core A'],
            ['Drywall 5/8"', 'SF', '21,600', 'Levels 2-4'],
          ],
        );
      case 'takeoff_summary':
        return const ReportTableModel(
          columns: ['Takeoff', 'Items', 'Measured', 'Status'],
          rows: [
            ['Foundation', '14', '96%', 'Complete'],
            ['Structure', '32', '78%', 'In progress'],
            ['Interior Finishes', '41', '35%', 'In progress'],
          ],
        );
      case 'measurements_by_takeoff':
        return const ReportTableModel(
          columns: ['Takeoff', 'Measurement', 'Type', 'Value'],
          rows: [
            ['Foundation', 'Slab perimeter', 'Linear', '620 LF'],
            ['Foundation', 'Slab area', 'Area', '12,400 SF'],
            ['Structure', 'Column count', 'Count', '48 EA'],
          ],
        );
      case 'item_list':
        return const ReportTableModel(
          columns: ['Code', 'Item', 'Type', 'Unit'],
          rows: [
            ['03-100', 'Concrete Slab 4"', 'Material', 'SF'],
            ['03-210', 'Rebar #5', 'Material', 'LF'],
            ['09-250', 'Drywall 5/8"', 'Material', 'SF'],
            ['01-310', 'Concrete Crew', 'Labor', 'HR'],
          ],
        );
      case 'item_cost':
        return const ReportTableModel(
          columns: ['Item', 'Qty', 'Unit Cost', 'Total'],
          rows: [
            ['Concrete Slab 4"', '12,400', '\$6.20', '\$76,880'],
            ['Rebar #5', '8,250', '\$1.45', '\$11,963'],
            ['Drywall 5/8"', '21,600', '\$2.10', '\$45,360'],
          ],
          totals: ['Total', '', '', '\$134,203'],
        );
      case 'item_cost_by_type':
        return const ReportTableModel(
          columns: ['Type', 'Items', 'Total'],
          rows: [
            ['Material', '58', '\$98,430'],
            ['Labor', '21', '\$27,900'],
            ['Equipment', '9', '\$7,873'],
          ],
          totals: ['Total', '88', '\$134,203'],
        );
      case 'item_cost_by_takeoff':
        return const ReportTableModel(
          columns: ['Takeoff', 'Items', 'Total'],
          rows: [
            ['Foundation', '14', '\$52,310'],
            ['Structure', '32', '\$49,880'],
            ['Interior Finishes', '41', '\$32,013'],
          ],
          totals: ['Total', '87', '\$134,203'],
        );
      case 'estimate_summary':
        return const ReportTableModel(
          columns: ['Line', 'Amount'],
          rows: [
            ['Direct Cost', '\$134,203'],
            ['Overhead (8%)', '\$10,736'],
            ['Profit (10%)', '\$14,494'],
          ],
          totals: ['Estimate Total', '\$159,433'],
        );
      case 'cost_breakdown':
        return const ReportTableModel(
          columns: ['Category', 'Budget', 'Estimated', 'Variance'],
          rows: [
            ['Materials', '\$100,000', '\$98,430', '\$1,570'],
            ['Labor', '\$30,000', '\$27,900', '\$2,100'],
            ['Equipment', '\$8,000', '\$7,873', '\$127'],
          ],
          totals: ['Total', '\$138,000', '\$134,203', '\$3,797'],
        );
      default:
        return const ReportTableModel(columns: [], rows: []);
    }
  }
}
