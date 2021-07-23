class CreateConversation {
  bool? isGroupConversation;
  Null allRoomsId;
  String? connectionOwnerType;
  String? connectionOwnerId;
  String? connectionCategory;
  String? connectionType;
  String? connectionId;
  String? connectionName;
  String? connectionMobile;
  String? connectionEmail;
  String? connectionProfileThumbnailUrl;
  String? connectionProfileUrl;

  CreateConversation(
      {this.isGroupConversation,
        this.allRoomsId,
        this.connectionOwnerType,
        this.connectionOwnerId,
        this.connectionCategory,
        this.connectionType,
        this.connectionId,
        this.connectionName,
        this.connectionMobile,
        this.connectionEmail,
        this.connectionProfileThumbnailUrl,
        this.connectionProfileUrl});

  CreateConversation.fromJson(Map<String, dynamic> json) {
    isGroupConversation = json['isGroupConversation'];
    allRoomsId = json['allRoomsId'];
    connectionOwnerType = json['connectionOwnerType'];
    connectionOwnerId = json['connectionOwnerId'];
    connectionCategory = json['connectionCategory'];
    connectionType = json['connectionType'];
    connectionId = json['connectionId'];
    connectionName = json['connectionName'];
    connectionMobile = json['connectionMobile'];
    connectionEmail = json['connectionEmail'];
    connectionProfileThumbnailUrl = json['connectionProfileThumbnailUrl'];
    connectionProfileUrl = json['connectionProfileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isGroupConversation'] = this.isGroupConversation;
    data['allRoomsId'] = this.allRoomsId;
    data['connectionOwnerType'] = this.connectionOwnerType;
    data['connectionOwnerId'] = this.connectionOwnerId;
    data['connectionCategory'] = this.connectionCategory;
    data['connectionType'] = this.connectionType;
    data['connectionId'] = this.connectionId;
    data['connectionName'] = this.connectionName;
    data['connectionMobile'] = this.connectionMobile;
    data['connectionEmail'] = this.connectionEmail;
    data['connectionProfileThumbnailUrl'] = this.connectionProfileThumbnailUrl;
    data['connectionProfileUrl'] = this.connectionProfileUrl;
    return data;
  }
}
