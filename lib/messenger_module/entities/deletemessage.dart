class DeleteMessage {
  String conversationOwnerId;
  String conversationId;
  String messageStatus;
  List<String> messageIds;
  int messageDeletedTime;
  String conversationOwnerType;

  DeleteMessage(
      {this.conversationOwnerId,
        this.conversationId,
        this.messageStatus,
        this.messageIds,
        this.messageDeletedTime,
        this.conversationOwnerType});

  DeleteMessage.fromJson(Map<String, dynamic> json) {
    conversationOwnerId = json['conversationOwnerId'];
    conversationId = json['conversationId'];
    messageStatus = json['messageStatus'];
    messageIds = json['messageIds'].cast<String>();
    messageDeletedTime = json['messageDeletedTime'];
    conversationOwnerType = json['conversationOwnerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['conversationId'] = this.conversationId;
    data['messageStatus'] = this.messageStatus;
    data['messageIds'] = this.messageIds;
    data['messageDeletedTime'] = this.messageDeletedTime;
    data['conversationOwnerType'] = this.conversationOwnerType;
    return data;
  }
}
