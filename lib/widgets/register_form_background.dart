import 'package:flutter/material.dart';

class RegisterFormBackground extends StatelessWidget {
  final Widget child;
  final Function onBackPress;
  const RegisterFormBackground({
    @required this.child,
    @required this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        height: size.height,
        width: double.infinity,
        // Here i can use size.width but use double.infinity because both work as a same
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 5,
                child: Image.asset(
                  "assets/images/topleftregister.png",
                  width: size.width * 0.4,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/bottomrightregister.png",
                  width: size.width * 0.5,
                ),
              ),
              child,
              Positioned(
                top: size.height * 0.017,
                left: size.width * 0.04,
                child: IconButton(
                  iconSize: size.width * 0.08,
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: onBackPress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
