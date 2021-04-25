import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/register_screen.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/show_up.dart';

import 'package:venyuu_partner/widgets/venues_list.dart';
import 'package:venyuu_partner/widgets/app_drawer.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser.uid;
  firebase_storage.Reference ref;
  String dpUrl;

  // Future setDpUrl() async {
  //   ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child("placeholder-image.png");
  //   await ref.getDownloadURL().then((value) {
  //     Provider.of<Database>(context, listen: false)
  //         .updateDoc(user, {'dpUrl': value});
  //   });
  // }

  Future<bool> _exitAppDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'Exit Application',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Are you sure you want to exit the app?'),
          actions: [
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
            RoundedButton(
              text: 'Yes',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
              primary: Colors.white,
              elevation: 5,
              press: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _exitAppDialog,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: mediaHeight * 0.09,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Text(
                  'VenYuu',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: mediaHeight * 0.020,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  'Partner',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: mediaHeight * 0.014,
                    color: Colors.pink,
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {}),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              // icon: SvgPicture.asset("assets/icons/menu.svg"),
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: VenuesList(),
              ),
              ShowUp(
                delay: 1000,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      child: const Text(
                        '+  Add Venue',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          mediaWidth * 0.30,
                          mediaHeight * 0.06,
                        ),
                        primary: Color(0xFFF1E6FF),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(width: 1.8, color: kPrimaryColor),
                        ),
                      ),
                      onPressed: () async {
                        // setDpUrl();
                        await db.addDoc(user, {
                          'area': '',
                          'capacity': '',
                          'pricePerPlate': '',
                          'priceBooking': '',
                          'dj': false,
                          'caterer': false,
                          'bookedSlots': <DateTime>[],
                          'dpUrl':
                              'https://firebasestorage.googleapis.com/v0/b/banquet-app-b16fb.appspot.com/o/placeholder-image.png?alt=media&token=79d63c17-fb22-4fbd-891b-da374f5190b3',
                        });
                        db.updateDoc(user, {'venueId': '${db.docRef.id}'});
                        Navigator.of(context)
                            .pushNamed(RegisterFormScreen.routeName);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
