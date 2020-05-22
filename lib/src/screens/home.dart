import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/artist.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
import 'package:tempo_dingo/src/widgets/carousel.dart';

class Home extends StatefulWidget {
  final List<spotify.Track> tracks;
  final List<spotify.Artist> artists;

  const Home(this.tracks, this.artists);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainTheme,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tempo Dingo',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _Artists(widget.artists),
            const SizedBox(height: 20),
            _QuickPlay(widget.tracks),
          ],
        ),
      ),
    );
  }
}

class _Artists extends StatefulWidget {
  final List<spotify.Artist> artists;

  const _Artists(this.artists);

  @override
  __ArtistsState createState() => __ArtistsState();
}

class __ArtistsState extends State<_Artists> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(userModel.intl('artists'))),
            const SizedBox(height: 10),
            Container(
              height: 105,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.artists.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArtistScreen(
                                  userModel, widget.artists[index]))),
                      child: ArtistCard(
                        widget.artists[index].images.length > 0
                            ? widget.artists[index].images.first.url
                            : null,
                        widget.artists[index].name,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickPlay extends StatefulWidget {
  final List<spotify.Track> tracks;

  const _QuickPlay(this.tracks);

  @override
  __QuickPlayState createState() => __QuickPlayState();
}

class __QuickPlayState extends State<_QuickPlay> {
  List<spotify.Track> _shuffledList;

  List<spotify.Track> _addHistoryToList(List<String> historyIds) {
    List<spotify.Track> _newList = [];

    // Add purchased tracks recently played
    for (var i = 0; i < _shuffledList.length; i++) {
      for (var j = 0; j < historyIds.length; j++) {
        if (_shuffledList[i].id == historyIds[j])
          _newList.add(_shuffledList[i]);
      }
    }

    // Then, add the other purchased tracks
    for (var i = 0; i < widget.tracks.length; i++) {
      if (!_newList.contains(widget.tracks[i])) _newList.add(widget.tracks[i]);
    }
    return _newList;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _shuffledList = model.shuffleList(widget.tracks);
        _shuffledList = _addHistoryToList(model.history);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(model.intl('quick_play')),
            ),
            const SizedBox(height: 10),
            Carousel(_shuffledList),
          ],
        );
      },
    );
  }
}
