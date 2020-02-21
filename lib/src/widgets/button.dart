import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class Button extends StatefulWidget {
  final String text;
  final Function() callback;
  final bool isLoading;

  const Button(this.text, this.callback, this.isLoading);

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
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 30,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainTheme)),
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Apple',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class DarkButton extends StatefulWidget {
  final String text;
  final Function() callback;

  const DarkButton(this.text, this.callback);

  @override
  _DarkButtonState createState() => _DarkButtonState();
}

class _DarkButtonState extends State<DarkButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: widget.callback,
        color: mainTheme,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white)),
        child: Container(
          width: MediaQuery.of(context).size.width - 200,
          height: 40,
          child: Center(
              child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Apple',
              color: Colors.white,
            ),
          )),
        ),
      ),
    );
  }
}
