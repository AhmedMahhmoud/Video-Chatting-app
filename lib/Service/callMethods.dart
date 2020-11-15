
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_chat/models/call.dart';

class CallMethods with ChangeNotifier {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialed = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialed = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerID).set(hasDialledMap);
      await callCollection.doc(call.recieverID).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerID).delete();
      await callCollection.doc(call.recieverID).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
