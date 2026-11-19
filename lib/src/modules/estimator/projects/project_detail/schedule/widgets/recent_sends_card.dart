import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../../../../utils/app_icons.dart';
import '../../../models/schedule_model.dart';

class RecentSendsCard extends StatelessWidget {
  final List<ScheduleSendRecord> sends;
  const RecentSendsCard({super.key, required this.sends});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(AppIcons.email, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Recent Sends', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          if (sends.isEmpty)
            Text('No schedule emails have been sent for this project yet.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500))
          else
            for (final s in sends)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${DateFormat('MMM d, y').format(s.sentAt)} · ${s.recipientSummary}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
        ],
      ),
    );
  }
}
