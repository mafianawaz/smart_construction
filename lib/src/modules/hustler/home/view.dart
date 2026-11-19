import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/quick_action_card.dart';
import '../../../widgets/summary_card.dart';
import '../../../widgets/weather_card.dart';
import 'logic.dart';

class HustlerHomeView extends StatelessWidget {
  const HustlerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HustlerHomeLogic(),
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
                      title: 'Hustler',
                      columns: 2,
                      rowCount: 2,
                      items: [
                        RoleSummaryItem(value: '0', label: 'Organizations'),
                        RoleSummaryItem(value: '0', label: 'Active Projects'),
                        RoleSummaryItem(value: '0', label: 'Open Bids'),
                        RoleSummaryItem(value: '0', label: 'Pending COs'),
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
                          label: 'Reports',
                          icon: AppIcons.danger,
                          iconColor: AppColors.redColor,
                          onTap: () {
                            // Leave
                          },
                        ),
                        QuickActionItem(
                          label: 'Add Org',
                          icon: AppIcons.building,
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