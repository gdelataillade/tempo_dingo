import 'package:flutter/material.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class Library extends StatefulWidget {
  Library({Key key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(),
    );
  }
}
