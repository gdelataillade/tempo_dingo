import 'package:flutter/material.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(
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
            _SearchInput(),
            _SearchBody(),
          ],
        ),
      ),
    );
  }
}

class _SearchInput extends StatefulWidget {
  _SearchInput({Key key}) : super(key: key);

  @override
  __SearchInputState createState() => __SearchInputState();
}

class __SearchInputState extends State<_SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container();
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
