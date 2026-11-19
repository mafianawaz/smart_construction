import '../models/cfo_bulletin_models.dart';

/// Mock seam for the CFO Bulletins view. Values lifted from the Figma
/// reference.
class CfoBulletinMockData {
  CfoBulletinMockData._();

  /// GET /cfo/bulletins   (bulletins grouped per linked organization)
  static Future<List<CfoBulletinOrg>> organizations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [
      const CfoBulletinOrg(
        id: 'org-hust',
        name: 'Hust Concrete Comp',
        type: 'GENERAL_CONTRACTOR',
        bulletins: [],
      ),
      CfoBulletinOrg(
        id: 'org-dev',
        name: 'Dev Sandbox Organization',
        type: 'ROADWAY_CONSTRUCTION',
        isNew: true,
        bulletins: [
          CfoBulletin(
            id: 'b1',
            authorName: 'Test Admin',
            role: CfoBulletinRole.admin,
            postedAt: DateTime(2026, 5, 12, 17, 55),
            message: 'sassasa',
          ),
          CfoBulletin(
            id: 'b2',
            authorName: 'Test Admin',
            role: CfoBulletinRole.admin,
            postedAt: DateTime(2026, 5, 12, 17, 55),
            message: 'teststs',
          ),
          CfoBulletin(
            id: 'b3',
            authorName: 'Test Admin',
            role: CfoBulletinRole.admin,
            postedAt: DateTime(2026, 5, 12, 17, 54),
            projectName: 'Maisie Hicks',
            projectCode: '260009',
            message: 'fasdf',
          ),
          CfoBulletin(
            id: 'b4',
            authorName: 'Test Admin',
            role: CfoBulletinRole.admin,
            postedAt: DateTime(2026, 5, 12, 17, 54),
            message: 'tes',
          ),
          CfoBulletin(
            id: 'b5',
            authorName: 'Test HOURLY EMPLOYEE',
            role: CfoBulletinRole.fieldWorker,
            postedAt: DateTime(2026, 2, 4, 22, 20),
            projectName: 'Seven Eleven Store Branch',
            projectCode: '260022',
            message: 'test progress',
          ),
          CfoBulletin(
            id: 'b6',
            authorName: 'Test Manager',
            role: CfoBulletinRole.manager,
            postedAt: DateTime(2026, 2, 4, 19, 31),
            projectName: 'Downtown Town House Build',
            projectCode: '260007',
            message: 'test',
          ),
          CfoBulletin(
            id: 'b7',
            authorName: 'Test Admin',
            role: CfoBulletinRole.admin,
            postedAt: DateTime(2026, 1, 17, 4, 9),
            projectName: 'Tucker Carey',
            projectCode: '260008',
            message: 'The test task is currently in progress',
          ),
        ],
      ),
      const CfoBulletinOrg(
        id: 'org-hustler2',
        name: 'Dev Hustler Secondary Org',
        type: 'GENERAL_CONTRACTOR',
        bulletins: [],
      ),
    ];
  }
}
