import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/toggle_field_row.dart';
import '../data/account_settings_data.dart';
import '../logic.dart';
import '../models/account_settings_models.dart';
import 'radio_field_row.dart';
import 'settings_group_card.dart';


class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        const SizedBox(height: 16),

        // Standalone single toggle — keeps its own card.
        ToggleFieldRow(
          label: 'Failure Alerts',
          subtitle: 'Get notified about task failures',
          value: logic.failureAlertsEnabled,
          onChanged: logic.toggleFailureAlerts,
        ),

        // Grouped: one shared card, rows rendered without their own
        // background (standalone: false) so they don't nest a box inside
        // this card's box.
        SettingsGroupCard(
          title: 'Delivery Channels',
          children: [
            for (final channel in AccountSettingsData.deliveryChannels)
              ToggleFieldRow(
                label: channel.label,
                value: logic.channelToggles[channel.id] ?? false,
                onChanged: (v) => logic.toggleChannel(channel.id, v),
                standalone: false,
              ),
          ],
        ),

        SettingsGroupCard(
          title: 'CRM Contact Reminders',
          children: [
            for (final frequency in CrmReminderFrequency.values)
              RadioFieldRow(
                label: AccountSettingsData.crmReminderLabels[frequency] ?? '',
                selected: logic.crmReminderFrequency == frequency,
                onTap: () => logic.setCrmReminderFrequency(frequency),
              ),
          ],
        ),

        ToggleFieldRow(
          label: 'Integration Sync',
          subtitle: 'Integration sync exhaustion email',
          value: logic.integrationSyncEnabled,
          onChanged: logic.toggleIntegrationSync,
        ),

        SettingsGroupCard(
          title: 'In-App Alerts',
          children: [
            for (final option in AccountSettingsData.inAppAlertOptions)
              ToggleFieldRow(
                label: option.label,
                value: logic.inAppAlertToggles[option.id] ?? false,
                onChanged: (v) => logic.toggleInAppAlert(option.id, v),
                standalone: false,
              ),
          ],
        ),

        const SizedBox(height: 12),
        CustomButton(
          text: 'Save Preferences',
          isLoading: logic.alertsSaving,
          onPressed: logic.saveAlertPreferences,
        ),
      ],
    );
  }
}
