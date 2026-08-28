import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/quick_action_card.dart';
import '../../../widgets/summary_card.dart';
import '../../../widgets/weather_card.dart';
import 'logic.dart';
import 'widget/task_schedule_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoleSummaryCard(
                    title: 'FIELD WORKER',
                    items: [
                      RoleSummaryItem(value: '0', label: 'Projects'),
                      RoleSummaryItem(value: '0', label: 'Tasks'),
                      RoleSummaryItem(value: '0', label: 'Messages'),
                    ],
                  ),
                  SizedBox(height: 20),
                  QuickActionCard(
                    items: [
                      QuickActionItem(
                        label: 'Clock In',
                        icon: AppIcons.clock,
                        iconColor: AppColors.primaryOrangeDark,
                        onTap: () {
                          // Clock in
                        },
                      ),
                      QuickActionItem(
                        label: 'Leave',
                        icon: AppIcons.email,
                        iconColor: AppColors.actionButtonLeave,
                        onTap: () {
                          // Leave
                        },
                      ),
                      QuickActionItem(
                        label: 'Calculator',
                        icon: AppIcons.calculator,
                        iconColor: AppColors.actionButtonCalculator,
                        onTap: () {
                          // Calculator
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Schedule & Tasks',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        label: Text('View All',style: TextStyle(color: AppColors.primaryOrange,fontSize: 13),),
                        icon: Icon(Icons.arrow_forward_ios_rounded,color: AppColors.primaryOrange,size: 15,),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TaskScheduleCard(),
                  SizedBox(height: 10),
                  WeatherCard(
                    condition: 'Partly Cloudy',
                    location: 'Downtown District',
                    temperature: '28°',
                    weatherIcon: Icons.wb_sunny_outlined,
                    wind: '12 km/h',
                    humidity: '15%',
                    visibility: '10 km',
                    forecasts: [
                      WeatherForecastItem(
                        time: 'Now',
                        temperature: '28°',
                        icon: Icons.wb_sunny_outlined,
                      ),
                      WeatherForecastItem(
                        time: '11AM',
                        temperature: '31°',
                        icon: Icons.wb_sunny_outlined,
                      ),
                      WeatherForecastItem(
                        time: '1PM',
                        temperature: '33°',
                        icon: Icons.wb_sunny_outlined,
                      ),
                      WeatherForecastItem(
                        time: '3PM',
                        temperature: '30°',
                        icon: Icons.cloud_outlined,
                      ),
                      WeatherForecastItem(
                        time: '5PM',
                        temperature: '26°',
                        icon: Icons.water_drop_outlined,
                        isRain: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

