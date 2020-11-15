import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/Service/callMethods.dart';
import 'package:video_chat/configs/permessions.dart';
import 'package:video_chat/models/call.dart';

import 'callScreens.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;
  PickUpScreen({@required this.call});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  AudioCache player = AudioCache(prefix: "lib/assets/");
  AudioPlayer audioPlayer = AudioPlayer();
  void playSong() async {
    audioPlayer = await player.loop(
      "call.mp3",
    );
  }

  @override
  void initState() {
    playSong();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                Text(
                  "Incoming call ...",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 120,
                  child: Lottie.asset("lib/assets/images/lottieCall.json"),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(widget.call.callerName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic)),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        audioPlayer?.stop();
                        await Provider.of<CallMethods>(context, listen: false)
                            .endCall(call: widget.call);
                      },
                      child: Icon(
                        Icons.call_end,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        audioPlayer?.stop();
                        await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallScreen(call: widget.call),
                                ))
                            : {};
                      },
                      child: Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 35,
                      ),
                    )
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
