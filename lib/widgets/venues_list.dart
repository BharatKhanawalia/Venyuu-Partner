import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shimmer/shimmer.dart';

import 'package:venyuu_partner/widgets/venue_item.dart';

final _firestore = FirebaseFirestore.instance;

class VenuesList extends StatelessWidget {
  final String user = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 500;
    return StreamBuilder(
      stream: _firestore
          .collection('users')
          .doc(user)
          .collection('venues')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                offset += 5;
                time = 500 + offset;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Shimmer.fromColors(
                    period: Duration(milliseconds: time),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        // final documents = streamSnapshot.data.docs;
        return streamSnapshot.data.docs.length >= 1
            ? NotificationListener(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: ListView.builder(
                  cacheExtent: 9999,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    padding: EdgeInsets.all(10),
                    child: VenueItem(
                      documents: streamSnapshot.data.docs,
                      index: index,
                    ),
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.05,
                          child: Image.asset(
                            'assets/images/venue_placeholder.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No venues added yet!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF939393),
                        ),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}
