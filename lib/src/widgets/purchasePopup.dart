import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class PurchasePopup extends StatefulWidget {
  final UserModel userModel;
  final String trackId;
  final String name;
  final String artistId;
  final int price;

  const PurchasePopup(
    this.userModel,
    this.trackId,
    this.name,
    this.artistId,
    this.price,
  );

  @override
  _PurchasePopupState createState() => _PurchasePopupState();
}

class _PurchasePopupState extends State<PurchasePopup>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

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
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: widget.userModel,
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
        return ScaleTransition(
          scale: scaleAnimation,
          child: AlertDialog(
            title: Center(
              child: Text(
                "Purchase \"${widget.name}\"",
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
                      Text("It will cost you ${widget.price}"),
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
                    child: Text("No thanks"),
                  ),
                  FlatButton(
                    onPressed: () {
                      userModel.purchaseTrack(
                          widget.trackId, widget.artistId, widget.price);
                      Navigator.of(context).pop();
                    },
                    child: Text("Yes"),
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
