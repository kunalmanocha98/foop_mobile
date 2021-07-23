class MicStatusPayload {
  int? personId;
  int? eventId;
  int? isSpeakerOn;
  int? isVideoOn;
  MicStatusPayload({this.personId, this.eventId, this.isSpeakerOn,this.isVideoOn});

  MicStatusPayload.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    eventId = json['eventId'];
    isSpeakerOn = json['isSpeakerOn'];
    isVideoOn = json['isVideoOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['eventId'] = this.eventId;
    data['isSpeakerOn'] = this.isSpeakerOn;
    data['isVideoOn'] = this.isVideoOn;
    return data;
  }
}
