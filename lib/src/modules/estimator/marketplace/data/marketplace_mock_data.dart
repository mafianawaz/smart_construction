import '../models/marketplace_models.dart';

/// Mock-data seam. Replace each method with the HTTP call in its comment.
class MarketplaceMockData {
  MarketplaceMockData._();

  static const String currentOrg = 'Dev Sandbox Organization';

  static const List<String> trades = [
    'All Trades',
    'Concrete',
    'Framing And Gates',
    'General Contractor',
    'Specialty Trades',
  ];
  static const List<String> ratings = ['Any Rating', '4.0+', '4.5+'];
  static const List<String> contractorLocations = [
    'Location',
    'Phoenix, AZ',
    'Tempe, AZ',
  ];
  static const List<String> availability = [
    'All Availability',
    'Available',
    'Unavailable',
  ];
  static const List<String> sortOptions = [
    'Newest First',
    'Rate: Low to High',
    'Rate: High to Low',
  ];
  static const List<String> crewStatuses = [
    'All Status',
    'Available',
    'Unavailable',
  ];
  static const List<String> equipmentCategories = [
    'All Categories',
    'Cranes',
    'Concrete',
    'Excavators',
    'Lifts',
    'Compressors',
    'Scaffolding',
  ];
  static const List<String> formCategories = [
    'Cranes',
    'Concrete',
    'Excavators',
    'Lifts',
    'Compressors',
    'Scaffolding',
  ];
  static const List<String> conditions = ['Excellent', 'Good', 'Fair'];

  // GET /marketplace/contractors
  static List<ContractorModel> contractors() => const [
        ContractorModel(
          id: 'c1',
          name: 'Dev Sandbox Organization',
          code: 'M1',
          type: 'GENERAL CONTRACTOR',
          trade: 'General Contractor',
          location: 'Phoenix, AZ',
          description:
              'Leading commercial general contractor specializing in high-end structural engineering, lake demo, and waterfront rebuilds.',
          rating: 4.9,
          reviewCount: 18,
        ),
        ContractorModel(
          id: 'c2',
          name: 'Apex Concrete & Paving',
          code: 'M2',
          type: 'SPECIALTY TRADES',
          trade: 'Specialty Trades',
          location: 'Tempe, AZ',
          description:
              'Verified specialty contractor focusing on bridge deck replacements, highway paving, and custom structural concrete casting.',
          rating: 4.9,
          reviewCount: 18,
        ),
      ];

  // GET /marketplace/talent
  static List<TalentModel> talent() => [
        TalentModel(
          id: 't1',
          name: 'Test Admin',
          trade: 'Concrete',
          available: true,
          headline: 'Best Concrete Pourer',
          bio: 'Bird Construction Person. 10 Cnt · 0 Assets. Test Sandbox Organization.',
          rateMin: 25,
          rateMax: 45,
          email: 'test-admin@dev.test',
          location: 'Phoenix, AZ',
          skills: const ['Concrete pouring', 'Finishing'],
          certifications: const ['OSHA 30'],
          rating: 4.8,
          addedAt: DateTime(2026, 10, 1),
        ),
      ];

  // GET /marketplace/crews
  static List<CrewModel> crews() => const [
        CrewModel(
          id: 'cr1',
          name: 'tes',
          trade: 'Framing And Gates',
          available: true,
          workers: 5,
          hourlyRate: 55,
          location: 'Phoenix, AZ',
          notes: ['test', 'test'],
        ),
      ];

  // GET /marketplace/equipment
  static List<EquipmentModel> equipment() => const [
        EquipmentModel(
          id: 'e1',
          name: 'Tower Crane 10-ton (Flat Top)',
          make: 'Liebherr',
          model: '130 EC-B',
          year: '2018',
          category: 'Cranes',
          condition: 'Good',
          dailyRate: 650,
          weeklyRate: 3500,
          monthlyRate: 10500,
          deposit: 0,
          location: 'Phoenix, AZ',
          deliveryRadius: '30',
          photoUrls: [],
          ongoing: true,
          description: '',
          ownerOrg: currentOrg,
        ),
      ];

  // GET /marketplace/equipment/requests
  static List<RentalRequestModel> rentalRequests() => [
        RentalRequestModel(
          id: 'r1',
          equipmentId: 'e1',
          requesterOrg: 'Hoist Concrete Comp',
          start: DateTime(2026, 5, 14),
          end: DateTime(2026, 5, 21),
          deliveryRequested: true,
          note: 'Test',
          status: RentalRequestStatus.pending,
        ),
        RentalRequestModel(
          id: 'r2',
          equipmentId: 'e1',
          requesterOrg: 'Hoist Concrete Comp',
          start: DateTime(2026, 5, 14),
          end: DateTime(2026, 5, 21),
          deliveryRequested: true,
          note: 'Test',
          status: RentalRequestStatus.pending,
        ),
      ];

  // GET /jobs?status=open
  static List<JobOption> jobs() => const [
        JobOption('j1', 'Lakeside Warehouse'),
        JobOption('j2', 'Downtown Parking Structure'),
      ];
}
