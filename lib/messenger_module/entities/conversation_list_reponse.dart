class ConversationListResponse {
  String statusCode;
  String message;
  List<ConversationItem> rows;
  int total;

  ConversationListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  ConversationListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <ConversationItem>[];
      json['rows'].forEach((v) {
        rows.add(new ConversationItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ConversationItem {
  int isOnline=0;
  String sId;
  String conversationOwnerType;
  String conversationOwnerId;
  String mcId;
  String conversationId;
  String conversationWithType;
  String conversationWithTypeId;
  String conversationWithName;
  String conversationImageThumbnail;
  String conversationImage;
  String conversationName;
  String lastMessageByType;
  String lastMessageById;
  String lastMessageByName;
  String lastMessage;
  String lastMessageIcon;
  int lastMessageTime;
  bool isGroupConversation;
  bool isRoomAvailable;
  String lastMessageUTCTime;
  int unreadCount;

  ConversationItem(
      {this.sId,
        this.isOnline,
        this.conversationOwnerType,
        this.conversationOwnerId,
        this.mcId,
        this.isGroupConversation,
        this.conversationId,
        this.conversationWithType,
        this.conversationWithTypeId,
        this.conversationWithName,
        this.conversationImageThumbnail,
        this.conversationImage,
        this.conversationName,
        this.lastMessageByType,
        this.lastMessageById,
        this.lastMessageByName,
        this.lastMessage,
        this.lastMessageIcon,
        this.lastMessageTime,
        this.lastMessageUTCTime,
this.isRoomAvailable,
        this.unreadCount});

  ConversationItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isOnline=json['isOnline'];
    isRoomAvailable=json['isRoomAvailable'];
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    mcId = json['mcId'];
    conversationId = json['conversationId'];
    conversationWithType = json['conversationWithType'];
    conversationWithTypeId = json['conversationWithTypeId'];
    conversationWithName = json['conversationWithName'];
    conversationImageThumbnail = json['conversationImageThumbnail'];
    conversationImage = json['conversationImage'];
    conversationName = json['conversationName'];
    lastMessageByType = json['lastMessageByType'];
    lastMessageById = json['lastMessageById'];
    lastMessageByName = json['lastMessageByName'];
    lastMessage = json['lastMessage'];
    lastMessageIcon = json['lastMessageIcon'];
    lastMessageTime = json['lastMessageTime'];
    lastMessageUTCTime = json['lastMessageUTCTime'];
    isGroupConversation = json['isGroupConversation'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['isOnline']=this.isOnline;
    data['isRoomAvailable']=this.isRoomAvailable;
    data['isGroupConversation']=this.isGroupConversation;
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['mcId'] = this.mcId;
    data['conversationId'] = this.conversationId;
    data['conversationWithType'] = this.conversationWithType;
    data['conversationWithTypeId'] = this.conversationWithTypeId;
    data['conversationWithName'] = this.conversationWithName;
    data['conversationImageThumbnail'] = this.conversationImageThumbnail;
    data['conversationImage'] = this.conversationImage;
    data['conversationName'] = this.conversationName;
    data['lastMessageByType'] = this.lastMessageByType;
    data['lastMessageById'] = this.lastMessageById;
    data['lastMessageByName'] = this.lastMessageByName;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageIcon'] = this.lastMessageIcon;
    data['lastMessageTime'] = this.lastMessageTime;
    data['lastMessageUTCTime'] = this.lastMessageUTCTime;

    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
class ConversationItemDb {
  int isOnline=0;
  String sId;
  String conversationOwnerType;
  String conversationOwnerId;
  String mcId;
  String conversationId;
  String conversationWithType;
  String conversationWithTypeId;
  String conversationWithName;
  String conversationImageThumbnail;
  String conversationImage;
  String conversationName;
  String lastMessageByType;
  String lastMessageById;
  String lastMessageByName;
  String lastMessage;
  String lastMessageIcon;
  int lastMessageTime;
  int isGroupConversation;
  int isRoomAvailable;
  String lastMessageUTCTime;
  int unreadCount;
  int eventId;

  ConversationItemDb(
      {this.sId,
        this.isOnline,
        this.isRoomAvailable,
        this.conversationOwnerType,
        this.conversationOwnerId,
        this.mcId,
        this.eventId,
        this.isGroupConversation,
        this.conversationId,
        this.conversationWithType,
        this.conversationWithTypeId,
        this.conversationWithName,
        this.conversationImageThumbnail,
        this.conversationImage,
        this.conversationName,
        this.lastMessageByType,
        this.lastMessageById,
        this.lastMessageByName,
        this.lastMessage,
        this.lastMessageIcon,
        this.lastMessageTime,
        this.lastMessageUTCTime,

        this.unreadCount});

  ConversationItemDb.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isOnline=json['isOnline'];
    isRoomAvailable=json['isRoomAvailable'];
    conversationOwnerType = json['conversationOwnerType'];
    conversationOwnerId = json['conversationOwnerId'];
    mcId = json['mcId'];
    conversationId = json['conversationId'];
    conversationWithType = json['conversationWithType'];
    conversationWithTypeId = json['conversationWithTypeId'];
    conversationWithName = json['conversationWithName'];
    conversationImageThumbnail = json['conversationImageThumbnail'];
    conversationImage = json['conversationImage'];
    conversationName = json['conversationName'];
    lastMessageByType = json['lastMessageByType'];
    lastMessageById = json['lastMessageById'];
    lastMessageByName = json['lastMessageByName'];
    lastMessage = json['lastMessage'];
    lastMessageIcon = json['lastMessageIcon'];
    lastMessageTime = json['lastMessageTime'];
    lastMessageUTCTime = json['lastMessageUTCTime'];
    isGroupConversation = json['isGroupConversation'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['isRoomAvailable']=this.isRoomAvailable;
    data['isOnline']=this.isOnline;
    data['isGroupConversation']=this.isGroupConversation;
    data['conversationOwnerType'] = this.conversationOwnerType;
    data['conversationOwnerId'] = this.conversationOwnerId;
    data['mcId'] = this.mcId;
    data['conversationId'] = this.conversationId;
    data['conversationWithType'] = this.conversationWithType;
    data['conversationWithTypeId'] = this.conversationWithTypeId;
    data['conversationWithName'] = this.conversationWithName;
    data['conversationImageThumbnail'] = this.conversationImageThumbnail;
    data['conversationImage'] = this.conversationImage;
    data['conversationName'] = this.conversationName;
    data['lastMessageByType'] = this.lastMessageByType;
    data['lastMessageById'] = this.lastMessageById;
    data['lastMessageByName'] = this.lastMessageByName;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageIcon'] = this.lastMessageIcon;
    data['lastMessageTime'] = this.lastMessageTime;
    data['lastMessageUTCTime'] = this.lastMessageUTCTime;

    data['unreadCount'] = this.unreadCount;
    return data;
  }
}