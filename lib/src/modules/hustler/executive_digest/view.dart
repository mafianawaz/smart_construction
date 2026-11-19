import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/hustler/executive_digest/models/executive_digest_models.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'logic.dart';
import 'widgets/digest_empty_state.dart';
import 'widgets/digest_header.dart';
import 'widgets/digest_palette.dart';
import 'widgets/digest_period_tabs.dart';
import 'widgets/digest_primitives.dart';
import 'widgets/organization_digest_card.dart';
import 'widgets/portfolio_digest_card.dart';

class ExecutiveDigestView extends StatelessWidget {
  const ExecutiveDigestView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExecutiveDigestLogic>(
      init: ExecutiveDigestLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Executive Digest',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: logic.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: DigestPalette.primary,
                        ),
                      )
                    : _Content(logic: logic),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.logic});

  final ExecutiveDigestLogic logic;

  @override
  Widget build(BuildContext context) {
    final period = logic.period;

    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        const Text(
          "Let's review your overview",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: DigestPalette.text,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'AI-generated business intelligence summary of construction '
          'operations.',
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: DigestPalette.muted,
          ),
        ),
        const SizedBox(height: 16),
        DigestGenerateBar(
          onPressed: logic.generateAll,
          isLoading: logic.isGeneratingAny,
          hasReports: logic.hasAnyReport,
        ),
        const SizedBox(height: 14),
        DigestPeriodTabs(
          selected: period,
          onChanged: logic.selectPeriod,
        ),
        const SizedBox(height: 16),
        if (!logic.hasAnyReport)
          DigestEmptyState(
            boxed: true,
            title: 'No digest available for this period',
            message: 'Click "Generate Now" to create an AI-powered executive '
                'digest for the selected ${period.adjective} period.',
            onGenerate: logic.generateAll,
            isLoading: logic.isGeneratingAny,
          )
        else ...[
          PortfolioDigestCard(
            report: logic.portfolioReport,
            isLoading: logic.isGeneratingPortfolio,
            onGenerate: logic.generatePortfolio,
          ),
          const SizedBox(height: 16),
          for (final org in logic.organizations) ...[
            OrganizationDigestCard(
              organization: org,
              report: logic.reportFor(org),
              isExpanded: logic.isExpanded(org),
              isGenerating: logic.isGeneratingOrg(org),
              onToggle: () => logic.toggleExpanded(org),
              onGenerate: () => logic.generateForOrg(org),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ],
    );
  }
}
