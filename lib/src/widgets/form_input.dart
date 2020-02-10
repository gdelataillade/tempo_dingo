import 'package:flutter/material.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class FormInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;

  const FormInput(this.icon, this.placeholder, this.controller);

  @override
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(const Radius.circular(5)),
        ),
        child: TextField(
          autocorrect: false,
          controller: widget.controller,
          cursorColor: mainTheme,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: mainTheme),
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: mainTheme),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class FormInputPassword extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final bool hide;
  final Function() callback;

  const FormInputPassword(
      this.icon, this.placeholder, this.controller, this.hide, this.callback);

  @override
  _FormInputPasswordState createState() => _FormInputPasswordState();
}

class _FormInputPasswordState extends State<FormInputPassword> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(const Radius.circular(5)),
        ),
        child: TextField(
          autocorrect: false,
          obscureText: widget.hide,
          controller: widget.controller,
          cursorColor: mainTheme,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: mainTheme),
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              color: mainTheme,
              iconSize: 20,
              onPressed: widget.callback,
            ),
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: mainTheme),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
