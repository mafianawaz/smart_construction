import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_color.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String icon;
  final String count;

  const StatCard({
    super.key, required this.label, required this.icon, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(3, 0),
            ),
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: SvgPicture.asset(icon,color: Colors.white,)),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                Text(count, style: TextStyle(fontWeight: FontWeight.w600),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
