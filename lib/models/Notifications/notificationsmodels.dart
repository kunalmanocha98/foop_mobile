class NotificationListRequest {
  String personId;
  int pageNumber;
  int pageSize;

  NotificationListRequest({this.personId, this.pageNumber, this.pageSize});

  NotificationListRequest.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}

class NotificationListResponse {
  String statusCode;
  String message;
  int total;
  List<NotificationItem> rows;

  NotificationListResponse(
      {this.statusCode, this.message, this.total, this.rows});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//NotificationItem>();
      json['rows'].forEach((v) {
        rows.add(new NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationItem {
  String pid;
  String personId;
  String notificationTitle;
  String notificationText;
  String notificationActorImage;
  String notificationImage;
  String notificationWebDeepLink;
  String notificationMobileDeepLink;
  String isRead;
  String isOnline;
  String notificationActorName;
  String notificationActorPid;
  String notificationDate;
  String notificationReadDate;

  NotificationItem(
      {this.pid,
        this.personId,
        this.notificationTitle,
        this.notificationText,
        this.notificationActorImage,
        this.notificationImage,
        this.notificationWebDeepLink,
        this.notificationMobileDeepLink,
        this.isRead,
        this.isOnline,
        this.notificationActorName,
        this.notificationActorPid,
        this.notificationDate,
        this.notificationReadDate});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    personId = json['personId'];
    notificationTitle = json['notificationTitle'];
    notificationText = json['notificationText'];
    notificationActorImage = json['notificationActorImage'];
    notificationImage = json['notificationImage'];
    notificationWebDeepLink = json['notificationWebDeepLink'];
    notificationMobileDeepLink = json['notificationMobileDeepLink'];
    isRead = json['isRead'];
    isOnline = json['isOnline'];
    notificationActorName = json['notificationActorName'];
    notificationActorPid = json['notificationActorPid'];
    notificationDate = json['notificationDate'];
    notificationReadDate = json['notificationReadDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['personId'] = this.personId;
    data['notificationTitle'] = this.notificationTitle;
    data['notificationText'] = this.notificationText;
    data['notificationActorImage'] = this.notificationActorImage;
    data['notificationImage'] = this.notificationImage;
    data['notificationWebDeepLink'] = this.notificationWebDeepLink;
    data['notificationMobileDeepLink'] = this.notificationMobileDeepLink;
    data['isRead'] = this.isRead;
    data['isOnline'] = this.isOnline;
    data['notificationActorName'] = this.notificationActorName;
    data['notificationActorPid'] = this.notificationActorPid;
    data['notificationDate'] = this.notificationDate;
    data['notificationReadDate'] = this.notificationReadDate;
    return data;
  }
}