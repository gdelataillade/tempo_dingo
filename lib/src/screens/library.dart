import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/config/mock_data.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
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
        itemCount: tracks.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => print("play"),
            child: tracks[index],
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
  int _artistIndex = 0;

  @override
  Widget build(BuildContext context) {
    _artistIndex = 0;
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 25, right: 25),
        itemCount: (artists.length / 3).round(),
        itemBuilder: (BuildContext context, int index) {
          Widget row = Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () => print("Artist"),
                  child: artists[_artistIndex],
                ),
                artists.length > _artistIndex + 1
                    ? GestureDetector(
                        onTap: () => print("Artist"),
                        child: artists[_artistIndex + 1],
                      )
                    : Container(width: 80, height: 80),
                artists.length > _artistIndex + 2
                    ? GestureDetector(
                        onTap: () => print("Artist"),
                        child: artists[_artistIndex + 2],
                      )
                    : Container(width: 80, height: 80),
              ],
            ),
          );
          _artistIndex += 3;
          return row;
        },
      ),
    );
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
