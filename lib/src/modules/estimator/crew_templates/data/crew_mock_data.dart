import '../models/crew_models.dart';

/// Mock-data seam for Crew Templates.
class CrewMockData {
  CrewMockData._();

  /// The Figma frame only shows the empty state. Flip to `true` to preview
  /// populated cards while checking layout.
  static const bool showSampleData = false;

  // TODO(api): GET /crew-templates
  static List<CrewTemplateModel> templates() => !showSampleData
      ? const []
      : const [
          CrewTemplateModel(
            id: 'crew-1',
            code: 'CONC-CREW-A',
            name: 'Concrete Pour Crew',
            tradeType: 'Concrete',
            productionUnit: 'CY',
            productionPerDay: 40,
            description: 'Standard slab-on-grade pour crew',
            workers: [
              CrewWorkerModel(
                role: 'Foreman',
                count: 1,
                hourlyRate: 45,
                burdenPercent: 32,
              ),
              CrewWorkerModel(
                role: 'Laborer',
                count: 4,
                hourlyRate: 28,
                burdenPercent: 32,
              ),
            ],
            equipment: [
              CrewEquipmentModel(
                name: 'Concrete Pump',
                count: 1,
                dailyRate: 850,
                fixedCost: 120,
              ),
            ],
          ),
        ];
}
