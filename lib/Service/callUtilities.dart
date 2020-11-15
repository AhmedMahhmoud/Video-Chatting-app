import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_chat/Service/callMethods.dart';
import 'package:video_chat/Views/callScreens.dart';
import 'package:video_chat/models/UserModel.dart';
import 'package:video_chat/models/call.dart';

class CallUtils {
  static final CallMethods callMethods = new CallMethods();
  static dial({UserModel from, String recid, String recname, context}) async {
    Call call = Call(
        callerID: from.userID,
        callerName: from.username,
        channelID: Random().nextInt(1000).toString(),
        recieverID: recid,
        recieverName: recname);
    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialed = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
