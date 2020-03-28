import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import 'package:tempo_dingo/src/screens/game.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

SpotifyRepository spotifyRepository = SpotifyRepository();

class SearchTab extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;
  final List<Track> history;

  const SearchTab(this.tracks, this.artists, this.history);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _controller = TextEditingController();
  String _search = "";
  bool _showHistory = true;
  List<Track> _history = [];
  List<Track> _trackResults = [];
  List<Artist> _artistResults = [];

  void _initController() => _controller.addListener(_searchListener);

  void _makeSearch() {
    _trackResults.clear();
    spotifyRepository.getTrackSearchResults(_search).then((res) {
      setState(() => _trackResults = res);
    });
    _artistResults.clear();
    spotifyRepository.getArtistsSearchResults(_search).then((res) {
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
    return Container(
      color: mainTheme,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Search",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          _SearchInput(_controller),
          const SizedBox(height: 20),
          _showHistory ? _History(_history) : _SearchResult(_trackResults),
        ],
      ),
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
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(5)),
      ),
      child: TextField(
        autocorrect: false,
        controller: widget.controller,
        cursorColor: mainTheme,
        decoration: InputDecoration(
          prefixIcon:
              Icon(FeatherIcons.search, color: mainTheme.withOpacity(0.8)),
          hintText: "Artist, song or album...",
          hintStyle: TextStyle(color: mainTheme.withOpacity(0.8)),
          border: InputBorder.none,
        ),
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Recent searches",
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(height: 15),
          widget.history.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: Text("No recent searches")),
                )
              : Flexible(
                  child: ListView.builder(
                    shrinkWrap: false,
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: widget.history.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Track track = widget.history[index];

                      return TrackCard(
                        track.album.images.first.url,
                        track.name,
                        track.artists.first.name,
                        track.id,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _SearchResult extends StatefulWidget {
  final List<Track> tracks;

  const _SearchResult(this.tracks);

  @override
  __SearchResultState createState() => __SearchResultState();
}

class __SearchResultState extends State<_SearchResult> {
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
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Game(model, track))),
                      child: TrackCard(
                        track.album.images.first.url,
                        track.name,
                        track.artists.first.name,
                        track.id,
                      ),
                    );
                  },
                );
              },
            ),
          );
  }
}
