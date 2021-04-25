import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/screens/login_screen.dart';
import 'package:venyuu_partner/screens/signup_screen.dart';

import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/auth_widgets/background.dart';
import 'package:venyuu_partner/widgets/show_up.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ShowUp(
              child: Text(
                "WELCOME TO VENYUU PARTNER",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ShowUp(
              child: SizedBox(height: size.height * 0.05),
            ),
            ShowUp(
              delay: 400,
              child: SvgPicture.asset(
                "assets/images/welcome2.svg",
                height: size.height * 0.45,
              ),
            ),
            ShowUp(delay: 400, child: SizedBox(height: size.height * 0.05)),
            ShowUp(
              delay: 600,
              child: RoundedButton(
                vertical: 20,
                horizontal: 20,
                width: size.width * 0.8,
                text: "LOGIN",
                color: kPrimaryColor,
                textColor: Colors.white,
                press: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
              ),
            ),
            ShowUp(
              delay: 800,
              child: RoundedButton(
                vertical: 20,
                horizontal: 20,
                width: size.width * 0.8,
                text: "SIGN UP",
                color: kPrimaryLightColor,
                textColor: Colors.black,
                press: () {
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
