import '../models/kpi_model.dart';
import '../models/reward_model.dart';
import '../models/worker_model.dart';

/// Mock-data seam for the Workforce module.
///
/// Each method marks the HTTP call that should replace it.
class WorkforceMockData {
  /// GET /workforce/roles
  static const List<RatingRole> ratingRoles = [
    RatingRole('Field Worker', 'FIELD_WORKER'),
    RatingRole('Foreman', 'FOREMAN'),
    RatingRole('Project Manager', 'PROJECT_MANAGER'),
  ];

  /// GET /workforce/workers
  static List<WorkerModel> workers() => [
        WorkerModel(
          id: 'w1',
          fullName: 'John Martinez',
          email: 'j.martinez@realtest.com',
          phone: '(555) 234-5678',
          emergencyContact: 'Maria Martinez (Spouse)',
          employeeId: 'EMP-2024-049',
          department: 'Electrical',
          tradeRole: 'Electrician',
          level: 'Journeyman',
          trade: 'Electrical',
          roleLabel: 'Field Worker',
          employmentType: EmploymentType.fullTime,
          hireDate: DateTime(2024, 1, 15),
          status: WorkerStatus.active,
          currentAssignment: 'ACME Plaza - Phase 2',
          hoursThisWeek: 42.5,
          totalProgramHours: 1240,
          certifications: [
            WorkerCertification(
              name: 'OSHA 30-Hour Construction',
              expires: DateTime(2026, 12),
              status: CertStatus.active,
            ),
            WorkerCertification(
              name: 'Journeyman Electrician License',
              expires: DateTime(2027, 4),
              status: CertStatus.active,
            ),
          ],
        ),
        WorkerModel(
          id: 'w2',
          fullName: 'Sarah Chen',
          email: 's.chen@realtest.com',
          phone: '(555) 345-6789',
          emergencyContact: 'David Chen (Spouse)',
          employeeId: 'EMP-2023-017',
          department: 'Management',
          tradeRole: 'Project Manager',
          level: 'Senior',
          trade: 'Management',
          roleLabel: 'Project Manager',
          employmentType: EmploymentType.fullTime,
          hireDate: DateTime(2023, 3, 6),
          status: WorkerStatus.active,
          currentAssignment: 'Riverside Lofts',
          hoursThisWeek: 40,
          totalProgramHours: 2310,
          certifications: [
            WorkerCertification(
              name: 'PMP Certification',
              expires: DateTime(2027, 8),
              status: CertStatus.active,
            ),
          ],
        ),
        WorkerModel(
          id: 'w3',
          fullName: 'Mike Thompson',
          email: 'm.thompson@realtest.com',
          phone: '(555) 456-7890',
          emergencyContact: 'Linda Thompson (Spouse)',
          employeeId: 'EMP-2022-031',
          department: 'Carpentry',
          tradeRole: 'Carpenter',
          level: 'Journeyman',
          trade: 'Carpentry',
          roleLabel: 'Field Worker',
          employmentType: EmploymentType.fullTime,
          hireDate: DateTime(2022, 9, 12),
          status: WorkerStatus.active,
          currentAssignment: 'ACME Plaza - Phase 2',
          hoursThisWeek: 38,
          totalProgramHours: 3120,
          certifications: [
            WorkerCertification(
              name: 'OSHA 10-Hour Construction',
              expires: DateTime(2026, 11),
              status: CertStatus.expiringSoon,
            ),
          ],
        ),
        WorkerModel(
          id: 'w4',
          fullName: 'David Rodriguez',
          email: 'd.rodriguez@realtest.com',
          phone: '(555) 567-8901',
          emergencyContact: 'Elena Rodriguez (Mother)',
          employeeId: 'EMP-2025-008',
          department: 'Plumbing',
          tradeRole: 'Plumber',
          level: 'Apprentice',
          trade: 'Plumbing',
          roleLabel: 'Field Worker',
          employmentType: EmploymentType.contract,
          hireDate: DateTime(2025, 2, 3),
          status: WorkerStatus.active,
          currentAssignment: 'Harbor Point Tower',
          hoursThisWeek: 36,
          totalProgramHours: 640,
          certifications: [],
        ),
      ];

  /// GET /workforce/kpi-templates
  static List<KpiTemplate> kpiTemplates() => const [
        KpiTemplate(
          id: 'k1',
          name: 'test',
          description: 'test',
          category: KpiCategory.financial,
          unit: 'count',
          direction: KpiDirection.higherIsBetter,
          assignedRoleCodes: ['FIELD_WORKER'],
        ),
      ];

