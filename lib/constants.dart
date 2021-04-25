import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xBBF1E6FF);
const kLightColor = Color(0xFFf5edff);
const kRegisterPrimaryColor = Color(0xFFFC9596);
const kRegisterLightColor = Color(0xBBFBD0D1);
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
