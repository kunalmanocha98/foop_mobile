class AddConversationPayload {
  String? sId;
  String? mcId;
  String? conversationOwnerType;
  String? conversationOwnerId;
  String? personId;
  String? conversationId;
  String? conversationWithType;
  String? conversationWithTypeId;
  String? conversationWithName;
  String? conversationImageThumbnail;
  String? conversationImage;
  String? conversationName;
  String? lastMessage;
  String? lastMessageByType;
  String? lastMessageById;
  String? lastMessageByName;
  int? lastMessageTime;
  int? eventId;
  AddConversationPayload(
      {this.sId,
        this.mcId,
        this.personId,
        this.conversationOwnerType,
        this.conversationOwnerId,
        this.conversationId,
        this.conversationWithType,
        this.conversationWithTypeId,
        this.conversationWithName,
        this.conversationImageThumbnail,
        this.conversationImage,
        this.conversationName,
        this.lastMessage,
        this.lastMessageByType,
        this.lastMessageById,
        this.lastMessageByName,
        this.eventId,
        this.lastMessageTime});

  AddConversationPayload.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    sId = json['_id'];
    mcId = json['mcId'];
    personId = json['personId'];
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    conversationId = json['conversationId'];
    conversationWithType = json['conversationWithType'];
    conversationWithTypeId = json['conversationWithTypeId'];
    conversationWithName = json['conversationWithName'];
    conversationImageThumbnail = json['conversationImageThumbnail'];
    conversationImage = json['conversationImage'];
    conversationName = json['conversationName'];
    lastMessage = json['lastMessage'];
    lastMessageByType = json['lastMessageByType'];
    lastMessageById = json['lastMessageById'];
    lastMessageByName = json['lastMessageByName'];
    lastMessageTime = json['lastMessageTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['_id'] = this.sId;
    data['mcId'] = this.mcId;
    data['personId'] = this.personId;
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['conversationId'] = this.conversationId;
    data['conversationWithType'] = this.conversationWithType;
    data['conversationWithTypeId'] = this.conversationWithTypeId;
    data['conversationWithName'] = this.conversationWithName;
    data['conversationImageThumbnail'] = this.conversationImageThumbnail;
    data['conversationImage'] = this.conversationImage;
    data['conversationName'] = this.conversationName;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageByType'] = this.lastMessageByType;
    data['lastMessageById'] = this.lastMessageById;
    data['lastMessageByName'] = this.lastMessageByName;
    data['lastMessageTime'] = this.lastMessageTime;
    return data;
  }
}
