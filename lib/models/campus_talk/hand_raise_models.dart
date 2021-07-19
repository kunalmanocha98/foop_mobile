class UpdateHandRaiseRequest {
  int personId;
  int eventId;
  String participantType;
  int participantId;
  bool isAccepted;
  String role;
  String personType;

  UpdateHandRaiseRequest(
      {this.personId,
        this.eventId,
        this.participantType,
        this.participantId,
        this.isAccepted,
        this.personType,
        this.role});

  UpdateHandRaiseRequest.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    eventId = json['eventId'];
    participantType = json['participantType'];
    participantId = json['participantId'];
    isAccepted = json['isAccepted'];
    role = json['role'];
    personType = json['person_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['eventId'] = this.eventId;
    data['participantType'] = this.participantType;
    data['participantId'] = this.participantId;
    data['isAccepted'] = this.isAccepted;
    data['role'] = this.role;
    data['person_type'] = this.personType;
    return data;
  }
}

class UpdateHandRaiseResponse {
  String name;
  String profileImage;
  String personType;
  String role;
  String participantType;
  int participantId;
  bool isAccepted;

  UpdateHandRaiseResponse(
      {this.name,
        this.profileImage,
        this.personType,
        this.role,
        this.participantType,
        this.participantId,
        this.isAccepted});

  UpdateHandRaiseResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
    personType = json['person_type'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
    isAccepted = json['is_accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['person_type'] = this.personType;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    data['is_accepted'] = this.isAccepted;
    return data;
  }
}