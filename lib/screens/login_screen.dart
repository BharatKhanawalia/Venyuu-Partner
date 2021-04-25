import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/screens/signup_screen.dart';
import 'package:venyuu_partner/screens/dashboard.dart';
import 'package:venyuu_partner/screens/forgot_password_screen.dart';
import 'package:venyuu_partner/screens/verify_screen.dart';

import 'package:venyuu_partner/widgets/auth_widgets/already_have_an_account_acheck.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:venyuu_partner/widgets/auth_widgets/rounded_password_field.dart';
import 'package:venyuu_partner/widgets/auth_widgets/background.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

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
  bool _insteadSignup = false;
  var _isLoading = false;
  bool _isHidden = true;

  String _email = '';
  String _password = '';

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: Text('Error!'),
          content: Text(message),
          actions: <Widget>[
            !_insteadSignup
                ? TextButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                : Row(
                    children: [
                      TextButton(
                        child: Text('Sign Up'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpScreen.routeName);
                        },
                      ),
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  )
          ]),
    );
  }

  void _logIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );
      if (!_auth.currentUser.emailVerified) {
        Navigator.pushReplacementNamed(context, VerifyScreen.routeName);
      } else {
        if (userCredential != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, Dashboard.routeName, (route) => false);
        }
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your email and password';
      if (err.code == 'user-not-found') {
        message =
            'No user found for this email. Would you like to signup first?';
        setState(() {
          _insteadSignup = true;
        });
      } else if (err.code == 'wrong-password') {
        message = 'Wrong Password. Please check the password and try again.';
      } else if (err.code == 'user-disabled') {
        message =
            'This account is temporarily disabled. Please contact the administration or login from a different account.';
      }
      print(err.code);
      _showErrorDialog(message);
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
      _logIn();
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
              "LOGIN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/images/login1.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
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
                    borderColor: kPrimaryColor,
                    backgroundColor: kPrimaryLightColor,
                    hintText: 'Password',
                    obscureText: _isHidden ? true : false,
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      icon: _isHidden
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      color: kPrimaryColor,
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value.isEmpty || value == null) {
                        return 'Please enter a password.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
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
                text: "LOGIN",
                textColor: Colors.white,
                press: () {
                  _trySubmit();
                },
              ),
            if (!_isLoading) SizedBox(height: size.height * 0.03),
            if (!_isLoading)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!_isLoading) SizedBox(height: size.height * 0.02),
            if (!_isLoading)
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.pushReplacementNamed(
                      context, SignUpScreen.routeName);
                },
              ),
          ],
        ),
      ),
    );
  }
}
