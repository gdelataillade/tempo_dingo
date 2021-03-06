import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/artist.dart';
import 'package:tempo_dingo/src/screens/game.dart';
import 'package:tempo_dingo/src/widgets/artist_card.dart';
import 'package:tempo_dingo/src/widgets/purchasePopup.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

class SearchTab extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;
  final List<Track> history;

  const SearchTab(this.tracks, this.artists, this.history);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  UserModel _userModel;
  TextEditingController _controller = TextEditingController();
  String _search = "";
  bool _showHistory = true;
  List<Track> _trackResults = [];
  List<Artist> _artistResults = [];

  void _initController() => _controller.addListener(_searchListener);

  void _makeSearch() {
    _trackResults.clear();
    _userModel.spotifyRepository.getTrackSearchResults(_search).then((res) {
      setState(() => _trackResults = res);
    });
    _artistResults.clear();
    _userModel.spotifyRepository.getArtistsSearchResults(_search).then((res) {
      setState(() => _artistResults = res);
    });
  }

  void _searchListener() {
    _controller.text.isEmpty ? _search = "" : _search = _controller.text;
    if (_search.length > 2 && _showHistory) {
      setState(() => _showHistory = false);
    } else if (_search.length <= 2 && !_showHistory) {
      setState(() => _showHistory = true);
    }
    if (!_showHistory) _makeSearch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;
        return Container(
          color: mainTheme,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _userModel.intl('search'),
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              _SearchInput(_controller),
              const SizedBox(height: 10),
              _showHistory
                  ? _History(widget.history)
                  : _ResultsTab(_trackResults, _artistResults),
            ],
          ),
        );
      },
    );
  }
}

class _SearchInput extends StatefulWidget {
  final TextEditingController controller;

  const _SearchInput(this.controller);

  @override
  __SearchInputState createState() => __SearchInputState();
}

class __SearchInputState extends State<_SearchInput> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(const Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: TextField(
            autocorrect: false,
            controller: widget.controller,
            cursorColor: mainTheme,
            decoration: InputDecoration(
              prefixIcon:
                  Icon(FeatherIcons.search, color: mainTheme.withOpacity(0.8)),
              hintText: model.intl('search_hint'),
              hintStyle: TextStyle(color: mainTheme.withOpacity(0.8)),
              border: InputBorder.none,
            ),
          ),
        );
      },
    );
  }
}

class _ResultsTab extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;

  const _ResultsTab(this.tracks, this.artists);

  @override
  __ResultsTabState createState() => __ResultsTabState();
}

class __ResultsTabState extends State<_ResultsTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
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
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Tab(
                  child: Text("Songs",
                      style: TextStyle(
                        color: _tabIndex == 0
                            ? Colors.white
                            : Color.fromRGBO(153, 162, 189, 1),
                        fontSize: 18,
                        fontFamily: 'Apple-Semibold',
                      )),
                ),
                onTap: () => setState(() => _tabIndex = 0),
              ),
              GestureDetector(
                child: Tab(
                  child: Text("Artists",
                      style: TextStyle(
                        color: _tabIndex == 1
                            ? Colors.white
                            : Color.fromRGBO(153, 162, 189, 1),
                        fontSize: 18,
                        fontFamily: 'Apple-Semibold',
                      )),
                ),
                onTap: () => setState(() => _tabIndex = 1),
              ),
            ],
          ),
          _tabIndex == 0
              ? _TrackSearchResults(widget.tracks)
              : _ArtistSearchResults(widget.artists),
        ],
      ),
    );
  }
}

class _History extends StatefulWidget {
  final List<Track> history;

  const _History(this.history);

  @override
  __HistoryState createState() => __HistoryState();
}

class __HistoryState extends State<_History> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                model.intl('recent_games'),
                style: Theme.of(context).textTheme.title,
              ),
              widget.history.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(child: Text(model.intl('no_recent_games'))),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: false,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: widget.history.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Track track = widget.history[index];

                          return GestureDetector(
                            onTap: () {
                              if (track.previewUrl != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Game(model, track)));
                              }
                            },
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
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackSearchResults extends StatefulWidget {
  final List<Track> tracks;

  const _TrackSearchResults(this.tracks);

  @override
  __TrackSearchResultsState createState() => __TrackSearchResultsState();
}

class __TrackSearchResultsState extends State<_TrackSearchResults> {
  @override
  Widget build(BuildContext context) {
    return widget.tracks.length == 0
        ? Container()
        : Flexible(
            child: ListView.builder(
              shrinkWrap: false,
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: widget.tracks.length,
              itemBuilder: (BuildContext context, int index) {
                final Track track = widget.tracks[index];

                return ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    return GestureDetector(
                      onTap: () {
                        if (track.previewUrl == null) return;
                        if (model.songs.contains(track.id))
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Game(model, track)));
                        else
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                PurchasePopup(model, track),
                          );
                      },
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
                );
              },
            ),
          );
  }
}

class _ArtistSearchResults extends StatefulWidget {
  final List<Artist> artists;

  const _ArtistSearchResults(this.artists);

  @override
  __ArtistSearchResultsState createState() => __ArtistSearchResultsState();
}

class __ArtistSearchResultsState extends State<_ArtistSearchResults> {
  int _artistIndex = 0;

  @override
  Widget build(BuildContext context) {
    _artistIndex = 0;
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Flexible(
          child: ListView.builder(
            itemCount: (widget.artists.length / 3).round(),
            itemBuilder: (BuildContext context, int i) {
              // print("length ${widget.artists.length}");
              // print(_artistIndex);
              Widget row = Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ArtistScreen(model, widget.artists[i * 3]))),
                    child: ArtistCard(
                      widget.artists[_artistIndex].images.length > 0
                          ? widget.artists[_artistIndex].images.first.url
                          : null,
                      widget.artists[_artistIndex].name,
                    ),
                  ),
                  widget.artists.length > _artistIndex + 1
                      ? GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtistScreen(
                                      model, widget.artists[(i * 3) + 1]))),
                          child: ArtistCard(
                            widget.artists[_artistIndex + 1].images.length > 0
                                ? widget
                                    .artists[_artistIndex + 1].images.first.url
                                : null,
                            widget.artists[_artistIndex + 1].name,
                          ),
                        )
                      : Container(),
                  widget.artists.length > _artistIndex + 2
                      ? GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtistScreen(
                                      model, widget.artists[(i * 3) + 2]))),
                          child: ArtistCard(
                            widget.artists[_artistIndex + 2].images.length > 0
                                ? widget
                                    .artists[_artistIndex + 2].images.first.url
                                : null,
                            widget.artists[_artistIndex + 2].name,
                          ),
                        )
                      : Container(),
                ],
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
