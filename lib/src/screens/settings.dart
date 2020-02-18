import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:tempo_dingo/src/config/device_info.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/screens/profile.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            _Header(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 35),
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            const SizedBox(height: 20),
            _AudioSlider(),
            const SizedBox(height: 20),
            _DebugInfo(),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.chevron_left, color: Colors.white, size: 30),
              ),
              Text("Home", style: Theme.of(context).textTheme.title),
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
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        children: <Widget>[
          Text("Audio Volume ${_audio.round()}",
              style: Theme.of(context).textTheme.title),
          Slider(
            value: _audio,
            min: 0,
            max: 10,
            // divisions: 10,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            onChanged: (value) => setState(() => _audio = value),
          ),
        ],
      ),
    );
  }
}

class _DebugInfo extends StatefulWidget {
  const _DebugInfo();

  @override
  __DebugInfoState createState() => __DebugInfoState();
}

class __DebugInfoState extends State<_DebugInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  int _width = 0;
  int _height = 0;

  void _getDeviceResolution() {
    ui.Size size = ui.window.physicalSize;
    setState(() {
      _width = size.width.round();
      _height = size.height.round();
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getDeviceResolution();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    if (Platform.isAndroid) {
      deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    if (!mounted) return;
    setState(() => _deviceData = deviceData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        children: <Widget>[
          Text("Debug info:", style: Theme.of(context).textTheme.title),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Device:"),
                  Text("Screen size:"),
                  Text("App version:"),
                ],
              ),
              _deviceData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${_deviceData['name']} ${_deviceData['systemName']} ${_deviceData['systemVersion']}"),
                        Text("${_width}x$_height"),
                        Text(appVersion)
                      ],
                    )
                  : Container(),
            ],
          ),
        ],
      ),
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
