import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class FormInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final bool authFailed;

  const FormInput(
    this.icon,
    this.placeholder,
    this.controller,
    this.authFailed,
  );

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
          border: Border.all(
            color: widget.authFailed ? Colors.red : Colors.transparent,
            width: 1,
          ),
        ),
        child: TextField(
          autocorrect: false,
          controller: widget.controller,
          cursorColor: mainTheme,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: mainTheme),
            hintText: widget.placeholder,
            hintStyle:
                TextStyle(color: widget.authFailed ? Colors.red : mainTheme),
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
  final bool authFailed;
  final bool hide;
  final Function() callback;

  const FormInputPassword(
    this.icon,
    this.placeholder,
    this.controller,
    this.authFailed,
    this.hide,
    this.callback,
  );

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
          border: Border.all(
            color: widget.authFailed ? Colors.red : Colors.transparent,
            width: 1,
          ),
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
            hintStyle:
                TextStyle(color: widget.authFailed ? Colors.red : mainTheme),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
