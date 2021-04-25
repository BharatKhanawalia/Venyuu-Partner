import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';

import 'package:venyuu_partner/screens/dashboard.dart';

import 'package:venyuu_partner/widgets/register_form_background.dart';
import 'package:venyuu_partner/widgets/rounded_button.dart';

class FourthRegisterFormScreen extends StatefulWidget {
  static const routeName = '/fourth-register-screen';

  @override
  _FourthRegisterFormScreenState createState() =>
      _FourthRegisterFormScreenState();
}

class _FourthRegisterFormScreenState extends State<FourthRegisterFormScreen> {
  final user = FirebaseAuth.instance.currentUser;

  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  List<File> _image = [];

  final picker = ImagePicker();
  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance.ref().child(
          '${user.email}/${Provider.of<Database>(context, listen: false).docRef.id}/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(i);
          imgRef.add({'url': value, 'createdAt': Timestamp.now()});
          if (i == 1) {
            Provider.of<Database>(context, listen: false)
                .updateDoc(user.uid, {'dpUrl': value});
          }
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('venues')
        .doc(Provider.of<Database>(context, listen: false).docRef.id)
        .collection('imageUrls');
  }

  void _showNoImageError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'No Image Added!',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Please add atleast 1 image to upload.'),
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
          ]),
    );
  }

  Future<bool> _registrationCompleteDialog() async {
    return (await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        title: Text(
          'Venue Registered Successfully',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
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
              Provider.of<Database>(context, listen: false)
                  .updateDoc(user.uid, {
                'createdAt': Timestamp.now(),
              });
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                  Dashboard.routeName, (route) => false);
            },
          ),
        ],
      ),
    ));
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
                Provider.of<Database>(context, listen: false)
                    .deleteDoc(user.uid);
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
      body: Stack(
        children: [
          RegisterFormBackground(
            onBackPress: () {
              Navigator.of(context).pop();
            },
            child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: mediaHeight * 0.03),
                      width: mediaWidth * 0.5,
                      // height: mediaHeight * 0.3,
                      child: Text(
                        'Register Your Venue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: mediaHeight * 0.035,
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  // SizedBox(height: mediaHeight * 0.02),
                  Container(
                    height: mediaHeight * 0.7,
                    // color: kPrimaryLightColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'Upload Venue Images',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: mediaHeight * 0.03,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: mediaHeight * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'First Image will be displayed as your venue\'s display picture.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    fontSize: mediaHeight * 0.02,
                                    // fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // color: kPrimaryLightColor,
                          height: mediaHeight * 0.55,
                          padding: EdgeInsets.all(20),
                          child: GridView.builder(
                            itemCount: _image.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () =>
                                          !uploading ? chooseImage() : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kPrimaryLightColor,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add),
                                            Text(
                                              'Add Image',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: mediaHeight * 0.02),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      _image[index - 1]),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    _image.removeAt(index - 1);
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.close_rounded,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
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
                        TextButton(
                            onPressed: _registrationCompleteDialog,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kPrimaryColor,
                                fontSize: mediaHeight * 0.016,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
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
                                    Icons.upload_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (_image.length == 0) {
                                      _showNoImageError();
                                    } else {
                                      setState(() {
                                        uploading = true;
                                      });
                                      uploadFile().whenComplete(() {
                                        setState(() {
                                          uploading = false;
                                        });
                                        _registrationCompleteDialog();
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Upload',
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
                  ),
                ],
              ),
            ),
          ),
          uploading
              ? Center(
                  child: Container(
                    height: mediaHeight * 0.14,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            // backgroundColor: kPrimaryColor,
                            ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Uploading',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: mediaHeight * 0.02,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
