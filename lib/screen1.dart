import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'AdditonalInformation.dart';
import 'HourlyForecast.dart';
import 'Secrets.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> weatherFuture;
  late String city;

  @override
  void initState() {
    super.initState();
    city = 'Pune,India';
    weatherFuture = getCurrentWeather(city);
  }

  Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
    // print("Function called!");
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$APIKEY',
        ),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'Unexpected Error Occurred!';
      }
      // setState(() {
      //   temperature = data['list'][0]['main']['temp'];
      //   humidity = data['list'][0]['main']['humidity'];
      //   windSpeed = data['list'][3]['wind']['speed'];
      //   pressure = data['list'][0]['main']['pressure'];
      // });
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Colors.grey),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = getCurrentWeather(city);
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator
                    .adaptive()); // This will change the indicator bases on ios / android);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data;
          final temperature = data?['list'][0]['main']['temp'];
          final humidity = data?['list'][0]['main']['humidity'];
          final windSpeed = data?['list'][3]['wind']['speed'];
          final pressure = data?['list'][0]['main']['pressure'];
          final sky = data?['list'][0]['weather'][0]['main'];
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 100,
              sigmaY: 100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the City Name ',
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              city = textEditingController.text;
                              weatherFuture = getCurrentWeather(city);
                            });
                          },
                          child: const Text('Enter')),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${temperature}K",
                              style: TextStyle(fontSize: 30),
                            ),
                            Icon(
                              sky == 'Clouds' || sky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 50,
                            ),
                            Text(sky, style: TextStyle(fontSize: 30)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // SizedBox(
                            //   height: 150,
                            //   child: ListView.builder(
                            //       itemCount: 5,
                            //       scrollDirection: Axis.horizontal,
                            //       itemBuilder: (context,index)
                            //       {
                            //
                            //         final time1 = DateTime.parse(data?['list'][index+1]['dt_txt']);
                            //
                            //
                            //         return HourlyForecast(
                            //
                            //           time: DateFormat.j().format(time1),
                            //           value: data!['list'][index+1]['main']['temp'].toString(),
                            //           icon: data['list'][0]['weather'][0]['main']=='Clouds' || data['list'][0]['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,);
                            //       }),
                            // )

                            for (int i = 0; i < 6; i++)
                              HourlyForecast(
                                value: data!['list'][i + 1]['main']['temp']
                                    .toString(),
                                icon: data['list'][0]['weather'][0]['main'] ==
                                            'Clouds' ||
                                        data['list'][0]['weather'][0]['main'] ==
                                            'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                time: data['list'][i + 1]['dt_txt']
                                    .toString()
                                    .substring(12,
                                        16), // or use a package knowns as intl
                              ), // This will create a performance issue as it is building 40 widgets at the same time
                            //so we use list view builder to make this lazily as when we scroll it builds the widgets
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInformation(
                            icon: Icons.water_drop_rounded,
                            label: 'Humidity',
                            value: humidity.toString(),
                          ),
                          AdditionalInformation(
                            icon: Icons.wind_power_sharp,
                            label: 'Wind Speed',
                            value: windSpeed.toString(),
                          ),
                          AdditionalInformation(
                            icon: Icons.umbrella,
                            label: 'Pressure',
                            value: pressure.toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
