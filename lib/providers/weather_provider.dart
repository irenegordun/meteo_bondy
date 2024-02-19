// weather_provider.dart

import 'package:bondy/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

/// Enum representing the different states of weather data download
enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

/// A class responsible for providing weather data and managing its state
class WeatherProvider extends ChangeNotifier {
  late WeatherFactory ws;
  List<WeatherData> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, lon;

  /// Constructor for WeatherProvider
  WeatherProvider(String apiKey) {
    ws = WeatherFactory(apiKey);
  }

  /// Method to query forecast based on latitude and longitude
  Future<void> queryForecast(double lat, double lon) async {
    _state = AppState.DOWNLOADING;
    notifyListeners();

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat, lon);
    _data =
        forecasts.map((weather) => WeatherData(weather.toString())).toList();
    _state = AppState.FINISHED_DOWNLOADING;
    notifyListeners();
  }

  /// Method to query current weather based on latitude and longitude
  Future<void> queryWeather(double lat, double lon) async {
    _state = AppState.DOWNLOADING;
    notifyListeners();

    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    _data = [WeatherData(weather.toString())];
    _state = AppState.FINISHED_DOWNLOADING;
    notifyListeners();
  }

  /// Getter method to retrieve weather data
  List<WeatherData> get weatherData => _data;

  /// Getter method to retrieve the current app state
  AppState get appState => _state;

  /// Method to save latitude input.
  void saveLat(String input) {
    lat = double.tryParse(input);
  }

  /// Method to save longitude input
  void saveLon(String input) {
    lon = double.tryParse(input);
  }
}
