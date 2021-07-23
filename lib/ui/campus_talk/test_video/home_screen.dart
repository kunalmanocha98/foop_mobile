import "package:flutter/material.dart";
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

import 'participants.dart';
import 'universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _opCodeController = TextEditingController();
  TextEditingController _roomIdController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  bool isAudioMuted = false;
  bool isVideoMuted = false;
  String username = "";

  @override
  void initState() {
    super.initState();
  }

  joinMeeting() async {
    try {
      print('Join meeting clicked with ' +
          _userNameController.text +
          " => " +
          _roomIdController.text +
          " => " +
          _opCodeController.text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Participants(
                    opcode: _opCodeController.text,
                    authToken:
                        "",
                    participantId: _userNameController.text,
                    conferenceId: _roomIdController.text,
                    muteAudio: isAudioMuted,
                    muteVideo: isVideoMuted,
                  )));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(AppColors.appColorWhite),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom:200.0),
            child: Column(
              children: [
                InkWell(
                  onTap: joinMeeting,
                  child: Container(

                    height: 64,
                  color: Colors.black38,
                    child: Center(
                      child: Text(
                        "Join Meeting",
                        style: montserratStyle(20, Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  //initialValue: "600600",
                  controller: _opCodeController,
                  style: montserratStyle(20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "OPCode(600600)",
                    labelStyle: ralewayStyle(15),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _roomIdController,
                  style: montserratStyle(20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Room ID",
                    labelStyle: ralewayStyle(15),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _userNameController,
                  style: montserratStyle(20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username(this will be visible in the meeting)",
                    labelStyle: ralewayStyle(15),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CheckboxListTile(
                  value: isAudioMuted,
                  onChanged: (val) {
                    setState(() {
                      isAudioMuted = val!;
                    });
                  },
                  title: Text(
                    "Audio Mute",
                    style: ralewayStyle(18, Colors.black),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CheckboxListTile(
                  value: isVideoMuted,
                  onChanged: (val) {
                    setState(() {
                      isVideoMuted = val!;
                    });
                  },
                  title: Text(
                    "Video Mute",
                    style: ralewayStyle(18, Colors.black),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
