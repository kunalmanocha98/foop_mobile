class MessagePayloadDatabase {
  String messageToId;
  String date;
  String messageToType;
  int updatedDateTime;
  String updatedDateByType;
  String updatedDateById;
  int isGroupConversation;
  int allRoomsId;
  int eventId;
  String sId;
  String conversationId;
  String myConversationId;
  String mcId;
  String messageId;
  String message;
  String messageAttachment;
  String messageAttachmentThumbnail;
  String messageAttachmentType;
  String messageAttachmentMIMEType;
  String messageAttachmentName;
  String messageSentByName;
  String messageAction;
  String messageByType;
  String messageById;
  int messageSentTime;
  int messageDeliveredTime;
  int messageReadTime;
  String messageSentUTCTime;
  String messageDeliveredUTCTime;
  String messageReadUTCTime;
  String messageStatus;
  int isReply;
  String replyToMessageId;
  String originalMessage;
  String originalMessageSenderType;
  String originalMessageSenderName;
  String originalMessageSenderId;
  String originalMessageAttachment;
  String originalMessageAttachmentType;
  String originalMessageAttachmentMIMEType;
  String originalMessageAttachmentName;
  String originalMessageAttachmentThumbnail;
  String originalConversationId;
  int isForwarded;
  String forwardedFromMessageId;
  String flagCode;
  String flagName;
  String flagColorCode;
  String flagIcon;
  String messageDataType;
  String messageType;
  String messageSubType;
  String createdOn;
  int isBroadcastType;
  int isUploading;
  int isFailed = 0;

  MessagePayloadDatabase(
      {this.isUploading,
      this.isFailed,
      this.date,
      this.messageToId,
      this.messageToType,
      this.updatedDateTime,
      this.updatedDateByType,
      this.updatedDateById,
      this.sId,
      this.isGroupConversation,
      this.conversationId,
      this.myConversationId,
      this.mcId,
        this.allRoomsId,
        this.eventId,
      this.messageId,
      this.message,
      this.messageAttachment,
      this.messageAttachmentThumbnail,
      this.messageAttachmentType,
      this.messageAttachmentMIMEType,
      this.messageAttachmentName,
      this.messageSentByName,
      this.messageAction,
      this.messageByType,
      this.messageById,
      this.messageSentTime,
      this.messageDeliveredTime,
      this.messageReadTime,
      this.messageSentUTCTime,
      this.messageDeliveredUTCTime,
      this.messageReadUTCTime,
      this.messageStatus,
      this.isReply,
      this.replyToMessageId,
      this.originalMessage,
      this.originalMessageSenderType,
      this.originalMessageSenderName,
      this.originalMessageSenderId,
      this.originalMessageAttachment,
      this.originalMessageAttachmentType,
      this.originalMessageAttachmentMIMEType,
      this.originalMessageAttachmentName,
      this.originalMessageAttachmentThumbnail,
      this.originalConversationId,
      this.isForwarded,
      this.forwardedFromMessageId,
      this.flagCode,
      this.flagName,
      this.flagColorCode,
      this.flagIcon,
      this.messageDataType,
      this.messageType,
      this.messageSubType,
      this.createdOn,
      this.isBroadcastType});

  MessagePayloadDatabase.fromJson(Map<String, dynamic> json) {
    messageToId = json['messageToId'];
    date= json['date'];
    isFailed = json['isFailed'];
    isUploading = json['isUploading'];
    messageToType = json['messageToType'];
    updatedDateTime = json['updatedDateTime'];
    updatedDateByType = json['updatedDateByType'];
    updatedDateById = json['updatedDateById'];
    allRoomsId=json['allRoomsId'];
    eventId=json['eventId'];
    sId = json['_id'];
    isGroupConversation = json['isGroupConversation'];
    conversationId = json['conversationId'];
    myConversationId = json['myConversationId'];
    mcId = json['mcId'];
    messageId = json['messageId'];
    message = json['message'];
    messageAttachment = json['messageAttachment'];
    messageAttachmentThumbnail = json['messageAttachmentThumbnail'];
    messageAttachmentType = json['messageAttachmentType'];
    messageAttachmentMIMEType = json['messageAttachmentMIMEType'];
    messageAttachmentName = json['messageAttachmentName'];
    messageSentByName = json['messageSentByName'];
    messageAction = json['messageAction'];
    messageByType = json['messageByType'];
    messageById = json['messageById'];
    messageSentTime = json['messageSentTime'];
    messageDeliveredTime = json['messageDeliveredTime'];
    messageReadTime = json['messageReadTime'];
    messageSentUTCTime = json['messageSentUTCTime'];
    messageDeliveredUTCTime = json['messageDeliveredUTCTime'];
    messageReadUTCTime = json['messageReadUTCTime'];
    messageStatus = json['messageStatus'];
    isReply = json['isReply'];
    replyToMessageId = json['replyToMessageId'];
    originalMessage = json['originalMessage'];
    originalMessageSenderType = json['originalMessageSenderType'];
    originalMessageSenderName = json['originalMessageSenderName'];
    originalMessageSenderId = json['originalMessageSenderId'];
    originalMessageAttachment = json['originalMessageAttachment'];
    originalMessageAttachmentType = json['originalMessageAttachmentType'];
    originalMessageAttachmentMIMEType =
        json['originalMessageAttachmentMIMEType'];
    originalMessageAttachmentName = json['originalMessageAttachmentName'];
    originalMessageAttachmentThumbnail =
        json['originalMessageAttachmentThumbnail'];
    originalConversationId = json['originalConversationId'];
    isForwarded = json['isForwarded'];
    forwardedFromMessageId = json['forwardedFromMessageId'];
    flagCode = json['flagCode'];
    flagName = json['flagName'];
    flagColorCode = json['flagColorCode'];
    flagIcon = json['flagIcon'];
    messageDataType = json['messageDataType'];
    messageType = json['messageType'];
    messageSubType = json['messageSubType'];
    createdOn = json['createdOn'];
    isBroadcastType = json['isBroadcastType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isUploading'] = this.isUploading;
    data['messageToId'] = this.messageToId;
    data['date']=this.date;
    data['allRoomsId']=this.allRoomsId;
    data['eventId']=this.eventId;
    data['isFailed'] = this.isFailed;
    data['messageToType'] = this.messageToType;
    data['updatedDateTime'] = this.updatedDateTime;
    data['updatedDateByType'] = this.updatedDateByType;
    data['updatedDateById'] = this.updatedDateById;
    data['_id'] = this.sId;
    data['isGroupConversation'] = this.isGroupConversation;
    data['conversationId'] = this.conversationId;
    data['myConversationId'] = this.myConversationId;
    data['mcId'] = this.mcId;
    data['messageId'] = this.messageId;
    data['message'] = this.message;
    data['messageAttachment'] = this.messageAttachment;
    data['messageAttachmentThumbnail'] = this.messageAttachmentThumbnail;
    data['messageAttachmentType'] = this.messageAttachmentType;
    data['messageAttachmentMIMEType'] = this.messageAttachmentMIMEType;
    data['messageAttachmentName'] = this.messageAttachmentName;
    data['messageSentByName'] = this.messageSentByName;
    data['messageAction'] = this.messageAction;
    data['messageByType'] = this.messageByType;
    data['messageById'] = this.messageById;
    data['messageSentTime'] = this.messageSentTime;
    data['messageDeliveredTime'] = this.messageDeliveredTime;
    data['messageReadTime'] = this.messageReadTime;
    data['messageSentUTCTime'] = this.messageSentUTCTime;
    data['messageDeliveredUTCTime'] = this.messageDeliveredUTCTime;
    data['messageReadUTCTime'] = this.messageReadUTCTime;
    data['messageStatus'] = this.messageStatus;
    data['isReply'] = this.isReply;
    data['replyToMessageId'] = this.replyToMessageId;
    data['originalMessage'] = this.originalMessage;
    data['originalMessageSenderType'] = this.originalMessageSenderType;
    data['originalMessageSenderName'] = this.originalMessageSenderName;
    data['originalMessageSenderId'] = this.originalMessageSenderId;
    data['originalMessageAttachment'] = this.originalMessageAttachment;
    data['originalMessageAttachmentType'] = this.originalMessageAttachmentType;
    data['originalMessageAttachmentMIMEType'] =
        this.originalMessageAttachmentMIMEType;
    data['originalMessageAttachmentName'] = this.originalMessageAttachmentName;
    data['originalMessageAttachmentThumbnail'] =
        this.originalMessageAttachmentThumbnail;
    data['originalConversationId'] = this.originalConversationId;
    data['isForwarded'] = this.isForwarded;
    data['forwardedFromMessageId'] = this.forwardedFromMessageId;
    data['flagCode'] = this.flagCode;
    data['flagName'] = this.flagName;
    data['flagColorCode'] = this.flagColorCode;
    data['flagIcon'] = this.flagIcon;
    data['messageDataType'] = this.messageDataType;
    data['messageType'] = this.messageType;
    data['messageSubType'] = this.messageSubType;
    data['createdOn'] = this.createdOn;
    data['isBroadcastType'] = this.isBroadcastType;
    return data;
  }
}
