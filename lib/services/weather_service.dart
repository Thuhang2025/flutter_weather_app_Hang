// Weather Service
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final String apiKey;
  
  WeatherService({required this.apiKey});
  
  // Get current weather by city name
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'q': cityName},
      );
      
      print('Fetching weather for: $cityName');
      print('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        print('Error fetching data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error in getCurrentWeatherByCity: $e');
      throw Exception('Error: $e');
    }
  }
  
  // Get current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat, 
    double lon,
  ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'lat': lat.toString(), 'lon': lon.toString()},
      );
      
      print('Fetching weather for coordinates: lat=$lat, lon=$lon');
      print('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key');
      } else if (response.statusCode == 404) {
        throw Exception('Location not found');
      } else {
        print('Error fetching data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error in getCurrentWeatherByCoordinates: $e');
      throw Exception('Error: $e');
    }
  }
  
  // Get 5-day forecast by city name
  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'q': cityName},
      );
      
      print('Fetching forecast for: $cityName');
      print('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        
        if (forecastList.isEmpty) {
          print('Warning: Forecast list is empty');
          return [];
        }
        
        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        print('Error fetching forecast data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      print('Error in getForecast: $e');
      throw Exception('Error: $e');
    }
  }
  
  // Get 5-day forecast by coordinates
  Future<List<ForecastModel>> getForecastByCoordinates(
    double lat, 
    double lon,
  ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'lat': lat.toString(), 'lon': lon.toString()},
      );
      
      print('Fetching forecast for coordinates: lat=$lat, lon=$lon');
      print('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        
        if (forecastList.isEmpty) {
          print('Warning: Forecast list is empty');
          return [];
        }
        
        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key');
      } else if (response.statusCode == 404) {
        throw Exception('Location not found');
      } else {
        print('Error fetching forecast data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      print('Error in getForecastByCoordinates: $e');
      throw Exception('Error: $e');
    }
  }
  
  // Get weather icon URL
  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
