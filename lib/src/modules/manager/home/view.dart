import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/quick_action_card.dart';
import '../../../widgets/summary_card.dart';
import '../../../widgets/weather_card.dart';
import 'logic.dart';

class ManagerHomeView extends StatelessWidget {
  const ManagerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ManagerHomeLogic(),
        builder: (logic){
          return Scaffold(
            appBar: SecondaryAppbar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoleSummaryCard(
                      title: 'Manager',
                      columns: 2,
                      rowCount: 2,
                      items: [
                        RoleSummaryItem(value: '0', label: 'Active Projects'),
                        RoleSummaryItem(value: '0', label: 'Active Bids'),
                        RoleSummaryItem(value: '0', label: 'Unread Messages'),
                        RoleSummaryItem(value: '0', label: 'Upcoming Events'),
                      ],
                    ),
                    SizedBox(height: 20),
                    QuickActionCard(
                      items: [
                        QuickActionItem(
                          label: 'Bulletins',
                          icon: AppIcons.bulletin,
                          iconColor: AppColors.primaryOrangeDark,
                          onTap: () {
                            // Clock in
                          },
                        ),
                        QuickActionItem(
                          label: 'T&M Sheet',
                          icon: AppIcons.tool,
                          iconColor: AppColors.redColor,
                          onTap: () {
                            // Leave
                          },
                        ),
                        QuickActionItem(
                          label: 'Leave',
                          icon: AppIcons.email,
                          iconColor: AppColors.actionButtonLeave,
                          onTap: () {
                            // Calculator
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
        });
  }
}
