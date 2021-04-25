import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/second_register_screen.dart';

import 'package:venyuu_partner/widgets/register_form_background.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';

class RegisterFormScreen extends StatefulWidget {
  static const routeName = '/register-screen';

  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final user = FirebaseAuth.instance.currentUser.uid;
  String ownerType = 'Manager';

  Future<void> _saveForm() async {
    try {
      Provider.of<Database>(context, listen: false)
          .updateDoc(user, {'ownerType': ownerType});

      Navigator.of(context).pushNamed(
        SecondRegisterFormScreen.routeName,
      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'An error occured!',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            RoundedButton(
              text: 'Okay',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
              primary: Colors.white,
              elevation: 5,
              press: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _discardDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'Cancel Venue Registration',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Are you sure you want to discard your changes?'),
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
                Provider.of<Database>(context, listen: false).deleteDoc(user);
                Navigator.of(context).pop();
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
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _discardDialog,
      child: Scaffold(
        body: RegisterFormBackground(
          onBackPress: _discardDialog,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: mediaHeight * 0.03),
                width: mediaWidth * 0.5,
                child: Text(
                  'Register Your Venue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: mediaHeight * 0.036,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: mediaHeight * 0.06),
              Container(
                height: mediaHeight * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'POC (Point of Contact) Detail',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Dosis',
                            fontSize: mediaHeight * 0.03,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Select POC Designation',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: mediaHeight * 0.022,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ToggleSwitch(
                          initialLabelIndex: 0,
                          minWidth: mediaWidth * 0.36,
                          fontSize: mediaHeight * 0.014,
                          minHeight: mediaHeight * 0.063,
                          cornerRadius: 15.0,
                          activeBgColor: Colors.pink,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey[300],
                          inactiveFgColor: Colors.black,
                          labels: ['MANAGER', 'OWNER'],
                          icons: [Icons.people_alt_rounded, Icons.person],
                          onToggle: (index) {
                            if (index == 0) {
                              ownerType = 'Manager';
                            } else if (index == 1) {
                              ownerType = 'Owner';
                            }
                          },
                        ),
                        SizedBox(
                          height: mediaHeight * 0.01,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            children: [
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: kPrimaryColor,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _discardDialog();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: mediaHeight * 0.015,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Column(
                            children: [
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: kPrimaryColor,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _saveForm();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: mediaHeight * 0.015,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TextFieldContainer(
                        //   backgroundColor: kPrimaryLightColor,
                        //   borderColor: kPrimaryColor,
                        //   child: DropdownButtonFormField<String>(
                        //     dropdownColor: kPrimaryLightColor.withAlpha(255),
                        //     decoration: InputDecoration(border: InputBorder.none),
                        //     value: null,
                        //     icon: Icon(Icons.arrow_drop_down),
                        //     iconSize: 24,
                        //     elevation: 16,
                        //     hint: Text('Select POC Designation'),
                        //     isExpanded: true,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         ownerType = value;
                        //       });
                        //     },
                        //     validator: (newValue) {
                        //       if (newValue == null) {
                        //         return 'POC Designation is required';
                        //       }
                        //       return null;
                        //     },
                        //     items: <String>['Owner', 'Manager']
                        //         .map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),