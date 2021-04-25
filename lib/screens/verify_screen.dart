import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:venyuu_partner/screens/dashboard.dart';

import 'package:venyuu_partner/widgets/auth_widgets/background.dart';

class VerifyScreen extends StatefulWidget {
  static const routeName = '/verify-screen';

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  Timer _timer;

  @override
  void initState() {
    user = _auth.currentUser;
    user.sendEmailVerification();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Text(
                  'Email Verification Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'An email has been sent to :',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      user.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Please click the link in that email to continue.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {}, child: Text('Resend verification email'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    await _auth.currentUser.reload();
    var user = _auth.currentUser;
    if (user.emailVerified) {
      _timer.cancel();
      Navigator.pushReplacementNamed(context, Dashboard.routeName);
    }
  }
}
