import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../logic.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;
  final VoidCallback? onCancel;

  const LeaveRequestCard({
    super.key,
    required this.request,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              _StatusChip(
                status: request.status,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '${_format(request.startDate)} to '
                '${_format(request.endDate)} '
                '(${request.days} days)',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          if (request.reason.isNotEmpty) ...[
            const SizedBox(height: 7),

            Text(
              'Notes: ${request.reason}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],

          if (request.status == 'Approved') ...[
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Container(
                    // height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Reviewer note: YES',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 13,),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _format(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool approved = status == 'Approved';
    final bool denied = status == 'Denied';

    final Color color = approved
        ? Colors.green
        : denied
        ? Colors.red
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}