class ConnectionListResponseEntity {
  String? statusCode;
  String? message;

  List<ConnectionItem>? rows;
  int? total;

  ConnectionListResponseEntity(
      {this.statusCode, this.message, this.rows, this.total});

  ConnectionListResponseEntity.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];

    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ConnectionItem>();
      json['rows'].forEach((v) {
        rows!.add(new ConnectionItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;

    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ConnectionItem {
  bool? isGroupConversation;
  bool? isSelected = false;
  String? connectionId;
  String? connectionOwnerType;
  String? connectionOwnerId;
  String? connectionName;
  String? connectionType;
  String? connectionMobile;
  String? connectionEmail;
  String? connectionSubTitle;
  String? connectionProfileThumbnailUrl;
  String? connectionCategory;
  int? allRoomsId;
  int? eventId;

  ConnectionItem(
      {this.allRoomsId,
        this.eventId,
      this.connectionCategory,
      this.isSelected,
      this.connectionId,
      this.connectionOwnerType,
      this.connectionOwnerId,
      this.connectionName,
      this.connectionType,
      this.connectionMobile,
      this.connectionEmail,
      this.connectionSubTitle,
      this.isGroupConversation,
      this.connectionProfileThumbnailUrl});

  ConnectionItem.fromJson(Map<String, dynamic> json) {
    connectionId = json['connectionId'];
    allRoomsId = json['allRoomsId'];
    eventId = json['eventId'];
    connectionCategory = json['connectionCategory'];
    connectionOwnerType = json['connectionOwnerType'];
    connectionOwnerId = json['connectionOwnerId'];
    connectionName = json['connectionName'];
    connectionType = json['connectionType'];
    isGroupConversation = json['isGroupConversation'];
    connectionMobile = json['connectionMobile'];
    connectionEmail = json['connectionEmail'];
    connectionSubTitle = json['connectionSubTitle'];
    connectionProfileThumbnailUrl = json['connectionProfileThumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allRoomsId'] = this.allRoomsId;
    data['eventId'] = this.eventId;
    data['connectionId'] = this.connectionId;
    data['connectionCategory'] = this.connectionCategory;
    data['connectionOwnerType'] = this.connectionOwnerType;
    data['connectionOwnerId'] = this.connectionOwnerId;
    data['connectionName'] = this.connectionName;
    data['isGroupConversation'] = this.isGroupConversation;
    data['connectionType'] = this.connectionType;
    data['connectionMobile'] = this.connectionMobile;
    data['connectionEmail'] = this.connectionEmail;
    data['connectionSubTitle'] = this.connectionSubTitle;
    data['connectionProfileThumbnailUrl'] = this.connectionProfileThumbnailUrl;
    return data;
  }
}
