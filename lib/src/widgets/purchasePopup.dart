import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/game.dart';

class PurchasePopup extends StatefulWidget {
  final UserModel userModel;
  final Track track;

  const PurchasePopup(this.userModel, this.track);

  @override
  _PurchasePopupState createState() => _PurchasePopupState();
}

class _PurchasePopupState extends State<PurchasePopup>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  bool _haveEnoughStars;
  int _price;

  int setPrice(int popularity) {
    double price;

    price = (popularity + 1) / 5;
    return price.toInt() + 1;
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
    _price = setPrice(widget.track.popularity);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
        _haveEnoughStars = userModel.stars >= _price;
        return ScaleTransition(
          scale: scaleAnimation,
          child: AlertDialog(
            title: Center(
              child: Text(
                "Purchase \"${widget.track.name}\"",
                style: TextStyle(fontSize: 28, color: mainTheme),
                textAlign: TextAlign.center,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
              width: 200,
              height: 50,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("You have ${userModel.stars}"),
                      Icon(Icons.star, color: Color.fromRGBO(248, 207, 95, 1)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("It will cost you $_price"),
                      Icon(Icons.star, color: Color.fromRGBO(248, 207, 95, 1)),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "No thanks",
                      style: TextStyle(color: mainTheme),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_haveEnoughStars) {
                        userModel.purchaseTrack(widget.track.id,
                            widget.track.artists.first.id, _price);
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Game(userModel, widget.track)));
                      }
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: _haveEnoughStars ? mainTheme : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
