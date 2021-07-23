import 'package:eventify/eventify.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nexge_video_conference/signaling.dart';

class Participant {
  String? participantId;
  String? endpointId = null;
  bool isLocal = false;
  MediaStream? stream = null;
  List<dynamic>? ssrc;
  bool remoteAudioMuted = false;
  bool remoteVideoMuted = false;
  Signaling? _signaling;
  EventEmitter _eventEmitter = new EventEmitter();

  Participant(
      {required Signaling signaling,
      required String participantId,
      required bool isLocal}) {
    this._signaling = signaling;
    this.participantId = participantId;
    this.endpointId = null;
    this.isLocal = isLocal;
    this.stream = null;
    //this.ssrc;
    this.remoteAudioMuted = false;
    this.remoteVideoMuted = false;
  }

  on(eventName, Function listener) {
    return this._eventEmitter.on(eventName, this, (Event ev, context) {
      listener(ev.eventName, ev.eventData);
    });
  }

  off(eventName, listener) {
    this._eventEmitter.removeListener(eventName, listener);
  }

  emit(eventName, data) {
    this._eventEmitter.emit(eventName, null, data);
  }

  setEndpointId(endpointId) {
    this.endpointId = endpointId;
  }

  getEndpointId() {
    return this.endpointId;
  }

  setStream(MediaStream stream) {
    this.stream = stream;
  }

  MediaStream? getStream() {
    return this.stream;
  }

  addSsrc(ssrc) {
    this.ssrc = ssrc;
  }

  updateStream() {}

  muteAudio() {
    this
        .stream
        ?.getTracks()
        .firstWhere((track) => track.kind == "audio")
        .enabled = false;
    if (this.isLocal) {
      this._signaling?.send("endpoint-message", {
        'from': this.participantId,
        'conference_id': this._signaling?.conferenceId,
        'action': "AUDIO_MUTED",
      });
    }
  }

  unMuteAudio() {
    this
        .stream
        ?.getTracks()
        .firstWhere((track) => track.kind == "audio")
        .enabled = true;
    if (this.isLocal) {
      this._signaling?.send("endpoint-message", {
        'from': this.participantId,
        'conference_id': this._signaling?.conferenceId,
        'action': "AUDIO_UNMUTED",
      });
    }
  }

  muteVideo() {
    this
        .stream
        ?.getTracks()
        .firstWhere((track) => track.kind == "video")
        .enabled = false;
    if (this.isLocal) {
      this._signaling?.send("endpoint-message", {
        'from': this.participantId,
        'conference_id': this._signaling?.conferenceId,
        'action': "VIDEO_MUTED",
      });
    }
  }

  unMuteVideo() {
    this
        .stream
        ?.getTracks()
        .firstWhere((track) => track.kind == "video")
        .enabled = true;
    if (this.isLocal) {
      this._signaling?.send("endpoint-message", {
        'from': this.participantId,
        'conference_id': this._signaling?.conferenceId,
        'action': "VIDEO_UNMUTED",
      });
    }
  }

  isAudioMuted() {
    if (this.isLocal) {
      MediaStreamTrack mediaStreamTrack = this
          .stream
          ?.getTracks()
          .firstWhere((track) => track.kind == "audio") as MediaStreamTrack;

      return (mediaStreamTrack.enabled);
    } else {
      return this.remoteAudioMuted;
    }
  }

  isVideoMuted() {
    if (this.isLocal) {
      MediaStreamTrack mediaStreamTrack = this
          .stream
          ?.getTracks()
          .firstWhere((track) => track.kind == "video") as MediaStreamTrack;

      return mediaStreamTrack.enabled;
    } else {
      return this.remoteVideoMuted;
    }
  }

  pin() {
    /*this.rtc?.jvbsocket?.send(JSON.stringify({
          colibriClass: "PinnedEndpointChangedEvent",
          pinnedEndpoint: this.endpointId,
        }));*/
  }

  // broadcastMessage() {
  //   if (this.rtc) {
  //     this.rtc.conference.ws.send("endpoint-message", {
  //       from: this.participantId,
  //       conference_id: this.rtc.conference.conferenceId,
  //       action: "AUDIO_MUTED",
  //     });
  //   }
  // }

  unpin() {}
}
