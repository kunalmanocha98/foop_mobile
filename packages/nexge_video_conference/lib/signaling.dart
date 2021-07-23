import 'dart:async';
import 'dart:convert';

import 'package:eventify/eventify.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nexge_video_conference/conference_events.dart';
import 'package:nexge_video_conference/statistics.dart';
import 'package:nexge_video_conference/utils/listenable.dart';
import 'package:nexge_video_conference/utils/participant.dart';
import 'package:nexge_video_conference/utils/sdp.dart';
import 'package:nexge_video_conference/utils/sdp_util.dart';

import 'utils/device_info.dart'
    if (dart.library.js) 'utils/device_info_web.dart';
import 'utils/websocket.dart' if (dart.library.js) 'utils/websocket_web.dart';

enum SignalingState {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

/*
 * callbacks for Signaling API.
 */
typedef void SignalingStateCallback(SignalingState state);
typedef void CallStateCallback(CallState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void SuccessOrErrorEventCallback(int code, String message);
typedef void OnActiveSpeakerChange(String participantId);

class Signaling extends Listenable {
  String? host;
  String? port;
  String? authToken;
  String? userId;
  String? conferenceId;
  bool mute = false;
  bool videoMute = false;
  EventEmitter? eventEmitter;

  Signaling(eventEmitter, host, port, authToken, userId, conferenceId, mute,
      videoMute)
      : super.named(eventEmitter) {
    this.eventEmitter = eventEmitter;
    this.host = host;
    this.port = port;
    this.authToken = authToken;
    this.userId = userId;
    this.conferenceId = conferenceId;
    this.mute = mute;
    this.videoMute = videoMute;
  }

  JsonEncoder _encoder = JsonEncoder();
  JsonDecoder _decoder = JsonDecoder();
  //String _selfId = randomNumeric(6);
  SimpleWebSocket? socket;
  SimpleWebSocket? statusSocket;

  Map<String, Participant> participants = new Map();
  Map<String, String> streamIdToParticipant = new Map();
  List<RTCRtpSender> senders = [];
  //push data
  Map<String, dynamic> mc = new Map();
  bool changeMaxAvgBitrate = false;

  bool socketOpen = false;

  Participant? localParticipant;
  MediaStream? _localStream;
  //MediaStream? _remoteStream;
  MediaStream? displayStream;

  Statistics? statistics;
  //RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  //RTCVideoRenderer _remoteRender = RTCVideoRenderer();

  RTCPeerConnection? pc;

  bool iceGatheringStateComplete = false;

  SignalingStateCallback? onSignalingStateChange;
  CallStateCallback? onCallStateChange;
  StreamStateCallback? onLocalStream;
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onRemoveRemoteStream;
  OtherEventCallback? onPeersUpdate;

  //SuccessOrErrorEventCallback? onError;
  SuccessOrErrorEventCallback? onSuccess;
  OnActiveSpeakerChange? onActiveSpeakerChange;

  //String get sdpSemantics => 'unified-plan';
  String get sdpSemantics => 'plan-b';

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  close() async {
    await _cleanSessions();
    socket?.close();
    statusSocket?.close();

    this.emit(ConferenceEvents.LEFT_CONFERENCE, this.localParticipant);
  }

  Future<void> muteMyMic(mute) async {
    this.mute = mute;
    if (_localStream != null) {
      _localStream?.getAudioTracks()[0].enabled = !mute;
    }
    // await _send('mute', {
    //   'from': this.userId,
    //   'to': this.userId,
    //   'user_id': userId,
    //   'conference_id': conferenceId,
    //   'mute': mute,
    // });
    if (mute)
      onSuccess?.call(2002, "Muted successfully");
    else
      onSuccess?.call(2003, "UnMuted successfully");
  }

  Future<void> muteMyVideo(mute) async {
    this.videoMute = mute;
    if (_localStream != null) {
      _localStream?.getVideoTracks()[0].enabled = !mute;
    }
    // await _send('mute', {
    //   'from': this.userId,
    //   'to': this.userId,
    //   'user_id': userId,
    //   'conference_id': conferenceId,
    //   'mute': mute,
    // });
    if (mute)
      onSuccess?.call(2005, "Video Muted successfully");
    else
      onSuccess?.call(2006, "Video UnMuted successfully");
  }

  Future<MediaStream?> enableScreenSharing() async {
    try {
      this.displayStream = await navigator.mediaDevices.getDisplayMedia({
        'audio': true,
        'video': true,
      });
      RTCRtpSender rtpSender =
          this.senders.firstWhere((sender) => sender.track?.kind == "video");
      MediaStreamTrack? mediaStreamTrack =
          this.displayStream?.getTracks()[0] as MediaStreamTrack?;
      if (mediaStreamTrack != null) rtpSender.replaceTrack(mediaStreamTrack);
      this.localParticipant?.setStream(this.displayStream!);
    } catch (err, s) {
      print('ERROR: ${err}');
      print('ERROR: ${s}');
    }
    return this.displayStream;
  }

  Future<MediaStream?> disableScreenSharing() async {
    RTCRtpSender rtpSender =
        this.senders.firstWhere((sender) => sender.track?.kind == "video");

    MediaStreamTrack? mediaStreamTrack = this
        ._localStream
        ?.getTracks()
        .firstWhere((track) => track.kind == "video");

    if (mediaStreamTrack != null) rtpSender.replaceTrack(mediaStreamTrack);

    this.localParticipant?.setStream(this._localStream!);
    this.displayStream?.getTracks().forEach((track) => track.stop());

    return this._localStream;
  }

  //if you want to mute someones mic. But it's application's job to contact that peer.
  //This is for test purposes
  void muteMic(peerId, mute) {
    send('mute', {
      'from': this.userId,
      'to': peerId,
      'user_id': userId,
      'conference_id': conferenceId,
      'mute': mute,
    });
  }

  Future<void> bye() async {
    await send('bye', {
      //'session_id': sessionId,
      'from': this.userId,
      'user_id': userId,
      'conference_id': conferenceId,
    });
    //if (sessionId != null) _closeSession(_sessions[sessionId]);
  }

  void onStatsMessage(message) async {
    String action = message['colibriClass'];
    /*if (action == 'DominantSpeakerEndpointChangeEvent') {
      String dominantSpeakerEndpoint = message['dominantSpeakerEndpoint'];
      String participantId = dominantSpeakerEndpoint.split('@')[0];
      onActiveSpeakerChange?.call(participantId);
    }*/
    switch (action) {
      case "DominantSpeakerEndpointChangeEvent":
        String dominantSpeakerEndpoint = message["dominantSpeakerEndpoint"];
        String participantId = dominantSpeakerEndpoint.split("@")[0];
        this.emit(ConferenceEvents.DOMINANT_SPEAKER_CHANGED, participantId);
        break;
      case "LastNEndpointsChangeEvent":
        List<dynamic> lastNEndpoints = message["lastNEndpoints"];

        List participants =
            lastNEndpoints.map((e) => e?.split("@")[0]).toList();

        this.emit(
            ConferenceEvents.LAST_N_ACTIVE_ENDPOINTS_CHANGED, participants);
        break;
      default:
        //console.log(action, message);
        break;
    }
  }

  void onMessage(message) async {
    Map<String, dynamic> mapData = message;
    var data = mapData['data'];

    print('onMessage => ${mapData['type']} => ${data}');

    switch (mapData['type']) {
      case 'error':
        String message = data['message'];
        int code = data['code'] != null ? data['code'] : 0;
        //onError?.call(code, message);
        this.emit('error', {'code': code, 'message': message});
        break;
      case 'config':
        mc = data['mediaConstraints'];
        print(mc);
        if (data['changeMaxAvgBitrate'] != null)
          changeMaxAvgBitrate = data['changeMaxAvgBitrate'];
        break;
      case 'peers':
        {
          List<dynamic> peers = data;
          if (onPeersUpdate != null) {
            Map<String, dynamic> event = Map<String, dynamic>();
            event['self'] = this.userId;
            event['peers'] = peers;
            onPeersUpdate?.call(event);
          }
        }
        break;
      case 'offer':
        {
          var peerId = data['from'];
          var description = data['description'];
          var media = data['media'];
          var statws = data['statws'];

          if (pc == null) await _createSession(peerId: peerId);

          await pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          await _createAnswer();
          onCallStateChange?.call(CallState.CallStateNew);
          await connectStatsSocket(statws);
          this.statistics = new Statistics(this);
          this.statistics?.start();
        }
        break;
      case 'answer':
        {
          var description = data['description'];
          var sessionId = data['session_id'];
          pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
        }
        break;
      case 'candidate':
        {
          var peerId = data['from'];
          var candidateMap = data['candidate'];
          var sessionId = data['session_id'];
          RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
              candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

          if (pc != null) {
            await this.pc?.addCandidate(candidate);
          }
        }
        break;
      case "ssrc-add":
        //var ssrc = data["ssrc"];
        this.addSingleSsrc(data);
        break;
      case "ssrc-group-add":
        this.addGroupSsrc(data);
        break;
      case "ssrc-remove":
        //var ssrc = data["ssrc"];
        //ssrcRemove(ssrc);
        this.removeSsrc(data);
        break;
      case "endpoint-message":
        this.handleEndpointMessage(data);
        break;
      default:
        break;
    }
  }

  Participant? getParticipant(participantId) {
    if (!this.participants.containsKey(participantId)) {
      this.participants[participantId] = new Participant(
          signaling: this, participantId: participantId, isLocal: false);
    }
    return this.participants[participantId];
  }

  Participant? getParticipantByMsid(msid) {
    return this.getParticipant(this.streamIdToParticipant[msid]);
  }

  void putParticipant(Participant participant) {
    //this.participants[participant.participantId] = participant;
    List<dynamic> sources =
        participant.ssrc?.firstWhere((s) => s['name'] == "audio")['sources'];
    print('putParticipant:sources ${sources}');

    List<dynamic> parameters = sources.first['parameters'];
    String msid = parameters.firstWhere((p) => p['key'] == 'mslabel')['value'];

    this.streamIdToParticipant[msid] = participant.participantId!;
  }

  handleEndpointMessage(data) {
    String action = data["action"];
    String from = data["from"];
    Participant participant = this.participants[from]!;
    if (participant == null) return;
    switch (action) {
      case "AUDIO_MUTED":
        participant.remoteAudioMuted = true;
        participant.emit(ConferenceEvents.AUDIO_MUTE_CHANGED, participant);
        break;
      case "AUDIO_UNMUTED":
        participant.remoteAudioMuted = false;
        participant.emit(ConferenceEvents.AUDIO_MUTE_CHANGED, participant);
        break;
      case "VIDEO_MUTED":
        participant.remoteVideoMuted = true;
        participant.emit(ConferenceEvents.VIDEO_MUTE_CHANGED, participant);
        break;
      case "VIDEO_UNMUTED":
        participant.remoteVideoMuted = false;
        participant.emit(ConferenceEvents.VIDEO_MUTE_CHANGED, participant);
        break;
    }
  }

  renegociate(SDP sdp) async {
    RTCSessionDescription remoteDescription =
        new RTCSessionDescription(sdp.raw, "offer");
    //log('renegociate before  => ${sdp.raw}');
    var result = await this.pc?.setRemoteDescription(remoteDescription);
    RTCSessionDescription answer = (await this.pc?.createAnswer())!;
    //console.log("Renegotiate: setting local description");
    await this.pc?.setLocalDescription(answer);

    RTCSessionDescription r = (await this.pc?.getRemoteDescription())!;
    //log('renegociate after: ${r.sdp}');
  }

  addSingleSsrc(Map<String, dynamic> data) async {
    String participantId = data["participantId"];

    List<dynamic> ssrcInfo = data["ssrc"];
    Participant p = this.getParticipant(participantId)!;
    p.addSsrc(ssrcInfo);
    p.setEndpointId(data["endpointId"]);

    this.putParticipant(p);
    //console.log("addSingleSsrc", p);
    RTCSessionDescription remoteDescription =
        (await this.pc?.getRemoteDescription())!;

    SDP remoteSdp = new SDP(remoteDescription.sdp!);
    SDP modifiedSdp = this.addSsrc(ssrcInfo, remoteSdp);
    this.renegociate(modifiedSdp);
  }

  SDP addSsrc(List<dynamic> ssrcInfo, SDP remoteSdp) {
    //console.log("SSRC ADD", ssrcInfo);

    //const remoteSdp = new SDP(this.pc.currentRemoteDescription.sdp);
    //console.log(remoteSdp.media);
    List<String> addSsrcInfo = [];
    ssrcInfo.asMap().forEach((index, media) {
      String name = media['name'];
      String lines = "";
      media['sourceGroups'].forEach((sg) {
        lines +=
            'a=ssrc-group:${sg['semantics']} ${sg['sources'].join(" ")}\r\n';
      });
      media['sources'].forEach((s) {
        s['parameters'].forEach((p) {
          lines += 'a=ssrc:${s['ssrc']} ${p['key']}:${p['value']}\r\n';
        });
      });
      if (!addSsrcInfo.asMap().containsKey(index)) {
        addSsrcInfo.insert(index, "");
      }

      addSsrcInfo[index] += lines;
    });

    //print('addSsrcInfo ${addSsrcInfo}');

    addSsrcInfo.asMap().forEach((idx, lines) {
      //console.log("added " + lines);
      remoteSdp.media![idx] += lines;
    });

    remoteSdp.raw = remoteSdp.session! + remoteSdp.media!.join("");
    //console.log("finalSdp", remoteSdp.raw);

    return remoteSdp;
    /*
    const remoteDescription = new RTCSessionDescription({
      type: "offer",
      sdp: finalSdp,
    });
    return globalPc.createOffer().then(offer => {
      return globalPc.setLocalDescription(offer).then(() => {
        return globalPc.setRemoteDescription(remoteDescription);
      });
    }); */
  }

  addGroupSsrc(Map<String, dynamic> ssrcGroup) async {
    RTCSessionDescription remoteDescription =
        (await this.pc?.getRemoteDescription())!;
    SDP remoteSdp = new SDP(remoteDescription.sdp!);
    List<String> keys = ssrcGroup.keys.toList();
    keys.forEach((participantId) {
      remoteSdp = this.addSsrc(ssrcGroup[participantId]['ssrc'], remoteSdp);
      Participant p = this.getParticipant(participantId)!;
      p.setEndpointId(ssrcGroup[participantId]['endpointId']);
      p.addSsrc(ssrcGroup[participantId]['ssrc']);

      this.putParticipant(p);
      //console.log("addGroupSsrc", p);
    });
    if (keys.length > 0) this.renegociate(remoteSdp);
  }

  void removeSsrc(Map<String, dynamic> data) async {
    List<dynamic> ssrcInfo = data["ssrc"];
    //console.log("SSRC REMOVE", ssrcInfo);
    RTCSessionDescription remoteDescription =
        (await this.pc?.getRemoteDescription())!;

    //log('removeSsrc: ${remoteDescription.sdp}');

    SDP currentRemoteSdp = new SDP(remoteDescription.sdp!);

    List<String> removeSsrcInfo = [];
    //Process lines to be removed
    ssrcInfo.asMap().forEach((index, media) {
      String name = media['name'];
      String lines = "";
      media['sourceGroups'].forEach((sg) {
        lines +=
            'a=ssrc-group:${sg['semantics']} ${sg['sources'].join(" ")}\r\n';
      });

      List<String> ssrcs = [];

      media['sources'].forEach((s) {
        ssrcs.add(s['ssrc']);
      });

      currentRemoteSdp.media?.asMap().forEach((i2, media) {
        if (SDPUtil.findLine(media, 'a=mid:${name}', null) == null) {
          return;
        }

        if (!removeSsrcInfo.asMap().containsKey(i2)) {
          removeSsrcInfo.insert(i2, "");
        }
        //log('ssrcs ${ssrcs}');
        ssrcs.forEach((ssrc) {
          List<String> ssrcLines =
              SDPUtil.findLines(media, 'a=ssrc:${ssrc}', null);
          //log('ssrcLines ${ssrcLines}');
          if (ssrcLines.length > 0) {
            removeSsrcInfo[i2] += '${ssrcLines.join("\r\n")}\r\n';
          }
        });
        removeSsrcInfo[i2] += lines;
      });
    });
    //log('removeSsrcInfo ${removeSsrcInfo}');
    //console.log("removeSsrcInfo", removeSsrcInfo);
    //remove lines
    removeSsrcInfo.asMap().forEach((idx, lines) {
      // eslint-disable-next-line no-param-reassign
      List<String> linesList = lines.split("\r\n");
      linesList.removeLast(); // remove empty last element;
      //if (browser.usesPlanB()) {
      linesList.forEach((line) {
        String m = currentRemoteSdp.media!.asMap()[idx]!;
        if (m != null)
          currentRemoteSdp.media?[idx] = m.replaceFirst('${line}\r\n', "");
      });
      /*} else {
            lines.forEach(line => {
                const mid = currentRemoteSdp.media.findIndex(mLine => mLine.includes(line));
                if (mid > -1) {
                    currentRemoteSdp.media[mid] = currentRemoteSdp.media[mid].replace(`${line}\r\n`, '');
                    if (browser.isFirefox()) {
                        currentRemoteSdp.media[mid] = currentRemoteSdp.media[mid].replace('a=sendonly', 'a=inactive');
                    }
                }
            });
        }*/
    });

    currentRemoteSdp.raw =
        currentRemoteSdp.session! + currentRemoteSdp.media!.join("");
    //console.log("Removed SDP", currentRemoteSdp.raw);

    RTCSessionDescription modifiedRemoteDescription =
        new RTCSessionDescription(currentRemoteSdp.raw, "offer");
    return this
        .pc
        ?.setRemoteDescription(modifiedRemoteDescription)
        .then((result) {
      return this.pc?.createAnswer().then((answer) {
        //console.log("Renegotiate: setting local description");
        return this.pc?.setLocalDescription(answer);
      });
    });
  }

  getLocalStream({audio, video}) async {
    try {
      this._localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true,
      });
      print('Got Local Stream ${this._localStream?.id}');
      this.localParticipant = new Participant(
          signaling: this, participantId: this.userId!, isLocal: true);
      this.localParticipant?.setStream(this._localStream!);
      /*
      if (this.videoMute) {
        this.localParticipant.muteVideo();
        print('Mute Video===================');
      }
      if (this.mute) {
        this.localParticipant.muteAudio();
        print('Mute Audio===================');
      }
      */

      onLocalStream?.call(this._localStream!);
      this.emit(ConferenceEvents.JOINED_CONFERENCE, this.localParticipant);
      //return this._localStream;
    } catch (err, s) {
      //onError?.call(-1002, "Failed to get mic access");
      this.emit(
          'error', {'code': -1002, 'message': "Failed to get mic access"});
      print('ERROR: ${err}');
      print('ERROR: ${s}');
      throw err;
    }
  }

