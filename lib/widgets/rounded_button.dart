import 'package:flutter/material.dart';

import 'package:venyuu_partner/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final double vertical;
  final double horizontal;
  final double elevation;
  final Function press;
  final Color color, textColor, primary;
  const RoundedButton({
    this.fontSize,
    this.height,
    this.elevation,
    this.vertical,
    this.horizontal,
    this.text,
    this.press,
    this.primary = kPrimaryLightColor,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: primary,
          backgroundColor: color,
          elevation: elevation,
          padding:
              EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        onPressed: press,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: fontSize),
        ),
      ),
    );
  }
}
