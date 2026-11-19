import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import 'chip_widget.dart';

class AIBidsAnalysis extends StatelessWidget {
  const AIBidsAnalysis({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI Bids Analysis',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                PillChipWidget(
                  label: 'AI Active',
                  color: AppColors.primaryOrange,
                  icon: AppIcons.ai,
                )
              ],
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(AppIcons.bids, height: 30,color: Colors.grey,),
                  SizedBox(height: 10,),
                  Text("No bid insights yet. Run AI analysis to evaluate bid competitiveness, pricing risks, and opportunities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted
                    ),
                  )
                ],
              ),
            )

          ],
        )
    );
  }
}