  Future<void> connect() async {
    var url = 'https://$host:$port/ws';

    List<MediaDeviceInfo> mediaDevices =
        await navigator.mediaDevices.enumerateDevices();
    mediaDevices.forEach((md) {
      print('deviceId = ' +
          md.deviceId +
          // ", groupId=" +
          // md.groupId +
          ", kind=" +
          md.kind! +
          ", label=" +
          md.label);
    });

    List<MediaDeviceInfo> outputDevices = await Helper.audiooutputs;

    outputDevices.forEach((mdi) {
      print('OUTPUT: deviceId = ' +
          mdi.deviceId +
          // ", groupId=" +
          // md.groupId +
          ", kind=" +
          mdi.kind! +
          ", label=" +
          mdi.label);
    });

    socket = SimpleWebSocket(url);

    socket?.onOpen = () {
      socketOpen = true;
      onSignalingStateChange?.call(SignalingState.ConnectionOpen);
      if (pc == null) {
        send('new', {
          'name': userId,
          'id': this.userId,
          'user_agent': DeviceInfo.userAgent,
          'user_id': userId,
          'auth_token': authToken,
          'conference_id': conferenceId,
          'mute': mute,
          'token': this.authToken
        });
        onSuccess?.call(2000, "Socket connected successfully");
      }
    };

    socket?.onMessage = (message) {
      onMessage(_decoder.convert(message));
    };

    socket?.onClose = (int code, String reason) {
      socketOpen = false;
      print('Closed by server [$code => $reason]!');
      onSignalingStateChange?.call(SignalingState.ConnectionClosed);
      if (code == 500) {
        //onError?.call(-1000, "Failed to create socket");
        this.emit(
            'error', {'code': -1000, 'message': "Failed to create socket"});
      }
    };

    await socket?.connect();
  }

