import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Library",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
