import 'package:flutter/material.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/header.dart';

class PasswordForgotten extends StatelessWidget {
  const PasswordForgotten({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header(),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(35),
              child: _EmailForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  _EmailForm({Key key}) : super(key: key);

  @override
  __EmailFormState createState() => __EmailFormState();
}

class __EmailFormState extends State<_EmailForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Forgot you password?",
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }
}
