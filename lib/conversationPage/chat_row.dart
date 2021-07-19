class ChatRow {
  String sId;
  String conversationOwnerType;
  String conversationOwnerId;
  String mcId;
  String conversationId;
  String conversationWithType;
  String conversationWithTypeId;
  String conversationWithName;
  String conversationName;
  String lastMessageByType;
  String lastMessageById;
  String lastMessageByName;
  String lastMessage;
  Null lastMessageIcon;
  int lastMessageTime;
  String lastMessageUTCTime;
  bool isGroupConversation;
  bool isCommunityConversation;
  bool isRoomAvailable;
  bool isBotConversation;
  String conversationImageThumbnail;
  String conversationImage;
  int unreadCount;

  ChatRow(
      {this.sId,
      this.conversationOwnerType,
      this.conversationOwnerId,
      this.mcId,
      this.conversationId,
      this.conversationWithType,
      this.conversationWithTypeId,
      this.conversationWithName,
      this.conversationName,
      this.lastMessageByType,
      this.lastMessageById,
      this.lastMessageByName,
      this.lastMessage,
      this.lastMessageIcon,
      this.lastMessageTime,
      this.lastMessageUTCTime,
      this.isGroupConversation,
      this.isCommunityConversation,
      this.isRoomAvailable,
      this.isBotConversation,
      this.conversationImageThumbnail,
      this.conversationImage,
      this.unreadCount});

  ChatRow.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    mcId = json['mcId'];
    conversationId = json['conversationId'];
    conversationWithType = json['conversationWithType'];
    conversationWithTypeId = json['conversationWithTypeId'];
    conversationWithName = json['conversationWithName'];
    conversationName = json['conversationName'];
    lastMessageByType = json['lastMessageByType'];
    lastMessageById = json['lastMessageById'];
    lastMessageByName = json['lastMessageByName'];
    lastMessage = json['lastMessage'];
    lastMessageIcon = json['lastMessageIcon'];
    lastMessageTime = json['lastMessageTime'];
    lastMessageUTCTime = json['lastMessageUTCTime'];
    isGroupConversation = json['isGroupConversation'];
    isCommunityConversation = json['isCommunityConversation'];
    isRoomAvailable = json['isRoomAvailable'];
    isBotConversation = json['isBotConversation'];
    conversationImageThumbnail = json['conversationImageThumbnail'];
    conversationImage = json['conversationImage'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['mcId'] = this.mcId;
    data['conversationId'] = this.conversationId;
    data['conversationWithType'] = this.conversationWithType;
    data['conversationWithTypeId'] = this.conversationWithTypeId;
    data['conversationWithName'] = this.conversationWithName;
    data['conversationName'] = this.conversationName;
    data['lastMessageByType'] = this.lastMessageByType;
    data['lastMessageById'] = this.lastMessageById;
    data['lastMessageByName'] = this.lastMessageByName;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageIcon'] = this.lastMessageIcon;
    data['lastMessageTime'] = this.lastMessageTime;
    data['lastMessageUTCTime'] = this.lastMessageUTCTime;
    data['isGroupConversation'] = this.isGroupConversation;
    data['isCommunityConversation'] = this.isCommunityConversation;
    data['isRoomAvailable'] = this.isRoomAvailable;
    data['isBotConversation'] = this.isBotConversation;
    data['conversationImageThumbnail'] = this.conversationImageThumbnail;
    data['conversationImage'] = this.conversationImage;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
