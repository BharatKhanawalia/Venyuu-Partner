import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/dashboard.dart';
import 'package:venyuu_partner/screens/third_register_screen.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';

import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:venyuu_partner/widgets/register_form_background.dart';

class SecondRegisterFormScreen extends StatefulWidget {
  static const routeName = '/second-register-screen';

  @override
  _SecondRegisterFormScreenState createState() =>
      _SecondRegisterFormScreenState();
}

class _SecondRegisterFormScreenState extends State<SecondRegisterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _venueNameFocusNode = FocusNode();
  final _localityFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  final user = FirebaseAuth.instance.currentUser.uid;

  String venueName;
  String locality;
  String phone;

  @override
  void dispose() {
    _venueNameFocusNode.dispose();
    _localityFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      Provider.of<Database>(context, listen: false).updateDoc(user, {
        'venueName': venueName,
        'locality': locality,
        'phone': phone,
      });
      Navigator.of(context).pushNamed(
        ThirdRegisterFormScreen.routeName,
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
                Navigator.of(context).popAndPushNamed(Dashboard.routeName);
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

    return Scaffold(
      body: RegisterFormBackground(
        onBackPress: () {
          Navigator.of(context).pop();
        },
        child: NotificationListener(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: Container(
            height: mediaHeight,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: mediaHeight * 0.03),
                    width: mediaWidth * 0.5,
                    // height: mediaHeight * 0.3,
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
                    // color: kPrimaryLightColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Venue Details',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: mediaHeight * 0.03,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        // SizedBox(
                        //   height: mediaHeight * 0.03,
                        // ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RoundedInputField(
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                textInputAction: TextInputAction.next,
                                focusNode: _venueNameFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_localityFocusNode);
                                },
                                hintText: 'Name of the venue *',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name of the venue is required.';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  venueName = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedInputField(
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                textInputAction: TextInputAction.next,
                                focusNode: _localityFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_phoneFocusNode);
                                },
                                hintText: 'Locality *',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Locality is required.';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  locality = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedInputField(
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                textInputAction: TextInputAction.next,
                                focusNode: _phoneFocusNode,
                                hintText: 'Phone Number (Landline) *',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                validator: (value) {
                                  if (value.isEmpty) {
                                    _phoneFocusNode.requestFocus();
                                    return 'Phone number is required.';
                                  }
                                  if (value.length >= 1 && value.length < 8) {
                                    _phoneFocusNode.requestFocus();
                                    return 'Enter a valid phone number';
                                  }
                                  if (double.parse(value) < 0) {
                                    _phoneFocusNode.requestFocus();
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  phone = value;
                                },
                              ),
                            ],
                          ),
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
                                        FocusScope.of(context).unfocus();
                                        Future.delayed(
                                            const Duration(milliseconds: 200),
                                            () {
                                          _saveForm();
                                        });
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
        ),
      ),
    );
  }
}
