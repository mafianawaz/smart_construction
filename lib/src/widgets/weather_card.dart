import 'package:flutter/material.dart';

class WeatherForecastItem {
  const WeatherForecastItem({
    required this.time,
    required this.temperature,
    required this.icon,
    this.isRain = false,
  });

  final String time;
  final String temperature;
  final IconData icon;
  final bool isRain;
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.condition,
    required this.location,
    required this.temperature,
    required this.weatherIcon,
    this.wind = '',
    this.humidity = '',
    this.visibility = '',
    this.forecasts = const [],
    this.margin,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor = Colors.white,
  });

  final String condition;
  final String location;
  final String temperature;

  final IconData weatherIcon;

  final String wind;
  final String humidity;
  final String visibility;

  final List<WeatherForecastItem> forecasts;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================================
          // TOP
          // ================================================================
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(
                weatherIcon,
                size: 45,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.12),
          ),

          const SizedBox(height: 10),

          // ================================================================
          // WEATHER DETAILS
          // ================================================================
          Row(
            children: [
              if (wind.isNotEmpty)
                Expanded(
                  child: _WeatherDetail(
                    icon: Icons.air_rounded,
                    text: wind,
                  ),
                ),

              if (humidity.isNotEmpty)
                Expanded(
                  child: _WeatherDetail(
                    icon: Icons.water_drop_outlined,
                    text: humidity,
                  ),
                ),

              if (visibility.isNotEmpty)
                Expanded(
                  child: _WeatherDetail(
                    icon: Icons.visibility_outlined,
                    text: visibility,
                  ),
                ),
            ],
          ),

          if (forecasts.isNotEmpty) ...[
            const SizedBox(height: 10),

            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.12),
            ),

            const SizedBox(height: 10),

            Row(
              children: forecasts.map((forecast) {
                return Expanded(
                  child: _ForecastItem(
                    forecast: forecast,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// WEATHER DETAIL
// ============================================================================

class _WeatherDetail extends StatelessWidget {
  const _WeatherDetail({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FORECAST
// ============================================================================

class _ForecastItem extends StatelessWidget {
  const _ForecastItem({
    required this.forecast,
  });

  final WeatherForecastItem forecast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          forecast.time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),

        const SizedBox(height: 7),

        Icon(
          forecast.icon,
          size: 22,
          color: Colors.grey.shade500,
        ),

        const SizedBox(height: 7),

        Text(
          forecast.temperature,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}