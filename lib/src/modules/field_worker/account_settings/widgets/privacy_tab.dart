import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';
import '../models/account_settings_models.dart';


class PrivacyTab extends StatelessWidget {
  const PrivacyTab({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Account Data',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 6),
              Text(
                'Download a copy of all your account data including profile '
                'information, activity history, and settings, packaged as a ZIP file.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              CustomIconButton(
                text: 'Export My Data (ZIP)',
                icon: AppIcons.export,
                isLoading: logic.exportingData,
                onPressed: logic.exportAccountData,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity Log',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 12),
              for (final entry in logic.activityLog) _ActivityLogRow(entry: entry),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          borderColor: AppColors.redColor.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Deactivation',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 6),
              const Text(
                'Once your account is deactivated, all your data will be scheduled '
                'for permanent deletion. This action cannot be undone. Please make '
                'sure to export your data before proceeding.',
                style: TextStyle(fontSize: 12, color: AppColors.redColor),
              ),
              const SizedBox(height: 16),
              CustomIconButton(
                text: 'Request Account Deactivation',
                icon: AppIcons.danger,
                color: AppColors.redColor,
                isLoading: logic.requestingDeactivation,
                onPressed: () => _confirmDeactivation(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDeactivation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate account?'),
        content: const Text(
          'This will schedule your account and all its data for permanent '
          'deletion. This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate', style: TextStyle(color: AppColors.redColor)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      logic.requestAccountDeactivation();
    }
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.borderColor});

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _ActivityLogRow extends StatelessWidget {
  const _ActivityLogRow({required this.entry});

  final ActivityLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppIcons.activityLog, height: 18, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.action, style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                Text(
                  '${_formatTimestamp(entry.timestamp)} · ${entry.ipAddress}',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} $hour12:$minute $period';
  }
}
