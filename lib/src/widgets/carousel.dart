import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tempo_dingo/src/models/user_model.dart';

class Carousel extends StatefulWidget {
  final List<String> tracksId;

  const Carousel(this.tracksId);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with TickerProviderStateMixin {
  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        _userModel = model;

        // return FutureBuilder<>();

        return Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[],
              ),
            ),
          ],
        );
      },
    );
  }
}
