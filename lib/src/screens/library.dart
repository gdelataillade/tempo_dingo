import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/artist.dart';
import 'package:tempo_dingo/src/screens/game.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

class Library extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;

  const Library(this.tracks, this.artists);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
  TabController _tabController;
  UserModel _userModel;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: _tabIndex,
    );
    _tabController.addListener(_onChangedTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onChangedTab() {
    setState(() => _tabIndex = _tabController.index);
    _userModel.libraryTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        _tabController.index = model.libraryTabIndex;
        return Container(
          color: mainTheme,
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  elevation: 1,
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                      Tab(
                        child: Text(model.intl('songs'),
                            style: TextStyle(
                              color: _tabIndex == 0
                                  ? Colors.white
                                  : Color.fromRGBO(153, 162, 189, 1),
                              fontSize: 25,
                              fontFamily: 'Apple-Bold',
                            )),
                      ),
                      Tab(
                        child: Text(model.intl('artists'),
                            style: TextStyle(
                              color: _tabIndex == 1
                                  ? Colors.white
                                  : Color.fromRGBO(153, 162, 189, 1),
                              fontSize: 25,
                              fontFamily: 'Apple-Bold',
                            )),
                      ),
                      Tab(
                        child: Text(model.intl('favorite'),
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
                    _Songs(widget.tracks),
                    _Artists(widget.artists),
                    _Favorites(widget.tracks),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Songs extends StatefulWidget {
  final List<Track> tracks;

  const _Songs(this.tracks);

  @override
  __SongsState createState() => __SongsState();
}

class __SongsState extends State<_Songs> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 25, right: 25),
            itemCount: widget.tracks.length,
            itemBuilder: (BuildContext context, int index) {
              final Track track = widget.tracks[index];

              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Game(model, track))),
                child: TrackCard(
                  track.album.images.first.url,
                  track.name,
                  track.artists.first.name,
                  track.id,
                  track.popularity,
                  track.previewUrl == null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Artists extends StatefulWidget {
  final List<Artist> artists;

  const _Artists(this.artists);

  @override
  __ArtistsState createState() => __ArtistsState();
}

class __ArtistsState extends State<_Artists> {
  int _artistIndex = 0;

  @override
  Widget build(BuildContext context) {
    _artistIndex = 0;

    var artists = widget.artists;
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        return Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: (widget.artists.length / 3).round(),
            itemBuilder: (BuildContext context, int index) {
              Widget row = Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print(index);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArtistScreen(
                                    userModel, widget.artists[index * 3])));
                      },
                      child: ArtistCard(artists[_artistIndex].images.first.url,
                          artists[_artistIndex].name),
                    ),
                    artists.length > _artistIndex + 1
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtistScreen(
                                        userModel,
                                        widget.artists[index * 3 + 1]))),
                            child: ArtistCard(
                                artists[_artistIndex + 1].images.first.url,
                                artists[_artistIndex + 1].name),
                          )
                        : Container(width: 80, height: 80),
                    artists.length > _artistIndex + 2
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtistScreen(
                                        userModel,
                                        widget.artists[index * 3 + 2]))),
                            child: ArtistCard(
                                artists[_artistIndex + 2].images.first.url,
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
      },
    );
  }
}

class _Favorites extends StatefulWidget {
  final List<Track> tracks;

  const _Favorites(this.tracks);

  @override
  __FavoritesState createState() => __FavoritesState();
}

class __FavoritesState extends State<_Favorites> {
  UserModel _userModel;

  int _getFavoriteTracksNumber() {
    int counter = 0;

    for (var i = 0; i < widget.tracks.length; i++) {
      if (_userModel.isFavorite(widget.tracks[i].id)) counter++;
    }
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        return Scrollbar(
          child: _getFavoriteTracksNumber() == 0
              ? _NoFavorite()
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  itemCount: widget.tracks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Track track = widget.tracks[index];

                    return _userModel.isFavorite(track.id)
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Game(model, track))),
                            child: TrackCard(
                              track.album.images.first.url,
                              track.name,
                              track.artists.first.name,
                              track.id,
                              track.popularity,
                              track.previewUrl == null,
                            ),
                          )
                        : Container();
                  },
                ),
        );
      },
    );
  }
}

class _NoFavorite extends StatelessWidget {
  const _NoFavorite({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Center(
          child: Text(
            model.intl('no_favorite'),
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
          ),
        );
      },
    );
  }
}
