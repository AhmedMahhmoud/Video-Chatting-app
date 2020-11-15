import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/Service/callUtilities.dart';
import 'package:video_chat/Service/firebase.dart';
import 'package:video_chat/Views/pickUpscreen.dart';
import 'package:video_chat/Views/pickup_layout.dart';
import 'package:video_chat/configs/permessions.dart';
import 'package:video_chat/models/UserModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserModel userModel;
  UserModel reciever;
  void update() async {
    await Provider.of<FirebaseServices>(context, listen: false)
        .updateUserStatusOnResumed();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    update();
    setState(() {
      userModel = UserModel(
          userID: FirebaseAuth.instance.currentUser.uid,
          useremail: FirebaseAuth.instance.currentUser.email,
          username: FirebaseAuth.instance.currentUser.displayName);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        Provider.of<FirebaseServices>(context, listen: false)
            .updateUserStatusOnPaused();
        break;
      case AppLifecycleState.resumed:
        Provider.of<FirebaseServices>(context, listen: false)
            .updateUserStatusOnResumed();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myprovider = Provider.of<FirebaseServices>(context, listen: false);
    return PickUplayout(
      scaffold: Scaffold(
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: FloatingActionButton(
              onPressed: () async {
                await Provider.of<FirebaseServices>(context, listen: false)
                    .updateUserStatusOnPaused();
                await FirebaseAuth.instance.signOut();
              },
              tooltip: "Logout",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Text("All Users"),
        ),
        backgroundColor: Colors.black,
        body: StreamBuilder<QuerySnapshot>(
          stream: myprovider.getAllUsers(FirebaseAuth.instance.currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return snapshot.data.docs[index].id !=
                          FirebaseAuth.instance.currentUser.uid
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      snapshot.data.docs[index]
                                          .data()["username"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 19),
                                    ),
                                  ),
                                ),
                                Text(
                                  snapshot.data.docs[index].data()["email"],
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17),
                                ),
                                snapshot.data.docs[index].data()["status"] ==
                                        "online"
                                    ? InkWell(
                                        onTap: () async => await Permissions
                                                .cameraAndMicrophonePermissionsGranted()
                                            ? CallUtils.dial(
                                                context: context,
                                                from: userModel,
                                                recid: snapshot
                                                    .data.docs[index].id,
                                                recname: snapshot
                                                    .data.docs[index]
                                                    .data()["username"])
                                            : {},
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.green,
                                        ),
                                      )
                                    : Text(
                                        "Offline",
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                          ),
                        )
                      : Text("");
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
