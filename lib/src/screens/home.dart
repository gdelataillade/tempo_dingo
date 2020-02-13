import 'package:flutter/material.dart';
import 'package:tempo_dingo/main.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainTheme,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tempo Dingo",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            _Artists(),
            _QuickPlay(),
          ],
        ),
      ),
    );
  }
}

class _Artists extends StatefulWidget {
  _Artists({Key key}) : super(key: key);

  @override
  __ArtistsState createState() => __ArtistsState();
}

class __ArtistsState extends State<_Artists> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _QuickPlay extends StatefulWidget {
  _QuickPlay({Key key}) : super(key: key);

  @override
  __QuickPlayState createState() => __QuickPlayState();
}

class __QuickPlayState extends State<_QuickPlay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
