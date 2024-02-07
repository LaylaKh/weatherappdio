import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_dio/models/weather_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

WeatherModel data = WeatherModel();

class _MainPageState extends State<MainPage> {
  Future<void> getWeather(String city) async {
    final Dio dio = Dio();

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '99e8a0fe0e835bd24d899cd8d3a93d2e',
        'units': 'metric'
      },
    );
    final result = WeatherModel.fromJson(response.data);
    data = result;
    setState(() {});
  }

  @override
  void initState() {
    getWeather('Bishkek');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    final formatter = DateFormat('MMMM dd, yyyy');
    final formattedDate = formatter.format(currentDate);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: getColor(currentDate.hour),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                data.name ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 36,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                data.weather?.first.description ?? '',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const SizedBox(height: 33),
              CachedNetworkImage(
                imageUrl:
                    'https://openweathermap.org/img/wn/${data.weather?.first.icon}@2x.png',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 100,
              ),
              const SizedBox(height: 12),
              Text(
                formattedDate,
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: 'City'),
                onChanged: (val) {
                  getWeather(val);
                },
              ),
              const SizedBox(height: 30),
              WeatherWidget(model: data)
            ],
          ),
        ),
      ),
    );
  }

  List<Color> getColor(int currentHour) {
    List<Color> colors = [
      const Color(0xff223076),
      const Color(0xff06050E),
    ];

    if (currentHour >= 19 && currentHour < 23) {
      colors = [];
      colors.addAll(
        [
          const Color(0xff4BB5F1),
          const Color(0xff2F2CBC),
        ],
      );
    }

    return colors;
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.model});

  final WeatherModel? model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model?.name ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${model?.weather?.first.icon}@2x.png',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Text(
            model?.main?.temp.toString() ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}