  /// GET /workforce/kpi-ratings
  static List<KpiRating> ratings() => const [];

  /// Rating / assignment periods.
  static const List<String> periods = ['Q1 2026', 'Q2 2026', 'Q3 2026', 'Q4 2026'];

  /// GET /workforce/kpi-employees
  static const List<KpiEmployee> employees = [
    KpiEmployee(id: 'e1', name: 'Test', roleCode: 'SUPERINTENDENT'),
    KpiEmployee(id: 'e2', name: 'Field Worker', roleCode: 'FIELD_WORKER'),
    KpiEmployee(id: 'e3', name: 'Site Superintendent', roleCode: 'SUPERINTENDENT'),
    KpiEmployee(id: 'e4', name: 'John Martinez', roleCode: 'ELECTRICIAN'),
  ];

  /// GET /workforce/kpi-assignments
  static List<KpiAssignment> assignments() => const [
        KpiAssignment(
          id: 'a1',
          employeeId: 'e2',
          employeeName: 'Field Worker',
          roleCode: 'FIELD_WORKER',
          kpiId: 'k1',
          kpiName: 'test',
          category: KpiCategory.financial,
          unit: 'count',
          period: 'Q1 2026',
          status: KpiAssignmentStatus.active,
        ),
        KpiAssignment(
          id: 'a2',
          employeeId: 'e3',
          employeeName: 'Site Superintendent',
          roleCode: 'SUPERINTENDENT',
          kpiId: 'k1',
          kpiName: 'test',
          category: KpiCategory.financial,
          unit: 'count',
          period: 'Q1 2026',
          status: KpiAssignmentStatus.active,
        ),
        KpiAssignment(
          id: 'a3',
          employeeId: 'e4',
          employeeName: 'John Martinez',
          roleCode: 'ELECTRICIAN',
          kpiId: 'k1',
          kpiName: 'test',
          category: KpiCategory.financial,
          unit: 'count',
          period: 'Q2 2026',
        ),
      ];

  /// GET /workforce/kpi-results?employeeId=&period=
  static List<KpiResult> results() => const [
        KpiResult(
          id: 'r1',
          employeeId: 'e1',
          kpiId: 'k2',
          kpiName: 'Jobs Completed Per Week',
          category: KpiCategory.financial,
          unit: 'count',
          target: 10,
          actual: 8,
          period: 'Q1 2026',
        ),
        KpiResult(
          id: 'r2',
          employeeId: 'e1',
          kpiId: 'k3',
          kpiName: 'Safety Incidents',
          category: KpiCategory.safety,
          unit: 'count',
          direction: KpiDirection.lowerIsBetter,
          target: 0,
          actual: 0,
          period: 'Q1 2026',
        ),
        KpiResult(
          id: 'r3',
          employeeId: 'e1',
          kpiId: 'k4',
          kpiName: 'Client Satisfaction',
          category: KpiCategory.quality,
          unit: 'score',
          target: 9,
          actual: 7,
          period: 'Q1 2026',
        ),
      ];

  /// GET /workforce/rewards/me
  static List<RewardModel> rewards() => [
        RewardModel(
          id: 'rw1',
          title: 'Safety Champion',
          description: '30 consecutive days without any safety incidents',
          awardedOn: DateTime(2026, 7, 28),
          awardedBy: 'Site Superintendent',
          points: 200,
          icon: RewardIconKind.champion,
        ),
        RewardModel(
          id: 'rw2',
          title: 'Top Performer Q2',
          description: 'Highest KPI achievement score in the team for Q1 2026',
          awardedOn: DateTime(2026, 7, 1),
          awardedBy: 'Project Manager',
          points: 500,
          icon: RewardIconKind.topPerformer,
        ),
        RewardModel(
          id: 'rw3',
          title: 'Early Bird',
          description: 'Clocked in on time for 60 consecutive workdays',
          awardedOn: DateTime(2026, 6, 15),
          awardedBy: 'System',
          points: 150,
          icon: RewardIconKind.earlyBird,
        ),
        RewardModel(
          id: 'rw4',
          title: 'Team Player',
          description: 'Helped 3 crew members complete their tasks ahead of schedule',
          awardedOn: DateTime(2026, 5, 20),
          awardedBy: 'Site Superintendent',
          points: 300,
          icon: RewardIconKind.teamPlayer,
        ),
        RewardModel(
          id: 'rw5',
          title: 'Perfect Attendance',
          description: 'No missed shifts this quarter',
          awardedOn: DateTime(2026, 4, 30),
          awardedBy: 'System',
          points: 100,
        ),
      ];
}
