import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/widgets/button.dart';
import 'package:vibrate/vibrate.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      appBar: AppBar(
        elevation: 0,
        title: Text("Tempo Dingo",
            style: TextStyle(fontSize: 30, fontFamily: 'Apple-Semibold')),
      ),
      body: _GenreSelection(),
    );
  }
}

class _GenreSelection extends StatefulWidget {
  @override
  __GenreSelectionState createState() => __GenreSelectionState();
}

class __GenreSelectionState extends State<_GenreSelection> {
  List<Image> _genreImages = [];
  List<bool> _isSelectedList = List<bool>.filled(9, false);
  int _nbSelected = 0;

  void _selectGenre(int index) {
    setState(() {
      if (_isSelectedList[index] == true)
        _nbSelected--;
      else
        _nbSelected++;
      _isSelectedList[index] = !_isSelectedList[index];
    });
  }

  void _navigate() {
    // scoped model
  }

  @override
  void initState() {
    _genreImages = [
      Image.network(// pop
          'https://i.scdn.co/image/51dad9aaabe5643818840207a9a8957c2ad91bf2'),
      Image.network(// rock
          'https://i.scdn.co/image/14ce65949a921e76421a0164c17f9ebe0a8d76e8'),
      Image.network(// electro
          'https://i.scdn.co/image/3a8476a71714e7718a41a1157c40f93abb8cc750'),
      Image.network(// rap
          'https://i.scdn.co/image/56f4762485066b4ef867b96e16775f2b5b4db277'),
      Image.network(// metal
          'https://i.scdn.co/image/5931700f9515dd6587230130beb615e0549e47dc'),
      Image.network(// raggae
          'https://i.scdn.co/image/b5aae2067db80f694a980e596e7f49618c1206c9'),
      Image.network(// classic
          'https://i.scdn.co/image/a2ec08fe69ecec2748fbc764aede8f1b03ae8f88'),
      Image.network(// movies
          'https://i.scdn.co/image/bde64350466df4aa41efb9b8b766deef6c46fd08'),
      Image.network(// variete fr
          'https://i.scdn.co/image/dc5d92726318342e300e4ba1344561680c401734'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select your favorite genres",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _GenderCard(
                _genreImages[0],
                "Pop",
                _isSelectedList[0],
                0,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[1],
                "Rock",
                _isSelectedList[1],
                1,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[2],
                "Electro",
                _isSelectedList[2],
                2,
                _selectGenre,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _GenderCard(
                _genreImages[3],
                "Rap",
                _isSelectedList[3],
                3,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[4],
                "Metal",
                _isSelectedList[4],
                4,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[5],
                "Raggae",
                _isSelectedList[5],
                5,
                _selectGenre,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _GenderCard(
                _genreImages[6],
                "Classic",
                _isSelectedList[6],
                6,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[7],
                "Movies",
                _isSelectedList[7],
                7,
                _selectGenre,
              ),
              _GenderCard(
                _genreImages[8],
                "Variété 🇫🇷",
                _isSelectedList[8],
                8,
                _selectGenre,
              ),
            ],
          ),
          const SizedBox(height: 40),
          _nbSelected < 2
              ? DarkButton("Next", () {})
              : Button("Next", () {}, false),
        ],
      ),
    );
  }
}

class _GenderCard extends StatefulWidget {
  final Image image;
  final String artist;
  final bool isSelected;
  final int index;
  final Function(int) selectGenre;

  const _GenderCard(
    this.image,
    this.artist,
    this.isSelected,
    this.index,
    this.selectGenre,
  );

  @override
  __GenderCardState createState() => __GenderCardState();
}

class __GenderCardState extends State<_GenderCard> {
  String _formatString(String str) {
    String newString = str;

    if (newString.length > 13) return newString.substring(0, 13);
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Vibrate.feedback(FeedbackType.selection);
            widget.selectGenre(widget.index);
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: widget.isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : Border.all(color: mainTheme),
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: widget.image,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          _formatString(widget.artist),
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
