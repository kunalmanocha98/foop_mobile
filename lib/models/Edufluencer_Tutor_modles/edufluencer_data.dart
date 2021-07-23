class RequestDetailEdufluencer {
  String? statusCode;
  String? message;
  EdufluencerRequestData? rows;
  int? total;

  RequestDetailEdufluencer(
      {this.statusCode, this.message, this.rows, this.total});

  RequestDetailEdufluencer.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new EdufluencerRequestData.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class EdufluencerRequestData {
  int? id;
  int? personId;
  String? title;
  String? subtitle;
  String? avatar;
  bool? isFollowed;
  String? bookingStatus;
  String? conversationId;

  EdufluencerRequestData(
      {this.id,
        this.personId,
        this.title,
        this.subtitle,
        this.avatar,
        this.isFollowed,
        this.bookingStatus,
        this.conversationId});

  EdufluencerRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    title = json['title'];
    subtitle = json['subtitle'];
    avatar = json['avatar'];
    isFollowed = json['is_followed'];
    bookingStatus = json['booking_status'];
    conversationId = json['conversation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_id'] = this.personId;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['avatar'] = this.avatar;
    data['is_followed'] = this.isFollowed;
    data['booking_status'] = this.bookingStatus;
    data['conversation_id'] = this.conversationId;
    return data;
  }
}
