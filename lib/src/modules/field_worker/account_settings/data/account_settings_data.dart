import '../../../../widgets/custom_tabbar.dart';
import '../models/account_settings_models.dart';

/// Static config and mock data for Account Settings.
///
/// The skill/equipment suggestion lists are placeholders — replace with a
/// real taxonomy/catalog API call (`GET /skills`, `GET /equipment`) when
/// available. The activity log is likewise mock data standing in for
/// `GET /account/activity-log`.
class AccountSettingsData {
  static const topTabs = <CustomTabItem>[
    CustomTabItem(label: 'Profile'),
    CustomTabItem(label: 'Security'),
    CustomTabItem(label: 'Alerts'),
    CustomTabItem(label: 'Skills'),
    CustomTabItem(label: 'Privacy'),
  ];

  static const skillsSubTabs = <String>[
    'Skills',
    'Certifications',
    'Equipment'
  ];

  static const deliveryChannels = <NotificationChannelOption>[
    NotificationChannelOption(id: 'email', label: 'Email'),
    NotificationChannelOption(id: 'sms', label: 'SMS'),
    NotificationChannelOption(id: 'push', label: 'Push'),
    NotificationChannelOption(id: 'teams', label: 'Microsoft Teams'),
    NotificationChannelOption(id: 'slack', label: 'Slack'),
  ];

  static const inAppAlertOptions = <NotificationChannelOption>[
    NotificationChannelOption(id: 'swpppOverdue', label: 'SWPPP corrective action overdue'),
    NotificationChannelOption(id: 'deadlineWarning', label: 'Deadline Warning'),
    NotificationChannelOption(id: 'dailyProgressLogged', label: 'Daily Progress Logged'),
    NotificationChannelOption(id: 'reminder', label: 'Reminder'),
  ];

  static const crmReminderLabels = <CrmReminderFrequency, String>{
    CrmReminderFrequency.off: 'Off',
    CrmReminderFrequency.dailyToday: 'Daily today only',
    CrmReminderFrequency.dailyTodayPlusNext: 'Daily today + next few days',
    CrmReminderFrequency.weeklyDigest: 'Weekly digest',
  };

  // Mock suggestions for the search-to-add Skills field.
  static const skillSuggestions = <String>[
    'Welding',
    'Carpentry',
    'Electrical Wiring',
    'Plumbing',
    'Forklift Operation',
    'Scaffolding',
    'Concrete Finishing',
    'Heavy Equipment Operation',
    'HVAC',
    'Blueprint Reading',
    'OSHA 30',
    'First Aid/CPR',
  ];

  // Mock suggestions for the search-to-add Equipment field.
  static const equipmentSuggestions = <String>[
    'Excavator',
    'Bulldozer',
    'Crane',
    'Forklift',
    'Concrete Mixer',
    'Scaffolding Set',
    'Air Compressor',
    'Generator',
    'Nail Gun',
    'Table Saw',
  ];

  // Mock activity log rows — replace with a real GET /account/activity-log.
  static List<ActivityLogEntry> mockActivityLog(DateTime now) => [
        ActivityLogEntry(action: 'Logged in', timestamp: now.subtract(const Duration(hours: 2)), ipAddress: '102.108.34.68'),
        ActivityLogEntry(action: 'Logged in', timestamp: now.subtract(const Duration(days: 1, hours: 5)), ipAddress: '102.108.34.68'),
        ActivityLogEntry(action: 'Logged in', timestamp: now.subtract(const Duration(days: 2, hours: 1)), ipAddress: '84.17.170.208'),
        ActivityLogEntry(action: 'Logged in', timestamp: now.subtract(const Duration(days: 5)), ipAddress: '84.152.61.239'),
      ];
}
