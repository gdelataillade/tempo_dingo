import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
            ),
            _CarouselSlide(
              "Little Wing",
              "Jimi Hendrix",
              "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
            ),
            _CarouselSlide(
              "Little Wing",
              "Jimi Hendrix",
              "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
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
  final String imgUrl;

  const _CarouselSlide(this.track, this.artist, this.imgUrl);

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
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Image.network(widget.imgUrl,
                width: MediaQuery.of(context).size.width),
          ),
          Text(widget.track),
          Text(widget.artist),
        ],
      ),
    );
  }
}
