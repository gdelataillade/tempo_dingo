import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import 'package:tempo_dingo/src/widgets/loading_screen.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

SpotifyRepository repository = SpotifyRepository();

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
            body: Column(
              children: <Widget>[
                _ArtistHeader(
                    widget.artist.name, widget.artist.images.first.url),
                FutureBuilder<List<spotify.Track>>(
                  future: repository.getArtistTracks(
                      widget.artist.name, widget.artist.id),
                  builder: (context, tracks) {
                    switch (tracks.connectionState) {
                      case ConnectionState.waiting:
                        return LoadingScreen("Loading tracks...");
                      default:
                        if (tracks.hasError) return _Error();
                        return _ArtistTracks(tracks.data);
                    }
                  },
                ),
              ],
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
        Text(widget.artist, style: Theme.of(context).textTheme.title),
      ],
    );
  }
}

class _ArtistTracks extends StatefulWidget {
  final List<spotify.Track> tracks;

  const _ArtistTracks(this.tracks);

  @override
  __ArtistTracksState createState() => __ArtistTracksState();
}

class __ArtistTracksState extends State<_ArtistTracks> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 25, right: 25),
          itemCount: widget.tracks.length,
          itemBuilder: (BuildContext context, int index) {
            final spotify.Track track = widget.tracks[index];

            return TrackCard(
              track.album.images.first.url,
              track.name,
              track.artists.first.name,
              track.id,
              track.popularity,
            );
          },
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Error with API. Try again later.",
          style: Theme.of(context).textTheme.body1),
    );
  }
}
