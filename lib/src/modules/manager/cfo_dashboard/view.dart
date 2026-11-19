import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import 'logic.dart';
import 'widgets/cfo_org_card.dart';
import 'widgets/cfo_palette.dart';

class CfoDashboardView extends StatelessWidget {
  const CfoDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoDashboardLogic>(
      init: CfoDashboardLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'CFO Dashboard',
            subtitle: 'Financial overview across all your linked organisations',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(child: _body(logic)),
            ],
          ),
        );
      },
    );
  }

  Widget _body(CfoDashboardLogic logic) {
    if (logic.isLoading && logic.orgs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: CfoPalette.orange),
      );
    }

    return RefreshIndicator(
      color: CfoPalette.orange,
      onRefresh: logic.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        children: [
          if (logic.orgs.isEmpty)
            const _EmptyState()
          else
            for (final org in logic.orgs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CfoOrgCard(
                  org: org,
                  expanded: logic.isExpanded(org.id),
                  onToggle: () => logic.toggle(org.id),
                ),
              ),
        ],
      ),
    );
  }
}

/// Local empty state (stand-in for the shared `AppEmptyState`).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.account_balance_outlined,
              size: 40, color: CfoPalette.muted),
          SizedBox(height: 12),
          Text(
            'No linked organisations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CfoPalette.text,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Financials appear here once an organisation is linked.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: CfoPalette.muted),
          ),
        ],
      ),
    );
  }
}
