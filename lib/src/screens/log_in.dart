import 'package:flutter/material.dart';
import 'package:tempo_dingo/src/widgets/form_input.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Already have an account?",
            style: Theme.of(context).textTheme.title),
        FormInput(Icons.email, "Email"),
        FormInput(Icons.vpn_key, "Password"),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.topRight,
          child: Text("Forgot your password?",
              style: Theme.of(context).textTheme.body1),
        ),
        Row(
          children: <Widget>[
            Checkbox(value: false),
            Text("Keep me signed in", style: Theme.of(context).textTheme.body1),
          ],
        )
      ],
    );
  }
}
