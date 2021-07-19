class ChatCallallowedRequest {
  String actionByObjectType;
  int actionByObjectId;
  String actionOnObjectType;
  int actionOnObjectId;

  ChatCallallowedRequest(
      {this.actionByObjectType,
        this.actionByObjectId,
        this.actionOnObjectType,
        this.actionOnObjectId});

  ChatCallallowedRequest.fromJson(Map<String, dynamic> json) {
    actionByObjectType = json['action_by_object_type'];
    actionByObjectId = json['action_by_object_id'];
    actionOnObjectType = json['action_on_object_type'];
    actionOnObjectId = json['action_on_object_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_by_object_type'] = this.actionByObjectType;
    data['action_by_object_id'] = this.actionByObjectId;
    data['action_on_object_type'] = this.actionOnObjectType;
    data['action_on_object_id'] = this.actionOnObjectId;
    return data;
  }
}

class ChatCallallowedResponse {
  String statusCode;
  String message;
  int total;
  ChatCallAllowedModel rows;

  ChatCallallowedResponse(
      {this.statusCode, this.message, this.total, this.rows});

  ChatCallallowedResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    rows = json['rows'] != null ? new ChatCallAllowedModel.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    return data;
  }
}

class ChatCallAllowedModel {
  bool audioCallIsAllowed;
  bool videoCallIsAllowed;

  ChatCallAllowedModel({this.audioCallIsAllowed, this.videoCallIsAllowed});

  ChatCallAllowedModel.fromJson(Map<String, dynamic> json) {
    audioCallIsAllowed = json['audio_call_is_allowed'];
    videoCallIsAllowed = json['video_call_is_allowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audio_call_is_allowed'] = this.audioCallIsAllowed;
    data['video_call_is_allowed'] = this.videoCallIsAllowed;
    return data;
  }
}