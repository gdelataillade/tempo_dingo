import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/log_in.dart';

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
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LogIn()));
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
                        Text("42", style: Theme.of(context).textTheme.headline),
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
    return Container();
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
    return Container();
  }
}
