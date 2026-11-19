import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic.dart';
import '../models/crm_models.dart';
import '../widgets/crm_birthday_banner.dart';
import '../widgets/crm_compliance_alert.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_palette.dart';
import '../widgets/crm_search_field.dart';
import '../widgets/crm_stat_grid.dart';
import '../widgets/organization_card.dart';
import 'crm_filter_sheets.dart';
import 'organization_details_sheet.dart';
import 'organization_form_view.dart';

/// Organizations tab (reference screens 1-3).
class OrganizationsTab extends StatelessWidget {
  final CrmLogic logic;

  const OrganizationsTab({super.key, required this.logic});

  Future<void> _openForm({OrganizationModel? existing}) async {
    final isNew = existing == null;
    final initial = existing ??
        OrganizationModel(
          id: logic.newOrganizationId(),
          name: '',
          type: OrgType.vendor,
        );
    final result = await Get.to<OrganizationModel>(
      () => OrganizationFormView(
        initial: initial,
        isNew: isNew,
        owners: logic.owners,
      ),
    );
    if (result != null) logic.saveOrganization(result);
  }

  @override
  Widget build(BuildContext context) {
    final orgs = logic.filteredOrganizations;
    final alerts = logic.complianceAlerts;

    return ListView(
      children: [
        CrmBirthdayBanner(contacts: logic.upcomingBirthdays),
        const SizedBox(height: 12),
        CrmStatGrid(
          items: [
            CrmStatItem(
              label: 'Total Orgs',
              value: '${logic.totalOrgs}',
              icon: Icons.business_outlined,
              color: CrmPalette.orange,
              tint: CrmPalette.orangeTint,
            ),
            CrmStatItem(
              label: 'Active on Projects',
              value: '${logic.activeOnProjects}',
              icon: Icons.apartment_outlined,
              color: CrmPalette.orange,
              tint: CrmPalette.orangeTint,
            ),
            CrmStatItem(
              label: 'Compliance Issues',
              value: '${logic.complianceIssueCount}',
              icon: Icons.warning_amber_rounded,
              color: CrmPalette.danger,
              tint: CrmPalette.dangerTint,
            ),
            CrmStatItem(
              label: 'Inactive',
              value: '${logic.inactiveOrgs}',
              icon: Icons.do_not_disturb_alt_outlined,
              color: CrmPalette.orange,
              tint: CrmPalette.orangeTint,
            ),
          ],
        ),
        if (alerts.isNotEmpty) ...[
          const SizedBox(height: 12),
          CrmComplianceAlert(entries: alerts),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Organizations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CrmPalette.text,
                ),
              ),
            ),
            // Not in the reference; needed so organizations can be created.
            // CrmSmallButton(
            //   label: 'Add',
            //   icon: Icons.add,
            //   filled: true,
            //   onTap: () => _openForm(),
            // ),
          ],
        ),
        const SizedBox(height: 10),
        CrmSearchField(
          hint: 'Search organizations...',
          initialValue: logic.orgQuery,
          onChanged: logic.setOrgQuery,
          onFilterTap: () => showOrgFilterSheet(context, logic),
          filterActive: logic.hasOrgFilters,
        ),
        const SizedBox(height: 12),
        if (orgs.isEmpty)
          const CrmEmptyState(
            icon: Icons.business_outlined,
            title: 'No organizations found',
            message: 'Try a different search or clear your filters.',
          )
        else
          for (final org in orgs)
            OrganizationCard(
              key: ValueKey(org.id),
              org: org,
              onView: () => showOrganizationDetailsSheet(
                context,
                orgId: org.id,
                onEdit: (o) => _openForm(existing: o),
              ),
              onEdit: () => _openForm(existing: org),
            ),
      ],
    );
  }
}
