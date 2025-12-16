// Hourly Forecast List Widget
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  
  const HourlyForecastList({super.key, required this.forecasts});
  
  @override
  Widget build(BuildContext context) {
    // Get next 24 hours of forecasts
    final now = DateTime.now();
    final next24Hours = forecasts.where((forecast) {
      return forecast.dateTime.isAfter(now) && 
             forecast.dateTime.isBefore(now.add(const Duration(hours: 24)));
    }).take(8).toList();
    
    if (next24Hours.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: next24Hours.length,
      itemBuilder: (context, index) {
        final forecast = next24Hours[index];
        return Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                DateFormat('HH:mm').format(forecast.dateTime),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              CachedNetworkImage(
                imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                height: 50,
                width: 50,
                placeholder: (context, url) => const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.cloud,
                  color: Colors.white70,
                  size: 50,
                ),
              ),
              Text(
                '${forecast.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
