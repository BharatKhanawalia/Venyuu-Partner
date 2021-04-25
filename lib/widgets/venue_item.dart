import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:venyuu_partner/screens/venue_detail_screen.dart';

class ScreenArguments {
  final String url;
  final String venueName;
  final int index;
  final String venueId;
  final String locality;
  final bool caterer;
  final bool dj;
  final String area;
  final String capacity;
  final String priceBooking;
  final String pricePerPlate;
  final List bookedSlots;

  ScreenArguments({
    this.url,
    this.venueId,
    this.index,
    this.venueName,
    this.locality,
    this.caterer,
    this.dj,
    this.area,
    this.capacity,
    this.priceBooking,
    this.pricePerPlate,
    this.bookedSlots,
  });
}

class VenueItem extends StatefulWidget {
  const VenueItem({
    @required this.documents,
    @required this.index,
  });

  final documents;
  final index;

  @override
  _VenueItemState createState() => _VenueItemState();
}

class _VenueItemState extends State<VenueItem>
    with SingleTickerProviderStateMixin {
  final uid = FirebaseAuth.instance.currentUser.uid;

  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.03,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    final doc = widget.documents[widget.index];

    return GestureDetector(
      onPanCancel: () => _controller.reverse(),
      onPanUpdate: (DragUpdateDetails dragUpdateDetails) =>
          _controller.reverse(),
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: () {
        Navigator.pushNamed(context, VenueDetailScreen.routeName,
            arguments: ScreenArguments(
              url: doc.get('dpUrl'),
              index: widget.index,
              venueName: doc['venueName'],
              locality: doc['locality'],
              venueId: doc['venueId'],
              caterer: doc['caterer'],
              dj: doc['dj'],
              area: doc['area'],
              capacity: doc['capacity'],
              priceBooking: doc['priceBooking'],
              pricePerPlate: doc['pricePerPlate'],
              bookedSlots: doc['bookedSlots'],
            ));
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.39,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white,
            elevation: _controller.value == 0.0 ? 3 : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: FadeInImage.assetNetwork(
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/loading2.gif',
                      image: doc.get('dpUrl'),
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            width: double.infinity,
                            child: Text(
                              doc['venueName'].toUpperCase(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.016,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            width: double.infinity,
                            child: Text(
                              doc['locality'].toUpperCase(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.014,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          'Views',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.016,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
