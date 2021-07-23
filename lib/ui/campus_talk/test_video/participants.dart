import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nexge_video_conference/conference_events.dart';
import 'package:nexge_video_conference/nexge_rtc.dart';
import 'package:nexge_video_conference/utils/participant.dart';


class Participants extends StatefulWidget {
  final String opcode;
  final String authToken;
  final String participantId;
  final String conferenceId;
  bool muteAudio;
  bool muteVideo;
  bool screenShare = false;

  Participants(
      {required this.opcode,
      required this.authToken,
      required this.participantId,
      required this.conferenceId,
      required this.muteAudio,
      required this.muteVideo})
      : super();

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  List<dynamic> _peers = [];
  var _selfId;
  Participant? localParticipant;

  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  //RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  Map<String, RTCVideoRenderer> _remoteRenders = Map();

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    //await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    NexgeRTC.leave();
    _localRenderer.dispose();
    //_remoteRenderer.dispose();
    _remoteRenders.forEach((key, value) {
      value.srcObject = null;
    });
    _remoteRenders.clear();
  }

  void _connect() async {
    print('participantId => ' +
        widget.participantId +
        ', roomId => ' +
        widget.conferenceId);

    NexgeRTC.on('error', (eventName, data) {
      print('STATUS------------------------------------------------------: code = ${data['code']} reason = ${data['message']}');
     // Alert.show("ERROR: '${data['code']}' => '${data['message']}'");
    });

    NexgeRTC.on(ConferenceEvents.JOINED_CONFERENCE,
        (String eventName, Participant p) {
      localParticipant = p;
    //  Alert.show("Joined Conference as '${localParticipant?.participantId}'");
      print('STATUS------------------------------------------------------: ${localParticipant?.participantId}');
      setState(() {
        _localRenderer.srcObject = localParticipant?.stream;
        _localRenderer.muted = true;
      });
    });

    NexgeRTC.on(ConferenceEvents.LEFT_CONFERENCE,
        (String eventName, Participant p) {
      Participant localParticipant = p;
    //  Alert.show("Left Conference as '${localParticipant.participantId}'");
    });

    NexgeRTC.on(ConferenceEvents.REMOTE_PARTICIPANT_JOINED,
        (String eventName, Participant? remoteParticipant) async {
    //  Alert.show("Remote participant joined - '${remoteParticipant?.participantId}'");

      RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
      await _remoteRenderer.initialize();
      _remoteRenderer.srcObject = remoteParticipant?.stream;

      String? id = remoteParticipant?.stream?.id;
      if (id != null) _remoteRenders.putIfAbsent(id, () => _remoteRenderer);
      setState(() {
        _remoteRenders = _remoteRenders;
      });

      //register events on remote participant
      remoteParticipant?.on(ConferenceEvents.AUDIO_MUTE_CHANGED,
          (String eventName, Participant rp) {
       // Alert.show('Is ${rp.participantId} audio muted = ${rp.isAudioMuted()}');
      });

      remoteParticipant?.on(ConferenceEvents.VIDEO_MUTE_CHANGED,
          (String eventName, Participant rp) {
      //  Alert.show('Is ${rp.participantId} video muted = ${rp.isVideoMuted()}');
      });
    });

    NexgeRTC.on(ConferenceEvents.REMOTE_PARTICIPANT_LEFT,
        (String eventName, Participant? remoteParticipant) async {
     // Alert.show("Remote participant left - '${remoteParticipant?.participantId}'");

      String? id = remoteParticipant?.stream?.id;
      if (id != null) {
        RTCVideoRenderer? remoteRender = _remoteRenders.remove(id);
        remoteRender?.srcObject = null;
        //await remoteRender.dispose();
      }

      setState(() {
        _remoteRenders = _remoteRenders;
      });
    });

    NexgeRTC.on(ConferenceEvents.DOMINANT_SPEAKER_CHANGED,
        (String eventName, String participantId) {
    //  Alert.show("Dominant Speaker - '${participantId}'");
    });

    NexgeRTC.on(ConferenceEvents.LAST_N_ACTIVE_ENDPOINTS_CHANGED,
        (String eventName, List<String> participantIds) {
    //  Alert.show("Last N - '${participantIds}'");
    });

    //for internal purpose
    NexgeRTC.setOpCode(widget.opcode);

    bool success = await NexgeRTC.join(widget.authToken, widget.conferenceId,
        widget.participantId, widget.muteAudio, widget.muteVideo);

    print('connect success----------------------------------------------------------------------------------------------- = ${success}');
  }

  _muteMic(mute) async {
    setState(() {
      widget.muteAudio = mute;
    });

    //bool success = await NexgeAudioConference.join(widget.authToken, widget.conferenceId, widget.participantId, mute, false);
    bool success =
        //mute ? await NexgeRTC.muteAudio() : await NexgeRTC.unMuteAudio();
        mute
            ? await localParticipant?.muteAudio()
            : await localParticipant?.unMuteAudio();
  }

  _muteVideo(muteVideo) async {
    setState(() {
      widget.muteVideo = muteVideo;
    });

    //bool success = await NexgeAudioConference.join(widget.authToken, widget.conferenceId, widget.participantId, mute, false);
    bool success =
        //muteVideo ? await NexgeRTC.muteVideo() : await NexgeRTC.unMuteVideo();
        muteVideo
            ? await localParticipant?.muteVideo()
            : await localParticipant?.unMuteVideo();
    print('mute success = ${success}');
    print("Toggle Mic............" +
        widget.participantId +
        ", muteVideo=" +
        muteVideo.toString());
  }

  enableScreenSharing() async {
    await NexgeRTC.enableScreenSharing();
    setState(() {
      widget.screenShare = true;
    });
  }

  disableScreenSharing() async {
    await NexgeRTC.disableScreenSharing();
    setState(() {
      widget.screenShare = false;
    });
  }

  _hangUp() async {
    await NexgeRTC.leave();
    print("Hangup.......");
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self ? peer['name'] + '[You]' : peer['name']),
        onTap: null,
        trailing: SizedBox(
            width: 50.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: null,
                    icon: peer['mute']
                        ? const Icon(Icons.mic_off)
                        : const Icon(Icons.mic),
                    tooltip: 'Mute',
                  ),
                ])),
        //subtitle: Text('id: ' + peer['id']),
      ),
      Divider()
    ]);
  }

  List<Widget> buildVideo(BuildContext context, Orientation orientation) {
    List<Widget> views = [];

    _remoteRenders.forEach((id, remoteRender) {
      views.add(_buildAvatar(context, orientation, remoteRender));
    });
    return views;
  }

  Widget buildBody(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      //if (orientation == Orientation.portrait) {
      return Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: buildVideo(context, orientation),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 20.0,
            child: Container(
              width: orientation == Orientation.portrait ? 90.0 : 120.0,
              height: orientation == Orientation.portrait ? 120.0 : 90.0,
              child: RTCVideoView(_localRenderer, mirror: true),
              decoration: BoxDecoration(color: Colors.black54),
            ),
          )
        ],
      );
      /*} else {
        return Row(
          children: <Widget>[
            _buildAvatar(context, orientation),
            _buildAvatar(context, orientation),
            _buildAvatar(context, orientation),
            /*Expanded(
              child: SingleChildScrollView(
                child: _buildFields(context),
              ),
            ),*/
          ],
        );
      }*/
    });
  }

  Widget _buildAvatar(BuildContext context, Orientation orientation,
      RTCVideoRenderer rtcVideoRenderer) {
    return Container(
      height: 300.0,
      width: orientation == Orientation.landscape ? 300.0 : null,
      color: Colors.blue,
      child: rtcVideoRenderer != null
          ? Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: RTCVideoView(rtcVideoRenderer),
              decoration: BoxDecoration(color: Colors.black54),
            )
          : Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.white,
                child: Text('RR'),
              ),
            ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return Container(
      height: 800.0,
      color: Colors.white,
      child: Center(
        child: Container(
          height: 250.0,
          width: 250.0,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants'),
        leading: new Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 250.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'hangup',
                  onPressed: () async {
                    _hangUp();
                    Navigator.pop(context, false);
                    //return false;
                  },
                  tooltip: 'Hangup',
                  child: Icon(Icons.call_end),
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  heroTag: 'mute',
                  child: !widget.muteAudio
                      ? const Icon(Icons.mic_off)
                      : const Icon(Icons.mic),
                  onPressed: () => _muteMic(!widget.muteAudio),
                ),
                FloatingActionButton(
                  heroTag: 'muteVideo',
                  child: !widget.muteVideo
                      ? const Icon(Icons.videocam_off)
                      : const Icon(Icons.videocam),
                  onPressed: () => _muteVideo(!widget.muteVideo),
                ),
                FloatingActionButton(
                  heroTag: 'screenSharing',
                  child: widget.screenShare
                      ? const Icon(Icons.stop_screen_share)
                      : const Icon(Icons.screen_share),
                  onPressed: () => widget.screenShare
                      ? disableScreenSharing()
                      : enableScreenSharing(),
                )
              ])),
      body: WillPopScope(
        child: buildBody(context),
        /*child: OrientationBuilder(builder: (context, orientation) {
          return Container(
            child: Stack(children: <Widget>[
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(_remoteRenderer),
                    decoration: BoxDecoration(color: Colors.black54),
                  )),
              Positioned(
                left: 20.0,
                top: 20.0,
                child: Container(
                  width: orientation == Orientation.portrait ? 90.0 : 120.0,
                  height: orientation == Orientation.portrait ? 120.0 : 90.0,
                  child: RTCVideoView(_localRenderer, mirror: true),
                  decoration: BoxDecoration(color: Colors.black54),
                ),
              ),
            ]),
          );
        }),*/
        /*child: Center(
          child: Column(
            children: [
              new Text('Active speaker : ${activeSpeaker}'),
            ],
          ),
        ),*/
        /*child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: (_peers != null ? _peers.length : 0),
            itemBuilder: (context, i) {
              return _buildRow(context, _peers[i]);
            }),*/
        onWillPop: () async {
          _hangUp();
          Navigator.pop(context, false);
          return false;
        },
      ),
    );
  }
}
