class UpdateModeratorPayload {
  int personId;
  int eventId;
  String participantType;
  String role;
  int participantId;
  int isModerator;
  bool isAccepted;

  UpdateModeratorPayload(
      {this.personId,
        this.eventId,
        this.participantType,
        this.participantId,
        this.isAccepted,
        this.isModerator});

  UpdateModeratorPayload.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    isAccepted = json['isAccepted'];
    role = json['role'];
    eventId = json['eventId'];
    participantType = json['participantType'];
    participantId = json['participantId'];
    isModerator = json['isModerator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['role'] = this.role;
    data['isAccepted'] = this.isAccepted;
    data['eventId'] = this.eventId;
    data['participantType'] = this.participantType;
    data['participantId'] = this.participantId;
    data['isModerator'] = this.isModerator;
    return data;
  }
}
