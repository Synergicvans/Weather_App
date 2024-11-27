// ignore: file_names
import 'dart:convert';
import 'dart:ui';
import 'package:a3/additional_info_item.dart';
import 'package:a3/hourly_forecast_item.dart';
import 'package:a3/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  // double temp = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentWeather();
  // }

  late Future<Map<String, dynamic>> weather;
  //function is being maked
  Future<Map<String, dynamic>> getCurrentWeather() async {
    //future sholn't be dynamic it's not good in dart
    try {
      String cityName = 'Bhopal'; //
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,India&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (int.parse(data['cod']) != 200) {
        //data['cod']!='200'; can be also used here
        throw 'An unexpected error occured';
        //throw will terminate  the function at this point like return
      }
      return data;

      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
                //here weather calls function everytime thus if we remove
                //above line the whole build function won't be called
              }); //setstate will rebuild all the build functions
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            weather, //weather is variable thus no need for the full rebuiling and
        // if function is called , i.e getweather app
        builder: (context, snapshot) {
          //snapshot helps to handle state -error state , loading state
          print(snapshot);
          // print(snapshot.runtimeType);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            ); //as snapshot.error is dynamic object thus change to string
          }

          final data = snapshot.data!; //data can't be nullable

          final currentWeatherData = data['list'][0];
          //for better code experience
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]
              ['main']; //weather is the list thus added [0] and
          //main is called as it's in form of object
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Project A',
                                style: TextStyle(
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      //for border rounding the blur part helps to look like merged things
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        //for the merging blur help
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Placeholder(
                //   fallbackHeight: 250,
                // ), //use to determine the region
                const SizedBox(
                  height: 20,
                ),

                // const Align(
                //   //for the alignment ,we can use container also
                //   alignment: Alignment.centerLeft, child :
                const Center(
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 180, 180, 180)),
                  ),
                ),
                // ),

                const SizedBox(
                  height: 8,
                ),

                const Center(
                  child: SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          HourlyForecastItem(
                            //same with constructor for the changes
                            time: 'Have a',
                            icon: Icons.tag_faces_sharp,
                            temperature: 'good day',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ## ROW CARD
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal, //for tthe scrolling part
                //   child: Row(
                //     children: [
                //       //##card1

                //       for (int i = 0; i < 13; i++)
                //         HourlyForecastItem(
                //           //same with constructor for the changes
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temperature:
                //               data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),

                //##Now we create list view builder as we need
                //to create a scroolable cards which will render if only the ui needs
                //to be render // but data will be rendered already
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 32,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);
                        return HourlyForecastItem(
                          time: DateFormat.j().format(time),
                          icon: data['list'][index + 1]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temperature: data['list'][index + 1]['main']['temp']
                              .toString(),
                          //date time
                        );
                      }),
                ),

                // //weather forecast cards
                // const Placeholder(
                //   fallbackHeight: 150,
                // ),

                const SizedBox(
                  height: 15,
                ),

                //additional info
                // const Placeholder(
                //   fallbackHeight: 150,
                // ),

                //last part additional info
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //spaceing
                const SizedBox(
                  height: 8,
                ),

                //last row area
                Row(
                  //for the space evenly around around the boxes of additional info
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // this auto matically adjusts the things
                  children: [
                    AddtionalInfoItem(
                      //now we have to put the values by developer
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AddtionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AddtionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
