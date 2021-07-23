class InviteUserAsSpeakerResponse {
  Result? result;

  InviteUserAsSpeakerResponse({this.result});

  InviteUserAsSpeakerResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? name;
  String? profileImage;
  String? personType;
  String? role;
  String? participantType;
  int? participantId;

  Result(
      {this.name,
        this.profileImage,
        this.personType,
        this.role,
        this.participantType,
        this.participantId});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
    personType = json['person_type'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['person_type'] = this.personType;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    return data;
  }
}
