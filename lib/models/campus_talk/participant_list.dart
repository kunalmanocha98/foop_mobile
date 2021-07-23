class ParticipantListResponse {
  String? statusCode;
  String? message;
  Rows? rows;

  ParticipantListResponse({this.statusCode, this.message, this.rows});

  ParticipantListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class Rows {
  String? listType;
  List<ParticipantListItem>? membersList;

  Rows({this.listType, this.membersList});

  Rows.fromJson(Map<String, dynamic> json) {
    listType = json['list_type'];
    if (json['members_list'] != null) {
      membersList = [];//ParticipantListItem>();
      json['members_list'].forEach((v) {
        membersList!.add(new ParticipantListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_type'] = this.listType;
    if (this.membersList != null) {
      data['members_list'] = this.membersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticipantListItem {
  String? name;
  String? profileImage;
  String? role;
  String? type;
  String? participantType;
  int? participantId;
  int? isSpeakerOn;
  int? isVideoOn;
  int? isSpeaking;
  int? isModerator;
  String? personType;
  int? joinedDate;
  ParticipantListItem(
      {this.name,
        this.profileImage,
        this.role,
        this.type,
        this.isVideoOn,
        this.isSpeaking,
        this.isModerator,
        this.isSpeakerOn,
        this.participantType,
        this.personType,
        this.joinedDate,
        this.participantId});

  ParticipantListItem.fromJson(Map<String, dynamic> json) {
    isSpeaking = json['isSpeaking'];
    isVideoOn=json['is_video_on'];
    name = json['name'];
    isModerator = json['is_moderator'];
    type = json['type'];
    isSpeakerOn = json['is_speaker_on'];
    profileImage = json['profile_image'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
    personType = json['person_type'];
    joinedDate = json['joined_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isSpeaking'] = this.isSpeaking;
    data['is_moderator'] = this.isModerator;
    data['type'] = this.type;
    data['is_video_on'] = this.isVideoOn;
    data['is_speaker_on'] = this.isSpeakerOn;
    data['profile_image'] = this.profileImage;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    data['person_type'] = this.personType;
    data['joined_date'] = this.joinedDate;
    return data;
  }
}

class OnHandRaiseResponse {
  String? name;
  String? profileImage;
  String? role;
  String? type;
  String? participantType;
  int? participantId;
  int? isSpeakerOn;
  int? isModerator;
  String? personType;
  String? notification;
  List<Actions>? actions;
  OnHandRaiseResponse(
      {this.name,
        this.profileImage,
        this.role,
        this.type,
        this.isModerator,
        this.isSpeakerOn,
        this.participantType,
        this.personType,
        this.notification,
        this.actions,
        this.participantId});

  OnHandRaiseResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isModerator = json['is_moderator'];
    type = json['type'];
    isSpeakerOn = json['is_speaker_on'];
    profileImage = json['profile_image'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
    personType = json['person_type'];
    notification = json['notification'];
    if (json['actions'] != null) {
      actions = [];//Actions>();
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['is_moderator'] = this.isModerator;
    data['type'] = this.type;
    data['is_speaker_on'] = this.isSpeakerOn;
    data['profile_image'] = this.profileImage;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    data['person_type'] = this.personType;
    data['notification'] = this.notification;
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actions {
  String? actionText;
  String? actionCode;

  Actions({this.actionText, this.actionCode});

  Actions.fromJson(Map<String, dynamic> json) {
    actionText = json['action_text'];
    actionCode = json['action_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_text'] = this.actionText;
    data['action_code'] = this.actionCode;
    return data;
  }
}




/*
class ParticipantListResponse {
  String statusCode;
  String message;
  List<ParticipantListItem> rows;
  int total;

  ParticipantListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  ParticipantListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ParticipantListItem>();
      json['rows'].forEach((v) {
        rows.add(new ParticipantListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ParticipantListItem {
  String name;
  String profileImage;
  String role;
  String participantType;
  int participantId;
  bool isMute=false;

  ParticipantListItem(
      {this.name,
        this.profileImage,
        this.role,
        this.isMute,
        this.participantType,
        this.participantId});

  ParticipantListItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isMute = json['isMute'];
    profileImage = json['profile_image'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMute'] = this.isMute;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    return data;
  }
}*/
