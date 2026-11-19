import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import 'logic.dart';
import 'widgets/cfo_bulletin_palette.dart';
import 'widgets/cfo_bulletin_widgets.dart';

/// CFO → Bulletins: daily updates and notes across all linked organizations.
class CfoBulletinsView extends StatelessWidget {
  const CfoBulletinsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoBulletinsLogic>(
      init: CfoBulletinsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Bulletins',
            showBackButton: true,
            centerTitle: true,
          ),
          body: RefreshIndicator(
            color: CfoBulletinPalette.orange,
            onRefresh: logic.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              children: [
                const Text(
                  'Daily updates and notes across all your linked organizations.',
                  style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: CfoBulletinPalette.muted),
                ),
                const SizedBox(height: 12),
                if (logic.loading && logic.organizations.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: CfoBulletinPalette.orange),
                    ),
                  )
                else
                  for (final org in logic.organizations) ...[
                    CfoBulletinOrgSection(
                      org: org,
                      expanded: logic.isExpanded(org.id),
                      onToggle: () => logic.toggle(org.id),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}
