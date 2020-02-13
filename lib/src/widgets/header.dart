import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({Key key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 40),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          color: Colors.white,
          iconSize: 40,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child:
              Text("Tempo Dingo", style: Theme.of(context).textTheme.headline),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text("v1.0.0", style: Theme.of(context).textTheme.body1),
        ),
      ],
    );
  }
}
