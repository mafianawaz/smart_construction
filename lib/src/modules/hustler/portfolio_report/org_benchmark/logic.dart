import 'package:get/get.dart';
import '../data/portfolio_report_mock_data.dart';
import '../models/portfolio_benchmark.dart';
import '../models/portfolio_report_models.dart';

/// Controller for [OrganizationBenchmarkingView].
///
/// Pass the report already loaded by the Portfolio Report screen to avoid a
/// second fetch; when omitted (e.g. deep link) it loads its own.
class BenchmarkingLogic extends GetxController {
  BenchmarkingLogic({PortfolioReport? report}) : _report = report;

  PortfolioReport? _report;

  PortfolioReport? get report => _report;
  bool get isLoading => _report == null;

  PortfolioBenchmark get benchmark =>
      PortfolioBenchmark.compute(_report?.organizations ?? const []);

  @override
  void onInit() {
    super.onInit();
    if (_report == null) _load();
  }

  Future<void> _load() async {
    _report = await PortfolioReportMockData.fetchReport();
    update();
  }
}
