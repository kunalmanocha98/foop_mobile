class ConferenceEvents {
  static const AUDIO_INPUT_STATE_CHANGE =
      "conference.audio_input_state_changed";
  static const CONFERENCE_ERROR = "conference.error";
  static const CONFERENCE_FAILED = "conference.failed";
  static const JOINED_CONFERENCE = "conference.joined";
  static const LEFT_CONFERENCE = "conference.left";
  static const CONNECTION_ESTABLISHED = "conference.connectionEstablished";
  static const CONNECTION_INTERRUPTED = "conference.connectionInterrupted";
  static const CONNECTION_RESTORED = "conference.connectionRestored";
  static const DATA_CHANNEL_OPENED = "conference.dataChannelOpened";
  static const DOMINANT_SPEAKER_CHANGED = "conference.dominantSpeaker";
  static const LAST_N_ACTIVE_ENDPOINTS_CHANGED = "conference.lastNEndpoints";
  static const TRACK_ADDED = "conference.trackAdded";
  static const TRACK_AUDIO_LEVEL_CHANGED = "conference.audioLevelsChanged";
  static const TRACK_MUTE_CHANGED = "conference.trackMuteChanged";
  static const TRACK_REMOVED = "conference.trackRemoved";
  static const REMOTE_PARTICIPANT_JOINED = "conference.userJoined";
  static const REMOTE_PARTICIPANT_LEFT = "conference.userLeft";
  static const AUDIO_MUTE_CHANGED = "conference.userAudioMuteChanged";
  static const VIDEO_MUTE_CHANGED = "conference.userVideoMuteChanged";
}
