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
      theme: themeConfig,
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
  static const bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? TabView() : LogIn();
  }
}
