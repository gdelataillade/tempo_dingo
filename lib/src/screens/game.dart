import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class Game extends StatefulWidget {
  final UserModel userModel;
  final spotify.Track track;

  const Game(this.userModel, this.track);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
          _userModel = userModel;
          _userModel.addToHistory(widget.track.id);
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
            ),
            backgroundColor: mainTheme,
            body: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(widget.track.album.images.first.url,
                        width: MediaQuery.of(context).size.width),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.track.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Apple-Bold',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.track.artists.first.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 250,
                    child: Center(
                      child: Text(
                        "Tap the screen",
                        style: TextStyle(
                          color: Color.fromRGBO(77, 83, 105, 0.5),
                          fontFamily: 'Apple-Semibold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
