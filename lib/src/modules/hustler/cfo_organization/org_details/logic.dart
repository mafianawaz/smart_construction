import 'package:get/get.dart';

import '../data/cfo_org_mock_data.dart';
import '../models/cfo_org_format.dart';
import '../models/cfo_org_models.dart';

class CfoOrgDetailLogic extends GetxController {
  CfoOrgDetailLogic(this.orgId);

  final String orgId;

  late CfoOrgDetail detail;
  CfoDetailTab tab = CfoDetailTab.projects;

  @override
  void onInit() {
    super.onInit();
    detail = CfoOrgMockData.organizationDetail(orgId);
  }

  void selectTab(CfoDetailTab value) {
    if (tab == value) return;
    tab = value;
    update();
  }

  // ---- CSV ---------------------------------------------------------------

  static String _cell(Object? value) {
    final text = '${value ?? ''}'.replaceAll('"', '""');
    return '"$text"';
  }

  static String _toCsv(List<String> header, List<List<Object?>> rows) {
    final buffer = StringBuffer('${header.map(_cell).join(',')}\n');
    for (final row in rows) {
      buffer.writeln(row.map(_cell).join(','));
    }
    return buffer.toString();
  }

  /// CSV text for the Projects tab. Export itself is stubbed.
  String buildProjectsCsv() => _toCsv(
        ['Project', 'Client', 'Code', 'Status', 'Date'],
        [
          for (final p in detail.projects)
            [p.name, p.client, p.code, p.status.label, cfoIsoDate(p.date)],
        ],
      );

  String buildBidsCsv() => _toCsv(
        ['Bid', 'Client', 'Code', 'Due Date', 'Amount', 'Status'],
        [
          for (final b in detail.bids)
            [
              b.name,
              b.client,
              b.code,
              cfoIsoDate(b.dueDate),
              b.amount?.toStringAsFixed(2) ?? '',
              b.status.label,
            ],
        ],
      );

  String buildChangeOrdersCsv() => _toCsv(
        ['Code', 'Amount', 'Status', 'Created'],
        [
          for (final c in detail.changeOrders)
            [
              c.code,
              c.amount.toStringAsFixed(2),
              c.status.label,
              cfoIsoDate(c.createdAt),
            ],
        ],
      );

  String buildTeamCsv() => _toCsv(
        ['Name', 'Email', 'Role', 'Status'],
        [
          for (final m in detail.members)
            [m.name, m.email, m.role.label, m.isActive ? 'Active' : 'Inactive'],
        ],
      );

  String buildReceivablesCsv() => _toCsv(
        ['Title', 'Reference', 'Total', 'Outstanding', 'Due Date', 'Days Overdue'],
        [
          for (final r in detail.receivables)
            [
              r.title,
              r.reference,
              r.total.toStringAsFixed(2),
              r.outstanding.toStringAsFixed(2),
              cfoIsoDate(r.dueDate),
              r.daysOverdue(),
            ],
        ],
      );

  /// Real export: GET /cfo/organizations/{id}/projects/export.csv
  void exportProjectsCsv() =>
      _announce('Projects', detail.projects.length, buildProjectsCsv());

  /// Real export: GET /cfo/organizations/{id}/bids/export.csv
  void exportBidsCsv() =>
      _announce('Bids', detail.bids.length, buildBidsCsv());

  /// Real export: GET /cfo/organizations/{id}/change-orders/export.csv
  void exportChangeOrdersCsv() => _announce(
      'Change orders', detail.changeOrders.length, buildChangeOrdersCsv());

  /// Real export: GET /cfo/organizations/{id}/team/export.csv
  void exportTeamCsv() =>
      _announce('Team members', detail.members.length, buildTeamCsv());

  /// Real export: GET /cfo/organizations/{id}/receivables/export.csv
  void exportReceivablesCsv() => _announce(
      'Receivables', detail.receivables.length, buildReceivablesCsv());

  void _announce(String what, int count, String csv) {
    Get.snackbar(
      'Export CSV',
      '$count ${what.toLowerCase()} ready (${csv.length} bytes). '
          'File saving is not wired yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
