class GetUnreadCount {
  String conversationOwnerId;
  String conversationOwnerType;
  String conversationId;
  GetUnreadCount({this.conversationOwnerId, this.conversationOwnerType});

  GetUnreadCount.fromJson(Map<String, dynamic> json) {
    conversationOwnerId = json['conversationOwnerId'];
    conversationId = json['conversationId'];
    conversationOwnerType = json['conversationOwnerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['conversationId'] = this.conversationId;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['conversationOwnerType'] = this.conversationOwnerType;
    return data;
  }
}
