import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibrate/vibrate.dart';

import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/config/device_info.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/screens/profile.dart';

class Settings extends StatefulWidget {
  final UserModel userModel;

  const Settings(this.userModel);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  int _width = 0;
  int _height = 0;
  UserModel _userModel;

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
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        _userModel = model;
        return Scaffold(
          backgroundColor: mainTheme,
          appBar: AppBar(
            elevation: 1,
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(_userModel))),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: <Widget>[
                          Text("42", style: Theme.of(context).textTheme.body1),
                          Icon(Icons.star,
                              color: Color.fromRGBO(248, 207, 95, 1)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(FeatherIcons.user, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 35),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _userModel.intl("settings"),
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
      }),
    );
  }
}

class _Header extends StatefulWidget {
  _Header({Key key}) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      _userModel = model;
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.chevron_left, color: Colors.white, size: 30),
            ),
            Row(
              children: <Widget>[
                Text("42"),
                Icon(Icons.star, color: Colors.yellow),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(_userModel)));
                  },
                  child: Icon(FeatherIcons.user, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
    });
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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _audio = model.volume;
        return Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: Column(
            children: <Widget>[
              Text("${model.intl('volume')} ${_audio.round()}",
                  style: Theme.of(context).textTheme.title),
              Slider(
                  value: _audio,
                  min: 0,
                  max: 10,
                  // divisions: 10,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  onChanged: (value) {
                    setState(() => _audio = value);
                    model.volume = value;
                    if (_audio % 1 == 0) Vibrate.feedback(FeedbackType.impact);
                  }),
            ],
          ),
        );
      },
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
  final String _gitHubUrl = "https://github.com/gdelataillade/tempo_dingo";
  bool _enableVibration = true;
  bool _enableDarkTheme = true;
  String _language;
  UserModel _userModel;

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

  Widget _buildFlag(String path, String language) {
    return GestureDetector(
      onTap: () {
        if (_language != language) {
          Vibrate.feedback(FeedbackType.impact);
          setState(() => _language = language);
          _userModel.changeLanguage(language);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: _language == language ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Image.asset(path, width: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        _language = model.language;
        _enableVibration = _userModel.vibration;
        return Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(model.intl('vibration')),
                  Switch(
                      activeColor: Colors.white,
                      value: _enableVibration,
                      onChanged: (value) {
                        if (_enableVibration)
                          Vibrate.feedback(FeedbackType.impact);
                        setState(() => _enableVibration = value);
                        _userModel.vibration = value;
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(model.intl('dark_theme')),
                  Switch(
                      activeColor: Colors.white,
                      value: _enableDarkTheme,
                      onChanged: (value) {
                        if (_enableDarkTheme)
                          Vibrate.feedback(FeedbackType.impact);
                        setState(() => _enableDarkTheme = value);
                      }),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(model.intl('language')),
                  Row(
                    children: <Widget>[
                      _buildFlag('assets/images/united-states.png', "en"),
                      const SizedBox(width: 5),
                      _buildFlag('assets/images/france.png', "fr"),
                      const SizedBox(width: 5),
                      _buildFlag('assets/images/spain.png', "es"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  final Email email = _buildEmailReportBug();
                  try {
                    await FlutterEmailSender.send(email);
                  } catch (error) {
                    print(error);
                  }
                },
                child: Text(model.intl('report_bug')),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Made with Flutter in "),
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(_gitHubUrl)) {
                        await launch(_gitHubUrl);
                      } else {
                        throw 'Could not launch $_gitHubUrl';
                      }
                    },
                    child: Text("open source",
                        style: TextStyle(decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        children: <Widget>[
          Text("Debug info", style: Theme.of(context).textTheme.title),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Made with ", style: TextStyle(fontSize: 13)),
              Icon(FeatherIcons.heart, color: Colors.red, size: 15),
              Text(" by Gautier de Lataillade", style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
