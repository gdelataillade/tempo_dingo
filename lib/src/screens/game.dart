import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class Gameplay extends StatefulWidget {
  final UserModel userModel;
  final Track track;

  const Gameplay(this.userModel, this.track);

  @override
  _GameplayState createState() => _GameplayState();
}

class _GameplayState extends State<Gameplay> {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
          _userModel = userModel;
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
            ),
            backgroundColor: mainTheme,
            body: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: <Widget>[
                  Text(_userModel.fullName,
                      style: TextStyle(color: Colors.white)),
                  Text(widget.track.name,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
