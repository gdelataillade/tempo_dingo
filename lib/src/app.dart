import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/tab_view.dart';
import 'package:tempo_dingo/src/screens/log_in.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Dingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainTheme,
        fontFamily: 'Apple',
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontFamily: 'Apple-Bold',
            fontWeight: FontWeight.w700,
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
          body2: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Apple',
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: mainTheme,
        body: _CheckLogIn(),
      ),
    );
  }
}

class _CheckLogIn extends StatefulWidget {
  _CheckLogIn({Key key}) : super(key: key);

  @override
  __CheckLogInState createState() => __CheckLogInState();
}

class __CheckLogInState extends State<_CheckLogIn> {
  final bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? TabView() : LogIn();
  }
}
