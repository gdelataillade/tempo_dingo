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
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
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
                padding: const EdgeInsets.all(35),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Shop"),
        Text("If you like my app, you can buy me a coffee"),
        const SizedBox(height: 15),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _ShopItem(20, 0.49),
                _ShopItem(50, 0.99),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _ShopItem(100, 1.49),
                _ShopItem(500, 4.99),
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

  const _ShopItem(this.nbStars, this.price);

  @override
  __ShopItemState createState() => __ShopItemState();
}

class __ShopItemState extends State<_ShopItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: mainTheme.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${widget.nbStars}", style: TextStyle(color: mainTheme)),
              Icon(
                Icons.star,
                color: Color.fromRGBO(248, 207, 95, 1),
                size: 30,
              )
            ],
          ),
          Text("${widget.price}€", style: TextStyle(color: mainTheme)),
        ],
      ),
    );
  }
}
