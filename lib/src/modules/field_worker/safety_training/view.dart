import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/custom_tabbar.dart';
import 'attendance/view.dart';
import 'checklist_detail/view.dart';
import 'logic.dart';
import 'widget/stat_card.dart';

class SafetyTrainingView extends StatelessWidget {
  const SafetyTrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SafetyTrainingLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Safety Training',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage safety trainings, toolbox talks and checklist.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Total Assigned',
                        icon: AppIcons.assigned,
                        count: '2',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: StatCard(
                        label: 'Completed',
                        icon: AppIcons.tickCircle,
                        count: '0',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Pending',
                        icon: AppIcons.clock,
                        count: '0',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        label: 'Overdue',
                        icon: AppIcons.danger,
                        count: '0',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Obx(
                  () => CustomTabBar(
                    tabs: [
                      CustomTabItem(label: 'Training Program'),
                      CustomTabItem(label: 'Assignment'),
                      CustomTabItem(label: 'Toolbox Talks'),
                      CustomTabItem(label: 'Checklists'),
                    ],
                    selectedIndex: logic.selectedIndex.value,
                    onChanged: logic.changeIndex,
                  ),
                ),
                SizedBox(height: 15),
                Obx(() {
                  switch (logic.selectedIndex.value) {
                    case 0:
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Test',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'PPE(Personal Protective Equipment)',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'One Time Only',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '60 min',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Description',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Materials:  ',
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'test',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(color: Colors.grey),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '1 assigned . 0 completed',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '0%',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    case 1:
                      return Column(
                        children: [
                          CustomTextField(
                            hintText: 'Search Employees or trainings...',
                          ),
                        ],
                      );
                    case 2:
                      return Column(
                        children: [
                          Obx(()=> CustomToggle(
                            options: ['Schedule', 'Completed'],
                            isIconToggle: true,
                            isColored: true,
                            toggleIcon: [AppIcons.calendar, AppIcons.assigned],
                            selectedIndex: logic.selectedToolboxItem.value,
                            onChanged: logic.onChange,
                          )),
                          SizedBox(height: 10),
                          Obx((){
                            if(logic.selectedToolboxItem.value == 0){
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Heat Stress',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryOrange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.people_alt_outlined,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.to(()=> AttendanceView());
                                            },
                                            label: Text(
                                              'Attendance',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8,),
                                            ),
                                            child: Text(
                                              'Fire Safety',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8,),
                                            ),
                                            child: Text(
                                              'Overdue',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Date:  ',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Date: Mar 28, 2026   Presenter: test    Notes: test',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }else{
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Heat Stress',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8,),
                                            ),
                                            child: Text(
                                              'Fire Safety',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Test',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Attachments:  ',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'test',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          })

                        ],
                      );
                    case 3:
                      return Column(
                        children: [
                          Obx(()=> CustomToggle(
                            options: ['Completed', 'Templates'],
                            isIconToggle: true,
                            isColored: true,
                            toggleIcon: [AppIcons.clock, AppIcons.template],
                            selectedIndex: logic.selectedChecklistItem.value,
                            onChanged: logic.onChangeChecklist,
                          )),
                          SizedBox(height: 10),
                          Obx((){
                            if(logic.selectedChecklistItem.value == 0){
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Test',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              Get.to(()=> ChecklistDetailView());
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8,),
                                            ),
                                            child: Text(
                                              'Daily Pre-Task',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(8,),
                                            ),
                                            child: Text(
                                              'Completed',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      RichText(
                                        text: TextSpan(
                                          text: 'By:  ',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Test Admin   Date: Mar 28, 2026',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }else{
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Test',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8,),
                                        ),
                                        child: Text(
                                          'Daily Pre-Task',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '1 Item',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Test:  ',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'test',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          })

                        ],
                      );
                    default:
                      return SizedBox();
                  }
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
