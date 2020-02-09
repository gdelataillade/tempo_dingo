import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/screens/log_in.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Dingo',
      theme: ThemeData(
        primaryColor: mainTheme,
        fontFamily: 'Apple',
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontFamily: 'Apple',
            fontWeight: FontWeight.bold,
          ),
          title: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Apple-Semibold',
            fontWeight: FontWeight.bold,
          ),
          body1: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Apple',
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: mainTheme,
        body: LogIn(),
      ),
    );
  }
}