  Future<void> connectStatsSocket(String url) async {
    url = url.replaceFirst('wss', 'https');
    statusSocket = SimpleWebSocket(url);

    statusSocket?.onOpen = () {
      print('stats socket open ');
    };

    statusSocket?.onMessage = (message) {
      onStatsMessage(_decoder.convert(message));
    };

    statusSocket?.onClose = (int code, String reason) {
      print('Stats Socket Closed by server [$code => $reason]!');
    };

    await statusSocket?.connect();
  }

  /*Future<MediaStream> createStream() async {
    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': false
      };

      MediaStream stream = await navigator.mediaDevices
          .getUserMedia(mc == null ? mediaConstraints : mc);

      await _localRenderer.initialize();
      _localRenderer.srcObject = stream;
      _localRenderer.muted = true;

      if (this.mute) stream.getAudioTracks()[0].enabled = !this.mute;

      onLocalStream?.call(stream);
      return stream;
    } catch (err) {
      print(err);
      onError?.call(-1002, "Failed to get mic access");
    }
  }*/

  Future<void> _createSession({
    String? peerId,
  }) async {
    //_localStream = await createStream();

    pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    switch (sdpSemantics) {
      case 'plan-b':
        /*pc.onAddStream = (MediaStream stream) {
          print('========================RemoteStream = ${stream.id}');
          onAddRemoteStream?.call(stream);
          _remoteStream = stream;
        };*/
        pc?.onTrack = (event) async {
          print('RemoteStream = ${event.track.kind} = ${event.streams[0].id}');
          if (event.track.kind == 'video') {
            Participant? participant =
                this.getParticipantByMsid(event.streams[0].id);
            participant?.setStream(event.streams[0]);

            this.emit(ConferenceEvents.REMOTE_PARTICIPANT_JOINED, participant);

            /*participant.getStream().onRemoveTrack = (MediaStreamTrack track) {
              if (track.kind == "audio") return;
              //console.log("removed stream", e);
              this.emit(ConferenceEvents.REMOTE_PARTICIPANT_LEFT, participant);
            };*/

            //_remoteStream = event.streams[0];
            onAddRemoteStream?.call(event.streams[0]);
          }
        };

        //await pc.addStream(_localStream);
        this._localStream?.getTracks().forEach((track) async {
          RTCRtpSender sender =
              (await this.pc?.addTrack(track, this._localStream!))!;
          this.senders.add(sender);
        });
        break;
      case 'unified-plan':
        // Unified-Plan
        /*pc.onTrack = (event) async {
          if (event.track.kind == 'audio') {
            _remoteStream = event.streams[0];
            onAddRemoteStream?.call(event.streams[0]);
          }
        };
        _localStream.getTracks().forEach((track) {
          pc.addTrack(track, _localStream);
        });*/
        pc?.onTrack = (event) async {
          print('RemoteStream = ${event.track.kind} = ${event.streams[0].id}');
          if (event.track.kind == 'video') {
            Participant? participant =
                this.getParticipantByMsid(event.streams[0].id);
            participant?.setStream(event.streams[0]);

            this.emit(ConferenceEvents.REMOTE_PARTICIPANT_JOINED, participant);

            participant?.getStream()?.onRemoveTrack = (MediaStreamTrack track) {
              if (track.kind == "audio") return;
              //console.log("removed stream", e);
              this.emit(ConferenceEvents.REMOTE_PARTICIPANT_LEFT, participant);
            };

            //_remoteStream = event.streams[0];
            onAddRemoteStream?.call(event.streams[0]);
          }
        };

        //await pc.addStream(_localStream);
        this._localStream?.getTracks().forEach((track) async {
          RTCRtpSender sender =
              (await this.pc?.addTrack(track, this._localStream!))!;
          this.senders.add(sender);
        });
        break;
    }

    if (this.videoMute) {
      this.localParticipant?.muteVideo();
    }
    if (this.mute) {
      this.localParticipant?.muteAudio();
    }

    // Unified-Plan: Simuclast
    /*
      await pc.addTransceiver(
        track: _localStream.getAudioTracks()[0],
        init: RTCRtpTransceiverInit(
            direction: TransceiverDirection.SendOnly, streams: [_localStream]),
      );

      await pc.addTransceiver(
        track: _localStream.getVideoTracks()[0],
        init: RTCRtpTransceiverInit(
            direction: TransceiverDirection.SendOnly,
            streams: [
              _localStream
            ],
            sendEncodings: [
              RTCRtpEncoding(rid: 'f', active: true),
              RTCRtpEncoding(
                rid: 'h',
                active: true,
                scaleResolutionDownBy: 2.0,
                maxBitrate: 150000,
              ),
              RTCRtpEncoding(
                rid: 'q',
                active: true,
                scaleResolutionDownBy: 4.0,
                maxBitrate: 100000,
              ),
            ]),
      ); */
    /*
        var sender = pc.getSenders().find(s => s.track.kind == "video");
        var parameters = sender.getParameters();
        if(!parameters)
          parameters = {};
        parameters.encodings = [
          { rid: "h", active: true, maxBitrate: 900000 },
          { rid: "m", active: true, maxBitrate: 300000, scaleResolutionDownBy: 2 },
          { rid: "l", active: true, maxBitrate: 100000, scaleResolutionDownBy: 4 }
        ];
        sender.setParameters(parameters);
      */

    pc?.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
    };

