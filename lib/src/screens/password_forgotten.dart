import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/button.dart';
import 'package:tempo_dingo/src/widgets/form_input.dart';
import 'package:tempo_dingo/src/widgets/header.dart';
import 'package:email_validator/email_validator.dart';

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
  TextEditingController _emailController = TextEditingController();
  String _email = "";
  String _errorMessage = "";
  bool _emailFail = false;
  bool _emailValid = false;

  void _emailListener() {
    _emailController.text.isEmpty
        ? _email = ""
        : _email = _emailController.text;
    if (_emailValid && _email.length < 5) {
      setState(() => _emailValid = false);
    } else if (!_emailValid && _email.length > 5) {
      setState(() => _emailValid = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_emailListener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Forgot you password?",
          style: Theme.of(context).textTheme.title,
        ),
        const SizedBox(height: 20),
        Text(
            "Don't worry, just give me your email and I will send you a new one."),
        FormInput(
          FeatherIcons.mail,
          "Email",
          _emailController,
          _emailFail,
        ),
        const SizedBox(height: 40),
        _emailValid
            ? Button("Send new password", _sendNewPassword, false)
            : DarkButton("Send new password", () {}),
      ],
    );
  }

  Future<void> _sendNewPassword() async {
    print(_email);
    if (EmailValidator.validate(_email)) {
      final Email email = Email(
        body:
            "Hey Gautier, can you send me a new password please?\nMy email: $_email",
        subject: 'Tempo Dingo - Reset password',
        recipients: ["gautier2406@gmail.com"],
        cc: [_email],
        isHTML: false,
      );
      try {
        await FlutterEmailSender.send(email);
      } catch (error) {
        print(error);
      }
    } else {
      setState(() {
        _emailFail = true;
        _errorMessage = "Email not valid";
      });
    }
  }
}
