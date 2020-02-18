import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/screens/profile.dart';
import 'package:tempo_dingo/src/widgets/header.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            _Header(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            const SizedBox(height: 10),
            _AudioSlider(),
            _DebugInfo(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  _Header({Key key}) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.chevron_left, color: Colors.white),
              ),
              Text("Home"),
            ],
          ),
          Row(
            children: <Widget>[
              Text("42"),
              Icon(Icons.star, color: Colors.yellow),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Icon(FeatherIcons.user, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudioSlider extends StatefulWidget {
  const _AudioSlider();

  @override
  __AudioSliderState createState() => __AudioSliderState();
}

class __AudioSliderState extends State<_AudioSlider> {
  double _audio = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Audio Volume ${_audio.round()}"),
        Slider(
          value: _audio,
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          onChanged: (value) {
            setState(() {
              _audio = value;
              print(_audio);
            });
          },
        ),
      ],
    );
  }
}

class _DebugInfo extends StatelessWidget {
  const _DebugInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Debug info:"),
      ],
    );
  }
}

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  __FooterState createState() => __FooterState();
}

class __FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: " - ",
                children: <TextSpan>[],
              ),
              TextSpan(
                text: "Terms of service",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Made with ", style: TextStyle(fontSize: 13)),
              Icon(FeatherIcons.heart, color: Colors.red, size: 15),
              Text(" by Gautier de Lataillade", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
