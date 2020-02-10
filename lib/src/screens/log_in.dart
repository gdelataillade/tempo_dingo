import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/widgets/button.dart';
import 'package:tempo_dingo/src/widgets/form_input.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class LogIn extends StatefulWidget {
  LogIn({Key key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50),
          Text("Tempo Dingo", style: Theme.of(context).textTheme.headline),
          Text("v1.0.0", style: Theme.of(context).textTheme.body1),
          const SizedBox(height: 50),
          _LogInForm(),
        ],
      ),
    );
  }
}

class _LogInForm extends StatefulWidget {
  _LogInForm({Key key}) : super(key: key);

  @override
  __LogInFormState createState() => __LogInFormState();
}

class __LogInFormState extends State<_LogInForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = "";
  String _password = "";
  bool _staySignedIn = false;

  void _initControllers() {
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
  }

  void _emailListener() {
    _emailController.text.isEmpty
        ? _email = ""
        : _email = _emailController.text;
  }

  void _passwordListener() {
    _passwordController.text.isEmpty
        ? _password = ""
        : _password = _passwordController.text;
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Already have an account?",
            style: Theme.of(context).textTheme.title),
        FormInput(Icons.email, "Email", _emailController),
        FormInput(Icons.vpn_key, "Password", _passwordController),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.topRight,
          child: Text("Forgot your password?",
              style: Theme.of(context).textTheme.body1),
        ),
        Row(
          children: <Widget>[
            Theme(
              data: Theme.of(context)
                  .copyWith(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _staySignedIn,
                activeColor: Colors.white,
                checkColor: mainTheme,
                onChanged: (bool value) {
                  setState(() {
                    _staySignedIn = value;
                  });
                },
              ),
            ),
            Text("Keep me signed in", style: Theme.of(context).textTheme.body1),
          ],
        ),
        Button("Sign in", _submit),
      ],
    );
  }

  void _submit() {
    print(_email);
    print(_password);
  }
}
