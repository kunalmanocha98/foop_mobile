class MessagesPayload {
  String conversationOwnerType;
  String conversationOwnerId;
  String conversationId;
  String message;
  String pageNumber;
  String pageSize;

  MessagesPayload(
      {this.conversationOwnerType,
        this.conversationOwnerId,
        this.conversationId,
        this.message,
        this.pageNumber,
        this.pageSize});

  MessagesPayload.fromJson(Map<String, dynamic> json) {
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    conversationId = json['conversationId'];
    message = json['message'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['conversationId'] = this.conversationId;
    data['message'] = this.message;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
