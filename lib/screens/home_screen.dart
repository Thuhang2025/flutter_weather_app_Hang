// Home Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load weather on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
          child: Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              if (provider.state == WeatherState.loading) {
                return const LoadingShimmer();
              }
              
              if (provider.state == WeatherState.error) {
                return ErrorWidgetCustom(
                  message: provider.errorMessage,
                  onRetry: () => provider.fetchWeatherByLocation(),
                );
              }
              
              if (provider.currentWeather == null) {
                return const Center(
                  child: Text(
                    'No weather data',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              
              // Get gradient based on weather condition
              final gradient = _getBackgroundGradient(provider.currentWeather!.mainCondition);
              
              return Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Weather Card
                        CurrentWeatherCard(weather: provider.currentWeather!),
                        
                        const SizedBox(height: 24),
                        
                        // Hourly Forecast Section
                        const Text(
                          'Hourly Forecast',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160,
                          child: HourlyForecastList(forecasts: provider.forecast),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
  
  // Get background gradient based on weather condition
  LinearGradient _getBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
        );
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        );
    }
  }
}
