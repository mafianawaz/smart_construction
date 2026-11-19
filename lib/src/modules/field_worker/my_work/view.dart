import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/app_textfield.dart';
import 'logic.dart';
import 'project_details/view.dart';
import 'widget/calendar_view.dart';

class MyWorkView extends StatelessWidget {
  const MyWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MyWorkLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(isHome: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Search projects..',
                    leftIconPath: AppIcons.search,
                  ),
                  SizedBox(height: 15),
                  Obx(() => CustomToggle(
                      options: ["Table", "Calendar", "Map"],
                      isIconToggle: true,
                      toggleIcon: [AppIcons.table, AppIcons.calendar, AppIcons.map,],
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),

                                ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Testing General Contactor',style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),),
                                        IconButton(
                                            onPressed: (){
                                              Get.to(() => ProjectDetailView());
                                            },
                                            icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 15,)
                                        ),

                                      ],
                                    ),
                                    RichText(
                                      text:  TextSpan(
                                        text: 'Code: ',
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 13,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '261202',
                                          ),
                                          TextSpan(
                                            text: '  Client: ',
                                          ),
                                          TextSpan(
                                            text: 'XYZ',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Chip(
                                            backgroundColor: AppColors.statusChip,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                            side: BorderSide.none,
                                            label: Text('ACTIVE',style: TextStyle(color: Colors.white, fontSize: 13,),)),
                                        SizedBox(
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: LinearProgressIndicator(
                                              value: 10,
                                              minHeight: 12,
                                              backgroundColor: Colors.grey.shade50,
                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.statusChip),
                                            ),
                                          ),
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
                        return CalendarDemoScreen();
                      case 2:
                      return Column(
                        children: [
                          SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: Image.asset(AppImages.map,fit: BoxFit.cover,)),
                        ],
                      );
                      default:
                        return AppEmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'Nothing to do here',
                          message: 'No work matches your filters. Try clearing them or switching the source.',
                          buttonText: 'Clear Filters',
                          onButtonPressed: () {},
                        );
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
