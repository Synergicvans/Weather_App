import 'package:a3/WeatherScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //to remove the debug sign on the top right
      //Theme is for everypage thus it sets all over app theme
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        //copywith help to change the specific things to the app
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 100, 170, 65)),
      ), //
      home: const Weatherscreen(),
    );
  }
}
