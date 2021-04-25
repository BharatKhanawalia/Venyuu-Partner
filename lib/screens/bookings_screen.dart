import 'package:flutter/material.dart';
import 'package:venyuu_partner/constants.dart';

class BookingsScreen extends StatelessWidget {
  static const routeName = '/bookings-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Bookings',
        ),
        brightness: Brightness.dark,
      ),
    );
  }
}
