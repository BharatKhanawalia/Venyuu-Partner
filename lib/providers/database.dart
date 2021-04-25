import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database with ChangeNotifier {
  final uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference docRef;
  void setField(UserCredential _userCredential, Map<String, dynamic> data) {
    users.doc(_userCredential.user.uid).set(data);
    notifyListeners();
  }

  Future<void> addDoc(String user, Map<String, dynamic> data) async {
    docRef = await users.doc(user).collection('venues').add(data);
    notifyListeners();
  }

  void updateDoc(String user, Map<String, dynamic> data) {
    users.doc(user).collection('venues').doc(docRef.id).update(data);
    notifyListeners();
  }

  void deleteDoc(String user) {
    // users.doc(user).collection('venues').doc(docRef.id).delete();
    docRef.delete();
    notifyListeners();
  }
}
