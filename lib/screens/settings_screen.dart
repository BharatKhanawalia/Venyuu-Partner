import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venyuu_partner/constants.dart';
import 'package:venyuu_partner/screens/welcome_screen.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/Settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<bool> _logoutWarningDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            RoundedButton(
              text: 'Yes',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
              primary: Colors.white,
              elevation: 5,
              press: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, WelcomeScreen.routeName, (route) => false);
              },
            ),
            RoundedButton(
              text: 'No',
              color: kLightColor,
              vertical: 15,
              horizontal: 15,
              textColor: kPrimaryColor,
              primary: kPrimaryColor,
              elevation: 5,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Account Settings',
        ),
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              _logoutWarningDialog();
            },
          ),
        ],
      ),
    );
  }
}
