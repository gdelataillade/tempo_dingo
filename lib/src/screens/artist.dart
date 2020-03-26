import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class ArtistScreen extends StatefulWidget {
  final UserModel userModel;
  final Artist artist;

  const ArtistScreen(this.userModel, this.artist);

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
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
                  Text(widget.artist.name,
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
