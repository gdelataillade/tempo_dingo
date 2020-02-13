import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';

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
                          fontSize: 20,
                          fontFamily: 'Apple-Semibold',
                        )),
                  ),
                  Tab(
                    child: Text("Artists",
                        style: TextStyle(
                          color: _tabIndex == 1
                              ? Colors.white
                              : Color.fromRGBO(153, 162, 189, 1),
                          fontSize: 20,
                          fontFamily: 'Apple-Semibold',
                        )),
                  ),
                  Tab(
                    child: Text("Favourite",
                        style: TextStyle(
                          color: _tabIndex == 2
                              ? Colors.white
                              : Color.fromRGBO(153, 162, 189, 1),
                          fontSize: 20,
                          fontFamily: 'Apple-Semibold',
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
                Container(color: Colors.red),
                Container(color: Colors.blue),
                Container(color: Colors.yellow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
