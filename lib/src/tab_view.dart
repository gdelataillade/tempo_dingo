import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:tempo_dingo/src/screens/home.dart';
import 'package:tempo_dingo/src/screens/library.dart';
import 'package:tempo_dingo/src/screens/search.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class TabView extends StatefulWidget {
  TabView({Key key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  TabController _tabController;
  VoidCallback _onChangeTab;
  static int _currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _onChangeTab =
        () => setState(() => _currentTabIndex = _tabController.index);
    _tabController.addListener(_onChangeTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        bottomNavigationBar: _TabBar(_tabController, _currentTabIndex),
        body: _TabBarViewWidgets(_tabController),
      ),
    );
  }
}

class _TabBarViewWidgets extends StatefulWidget {
  final TabController _dataController;

  const _TabBarViewWidgets(this._dataController);

  __TabBarViewWidgetsState createState() => __TabBarViewWidgetsState();
}

class __TabBarViewWidgetsState extends State<_TabBarViewWidgets> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Search(),
        Home(),
        Library(),
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
      child: TabBar(
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
        controller: widget.dataController,
      ),
    );
  }
}
