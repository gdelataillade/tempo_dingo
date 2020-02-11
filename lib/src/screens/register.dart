import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tempo_dingo/src/widgets/button.dart';
import 'package:tempo_dingo/src/widgets/form_input.dart';

const Color mainTheme = Color.fromRGBO(38, 45, 64, 1);

class Register extends StatelessWidget {
  const Register({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Header(),
              const SizedBox(height: 10),
              _RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({Key key}) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 50),
        Text("Tempo Dingo", style: Theme.of(context).textTheme.headline),
        Text("v1.0.0", style: Theme.of(context).textTheme.body1),
      ],
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key key}) : super(key: key);

  @override
  __RegisterFormState createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _fullName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _errorMessage = "";
  bool _passwordFail = false;

  void _initControllers() {
    _fullNameController.addListener(_fullNameListener);
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
    _confirmPasswordController.addListener(_confirmPasswordListener);
  }

  void _fullNameListener() {
    _emailController.text.isEmpty
        ? _fullName = ""
        : _fullName = _fullNameController.text;
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

  void _confirmPasswordListener() {
    _confirmPasswordController.text.isEmpty
        ? _confirmPassword = ""
        : _confirmPassword = _confirmPasswordController.text;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormInput(
          Icons.people,
          "Full name",
          _fullNameController,
          false,
        ),
        FormInput(
          Icons.email,
          "Email",
          _emailController,
          false,
        ),
        FormInput(
          Icons.vpn_key,
          "Password",
          _passwordController,
          _passwordFail,
        ),
        FormInput(
          Icons.vpn_key,
          "Confirm password",
          _confirmPasswordController,
          _passwordFail,
        ),
        const SizedBox(height: 30),
        Button("Register", _submit),
      ],
    );
  }

  void _submit() {
    if (_password != _confirmPassword) {
      setState(() {
        _errorMessage = "Your passwords do not match.";
        _passwordFail = true;
      });
    }
  }
}
