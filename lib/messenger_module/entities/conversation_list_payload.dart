class ConversationListPayload {
  String conversationOwnerType;
  String conversationOwnerId;
  String conversationWithName;

  String institutionId;
  String personId;
  int pageNumber;
  int pageSize;
  ConversationListPayload(
      {this.conversationOwnerType,
        this.conversationOwnerId,
        this.pageNumber,
        this.pageSize,
        this.personId,
        this.institutionId,
        this.conversationWithName});

  ConversationListPayload.fromJson(Map<String, dynamic> json) {
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    conversationWithName = json['conversationWithName'];
    personId = json['personId'];
    institutionId = json['institutionId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['conversationWithName'] = this.conversationWithName;
    data['personId'] = this.personId;
    data['institutionId'] = this.institutionId;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
