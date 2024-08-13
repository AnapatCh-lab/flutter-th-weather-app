import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'util/weather_info.dart'; // Import the models

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String _apiKey = '2353ce98e985f57308eb8cbf02ad6ef2';
  List<City> cities = [];
  City? selectedCity;
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchCities();
    updateWeatherData();
  }

  Future<void> _fetchCities() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province.json'), // API endpoint
      );

      if (response.statusCode == 200) {
        final List<dynamic> cityList = json.decode(response.body);
        setState(() {
          cities = cityList
              .map((city) => City(
                    nameEn: city['name_en'].toString(),
                    nameTh: city['name_th'].toString(),
                  ))
              .toList();
          selectedCity = cities.isNotEmpty ? cities[0] : null;
          if (selectedCity != null) {
            _fetchWeather();
          }
        });
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  Future<void> _fetchWeather() async {
    try {
      if (selectedCity != null) {
        final weather = await getWeather(
            selectedCity!.nameEn); // Use English name for API call
        setState(() {
          _weather = weather;
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  void updateWeatherData() {
    Timer.periodic(const Duration(minutes: 15), (timer) {
      if (selectedCity != null) {
        getWeather(selectedCity!.nameEn).then((weather) {
          setState(() {
            _weather = weather;
          });
        }).catchError((error) {
          print('Error fetching weather data: $error');
        });
      }
    });
  }

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&lang=th&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> weatherData = json.decode(response.body);
      return Weather.fromJson(weatherData); // Convert JSON to Weather object
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 30,
            fontWeight: FontWeight.w600),
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 21, 38, 51),
      ),
      backgroundColor: Colors.blueGrey[700],
      body: Center(
        child: cities.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize
                    .min, // Ensure the Column only takes as much space as needed
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<City>(
                    value: selectedCity,
                    style: const TextStyle(
                      fontFamily: 'ThFont',
                    ),
                    dropdownColor: Colors.grey[800],
                    onChanged: (City? newValue) {
                      setState(() {
                        selectedCity = newValue!;
                        _fetchWeather();
                      });
                    },
                    items: cities.map<DropdownMenuItem<City>>((City city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text(
                          city.nameTh,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'ThFont',
                            fontSize: 20,
                          ),
                        ), // Display Thai name
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  if (_weather != null) ...[
                    Lottie.network(
                      getWeatherIcon(_weather?.description),
                    ),
                    Text(
                      selectedCity!.nameTh,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                    Text(
                      '${_weather?.temp.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Min: ${_weather?.minTemp.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                    Text(
                      'Max: ${_weather?.maxTemp.toStringAsFixed(2)} °C',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _weather?.description ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                  ] else
                    const Text(
                      'Select a city to view weather information',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ThFont',
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
