import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
        bottomNavigationBar: _TabBar(_tabController),
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
        Container(color: Colors.blue),
        Container(color: Colors.red),
        Container(color: Colors.yellow),
      ],
      controller: widget._dataController,
    );
  }
}

class _TabBar extends StatefulWidget {
  final TabController _dataController;

  const _TabBar(this._dataController);

  @override
  __TabBarState createState() => __TabBarState();
}

class __TabBarState extends State<_TabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: mainTheme,
      tabs: <Widget>[
        Tab(icon: Icon(FeatherIcons.search, color: Colors.black)),
        Tab(icon: Icon(FeatherIcons.home, color: Colors.black)),
        Tab(icon: Icon(FeatherIcons.music, color: Colors.black)),
      ],
      controller: widget._dataController,
    );
  }
}
