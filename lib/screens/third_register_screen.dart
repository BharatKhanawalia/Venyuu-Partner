import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/dashboard.dart';
import 'package:venyuu_partner/screens/fourth_register_screen.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';

import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:venyuu_partner/widgets/text_field_container.dart';
import 'package:venyuu_partner/widgets/register_form_background.dart';

class ThirdRegisterFormScreen extends StatefulWidget {
  static const routeName = '/third-register-screen';

  @override
  _ThirdRegisterFormScreenState createState() =>
      _ThirdRegisterFormScreenState();
}

class _ThirdRegisterFormScreenState extends State<ThirdRegisterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressFocusNode = FocusNode();
  final _pincodeFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();

  final user = FirebaseAuth.instance.currentUser.uid;

  String address;
  String pincode;
  String city;
  String state;

  @override
  void dispose() {
    _addressFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _cityFocusNode.dispose();
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
        'address': address,
        'pincode': pincode,
        'city': city,
        'state': state,
      });
      Navigator.of(context).pushNamed(
        FourthRegisterFormScreen.routeName,
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
                            'Venue Address Details',
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
                                focusNode: _addressFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_pincodeFocusNode);
                                },
                                hintText: 'Address Line *',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Address line is required.';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  address = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedInputField(
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                textInputAction: TextInputAction.next,
                                focusNode: _pincodeFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_cityFocusNode);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                hintText: 'Pincode *',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Pincode is required.';
                                  }
                                  if (value.length >= 1 && value.length < 6) {
                                    return 'Invalid Pincode';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  pincode = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedInputField(
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                textInputAction: TextInputAction.next,
                                focusNode: _cityFocusNode,
                                hintText: 'City *',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'City is required.';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  city = value;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFieldContainer(
                                width: mediaWidth * 0.8,
                                backgroundColor: kPrimaryLightColor,
                                borderColor: kPrimaryColor,
                                child: DropdownButtonFormField<String>(
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  value: null,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  hint: Text('Select State *'),
                                  isExpanded: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      state = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'State is required';
                                    }
                                    return null;
                                  },
                                  items: <String>[
                                    'Andaman and Nicobar Islands',
                                    'Andhra Pradesh',
                                    'Arunachal Pradesh',
                                    'Assam',
                                    'Bihar',
                                    'Chandigarh',
                                    'Chhattisgarh',
                                    'Dadra and Nagar Haveli and Daman and Diu',
                                    'Delhi',
                                    'Goa',
                                    'Gujarat',
                                    'Haryana',
                                    'Himachal Pradesh',
                                    'Jammu and Kashmir',
                                    'Jharkhand',
                                    'Karnataka',
                                    'Kerala',
                                    'Ladakh',
                                    'Lakshadweep',
                                    'Madhya Pradesh',
                                    'Maharashtra',
                                    'Manipur',
                                    'Meghalaya',
                                    'Mizoram',
                                    'Nagaland',
                                    'Odisha',
                                    'Puducherry',
                                    'Punjab',
                                    'Rajasthan',
                                    'Sikkim',
                                    'Tamil Nadu',
                                    'Telangana',
                                    'Tripura',
                                    'Uttar Pradesh',
                                    'Uttarakhand',
                                    'West Bengal'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
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
