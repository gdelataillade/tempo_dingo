import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final Function() callback;

  const Button(this.text, this.callback);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: widget.callback,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width - 200,
          height: 40,
          child: Center(child: Text(widget.text)),
        ),
      ),
    );
  }
}
