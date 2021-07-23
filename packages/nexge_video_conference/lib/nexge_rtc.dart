library nexge_video_conference;

import 'dart:async';
import 'dart:convert';

import 'package:eventify/eventify.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:nexge_video_conference/signaling.dart';

/**
 * Callbacks for Nexge Audio Conference API
 */

typedef void OtherEventCallback(dynamic event);
typedef void SuccessOrErrorEventCallback(int code, String message);
typedef void OnActiveSpeakerChange(String participantId);

class NexgeRTC {
  String _host = 'conf-signalling.nexge.com';
  //final String _host = 'localhost';
  String _port = '3000';
  final String? _authToken;
  final String? _userId;
  final String? _conferenceId;
  bool? _mute;
  bool? _videoMute;
  static String _opcode = "600600";

  Signaling? _signaling;

  static NexgeRTC? _nexgeAudioConference;

  static OtherEventCallback? onPeersUpdate;
  //static SuccessOrErrorEventCallback? onError;
  //static SuccessOrErrorEventCallback onSuccess;
  //static OnActiveSpeakerChange onActiveSpeakerChange;

  static StreamStateCallback? onLocalStream;
  static StreamStateCallback? onAddRemoteStream;
  static StreamStateCallback? onRemoveRemoteStream;

  static EventEmitter eventEmitter = new EventEmitter();

  NexgeRTC(this._authToken, this._userId, this._conferenceId, this._mute,
      this._videoMute);

  Future<bool> startForegroundService() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Mic is active',
      notificationText: 'Mic is active',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    print('Started FlutterBackgroundPlugin');
    return FlutterBackground.enableBackgroundExecution();
  }

  Future<bool> stopForegroundService() async {
    print('Stopped FlutterBackgroundPlugin');

    try {
      if (FlutterBackground.isBackgroundExecutionEnabled)
        await FlutterBackground.disableBackgroundExecution();
    } catch (err) {
      print(err);
    }
    return true;
  }

  Future<String> getHostAndPort(String code) async {
    var url = "https://opcode.nexge.com/api/get?code=${code}";
    print('GET $url');
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      print(data);
      print('getHostAndPort:response => ${data['apiProxyBaseUrl']}.');
      return data['apiProxyBaseUrl'];
    }
    return 'conf-signalling.nexge.com:3000';
  }

  void setHostAndPort(String hostAndPort) async {
    List<String> hp = hostAndPort.split(":");
    this._host = hp[0];
    this._port = hp[1];
  }

  Future<void> _connect() async {
    if (_signaling == null) {
      String hostAndPort = await getHostAndPort(_opcode);
      setHostAndPort(hostAndPort);

      _signaling = Signaling(
          eventEmitter,
          this._host,
          this._port,
          this._authToken,
          this._userId,
          this._conferenceId,
          this._mute,
          this._videoMute);

      _signaling?.onPeersUpdate = ((event) {
        onPeersUpdate?.call(event);
      });

      // _signaling?.onError = (int code, String reason) {
      //   onError?.call(code, reason);
      // };

      /*_signaling.onSuccess = (int code, String reason) {
        onSuccess?.call(code, reason);
      };

      _signaling.onActiveSpeakerChange = (String participantId) {
        onActiveSpeakerChange?.call(participantId);
      };*/

      _signaling?.onLocalStream = (MediaStream stream) {
        onLocalStream?.call(stream);
      };

      _signaling?.onAddRemoteStream = (MediaStream stream) {
        onAddRemoteStream?.call(stream);
      };

      _signaling?.onRemoveRemoteStream = (MediaStream stream) {
        onRemoveRemoteStream?.call(stream);
      };

      await _signaling?.getLocalStream(audio: true, video: true);
      await _signaling?.connect();
      if (WebRTC.platformIsAndroid) await startForegroundService();
    }
  }

  Future<void> _muteMyMic(mute) async {
    await _signaling?.muteMyMic(mute);
  }

  Future<void> _muteMyVideo(mute) async {
    await _signaling?.muteMyVideo(mute);
  }

  Future<void> enableScreen() async {
    await _signaling?.enableScreenSharing();
  }

  Future<void> disableScreen() async {
    await _signaling?.disableScreenSharing();
  }

  Future<void> _closeSignalling() async {
    try {
      if (WebRTC.platformIsAndroid) await stopForegroundService();
      if (_signaling != null) {
        await _signaling?.bye();
        await _signaling?.close();
      }
    } catch (err) {
      print('ERROR: ${err}');
    }
  }

  static getText() {
    return "Video Conference";
  }

  static String getVersion() {
    return '1.1.0';
  }

  static void setOpCode(String opcode) {
    print('OPCode is set ${opcode} => ${opcode.trim().length}');
    if (opcode != null && opcode.trim().length > 0) _opcode = opcode;
  }

  static Future<bool> join(String authToken, String conferenceId,
      String participantId, bool mute, bool videoMute) async {
    try {
      if (_nexgeAudioConference == null) {
        _nexgeAudioConference =
            NexgeRTC(authToken, participantId, conferenceId, mute, videoMute);
        await _nexgeAudioConference?._connect();
      } else {
        await _nexgeAudioConference?._muteMyMic(mute);
      }
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }
/*
  static Future<bool> muteAudio() async {
    try {
      await _nexgeAudioConference?._muteMyMic(true);
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }

  static Future<bool> unMuteAudio() async {
    try {
      await _nexgeAudioConference?._muteMyMic(false);
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }

  static Future<bool> muteVideo() async {
    try {
      await _nexgeAudioConference?._muteMyVideo(true);
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }

  static Future<bool> unMuteVideo() async {
    try {
      await _nexgeAudioConference?._muteMyVideo(false);
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }
  */

  static Future<bool> enableScreenSharing() async {
    try {
      await _nexgeAudioConference?.enableScreen();
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }

  static Future<bool> disableScreenSharing() async {
    try {
      await _nexgeAudioConference?.disableScreen();
      return true;
    } catch (err) {
      print('ERROR: ${err}');
      return false;
    }
  }

  static Listener on(String eventName, Function listener) {
    return eventEmitter.on(eventName, null, (Event ev, context) {
      listener(ev.eventName, ev.eventData);
    });

    //return _nexgeAudioConference?._signaling?.on(eventName, listener);
  }

  /*static void off(Listener listener) {
    eventEmitter.off(listener);
    //return _nexgeAudioConference?._signaling?.off(eventName, listener);
  }*/

  static Future<bool> leave() async {
    try {
      if (_nexgeAudioConference != null) {
        await _nexgeAudioConference?._closeSignalling();
        eventEmitter.clear();
        _nexgeAudioConference = null;
      } else {
        print('Conference already closed');
      }
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
