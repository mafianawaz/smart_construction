import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../../utils/app_icons.dart';
import '../../models/project_enums.dart';
import '../../models/scheduled_log_model.dart';
import 'detail_card.dart';

/// One RFI Log / Submittal Log subsection. Two of these are stacked
/// inside a single "Scheduled Log Emails" [DetailCard] by the caller.
class ScheduledLogSection extends StatelessWidget {
  final ScheduledLogSettings settings;
  final ValueChanged<LogCadence> onCadenceChanged;
  final VoidCallback onSendTest;
  final VoidCallback onSave;

  const ScheduledLogSection({
    super.key,
    required this.settings,
    required this.onCadenceChanged,
    required this.onSendTest,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.fieldBorder,),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(settings.type.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text('Currently: ${settings.cadence == LogCadence.off ? 'Off' : settings.cadence.label}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(settings.type.description,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Failure alerts go to:\n'
                    '${settings.failureAlertRecipient ?? 'Nobody - set a project manager or update the cadence to record an editor.'}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Cadence', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          CustomDropdown<LogCadence>(
            value: settings.cadence,
            items: LogCadence.values,
            itemLabel: (item) => item.label,
            onChanged: (v) => v == null ? null : onCadenceChanged(v),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppIcons.send, height: 13, color: Colors.grey,),
                  const SizedBox(width: 6),
                  const Text('Send Test Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue)),
                ],
              ),
              ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
