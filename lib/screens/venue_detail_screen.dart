import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:flutter_point_tab_bar/pointTabBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:photo_view/photo_view.dart';

import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/widgets/rounded_button.dart';
import 'package:venyuu_partner/widgets/rounded_input_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:venyuu_partner/widgets/venue_item.dart';

class VenueDetailScreen extends StatefulWidget {
  static const routeName = '/venue-detail-screen';

  @override
  _VenueDetailScreenState createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final String uid = FirebaseAuth.instance.currentUser.uid;
  firebase_storage.Reference ref;
  final _formKey = GlobalKey<FormState>();

  DateTime _focusedDay = DateTime.now();

  Future deleteFiles(String venueId) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${user.email}/$venueId');
    await ref.listAll().then((result) => result.items.forEach((element) {
          element.delete();
        }));
  }

  Future<String> valueDialog(String title, String hinText, Icon prefixIcon,
      Function onSaved, Function onPress,
      [Widget prefixText]) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Row(
            children: [
              prefixIcon,
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: RoundedInputField(
              // initialValue: initialValue,
              prefix: prefixText,
              backgroundColor: kPrimaryColor.withAlpha(30),
              borderColor: kPrimaryColor,
              hintText: hinText,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a value.';
                }
                return null;
              },
              onSaved: onSaved,
            ),
          ),
          actions: [
            RoundedButton(
              text: 'Clear Value',
              color: kLightColor,
              vertical: 15,
              horizontal: 15,
              textColor: kPrimaryColor,
              primary: kPrimaryColor,
              elevation: 5,
              press: onPress,
            ),
            RoundedButton(
              text: 'Submit',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
              elevation: 5,
              press: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> yesNoDialog(
      String title, Icon prefixIcon, Function onYesPress, Function onNoPress) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Row(
            children: [
              prefixIcon,
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RoundedButton(
                  width: double.infinity,
                  text: 'Yes',
                  color: kPrimaryColor,
                  vertical: 15,
                  horizontal: 15,
                  textColor: Colors.white,
                  elevation: 5,
                  press: onYesPress,
                ),
                RoundedButton(
                  width: double.infinity,
                  text: 'No',
                  color: kLightColor,
                  vertical: 15,
                  horizontal: 15,
                  textColor: kPrimaryColor,
                  primary: kPrimaryColor,
                  elevation: 5,
                  press: onNoPress,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<bool> discardDialog() async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(25))),
  //         title: Text(
  //           'Discard Changes',
  //           style: TextStyle(fontWeight: FontWeight.w700),
  //         ),
  //         content: Text(
  //             'All unsaved changes will be lost. Do you wish to continue?'),
  //         actions: [
  //           RoundedButton(
  //             text: 'Yes',
  //             color: kLightColor,
  //             vertical: 15,
  //             horizontal: 15,
  //             textColor: kPrimaryColor,
  //             primary: kPrimaryColor,
  //             elevation: 5,
  //             press: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           RoundedButton(
  //             text: 'No',
  //             color: kPrimaryColor,
  //             vertical: 15,
  //             horizontal: 15,
  //             textColor: Colors.white,
  //             elevation: 5,
  //             press: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   ));
  // }

  // Future<String> changesSavedDialog() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(25))),
  //         title: Text(
  //           'Changes Saved Successfully',
  //           style: TextStyle(fontWeight: FontWeight.w700),
  //         ),
  //         actions: [
  //           RoundedButton(
  //             text: 'OK',
  //             color: kPrimaryColor,
  //             vertical: 15,
  //             horizontal: 15,
  //             textColor: Colors.white,
  //             primary: kPrimaryLightColor,
  //             elevation: 5,
  //             press: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<bool> againDeleteConfirm(String venueId) async {
    return (await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'Confirm Venue Delete',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          // content: Text(
          //   'This is the last confirmation!',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          actions: [
            RoundedButton(
              text: 'Delete Venue',
              color: Colors.red,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
              elevation: 5,
              press: () {
                deleteFiles(venueId);
                _firestore
                    .collection('users')
                    .doc(uid)
                    .collection('venues')
                    .doc(venueId)
                    .collection('imageUrls')
                    .get()
                    .then((value) => value.docs.forEach((element) {
                          element.reference.delete();
                        }));
                _firestore
                    .collection('users')
                    .doc(uid)
                    .collection('venues')
                    .doc(venueId)
                    .delete();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            RoundedButton(
              text: 'Cancel',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
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

  Future<bool> deleteConfirmDialog(String venueId) async {
    return (await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          title: Text(
            'Delete this Venue?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: RichText(
              text: TextSpan(
                  style: TextStyle(fontFamily: 'Nunito', color: Colors.black),
                  children: <TextSpan>[
                TextSpan(text: 'Are you sure you want to delete this venue?'),
                TextSpan(
                    text: '\nWarning: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        'All the data of this venue will be erased forever and cannot be recovered. Your venue won\'t show on the Customer App after deleting. Any ongoing membership will also be deleted.'),
              ])),
          actions: [
            RoundedButton(
              text: 'Yes',
              color: kLightColor,
              vertical: 15,
              horizontal: 15,
              textColor: kPrimaryColor,
              primary: kPrimaryColor,
              elevation: 5,
              press: () {
                Navigator.of(context).pop();
                againDeleteConfirm(venueId);
              },
            ),
            RoundedButton(
              text: 'No',
              color: kPrimaryColor,
              vertical: 15,
              horizontal: 15,
              textColor: Colors.white,
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

  bool _isCatererEdited = false;
  bool _isDjEdited = false;
  bool _isAreaEdited = false;
  bool _isCapacityEdited = false;
  bool _isPriceBookingEdited = false;
  bool _isPricePerPlateEdited = false;

  bool _dateRemoved = false;

  bool _caterer = false;
  bool _dj = false;
  String _area = '';
  String _capacity = '';
  String _pricePerPlate = '';
  String _priceBooking = '';

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  // List _selectedDaysList = [];
  // final List<DateTime> _selectedList = [];

  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   setState(() {
  //     _focusedDay = focusedDay;
  //     // Update values in a Set
  //     if (_selectedDays.contains(selectedDay)) {
  //       _selectedDays.remove(selectedDay);
  //     } else {
  //       _selectedDays.add(selectedDay);
  //     }
  //     _selectedDaysList = _selectedDays.toList();
  //   });
  //    _firestore
  //        .collection('users')
  //        .doc(uid)
  //        .collection('venues')
  //        .doc(venueId)
  //        .update({'bookedSlots': _selectedDaysList});
  // }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
        ModalRoute.of(context).settings.arguments as ScreenArguments;
    final updateValue = _firestore
        .collection('users')
        .doc(uid)
        .collection('venues')
        .doc(args.venueId);
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    var bookedSlotsLength = args.bookedSlots.length;
    for (var i = 0; i < bookedSlotsLength; i++) {
      DateTime myDateTime = args.bookedSlots[i].toDate();
      if (!_selectedDays.contains(myDateTime) && !_dateRemoved) {
        _selectedDays.add(myDateTime);
      }
    }

    var format =
        NumberFormat.currency(locale: 'HI', symbol: '₹ ', decimalDigits: 0);
    final String _formatPriceBooking = _priceBooking != ''
        ? format.format(double.tryParse(_priceBooking))
        : '₹ --';
    final String _formatPricePerPlate = _pricePerPlate != ''
        ? format.format(double.tryParse(_pricePerPlate))
        : '₹ --';
    final String _formatArea = _area != ''
        ? NumberFormat.currency(locale: 'HI', symbol: '', decimalDigits: 0)
            .format(double.tryParse(_area))
        : '-- ';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            height: mediaHeight * 0.38,
            width: double.infinity,
            child: StreamBuilder(
              stream: _firestore
                  .collection('users')
                  .doc(uid)
                  .collection('venues')
                  .doc(args.venueId)
                  .collection('imageUrls')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (ctx, streamSnapshot) {
                if (!streamSnapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (streamSnapshot.connectionState ==
                    ConnectionState.waiting)
                  return Text('Loading ...');
                else {
                  return streamSnapshot.data.docs.length >= 1
                      ? CarouselSlider.builder(
                          itemCount: streamSnapshot.data.docs.length,
                          itemBuilder: (BuildContext ctx, int index, int i) {
                            return FadeInImage.assetNetwork(
                              image: streamSnapshot.data.docs[index]['url'],
                              fit: BoxFit.fill,
                              placeholder: 'assets/images/loading2.gif',
                              // loadingBuilder: (BuildContext context,
                              //     Widget child,
                              //     ImageChunkEvent loadingProgress) {
                              //   if (loadingProgress == null) return child;
                              //   return Center(
                              //     child: CircularProgressIndicator(
                              //         // value: loadingProgress.expectedTotalBytes !=
                              //         //         null
                              //         //     ? loadingProgress
                              //         //             .cumulativeBytesLoaded /
                              //         //         loadingProgress.expectedTotalBytes
                              //         //     : null,
                              //         ),
                              //   );
                              // },
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: double.infinity,
                            enableInfiniteScroll: false,
                            disableCenter: false,
                          ),
                        )
                      : FadeInImage.assetNetwork(
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/banquet-app-b16fb.appspot.com/o/placeholder-image.png?alt=media&token=79d63c17-fb22-4fbd-891b-da374f5190b3',
                          fit: BoxFit.fill,
                          placeholder: 'assets/images/loading2.gif',
                          // loadingBuilder: (BuildContext context, Widget child,
                          //     ImageChunkEvent loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return Center(
                          //     child: CircularProgressIndicator(
                          //         // value: loadingProgress.expectedTotalBytes !=
                          //         //         null
                          //         //     ? loadingProgress
                          //         //             .cumulativeBytesLoaded /
                          //         //         loadingProgress.expectedTotalBytes
                          //         //     : null,
                          //         ),
                          //   );
                          // },
                        );
                }
              },
            ),
          ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: mediaHeight * 0.2,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: mediaHeight * 0.68,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -3), //(x,y)
                        blurRadius: 12,
                      ),
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Container(
                    // color: kPrimaryColor,
                    margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      args.venueName.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: mediaWidth * 0.044,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      args.locality.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: mediaWidth * 0.035,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                  child: Text(
                                'Views',
                                style: TextStyle(
                                    fontSize: mediaWidth * 0.044,
                                    fontWeight: FontWeight.w800),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mediaHeight * 0.03,
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kLightColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  offset: Offset(0, 5), //(x,y)
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            // height: mediaHeight * 0.6,
                            child: DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  TabBar(
                                    labelColor: kPrimaryColor,
                                    unselectedLabelColor: Colors.black,
                                    unselectedLabelStyle: TextStyle(
                                      fontSize: mediaWidth * 0.028,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Nunito',
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: mediaWidth * 0.032,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Nunito',
                                    ),
                                    tabs: [
                                      Tab(
                                          child: Text(
                                        'Details',
                                        textAlign: TextAlign.center,
                                      )),
                                      Tab(
                                          child: Text(
                                        'Bookings',
                                        textAlign: TextAlign.center,
                                      )),
                                      Tab(
                                          child: Text(
                                        'Settings',
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                    indicator: PointTabIndicator(
                                      position:
                                          PointTabIndicatorPosition.bottom,
                                      color: kPrimaryColor,
                                      insets: EdgeInsets.only(bottom: 8),
                                    ),
                                  ),
                                  Divider(),
                                  Flexible(
                                    child: Container(
                                      // color: kPrimaryColor,
                                      margin: EdgeInsets.only(bottom: 22),
                                      child: TabBarView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            Scrollbar(
                                              isAlwaysShown: true,
                                              thickness: 6,
                                              radius: Radius.circular(20),
                                              child: SingleChildScrollView(
                                                padding: EdgeInsets.all(10),
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.food_bank_rounded,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Outside Catering Allowed',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        // color: kPrimaryColor,
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  _isCatererEdited
                                                                      ? _caterer
                                                                          ? 'Yes'
                                                                          : 'No'
                                                                      : args.caterer
                                                                          ? 'Yes'
                                                                          : 'No',
                                                                  maxLines: 2,
                                                                  minFontSize: 5,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(fontSize: mediaWidth * 0.03, fontWeight: FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size:
                                                                      mediaHeight *
                                                                          0.025,
                                                                ),
                                                                onPressed: () {
                                                                  yesNoDialog(
                                                                      'Is Outside Catering Allowed?',
                                                                      Icon(
                                                                        Icons
                                                                            .food_bank_rounded,
                                                                        color:
                                                                            kPrimaryColor,
                                                                      ), () {
                                                                    updateValue
                                                                        .update({
                                                                      'caterer':
                                                                          true,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _caterer =
                                                                          true;
                                                                      _isCatererEdited =
                                                                          true;
                                                                    });

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }, () {
                                                                    updateValue
                                                                        .update({
                                                                      'caterer':
                                                                          false,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _caterer =
                                                                          false;
                                                                      _isCatererEdited =
                                                                          true;
                                                                    });

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.music_note,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Outside DJ Allowed',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  _isDjEdited
                                                                      ? _dj
                                                                          ? 'Yes'
                                                                          : 'No'
                                                                      : args.dj
                                                                          ? 'Yes'
                                                                          : 'No',
                                                                  maxLines: 2,
                                                                  minFontSize: 5,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(fontSize: mediaWidth * 0.03, fontWeight: FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size:
                                                                      mediaHeight *
                                                                          0.025,
                                                                ),
                                                                onPressed: () {
                                                                  yesNoDialog(
                                                                      'Is Outside DJ Allowed?',
                                                                      Icon(
                                                                        Icons
                                                                            .music_note,
                                                                        color:
                                                                            kPrimaryColor,
                                                                      ), () {
                                                                    updateValue
                                                                        .update({
                                                                      'dj':
                                                                          true,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _dj =
                                                                          true;
                                                                      _isDjEdited =
                                                                          true;
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }, () {
                                                                    updateValue
                                                                        .update({
                                                                      'dj':
                                                                          false,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _dj =
                                                                          false;
                                                                      _isDjEdited =
                                                                          true;
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.apartment,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Area (in sq.ft.)',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                      _isAreaEdited
                                                                          ? '$_formatArea sq.ft.'
                                                                          : args.area !=
                                                                                  ''
                                                                              ? '${NumberFormat.currency(locale: 'HI', symbol: '', decimalDigits: 0).format(double.tryParse(args.area))} sq.ft.'
                                                                              : '-- sq.ft.',
                                                                      maxLines:
                                                                          2,
                                                                      minFontSize:
                                                                          5,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style: TextStyle(
                                                                          fontSize: mediaWidth *
                                                                              0.03,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size:
                                                                      mediaHeight *
                                                                          0.025,
                                                                ),
                                                                onPressed: () {
                                                                  valueDialog(
                                                                    // args.area ==
                                                                    //         ''
                                                                    //     ? null
                                                                    //     : args
                                                                    //         .area,
                                                                    'Enter Area in sq.ft.',
                                                                    'Area (sq.ft.)',
                                                                    Icon(
                                                                      Icons
                                                                          .apartment,
                                                                      color:
                                                                          kPrimaryColor,
                                                                    ),
                                                                    (value) {
                                                                      updateValue
                                                                          .update({
                                                                        'area':
                                                                            value,
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        _area =
                                                                            value;
                                                                        _isAreaEdited =
                                                                            true;
                                                                      });
                                                                    },
                                                                    () {
                                                                      updateValue
                                                                          .update({
                                                                        'area':
                                                                            '',
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        _area =
                                                                            '';
                                                                        _isAreaEdited =
                                                                            true;
                                                                      });
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  );
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons
                                                            .reduce_capacity_rounded,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Max. Capacity of People',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  _isCapacityEdited
                                                                      ? _capacity != ''
                                                                          ? _capacity
                                                                          : '--'
                                                                      : args.capacity != ''
                                                                          ? args.capacity
                                                                          : '--',
                                                                  maxLines: 2,
                                                                  minFontSize: 5,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(fontSize: mediaWidth * 0.03, fontWeight: FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size:
                                                                      mediaHeight *
                                                                          0.025,
                                                                ),
                                                                onPressed: () {
                                                                  valueDialog(
                                                                    // args.capacity ==
                                                                    //         ''
                                                                    //     ? null
                                                                    //     : args
                                                                    //         .capacity,
                                                                    'Enter the Maximum Capacity of People',
                                                                    'Capacity',
                                                                    Icon(
                                                                      Icons
                                                                          .reduce_capacity,
                                                                      color:
                                                                          kPrimaryColor,
                                                                    ),
                                                                    (value) {
                                                                      updateValue
                                                                          .update({
                                                                        'capacity':
                                                                            value,
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        _capacity =
                                                                            value;
                                                                        _isCapacityEdited =
                                                                            true;
                                                                      });
                                                                    },
                                                                    () {
                                                                      updateValue
                                                                          .update({
                                                                        'capacity':
                                                                            '',
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        _capacity =
                                                                            '';
                                                                        _isCapacityEdited =
                                                                            true;
                                                                      });
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  );
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons
                                                            .request_page_rounded,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Booking Price',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  _isPriceBookingEdited
                                                                      ? _formatPriceBooking
                                                                      : args.priceBooking != ''
                                                                          ? '${NumberFormat.currency(locale: 'HI', symbol: '₹ ', decimalDigits: 0).format(double.tryParse(args.priceBooking))}'
                                                                          : '₹ --',
                                                                  maxLines: 3,
                                                                  minFontSize: 5,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(fontSize: mediaWidth * 0.03, fontWeight: FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.edit,
                                                                size:
                                                                    mediaHeight *
                                                                        0.025,
                                                              ),
                                                              onPressed: () {
                                                                valueDialog(
                                                                  // args.priceBooking ==
                                                                  //         ''
                                                                  //     ? null
                                                                  //     : args
                                                                  //         .priceBooking,
                                                                  'Enter the Price for Booking of Venue',
                                                                  'Booking Price',
                                                                  Icon(
                                                                    Icons
                                                                        .request_page_rounded,
                                                                    color:
                                                                        kPrimaryColor,
                                                                  ),
                                                                  (value) {
                                                                    updateValue
                                                                        .update({
                                                                      'priceBooking':
                                                                          value,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _priceBooking =
                                                                          value;
                                                                      _isPriceBookingEdited =
                                                                          true;
                                                                    });
                                                                  },
                                                                  () {
                                                                    updateValue
                                                                        .update({
                                                                      'priceBooking':
                                                                          '',
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _priceBooking =
                                                                          '';
                                                                      _isPriceBookingEdited =
                                                                          true;
                                                                    });
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  Text('₹ '),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons
                                                            .attach_money_rounded,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: AutoSizeText(
                                                        'Price Per Plate',
                                                        maxLines: 3,
                                                        minFontSize: 5,
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing: Container(
                                                        width:
                                                            mediaWidth * 0.28,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: AutoSizeText(
                                                                  _isPricePerPlateEdited
                                                                      ? _formatPricePerPlate
                                                                      : args.pricePerPlate != ''
                                                                          ? '${NumberFormat.currency(locale: 'HI', symbol: '₹ ', decimalDigits: 0).format(double.tryParse(args.pricePerPlate))}'
                                                                          : '₹ --',
                                                                  maxLines: 3,
                                                                  minFontSize: 5,
                                                                  textAlign: TextAlign.end,
                                                                  style: TextStyle(fontSize: mediaWidth * 0.03, fontWeight: FontWeight.w600)),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.edit,
                                                                size:
                                                                    mediaHeight *
                                                                        0.025,
                                                              ),
                                                              onPressed: () {
                                                                valueDialog(
                                                                  // args.pricePerPlate ==
                                                                  //         ''
                                                                  //     ? null
                                                                  //     : args
                                                                  //         .pricePerPlate,
                                                                  'Enter the Price for Each Plate',
                                                                  'Price Per Plate',
                                                                  Icon(
                                                                    Icons
                                                                        .attach_money_rounded,
                                                                    color:
                                                                        kPrimaryColor,
                                                                  ),
                                                                  (value) {
                                                                    updateValue
                                                                        .update({
                                                                      'pricePerPlate':
                                                                          value,
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _pricePerPlate =
                                                                          value;
                                                                      _isPricePerPlateEdited =
                                                                          true;
                                                                    });
                                                                  },
                                                                  () {
                                                                    updateValue
                                                                        .update({
                                                                      'pricePerPlate':
                                                                          '',
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _pricePerPlate =
                                                                          '';
                                                                      _isPricePerPlateEdited =
                                                                          true;
                                                                    });
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  Text('₹ '),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Select the Booked Slots',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'Dosis',
                                                    fontSize: mediaWidth * 0.04,
                                                    color: Colors.pink[300],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    // decoration: BoxDecoration(
                                                    //     border: Border.all(
                                                    //         color: Colors.grey[300]),
                                                    //     borderRadius:
                                                    //         BorderRadius.circular(
                                                    //             25)),
                                                    child: Scrollbar(
                                                      isAlwaysShown: true,
                                                      thickness: 6,
                                                      radius:
                                                          Radius.circular(20),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        child: TableCalendar(
                                                          availableGestures:
                                                              AvailableGestures
                                                                  .none,
                                                          headerStyle:
                                                              HeaderStyle(
                                                            leftChevronIcon:
                                                                Icon(
                                                              Icons
                                                                  .chevron_left_rounded,
                                                              color:
                                                                  kPrimaryColor,
                                                              size: 35,
                                                            ),
                                                            rightChevronIcon:
                                                                Icon(
                                                              Icons
                                                                  .chevron_right_rounded,
                                                              color:
                                                                  kPrimaryColor,
                                                              size: 35,
                                                            ),
                                                            titleTextStyle:
                                                                TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                            formatButtonVisible:
                                                                false,
                                                            titleCentered: true,
                                                          ),
                                                          daysOfWeekHeight:
                                                              mediaHeight *
                                                                  0.03,
                                                          daysOfWeekStyle:
                                                              DaysOfWeekStyle(
                                                            weekdayStyle:
                                                                TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                            weekendStyle:
                                                                TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                            dowTextFormatter: (date,
                                                                    locale) =>
                                                                DateFormat.E(
                                                                        locale)
                                                                    .format(
                                                                        date)[0],
                                                          ),
                                                          calendarStyle:
                                                              CalendarStyle(
                                                            selectedDecoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            cellMargin:
                                                                EdgeInsets.all(
                                                                    4),
                                                            defaultTextStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                            ),
                                                            disabledTextStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                            ),
                                                            holidayTextStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                            ),
                                                            outsideTextStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            todayTextStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                            ),
                                                            weekendTextStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  mediaWidth *
                                                                      0.034,
                                                            ),
                                                          ),
                                                          startingDayOfWeek:
                                                              StartingDayOfWeek
                                                                  .monday,
                                                          selectedDayPredicate:
                                                              (day) {
                                                            // Use values from Set to mark multiple days as selected
                                                            return _selectedDays
                                                                .contains(day);
                                                          },
                                                          onDaySelected: (DateTime
                                                                  selectedDay,
                                                              DateTime
                                                                  focusedDay) {
                                                            setState(() {
                                                              _focusedDay =
                                                                  focusedDay;
                                                              // Update values in a Set
                                                              if (_selectedDays
                                                                  .contains(
                                                                      selectedDay)) {
                                                                _selectedDays
                                                                    .remove(
                                                                        selectedDay);
                                                                _dateRemoved =
                                                                    true;
                                                              } else {
                                                                _selectedDays.add(
                                                                    selectedDay
                                                                        .toLocal());
                                                              }
                                                              // _selectedDaysList =
                                                              //     _selectedDays
                                                              //         .toList();
                                                            });
                                                            updateValue.update({
                                                              'bookedSlots':
                                                                  _selectedDays
                                                                      .toList()
                                                            });
                                                          },
                                                          onPageChanged:
                                                              (focusedDay) {
                                                            _focusedDay =
                                                                focusedDay;
                                                          },
                                                          firstDay:
                                                              DateTime.now(),
                                                          lastDay:
                                                              DateTime.now()
                                                                  .add(
                                                            Duration(
                                                              days: 400,
                                                            ),
                                                          ),
                                                          focusedDay:
                                                              _focusedDay,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SingleChildScrollView(
                                              padding: EdgeInsets.all(10),
                                              physics: BouncingScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  // ListTile(
                                                  //   leading: Icon(
                                                  //     Icons.edit,
                                                  //     color: kPrimaryColor,
                                                  //   ),
                                                  //   title: Text(
                                                  //     'Edit Venue',
                                                  //     style: TextStyle(
                                                  //         fontSize: mediaWidth *
                                                  //             0.032,
                                                  //         fontWeight:
                                                  //             FontWeight.w600),
                                                  //   ),
                                                  //   onTap: () {
                                                  //     print('Edit Venue');
                                                  //   },
                                                  // ),
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    title: Text(
                                                      'Delete Venue',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: mediaWidth *
                                                              0.032,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    onTap: () {
                                                      print('Delete Venue');
                                                      deleteConfirmDialog(
                                                          args.venueId);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mediaHeight * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: RoundedButton(
                                vertical: 15,
                                horizontal: 10,
                                fontSize: mediaWidth * 0.028,
                                elevation: 5,
                                textColor: kPrimaryColor,
                                primary: kPrimaryColor,
                                color: kLightColor,
                                text: '◀   Go Back to Dashboard',
                                press: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: RoundedButton(
                                vertical: 15,
                                horizontal: 10,
                                elevation: 5,
                                text: 'Buy Premium Membership',
                                press: () {
                                  print(_selectedDays);
                                },
                                fontSize: mediaWidth * 0.028,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   top: 20,
          //   left: 10,
          //   child: Container(
          //     width: mediaWidth * 0.08,
          //     height: mediaHeight * 0.08,
          //     child: Tooltip(
          //       message: 'Go Back to Dashboard',
          //       child: RawMaterialButton(
          //         fillColor: Colors.white,
          //         shape: CircleBorder(
          //             side: BorderSide(
          //           color: Colors.black,
          //           width: 2,
          //           style: BorderStyle.solid,
          //         )),
          //         elevation: 7,
          //         child: Icon(
          //           Icons.chevron_left_rounded,
          //           color: Colors.black,
          //           size: mediaHeight * 0.03,
          //         ),
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 20,
          //   right: 10,
          //   child: Container(
          //     width: mediaWidth * 0.08,
          //     height: mediaHeight * 0.08,
          //     child: Tooltip(
          //       message: 'Delete Venue',
          //       child: RawMaterialButton(
          //         fillColor: Colors.red,
          //         shape: CircleBorder(),
          //         elevation: 0.0,
          //         child: Icon(
          //           Icons.delete_rounded,
          //           color: Colors.white,
          //           size: mediaHeight * 0.024,
          //         ),
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/*
Image.network(
              args.url,
              fit: BoxFit.fill,
            ),
            */

/* no image url
https://firebasestorage.googleapis.com/v0/b/banquet-app-b16fb.appspot.com/o/placeholder-image.png?alt=media&token=79d63c17-fb22-4fbd-891b-da374f5190b3
*/

/*
ListTile(
                                                      leading: Icon(
                                                        Icons.apartment,
                                                        color: kPrimaryColor,
                                                      ),
                                                      title: Text(
                                                        'Area (in sq.ft.)',
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaWidth *
                                                                    0.032,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      trailing:
                                                          TextFieldContainer(
                                                        width:
                                                            mediaWidth * 0.25,
                                                        backgroundColor:
                                                            kPrimaryColor
                                                                .withAlpha(30),
                                                        borderColor:
                                                            kPrimaryColor,
                                                        child: TextFormField(
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.center,
                                                          decoration: InputDecoration.collapsed(
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      mediaWidth *
                                                                          0.026),
                                                              hintText:
                                                                  'in sq.ft.'),
                                                        ),
                                                      ),
                                                    ),
*/