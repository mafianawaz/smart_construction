import 'package:flutter/material.dart';

/// Top-level Account Settings tabs.
enum AccountSettingsTab { profile, security, alerts, skills, privacy }

/// Skills tab's nested sub-tabs.
enum SkillsSubTab { skills, certifications, equipment }

/// CRM contact reminder cadence (Alerts tab).
enum CrmReminderFrequency { off, dailyToday, dailyTodayPlusNext, weeklyDigest }

/// A single notification delivery channel toggle (Email, SMS, Push, ...).
class NotificationChannelOption {
  final String id;
  final String label;

  const NotificationChannelOption({required this.id, required this.label});
}

/// A single in-progress or saved certification. Holds its own
/// [TextEditingController] the same way Calculator's dynamic-list entries
/// (e.g. Masonry's openings) do, since each row needs its own live text
/// field.
class CertificationEntry {
  CertificationEntry({
    required this.id,
    this.issueDate,
    this.expiryDate,
    this.uploadedFileName,
  }) : nameController = TextEditingController();

  final String id;
  final TextEditingController nameController;
  DateTime? issueDate;
  DateTime? expiryDate;
  String? uploadedFileName;

  void dispose() => nameController.dispose();
}

/// A single account activity/audit log row (Privacy tab).
class ActivityLogEntry {
  final String action;
  final DateTime timestamp;
  final String ipAddress;

  const ActivityLogEntry({
    required this.action,
    required this.timestamp,
    required this.ipAddress,
  });
}
