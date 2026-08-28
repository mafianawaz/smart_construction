import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

class TaskScheduleCard extends StatelessWidget {
  const TaskScheduleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(6, 0),
              color: Colors.black.withOpacity(0.08),
            ),
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(Icons.calendar_month_outlined,size: 30,color: Colors.grey.shade300),
            Text('No new project assignments',style: TextStyle(
                color: Colors.grey.shade400
            ),)

          ],
        ),
      ),
    );
  }
}
