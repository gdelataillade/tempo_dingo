import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class Profile extends StatefulWidget {
  final UserModel userModel;

  const Profile(this.userModel);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          _userModel = model;
          return Scaffold(
            appBar: AppBar(elevation: 0),
            backgroundColor: mainTheme,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Profile",
                        style: Theme.of(context).textTheme.headline),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${_userModel.stars}",
                            style: Theme.of(context).textTheme.headline),
                        Icon(
                          Icons.star,
                          color: Color.fromRGBO(248, 207, 95, 1),
                          size: 55,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // _Shop(),
                    // const SizedBox(height: 25),
                    _Highscores(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Highscores extends StatefulWidget {
  _Highscores({Key key}) : super(key: key);

  @override
  __HighscoresState createState() => __HighscoresState();
}

class __HighscoresState extends State<_Highscores> {
  String _shortenTrackName(String name) {
    List<String> _res = name.split(" (");
    _res = _res.first.split(" -");
    _res = _res.first.split(" /");
    return _res.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Text(
            "Highscores",
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Apple-Semibold',
            ),
          ),
        ),
        ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return FutureBuilder<List<Track>>(
              future: model.spotifyRepository.getTrackList(model.songs),
              builder: (context, tracks) {
                switch (tracks.connectionState) {
                  case ConnectionState.waiting:
                    return Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 10),
                        child: loadingWhite);
                  default:
                    if (tracks.hasError) return Container();
                    return Container(
                      height: tracks.data.length * 30.0,
                      child: ListView.builder(
                        itemCount: tracks.data.length,
                        itemBuilder: (context, i) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_shortenTrackName(tracks.data[i].name)),
                                Text(model.highscores[i],
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _Shop extends StatefulWidget {
  _Shop({Key key}) : super(key: key);

  @override
  __ShopState createState() => __ShopState();
}

class __ShopState extends State<_Shop> {
  UserModel _userModel;

  void _purshaseStars(int nbStars, double price) {
    print("Purshase $nbStars stars for $price€");
    _userModel.addOrRemoveStars(nbStars);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Shop",
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Apple-Semibold',
          ),
        ),
        const SizedBox(height: 10),
        Text("If you like my app, you can buy me a coffee"),
        const SizedBox(height: 15),
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          _userModel = model;
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ShopItem(20, 0.49, _purshaseStars),
                  _ShopItem(50, 0.99, _purshaseStars),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ShopItem(100, 1.49, _purshaseStars),
                  _ShopItem(500, 4.99, _purshaseStars),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _ShopItem extends StatefulWidget {
  final int nbStars;
  final double price;
  final Function(int, double) purshaseStars;

  const _ShopItem(this.nbStars, this.price, this.purshaseStars);

  @override
  __ShopItemState createState() => __ShopItemState();
}

class __ShopItemState extends State<_ShopItem> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 140,
      height: 80,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      onPressed: () => widget.purshaseStars(widget.nbStars, widget.price),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${widget.nbStars}",
                  style: TextStyle(
                    color: mainTheme,
                    fontSize: 20,
                    fontFamily: 'Apple',
                  )),
              Icon(
                Icons.star,
                color: Color.fromRGBO(248, 207, 95, 1),
                size: 30,
              )
            ],
          ),
          Text("for ${widget.price}€",
              style: TextStyle(
                color: mainTheme,
                fontSize: 18,
                fontFamily: 'Apple',
              )),
        ],
      ),
    );
  }
}
