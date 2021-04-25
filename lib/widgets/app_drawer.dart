import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/screens/bookings_screen.dart';
import 'package:venyuu_partner/screens/settings_screen.dart';
import 'package:venyuu_partner/screens/wallet_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              AppBar(
                toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                backgroundColor: kPrimaryColor,
                // .withAlpha(200),
                brightness: Brightness.dark,
                title: Text(
                  '${FirebaseAuth.instance.currentUser.email}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              SizedBox(
                height: 10,
              ),
              // ListTile(
              //   leading: Icon(Icons.shop),
              //   title: Text(
              //     'Dashboard',
              //     style: TextStyle(fontSize: 12),
              //   ),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, Dashboard.routeName);
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              ListTile(
                leading: Icon(
                  Icons.book_online_outlined,
                ),
                title: Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(BookingsScreen.routeName);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
                title: Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(WalletScreen.routeName);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Version',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//-------------------------------------------------->
//TEXT HIGHLIGHT
  // static List<Shadow> outlinedText(
  //     {double strokeWidth = 2,
  //     Color strokeColor = Colors.black,
  //     int precision = 5}) {
  //   Set<Shadow> result = HashSet();
  //   for (int x = 1; x < strokeWidth + precision; x++) {
  //     for (int y = 1; y < strokeWidth + precision; y++) {
  //       double offsetX = x.toDouble();
  //       double offsetY = y.toDouble();
  //       result.add(Shadow(
  //           offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
  //           color: strokeColor));
  //       result.add(Shadow(
  //           offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
  //           color: strokeColor));
  //       result.add(Shadow(
  //           offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
  //           color: strokeColor));
  //       result.add(Shadow(
  //           offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
  //           color: strokeColor));
  //     }
  //   }
  //   return result.toList();
  // }