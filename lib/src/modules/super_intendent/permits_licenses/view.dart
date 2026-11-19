import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'logic.dart';
import 'widgets/expiring_permits_card.dart';
import 'widgets/permits_palette.dart';

class PermitsView extends StatelessWidget {
  const PermitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermitsLogic>(
      init: PermitsLogic(),
      builder: (logic) {
        final permits = logic.expiringSoon;
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Permits & Licenses',
            subtitle: 'Overview of permits expiring soon across all projects.',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (permits.isEmpty)
                      const _NoPermitsCard()
                    else
                      ExpiringPermitsCard(
                        windowDays: PermitsLogic.windowDays,
                        permits: permits,
                        onTap: logic.openPermit,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoPermitsCard extends StatelessWidget {
  const _NoPermitsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: PermitsPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PermitsPalette.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.verified_outlined,
              size: 44, color: PermitsPalette.textMuted),
          SizedBox(height: 12),
          Text(
            'No permits expiring soon',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PermitsPalette.textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Nothing expires in the next 30 days.',
            style: TextStyle(fontSize: 12, color: PermitsPalette.textMuted),
          ),
        ],
      ),
    );
  }
}
