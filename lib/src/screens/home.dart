import 'package:flutter/material.dart';

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
            _QuickPlay(),
          ],
        ),
      ),
    );
  }
}

Widget artist = ArtistCard(
  "https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8",
  "Jimi Hendrix",
);

List<Widget> artists = [
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
  artist,
];

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
    return Container();
  }
}
