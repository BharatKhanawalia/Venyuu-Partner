import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/login_screen.dart';
import 'package:venyuu_partner/screens/verify_screen.dart';

import 'package:venyuu_partner/widgets/auth_widgets/already_have_an_account_acheck.dart';
import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:venyuu_partner/widgets/auth_widgets/background.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/auth_widgets/rounded_password_field.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = 'signup-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  var _isLoading = false;
  bool _isNewHidden = true;
  bool _isConfirmHidden = true;

  String _email = '';
  String _password = '';

  bool _insteadLogin = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          !_insteadLogin
              ? TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              : Row(
                  children: [
                    TextButton(
                      child: Text('Log In'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                    ),
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SignUpScreen.routeName);
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );
      Provider.of<Database>(context, listen: false)
          .setField(userCredential, {'email': _email});
      Navigator.pushNamed(context, VerifyScreen.routeName);
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your email and password';
      if (err.code == 'email-already-in-use') {
        message = 'This email address exists. Would you like to login instead?';
        setState(() {
          _insteadLogin = true;
        });
      }
      print(err.code);
      _showErrorDialog(message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err.code);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _signUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/images/signup1.svg",
              height: size.height * 0.35,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  RoundedInputField(
                    backgroundColor: kPrimaryLightColor,
                    borderColor: kPrimaryColor,
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  RoundedPasswordField(
                    backgroundColor: kPrimaryLightColor,
                    borderColor: kPrimaryColor,
                    hintText: 'Create New Password',
                    controller: _passController,
                    obscureText: _isNewHidden ? true : false,
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      icon: _isNewHidden
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      color: kPrimaryColor,
                      onPressed: () {
                        setState(() {
                          _isNewHidden = !_isNewHidden;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value.isEmpty || value == null) {
                        return 'Please enter a password.';
                      } else if (value.length < 8) {
                        return 'Password must have atleast 8 characters.';
                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must have atleast 1 Upper-Case Character.';
                      } else if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must have atleast 1 Numerical Character.';
                      } else if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must have atleast 1 Lower-Case Character.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  RoundedPasswordField(
                    backgroundColor: kPrimaryLightColor,
                    borderColor: kPrimaryColor,
                    hintText: 'Confirm New Password',
                    obscureText: _isConfirmHidden ? true : false,
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      icon: _isConfirmHidden
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      color: kPrimaryColor,
                      onPressed: () {
                        setState(() {
                          _isConfirmHidden = !_isConfirmHidden;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value.isEmpty || value == null) {
                        return 'Please enter a password.';
                      }
                      if (value.compareTo(_passController.text) != 0) {
                        return 'Password does not match.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              RoundedButton(
                vertical: 20,
                horizontal: 20,
                width: size.width * 0.8,
                text: "SIGNUP",
                textColor: Colors.white,
                press: () {
                  _trySubmit();
                },
              ),
            if (!_isLoading) SizedBox(height: size.height * 0.03),
            if (!_isLoading)
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
              ),
          ],
        ),
      ),
    );
  }
}
