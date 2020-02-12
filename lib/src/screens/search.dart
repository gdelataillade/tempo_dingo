import 'package:flutter/material.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(),
    );
  }
}
