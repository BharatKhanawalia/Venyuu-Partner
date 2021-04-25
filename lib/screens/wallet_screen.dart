import 'package:flutter/material.dart';
import 'package:venyuu_partner/constants.dart';

class WalletScreen extends StatelessWidget {
  static const routeName = '/wallet-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Wallet',
        ),
        brightness: Brightness.dark,
      ),
    );
  }
}
