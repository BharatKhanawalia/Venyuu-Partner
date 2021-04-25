import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/screens/login_screen.dart';
import 'package:venyuu_partner/screens/signup_screen.dart';

import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:venyuu_partner/widgets/auth_widgets/background.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgot-password-screen';

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
  final _formKey = GlobalKey<FormState>();
  bool _userFound = true;
  bool _insteadSignup = false;
  var _isLoading = false;
  String _email = '';

  void _showErrorDialog({String heading, String message}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            heading,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(message),
          actions: <Widget>[
            !_insteadSignup
                ? RoundedButton(
                    text: 'Okay',
                    color: kPrimaryColor,
                    vertical: 15,
                    horizontal: 15,
                    textColor: Colors.white,
                    primary: Colors.white,
                    elevation: 5,
                    press: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                : Row(
                    children: [
                      RoundedButton(
                        text: 'Sign Up',
                        color: kLightColor,
                        vertical: 15,
                        horizontal: 15,
                        textColor: kPrimaryColor,
                        primary: kPrimaryColor,
                        elevation: 5,
                        press: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(
                              context, SignUpScreen.routeName);
                        },
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      RoundedButton(
                        text: 'Close',
                        color: kPrimaryColor,
                        vertical: 15,
                        horizontal: 15,
                        textColor: Colors.white,
                        elevation: 5,
                        press: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  )
          ]),
    );
  }

  Future<void> _resetPassword(String email) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      var heading = 'Error!';
      var message = 'An error occured. Please check your email.';
      if (err.code == 'user-not-found') {
        setState(() {
          _isLoading = true;
        });
        setState(() {
          _userFound = false;
        });
        heading = 'No Such Email Registered';
        message =
            'No account found for this email. Would you like to signup instead?';
        setState(() {
          _insteadSignup = true;
        });
      }
      if (!_userFound) _showErrorDialog(heading: heading, message: message);
      setState(() {
        _isLoading = false;
      });
    }
    if (_userFound)
      _showErrorDialog(
          heading: 'Password Reset Email Sent',
          message:
              'An email has been sent to your email address, $_email. Follow the directions in the email to reset your password.');
    setState(() {
      _isLoading = false;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _resetPassword(_email);
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
              "RESET PASSWORD",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Form(
              key: _formKey,
              child: RoundedInputField(
                backgroundColor: kPrimaryLightColor,
                borderColor: kPrimaryColor,
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email Address',
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
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              RoundedButton(
                vertical: 20,
                horizontal: 20,
                width: size.width * 0.8,
                text: "SUBMIT",
                textColor: Colors.white,
                press: () {
                  _trySubmit();
                },
              ),
            if (!_isLoading)
              RoundedButton(
                vertical: 20,
                horizontal: 20,
                width: size.width * 0.8,
                text: "BACK TO LOGIN",
                color: kPrimaryLightColor,
                textColor: Colors.black,
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
