import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

class Library extends StatefulWidget {
  Library({Key key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_onChangedTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onChangedTab() => setState(() => _tabIndex = _tabController.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainTheme,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              elevation: 0,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    child: Text("Songs",
                        style: TextStyle(
                          color: _tabIndex == 0
                              ? Colors.white
                              : Color.fromRGBO(153, 162, 189, 1),
                          fontSize: 25,
                          fontFamily: 'Apple-Bold',
                        )),
                  ),
                  Tab(
                    child: Text("Artists",
                        style: TextStyle(
                          color: _tabIndex == 1
                              ? Colors.white
                              : Color.fromRGBO(153, 162, 189, 1),
                          fontSize: 25,
                          fontFamily: 'Apple-Bold',
                        )),
                  ),
                  Tab(
                    child: Text("Favorite",
                        style: TextStyle(
                          color: _tabIndex == 2
                              ? Colors.white
                              : Color.fromRGBO(153, 162, 189, 1),
                          fontSize: 25,
                          fontFamily: 'Apple-Bold',
                        )),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: mainTheme,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _Songs(),
                _Artists(),
                _Favorites(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget card1 = TrackCard(
  "https://i.scdn.co/image/ab67616d0000b27319dcd95d28b63d10164327f2",
  "Little Wing",
  "Jimi Hendrix",
  () => print("like"),
);

Widget card2 = TrackCard(
  "https://i.scdn.co/image/4dd3a9aa1a8dc5b9a49397caa67aff6ae8e7b642",
  "Someday",
  "The Strokes",
  () => print("like"),
);

List<Widget> _tracks = [
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
  card1,
  card2,
];

class _Songs extends StatefulWidget {
  _Songs({Key key}) : super(key: key);

  @override
  __SongsState createState() => __SongsState();
}

class __SongsState extends State<_Songs> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 25, right: 25),
        itemCount: _tracks.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => print("play"),
            child: _tracks[index],
          );
        },
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
    return Column();
  }
}

class _Favorites extends StatefulWidget {
  _Favorites({Key key}) : super(key: key);

  @override
  __FavoritesState createState() => __FavoritesState();
}

class __FavoritesState extends State<_Favorites> {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
