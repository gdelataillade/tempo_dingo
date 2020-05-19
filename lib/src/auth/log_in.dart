// import 'package:flutter/material.dart';
// import 'package:feather_icons_flutter/feather_icons_flutter.dart';
// import 'package:scoped_model/scoped_model.dart';

// import 'package:tempo_dingo/src/models/user_model.dart';
// import 'package:tempo_dingo/src/screens/register.dart';
// import 'package:tempo_dingo/src/screens/password_forgotten.dart';
// import 'package:tempo_dingo/src/widgets/form_input.dart';
// import 'package:tempo_dingo/src/widgets/button.dart';
// import 'package:tempo_dingo/src/config/theme_config.dart';

// class LogIn extends StatefulWidget {
//   LogIn({Key key}) : super(key: key);

//   @override
//   _LogInState createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
//         return Container(
//           padding: const EdgeInsets.all(35),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 50),
//               Text("Tempo Dingo", style: Theme.of(context).textTheme.headline),
//               Text("v1.0.0", style: Theme.of(context).textTheme.body1),
//               const SizedBox(height: 50),
//               _LogInForm(),
//               const SizedBox(height: 15),
//               _Separator(),
//               const SizedBox(height: 15),
//               _Register(),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class _LogInForm extends StatefulWidget {
//   _LogInForm({Key key}) : super(key: key);

//   @override
//   __LogInFormState createState() => __LogInFormState();
// }

// class __LogInFormState extends State<_LogInForm> {
//   TextEditingController _emailController =
//       TextEditingController(text: 'gautier2406@gmail.com');
//   // TextEditingController();
//   TextEditingController _passwordController =
//       // TextEditingController();
//       TextEditingController(text: 'salutsalut');

//   UserModel _userModel;
//   String _email = "";
//   String _password = "";
//   bool _staySignedIn = true;
//   bool _inputsAreValid = false;
//   bool _hidePassword = true;
//   bool _authFailed = false;
//   bool _isLoading = false;

//   void _initControllers() {
//     _emailController.addListener(_emailListener);
//     _passwordController.addListener(_passwordListener);
//   }

//   void _emailListener() {
//     _emailController.text.isEmpty
//         ? _email = ""
//         : _email = _emailController.text;
//     if (_checkValidInputs() && !_inputsAreValid)
//       setState(() => _inputsAreValid = true);
//     if (!_checkValidInputs() && _inputsAreValid)
//       setState(() => _inputsAreValid = false);
//   }

//   void _passwordListener() {
//     _passwordController.text.isEmpty
//         ? _password = ""
//         : _password = _passwordController.text;
//     if (_checkValidInputs() && !_inputsAreValid)
//       setState(() => _inputsAreValid = true);
//     if (!_checkValidInputs() && _inputsAreValid)
//       setState(() => _inputsAreValid = false);
//   }

//   bool _checkValidInputs() {
//     if (_email.length >= 4 && _password.length >= 4) return true;
//     return false;
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initControllers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<UserModel>(
//       builder: (context, child, model) {
//         _userModel = model;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("Login", style: Theme.of(context).textTheme.title),
//             FormInput(
//                 FeatherIcons.mail, "Email", _emailController, _authFailed),
//             FormInputPassword(Icons.vpn_key, "Password", _passwordController,
//                 _authFailed, _hidePassword, _toggleHidePassword),
//             const SizedBox(height: 5),
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => PasswordForgotten())),
//                 child: Text("Forgot your password?",
//                     style: Theme.of(context).textTheme.body2),
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Theme(
//                   data: Theme.of(context)
//                       .copyWith(unselectedWidgetColor: Colors.white),
//                   child: Checkbox(
//                     value: _staySignedIn,
//                     activeColor: Colors.white,
//                     checkColor: mainTheme,
//                     onChanged: (bool value) {
//                       setState(() => _staySignedIn = value);
//                     },
//                   ),
//                 ),
//                 Text("Keep me signed in",
//                     style: Theme.of(context).textTheme.body2),
//               ],
//             ),
//             _authFailed
//                 ? Text(
//                     "Email or password incorrect.",
//                     style: TextStyle(color: Colors.red),
//                   )
//                 : Container(),
//             const SizedBox(height: 8),
//             _inputsAreValid
//                 ? Button("Sign in", _submit, _isLoading)
//                 : DarkButton("Sign in", () {}),
//           ],
//         );
//       },
//     );
//   }

//   void _toggleHidePassword() {
//     setState(() => _hidePassword = !_hidePassword);
//   }

//   void _submit() async {
//     setState(() => _isLoading = true);
//     bool _loggedIn = await _userModel.login(_email, _password, false);
//     setState(() => _isLoading = false);

//     _loggedIn
//         ? setState(() => _authFailed = false)
//         : setState(() => _authFailed = true);
//   }
// }

// class _Separator extends StatelessWidget {
//   const _Separator({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Container(
//             height: 1,
//             width: MediaQuery.of(context).size.width / 2 - 60,
//             color: Colors.white,
//           ),
//           Text("OR"),
//           Container(
//             height: 1,
//             width: MediaQuery.of(context).size.width / 2 - 60,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Register extends StatefulWidget {
//   _Register({Key key}) : super(key: key);

//   @override
//   __RegisterState createState() => __RegisterState();
// }

// class __RegisterState extends State<_Register> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text("New member?", style: Theme.of(context).textTheme.title),
//         const SizedBox(height: 15),
//         ScopedModelDescendant<UserModel>(
//           builder: (context, child, model) {
//             return Button(
//               "Register",
//               () => Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => Register(model))),
//               false,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
