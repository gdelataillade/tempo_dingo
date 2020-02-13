import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:tempo_dingo/src/screens/home.dart';
import 'package:tempo_dingo/src/screens/library.dart';
import 'package:tempo_dingo/src/screens/search.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

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
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.settings),
                color: Colors.white,
                onPressed: () {},
              );
            },
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text("42", style: Theme.of(context).textTheme.body1),
                Icon(Icons.star, color: Color.fromRGBO(248, 207, 95, 1)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.people),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
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
