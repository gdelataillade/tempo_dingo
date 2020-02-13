import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tempo_dingo/src/widgets/button.dart';
import 'package:tempo_dingo/src/widgets/form_input.dart';
import 'package:tempo_dingo/src/widgets/header.dart';
import 'package:tempo_dingo/src/config/register_config.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

class Register extends StatelessWidget {
  const Register({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(35),
              child: _RegisterForm(),
            ),
            // _TermsAndConditions(),
          ],
        ),
      ),
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
  bool _fullNameFail = false;
  bool _emailFail = false;
  bool _passwordFail = false;

  void _initControllers() {
    _fullNameController.addListener(_fullNameListener);
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
    _confirmPasswordController.addListener(_confirmPasswordListener);
  }

  void _fullNameListener() {
    _fullNameController.text.isEmpty
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Create your account",
          style: Theme.of(context).textTheme.title,
        ),
        FormInput(
          Icons.people,
          "Full name",
          _fullNameController,
          _fullNameFail,
        ),
        FormInput(
          FeatherIcons.mail,
          "Email",
          _emailController,
          _emailFail,
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
        _showErrorMessage(),
        Button("Register", _submit),
      ],
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length != 0)
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    return Container();
  }

  void _submit() async {
    _resetFails();
    if (_password != _confirmPassword) {
      setState(() {
        _errorMessage = "Your passwords do not match.";
        _passwordFail = true;
      });
    } else if (_fullName.length == 0) {
      setState(() {
        _errorMessage = "Full name incomplete.";
        _fullNameFail = true;
      });
    } else if (_email.length == 0) {
      setState(() {
        _errorMessage = "Email is invalid.";
        _emailFail = true;
      });
    } else if (_password.length == 0) {
      setState(() {
        _errorMessage = "Password is invalid.";
        _passwordFail = true;
      });
    } else {
      final bool alreadyExists = await _checkIfAlreadyExists();

      if (alreadyExists) {
        setState(() {
          _errorMessage = "Email already exists.";
          _emailFail = true;
        });
      } else {
        await Firestore.instance
            .collection('users')
            .document(_email)
            .setData(_buildData())
            .catchError((err) => print(err))
            .whenComplete(() => print("Completed"));
      }
    }
    _errorMessage.length > 0 ?? print(_errorMessage);
  }

  Map<String, dynamic> _buildData() => {
        "creation": DateTime.now(),
        "darkTheme": darkTheme,
        "email": _email,
        "password": _password,
        "fullName": _fullName,
        "language": language,
        "stars": stars,
        "staySignedIn": staySignedIn,
        "vibration": vibration,
        "library": library,
      };

  Future<bool> _checkIfAlreadyExists() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(_email).get();

    return snapshot.data == null ? false : true;
  }

  void _resetFails() {
    _fullNameFail = false;
    _emailFail = false;
    _passwordFail = false;
  }
}

class _TermsAndConditions extends StatefulWidget {
  _TermsAndConditions({Key key}) : super(key: key);

  @override
  __TermsAndConditionsState createState() => __TermsAndConditionsState();
}

class __TermsAndConditionsState extends State<_TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Terms and conditions",
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
