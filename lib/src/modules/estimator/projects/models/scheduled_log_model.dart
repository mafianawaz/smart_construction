import 'project_enums.dart';

enum ScheduledLogType { rfi, submittal }

extension ScheduledLogTypeX on ScheduledLogType {
  String get title {
    switch (this) {
      case ScheduledLogType.rfi:
        return 'RFI Log';
      case ScheduledLogType.submittal:
        return 'Submittal Log';
    }
  }

  String get description {
    switch (this) {
      case ScheduledLogType.rfi:
        return "PDF snapshot of the project's RFI log emailed to your "
            'distribution recipients.';
      case ScheduledLogType.submittal:
        return "PDF snapshot of the project's Submittal log emailed to "
            'your distribution recipients.';
    }
  }
}

class ScheduledLogSettings {
  final ScheduledLogType type;
  final LogCadence cadence;

  /// Who failure alerts go to; null renders the "Nobody — set a
  /// project manager…" hint from the reference.
  final String? failureAlertRecipient;

  const ScheduledLogSettings({
    required this.type,
    this.cadence = LogCadence.off,
    this.failureAlertRecipient,
  });

  ScheduledLogSettings copyWith({
    LogCadence? cadence,
    String? failureAlertRecipient,
  }) {
    return ScheduledLogSettings(
      type: type,
      cadence: cadence ?? this.cadence,
      failureAlertRecipient: failureAlertRecipient ?? this.failureAlertRecipient,
    );
  }
}
