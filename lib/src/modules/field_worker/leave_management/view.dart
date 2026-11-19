import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import 'leave_request/view.dart';
import 'logic.dart';
import 'widget/leave_dashboard.dart';

class LeaveManagementView extends StatelessWidget {
  const LeaveManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveManagementLogic>(
      init: LeaveManagementLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Leave Management',
            showBackButton: true,
            centerTitle: true,
            actions: logic.isRequestMode
                ? null
                : [
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkResponse(
                  onTap: logic.openRequestForm,
                  radius: 24,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: logic.isRequestMode
              ? LeaveRequestForm(logic: logic,)
              : LeaveDashboard(logic: logic,),
        );
      },
    );
  }
}
