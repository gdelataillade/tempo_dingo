import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import 'package:tempo_dingo/src/widgets/track_card.dart';

SpotifyRepository spotifyRepository = SpotifyRepository();

class SearchTab extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;

  const SearchTab(this.tracks, this.artists);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _controller = TextEditingController();
  String _search = "";
  bool _showRecommendations = true;
  List<Track> _recommendations = [];

  void _initController() => _controller.addListener(_searchListener);

  void _searchListener() {
    _controller.text.isEmpty ? _search = "" : _search = _controller.text;
    if (_search.length > 2 && _showRecommendations) {
      setState(() => _showRecommendations = false);
    } else if (_search.length <= 2 && !_showRecommendations) {
      setState(() => _showRecommendations = true);
    }
  }

  void _initReco() async {
    final List<Track> reco = await spotifyRepository.getRecommandedTracks(
        widget.artists, widget.tracks);
    setState(() {
      _recommendations = reco;
    });
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
    _initReco();
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
          _showRecommendations
              ? Recommendations(_recommendations)
              : _SearchResult(),
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

class Recommendations extends StatefulWidget {
  final List<Track> recommendations;

  const Recommendations(this.recommendations);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  @override
  Widget build(BuildContext context) {
    return widget.recommendations.length == 0
        ? Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(child: loadingWhite),
          )
        : Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: widget.recommendations.length,
              itemBuilder: (BuildContext context, int index) {
                final Track track = widget.recommendations[index];

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
}

class _SearchResult extends StatefulWidget {
  const _SearchResult();

  @override
  __SearchResultState createState() => __SearchResultState();
}

class __SearchResultState extends State<_SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