    pc?.onIceConnectionState = (state) {
      print(state);
      if (RTCIceConnectionState.RTCIceConnectionStateConnected == state) {
        //print("Enabling speakerphone @@@@@@@@@@");
        //_localStream?.getAudioTracks()[0].enableSpeakerphone(true);
      }
    };

    pc?.onIceGatheringState = (state) async {
      print(state);
      if (RTCIceGatheringState.RTCIceGatheringStateComplete == state) {
        RTCSessionDescription s = (await pc?.getLocalDescription())!;
        await send('answer', {
          'from': this.userId,
          'conference_id': conferenceId,
          'description': {'sdp': s.sdp, 'type': s.type},
        });
        iceGatheringStateComplete = true;
        onSuccess?.call(2004, "Successfully joined");
      }
    };

    pc?.onRenegotiationNeeded = () {
      print("onRenegotiationNeeded!!!!!!!!! ${pc?.signalingState} ");
    };

    pc?.onRemoveStream = (MediaStream stream) {
      Participant? participant = getParticipantByMsid(stream.id);
      //console.log("removed stream", e);
      this.streamIdToParticipant.remove(stream.id);
      this.participants.remove(participant?.participantId);
      this.emit(ConferenceEvents.REMOTE_PARTICIPANT_LEFT, participant);
      onRemoveRemoteStream?.call(stream);
    };
  }

  Future<void> _createAnswer() async {
    try {
      RTCSessionDescription? s = await pc?.createAnswer({});
      if (changeMaxAvgBitrate && s?.sdp != null) {
        String? answerSdp = s?.sdp?.replaceFirst('useinbandfec=1',
            'useinbandfec=1; stereo=1; maxaveragebitrate=510000');
        s?.sdp = answerSdp;
      }
      //print('mute = ${this.mute}');
      if (this.mute) {
        s?.sdp = s.sdp?.replaceFirst('a=sendrecv', 'a=recvonly');
        s?.sdp = s.sdp?.replaceFirst('a=sendonly', 'a=recvonly');
      } else {
        s?.sdp = s.sdp?.replaceFirst('a=sendrecv', 'a=sendrecv');
        s?.sdp = s.sdp?.replaceFirst('a=sendonly', 'a=sendrecv');
      }
      //print(s.sdp);
      if (s != null) await pc?.setLocalDescription(s);
      print("Local description set");
      if (iceGatheringStateComplete) {
        RTCSessionDescription s = (await pc?.getLocalDescription())!;
        await send('answer', {
          'from': this.userId,
          'conference_id': conferenceId,
          'description': {'sdp': s.sdp, 'type': s.type},
        });
        onSuccess?.call(2001, "renegotiation complete");
      }
    } catch (e) {
      print(e.toString());
      //onError?.call(-1001, "Failed to create answer");
      this.emit('error', {'code': -1000, 'message': "Failed to create answer"});
    }
  }

  send(event, data) async {
    var request = Map();
    request["type"] = event;
    request["data"] = data;
    await socket?.send(_encoder.convert(request));
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream?.getTracks().forEach((element) async {
        print('closing track ${element.id} => ${element.kind}');
        await element.stop();
      });
      await _localStream?.dispose();
      _localStream = null;
    }

    await pc?.close();
    await pc?.dispose();

    try {
      //_localRenderer.srcObject = null;
      //_localRenderer.dispose();

      print('_localRenderer disposed');
    } catch (e) {
      //print(e);
    }

    try {
      //_remoteRender.srcObject = null;
      //_remoteRender.dispose();
      print('_remoteRender disposed');
    } catch (e) {
      //print(e);
    }

    try {
      this.statistics?.stop();
      print('stats timer disposed');
    } catch (e) {
      //print(e);
    }
  }
}
