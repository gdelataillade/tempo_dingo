import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
          return model.isConnected
              ? Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _userModel.logout();
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Text("Logout", style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 5),
                            Icon(FeatherIcons.logOut),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: mainTheme,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Profile",
                              style: Theme.of(context).textTheme.headline),
                          const SizedBox(height: 10),
                          Text(_userModel.fullName,
                              style: Theme.of(context).textTheme.title),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("${_userModel.stars}",
                                  style: Theme.of(context).textTheme.headline),
                              Icon(
                                Icons.star,
                                color: Color.fromRGBO(248, 207, 95, 1),
                                size: 50,
                              ),
                            ],
                          ),
                          _Highscores(),
                          _Shop(),
                        ],
                      ),
                    ),
                  ),
                )
              : _GuestProfile();
        },
      ),
    );
  }
}

class _GuestProfile extends StatefulWidget {
  @override
  __GuestProfileState createState() => __GuestProfileState();
}

class __GuestProfileState extends State<_GuestProfile> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text("Guest"),
          ),
          backgroundColor: mainTheme,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${userModel.stars}",
                        style: Theme.of(context).textTheme.headline),
                    Icon(
                      Icons.star,
                      color: Color.fromRGBO(248, 207, 95, 1),
                      size: 50,
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () => userModel.addOrRemoveStars(3),
                  child: Text("+3"),
                ),
                RaisedButton(
                  onPressed: () => userModel.addOrRemoveStars(-10),
                  child: Text("-10"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Highscores extends StatefulWidget {
  _Highscores({Key key}) : super(key: key);

  @override
  __HighscoresState createState() => __HighscoresState();
}

class __HighscoresState extends State<_Highscores> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Highscores"),
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
  void _purshaseStars(int nbStars, double price) {
    print("Purshase $nbStars stars for $price€");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Shop"),
        Text("If you like my app, you can buy me a coffee"),
        const SizedBox(height: 15),
        Column(
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
        ),
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
