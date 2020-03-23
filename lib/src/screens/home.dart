import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tempo_dingo/src/config/mock_data.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
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
                  "Tempo Dingo",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 24), child: Text("Artists")),
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
                  onTap: () => print("Artist"),
                  child: ArtistCard(
                    widget.artists[index].images.first.url,
                    widget.artists[index].name,
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text("Quick play"),
        ),
        const SizedBox(height: 10),
        Carousel(widget.tracks),
      ],
    );
  }
}

class _CarouselSlide extends StatefulWidget {
  final String track;
  final String artist;
  final String imgAlbumUrl;
  final String imgArtistUrl;

  const _CarouselSlide(
      this.track, this.artist, this.imgAlbumUrl, this.imgArtistUrl);

  @override
  __CarouselSlideState createState() => __CarouselSlideState();
}

class __CarouselSlideState extends State<_CarouselSlide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: mainTheme.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(widget.imgAlbumUrl,
                  width: MediaQuery.of(context).size.width),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    widget.track,
                    style: TextStyle(
                      color: mainTheme,
                      fontFamily: 'Apple-Bold',
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          color: mainTheme.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.artist,
                    style: TextStyle(
                      color: mainTheme,
                      fontFamily: 'Apple',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: mainTheme.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: Image.network(widget.imgArtistUrl, width: 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
