import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/Service/callMethods.dart';
import 'package:video_chat/Views/pickUpscreen.dart';
import 'package:video_chat/models/call.dart';

class PickUplayout extends StatelessWidget {
  @override
  final Widget scaffold;
  PickUplayout({this.scaffold});
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Provider.of<CallMethods>(context)
          .callStream(uid: FirebaseAuth.instance.currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.data() != null) {
          Call call = Call.fromMap(snapshot.data.data());
          if (!call.hasDialed) {
            return PickUpScreen(call: call);
          }
          return scaffold;
        }
        return scaffold;
      },
    );
  }
}
