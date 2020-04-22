import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/home.dart';
import 'package:tempo_dingo/src/screens/library.dart';
import 'package:tempo_dingo/src/screens/profile.dart';
import 'package:tempo_dingo/src/screens/search.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/screens/settings.dart';
import 'package:vibrate/vibrate.dart';

class TabView extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;
  final List<Track> history;

  const TabView(this.tracks, this.artists, this.history);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  UserModel _userModel;
  TabController _tabController;
  VoidCallback _onChangeTab;
  int _currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _currentTabIndex);
    _onChangeTab = () {
      if (_currentTabIndex != _tabController.index) {
        Vibrate.feedback(FeedbackType.selection);
        setState(() => _currentTabIndex = _tabController.index);
        _userModel.tabViewIndex = _tabController.index;
      }
    };
    _tabController.addListener(_onChangeTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      _userModel = model;
      _tabController.index = _userModel.tabViewIndex;
      return Center(
        child: Scaffold(
          backgroundColor: mainTheme,
          appBar: AppBar(
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Settings(_userModel))),
                  icon: Icon(FeatherIcons.settings),
                  color: Colors.white,
                );
              },
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(_userModel))),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 10),
                      child: Row(
                        children: <Widget>[
                          Text("${_userModel.stars}",
                              style: Theme.of(context).textTheme.body1),
                          Icon(Icons.star,
                              color: Color.fromRGBO(248, 207, 95, 1)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(FeatherIcons.user, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _TabBar(_tabController, _currentTabIndex),
          body: _TabBarViewWidgets(
            widget.tracks,
            widget.artists,
            widget.history,
            _tabController,
          ),
        ),
      );
    });
  }
}

class _TabBarViewWidgets extends StatefulWidget {
  final List<Track> tracks;
  final List<Artist> artists;
  final List<Track> history;
  final TabController _dataController;

  const _TabBarViewWidgets(
    this.tracks,
    this.artists,
    this.history,
    this._dataController,
  );

  __TabBarViewWidgetsState createState() => __TabBarViewWidgetsState();
}

class __TabBarViewWidgetsState extends State<_TabBarViewWidgets> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SearchTab(widget.tracks, widget.artists, widget.history),
        Home(widget.tracks, widget.artists),
        Library(widget.tracks, widget.artists),
      ],
      controller: widget._dataController,
    );
  }
}

class _TabBar extends StatefulWidget {
  final TabController dataController;
  final int currentTabIndex;

  const _TabBar(this.dataController, this.currentTabIndex);

  @override
  __TabBarState createState() => __TabBarState();
}

class __TabBarState extends State<_TabBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: mainTheme,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          controller: widget.dataController,
          indicatorColor: Colors.transparent,
          indicatorWeight: 20,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                FeatherIcons.search,
                color: Colors.white,
                size: widget.currentTabIndex == 0 ? 30 : 24,
              ),
              child: Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Apple-Semibold",
                  fontSize: widget.currentTabIndex == 0 ? 16 : 14,
                ),
              ),
            ),
            Tab(
              icon: Icon(
                FeatherIcons.home,
                color: Colors.white,
                size: widget.currentTabIndex == 1 ? 30 : 24,
              ),
              child: Text(
                "Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Apple-Semibold",
                  fontSize: widget.currentTabIndex == 1 ? 16 : 14,
                ),
              ),
            ),
            Tab(
              icon: Icon(
                FeatherIcons.music,
                color: Colors.white,
                size: widget.currentTabIndex == 2 ? 30 : 24,
              ),
              child: Text(
                "Library",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Apple-Semibold",
                  fontSize: widget.currentTabIndex == 2 ? 16 : 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
