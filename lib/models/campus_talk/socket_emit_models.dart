

class JoinEventPayload {
  int? personId;
  int? eventId;

  JoinEventPayload({this.personId, this.eventId});

  JoinEventPayload.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['eventId'] = this.eventId;
    return data;
  }
}

class GetMemberEventPayload {
  int? personId;
  int? eventId;
  String? listType;
  List<int>? participantIds;
  String? searchValue;

  GetMemberEventPayload({this.personId, this.eventId, this.listType,this.participantIds,this.searchValue});

  GetMemberEventPayload.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    eventId = json['eventId'];
    listType = json['list_type'];
    searchValue = json['searchValue'];
    participantIds = json['personIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['eventId'] = this.eventId;
    data['personIds'] = this.participantIds;
    data['list_type'] = this.listType;
    data['searchValue'] = this.searchValue;
    return data;
  }
}

class JoinEventResponse {
  String? statusCode;
  String? message;
  JoinEventModel? rows;
  int? total;
  int? startTime;

  JoinEventResponse({this.statusCode, this.message, this.rows, this.total,this.startTime});

  JoinEventResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new JoinEventModel.fromJson(json['rows']) : null;
    total = json['total'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    data['startTime'] = this.total;
    return data;
  }
}

class JoinEventModel {
  String? name;
  String? profileImage;
  String? personType;
  String? role;
  String? participantType;
  int? participantId;
  int? isModerator;
  int? startTime;
  String? channelName;
  String? token;
  String? nexToken;
  String? conversationId;
  JoinEventModel(
      {this.name,
        this.profileImage,
        this.personType,
        this.role,
        this.participantType,
        this.participantId,
        this.isModerator,
        this.channelName,
        this.token,
        this.nexToken,
        this.conversationId,
        this.startTime});

  JoinEventModel.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    token = json['token'];
    name = json['name'];
    nexToken=json['nexToken'];
    conversationId = json['conversationId'];
    profileImage = json['profile_image'];
    personType = json['person_type'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
    isModerator = json['is_moderator'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['conversationId'] = this.conversationId;
    data['channelName'] = this.channelName;
    data['nexToken'] = this.nexToken;
    data['token'] = this.token;
    data['profile_image'] = this.profileImage;
    data['person_type'] = this.personType;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    data['is_moderator'] = this.isModerator;
    data['start_time'] = this.startTime;
    return data;
  }
}


class BaseEventResponse {
  String? statusCode;
  String? message;
  int? total;

  BaseEventResponse({this.statusCode, this.message, this.total});

  BaseEventResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}

class TalkNotificationResponse {
  String? notification;
  String? colorCode;

  TalkNotificationResponse({this.notification, this.colorCode});

  TalkNotificationResponse.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['color_code'] = this.colorCode;
    return data;
  }
}
