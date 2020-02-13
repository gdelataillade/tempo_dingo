import 'package:flutter/material.dart';

final Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

final ThemeData themeConfig = ThemeData(
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
);
