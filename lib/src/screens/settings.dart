import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:tempo_dingo/src/config/device_info.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/screens/profile.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            _SettingsFields(_deviceData, _width, _height),
            const SizedBox(height: 20),
            _DebugInfo(_deviceData, _width, _height),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: <Widget>[
                Icon(Icons.chevron_left, color: Colors.white, size: 30),
                Text("Home", style: Theme.of(context).textTheme.title),
              ],
            ),
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

class _SettingsFields extends StatefulWidget {
  final Map<String, dynamic> deviceData;
  final int width;
  final int height;

  const _SettingsFields(this.deviceData, this.width, this.height);

  @override
  __SettingsFieldsState createState() => __SettingsFieldsState();
}

class __SettingsFieldsState extends State<_SettingsFields> {
  bool _enableVibration = true;
  bool _enableDarkTheme = true;

  Email _buildEmailReportBug() {
    return Email(
      body:
          "Please write bug description:\n\n\n<--- Don't write below --->\nDevice: ${widget.deviceData['name']} ${widget.deviceData['systemName']} ${widget.deviceData['systemVersion']}\nScreen size: ${widget.width}x${widget.height}\nApp version: $appVersion",
      subject: "Tempo Dingo - Bug report",
      recipients: ["gautier2406@gmail.com"],
    );
  }

  Email _buildEmailRecommendation() {
    return Email(
      body: "Please write your recommendation below:\n\n\n",
      subject: "Tempo Dingo - Bug report",
      recipients: ["gautier2406@gmail.com"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Vibration"),
              Switch(
                activeColor: Colors.white,
                value: _enableVibration,
                onChanged: (value) => setState(() => _enableVibration = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Dark Theme"),
              Switch(
                activeColor: Colors.white,
                value: _enableDarkTheme,
                onChanged: (value) => setState(() => _enableDarkTheme = value),
              ),
            ],
          ),
          Text("Language"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final Email email = _buildEmailReportBug();
              try {
                await FlutterEmailSender.send(email);
              } catch (error) {
                print(error);
              }
            },
            child: Text("Report a bug"),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final Email email = _buildEmailRecommendation();
              try {
                await FlutterEmailSender.send(email);
              } catch (error) {
                print(error);
              }
            },
            child: Text("Have any recommendation?"),
          ),
        ],
      ),
    );
  }
}

class _DebugInfo extends StatefulWidget {
  final Map<String, dynamic> deviceData;
  final int width;
  final int height;

  const _DebugInfo(this.deviceData, this.width, this.height);

  @override
  __DebugInfoState createState() => __DebugInfoState();
}

class __DebugInfoState extends State<_DebugInfo> {
  @override
  Widget build(BuildContext context) {
    print(widget.deviceData);
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
              widget.deviceData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${widget.deviceData['name']} ${widget.deviceData['systemName']} ${widget.deviceData['systemVersion']}"),
                        Text("${widget.width}x${widget.height}"),
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

class _Footer extends StatelessWidget {
  const _Footer({Key key}) : super(key: key);

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
