import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();
  String _search = "";
  bool _showRecommendations = true;

  void _initController() => _controller.addListener(_searchListener);

  void _searchListener() {
    _controller.text.isEmpty ? _search = "" : _search = _controller.text;
    if (_search.length > 2 && _showRecommendations) {
      setState(() => _showRecommendations = false);
    } else if (_search.length <= 2 && !_showRecommendations) {
      setState(() => _showRecommendations = true);
    }
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
      child: SingleChildScrollView(
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
            _SearchBody(),
          ],
        ),
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

class _SearchBody extends StatefulWidget {
  _SearchBody({Key key}) : super(key: key);

  @override
  __SearchBodyState createState() => __SearchBodyState();
}

class __SearchBodyState extends State<_SearchBody> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
