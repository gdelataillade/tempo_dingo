import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

SpotifyRepository spotifyRepository = SpotifyRepository();

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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<Track>>(
            future: spotifyRepository.getTrackList(model.songs),
            builder:
                (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loadingWhite);
                default:
                  if (snapshot.hasError) return Container();
                  return Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Track track = snapshot.data[index];

                        return TrackCard(
                          track.album.images.first.url,
                          track.name,
                          track.artists.first.name,
                          track.id,
                        );
                      },
                    ),
                  );
              }
            });
      },
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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<Artist>>(
          future: spotifyRepository.getArtistsList(model.artists),
          builder:
              (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: loadingWhite);
              default:
                if (snapshot.hasError) return Container();
                var artists = snapshot.data;
                return Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    itemCount: (snapshot.data.length / 3).round(),
                    itemBuilder: (BuildContext context, int index) {
                      Widget row = Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => print("Artist"),
                              child: ArtistCard(
                                  artists[_artistIndex].images.first.url,
                                  artists[_artistIndex].name),
                            ),
                            artists.length > _artistIndex + 1
                                ? GestureDetector(
                                    onTap: () => print("Artist"),
                                    child: ArtistCard(
                                        artists[_artistIndex + 1]
                                            .images
                                            .first
                                            .url,
                                        artists[_artistIndex + 1].name),
                                  )
                                : Container(width: 80, height: 80),
                            artists.length > _artistIndex + 2
                                ? GestureDetector(
                                    onTap: () => print("Artist"),
                                    child: ArtistCard(
                                        artists[_artistIndex + 2]
                                            .images
                                            .first
                                            .url,
                                        artists[_artistIndex + 2].name),
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
          },
        );
      },
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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<Track>>(
            future: spotifyRepository.getTrackList(model.favorite),
            builder:
                (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loadingWhite);
                default:
                  if (snapshot.hasError) return Container();
                  return Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Track track = snapshot.data[index];

                        return TrackCard(
                          track.album.images.first.url,
                          track.name,
                          track.artists.first.name,
                          track.id,
                        );
                      },
                    ),
                  );
              }
            });
      },
    );
  }
}
