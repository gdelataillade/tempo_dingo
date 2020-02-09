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
