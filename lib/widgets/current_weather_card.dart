// Current Weather Card Widget
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  
  const CurrentWeatherCard({super.key, required this.weather});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // City name - centered
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Date
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Weather icon and temperature side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather icon
              CachedNetworkImage(
                imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                height: 120,
                width: 120,
                placeholder: (context, url) => const SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.cloud,
                  color: Colors.white,
                  size: 120,
                ),
              ),
              const SizedBox(width: 16),
              // Temperature
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Feels like
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  LinearGradient _getWeatherGradient(String condition) {
    // Return different gradients based on weather condition
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
        return const LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
