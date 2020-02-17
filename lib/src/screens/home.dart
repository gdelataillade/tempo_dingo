import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tempo_dingo/main.dart';

import 'package:tempo_dingo/src/config/mock_data.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

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
            _Artists(),
            const SizedBox(height: 20),
            _QuickPlay(),
          ],
        ),
      ),
    );
  }
}

class _Artists extends StatefulWidget {
  _Artists({Key key}) : super(key: key);

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
            itemCount: artists.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 0),
                child: GestureDetector(
                  onTap: () => print("Artist"),
                  child: artists[index],
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
  _QuickPlay({Key key}) : super(key: key);

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
        CarouselSlider(
          height: 350,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          items: <Widget>[
            _CarouselSlide(
              "Little Wing",
              "Jimi Hendrix",
              "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
              "https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8",
            ),
            _CarouselSlide(
              "Little Wing",
              "Jimi Hendrix",
              "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
              "https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8",
            ),
            _CarouselSlide(
              "Little Wing",
              "Jimi Hendrix",
              "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
              "https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8",
            ),
          ],
        ),
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
      height: 200,
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
                      color: mainTheme.withOpacity(0.3),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: Offset(1, 1),
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
          // Padding(
          //   padding:
          //       EdgeInsets.only(left: MediaQuery.of(context).size.width - 200),
          //   child: GestureDetector(
          //     onTap: () => print("play"),
          //     child: Text(
          //       "Play >",
          //       style: TextStyle(
          //         color: mainTheme,
          //         fontFamily: 'Apple',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
