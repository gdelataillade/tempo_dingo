import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class ArtistScreen extends StatefulWidget {
  final UserModel userModel;
  final spotify.Artist artist;

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
              elevation: 0,
            ),
            backgroundColor: mainTheme,
            body: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: Column(
                children: <Widget>[
                  _ArtistHeader(
                      widget.artist.name, widget.artist.images.first.url),
                  _ArtistTracks(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ArtistHeader extends StatefulWidget {
  final String artist;
  final String imgUrl;

  const _ArtistHeader(this.artist, this.imgUrl);

  @override
  __ArtistHeaderState createState() => __ArtistHeaderState();
}

class __ArtistHeaderState extends State<_ArtistHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.white,
            borderRadius: BorderRadius.all(const Radius.circular(200)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.network(widget.imgUrl),
          ),
        ),
        const SizedBox(height: 20),
        Text(widget.artist),
      ],
    );
  }
}

class _ArtistTracks extends StatefulWidget {
  @override
  __ArtistTracksState createState() => __ArtistTracksState();
}

class __ArtistTracksState extends State<_ArtistTracks> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
