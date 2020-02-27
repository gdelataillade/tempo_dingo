import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class LoadingScreen extends StatefulWidget {
  final String text;

  const LoadingScreen(this.text);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(child: loadingWhite),
          Text(widget.text),
        ],
      ),
    );
  }
}
