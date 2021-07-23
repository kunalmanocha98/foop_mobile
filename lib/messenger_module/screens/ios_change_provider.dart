import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/messenger_module/entities/message_list_payload.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';

class IosNotifier extends ChangeNotifier {
  BuildContext? context;
  int _pageNumber = 1;
  List<MessagePayloadDatabase>? _listMessages;
  // bool _loading = false;
  bool isDisposed = false;

  List<MessagePayloadDatabase>? get value => _value;
  List<MessagePayloadDatabase>? _value;

  @override
  void dispose() {
    ToastBuilder().showToast(
        "Chat Notifier is disposed", context, HexColor(AppColors.information));
    isDisposed = true;
    super.dispose();
  }

  List<MessagePayloadDatabase>? getMessagesList() {
    return _listMessages;
  }

  Future<void> reload(DatabaseHelper db, String conversationId, int userId,
      String searchValue,int eventId) async {
    print("new convrestaion   starting page call--------------------------------------------------------------------");
    _listMessages = <MessagePayloadDatabase>[];
    _pageNumber = 1;
    await getMessages(_pageNumber, db, conversationId, userId, searchValue,eventId);
  }

  Future<void> getMore(
      DatabaseHelper db, String conversationId, int userId,int eventId) async {
    // _loading = true;
    await getMessages(_pageNumber, db, conversationId, userId, "",eventId);
    // _loading = false;
  }

  Future<void> getOlderMessages(
      DatabaseHelper db, String conversationId, int userId,int eventId) async {
    _listMessages ??= <MessagePayloadDatabase>[];
    if(conversationId!=null)
    _listMessages = await db.getMessages(conversationId);

    notifyListeners();
  }

  Future<void> deleteMessage(
  String id,String conversationId,
    DatabaseHelper db,
  ) async {
    _listMessages ??= <MessagePayloadDatabase>[];
    await db.deleteMessage(id);
    _listMessages = await db.getMessages(conversationId);
    notifyListeners();
  }

  Future<void> getMessages(int page, DatabaseHelper db, String conversationId,
      int userId, String searchValue,int eventId) async {
    _listMessages ??= <MessagePayloadDatabase>[];
    int pageNumber = page;
    MessagesPayload messagesPayload = MessagesPayload();
    messagesPayload.conversationId = conversationId;
    messagesPayload.conversationOwnerType = "person";
    messagesPayload.conversationOwnerId = userId.toString();
    messagesPayload.pageSize = "50";
    messagesPayload.message = searchValue;
    messagesPayload.pageNumber = pageNumber.toString();
    Calls()
        .call(jsonEncode(messagesPayload), context, Config.LIST_MESSAGES)
        .then((v) async {
      if (v != null) {
        var data = MessagesResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            if (_pageNumber == 1) _listMessages!.clear();
            pageNumber++;
            _pageNumber = pageNumber;
            try {
              for (var item in data.rows!) {
                _listMessages!.add(getMessagePayload(item));

                saveData(
                    getMessagePayload(item), db, conversationId, userId, false,eventId);
              }
            } catch (e) {
              print(e);
            }

            notifyListeners();
          }
        }
      } else {}
    }).catchError((onError) {});
  }

  Future<void> saveData(
      MessagePayloadDatabase messageDataData,
      DatabaseHelper db,
      String conversationId,
      int userId,
      bool isUpdate,
      int eventId) async {
    print(messageDataData.messageDeliveredTime.toString());
    var message =
        await db.getMessageItem(conversationId, messageDataData.messageId);
    if (message != null) {
      await db.updateMessage(messageDataData);
    } else {
      await db.insertMessage(messageDataData);
    }
    if (isUpdate) getOlderMessages(db, conversationId, userId,eventId);
  }

  MessagePayloadDatabase getMessagePayload(MessagePayload messageDataData) {
    MessagePayloadDatabase message = MessagePayloadDatabase();
    message.allRoomsId=messageDataData.allRoomsId;
    message.messageAttachmentThumbnail = messageDataData.messageAttachmentThumbnail;
    message.messageAttachmentMIMEType = messageDataData.messageAttachmentMIMEType;
    message.messageAttachmentName = messageDataData.messageAttachmentName;
    message.replyToMessageId = messageDataData.replyToMessageId;
    message.originalMessage = messageDataData.originalMessage;
    message.originalMessageSenderType =
        messageDataData.originalMessageSenderType;
    message.originalMessageSenderName =
        messageDataData.originalMessageSenderName;
    message.originalMessageSenderId = messageDataData.originalMessageSenderId;
    message.originalMessageAttachment =
        messageDataData.originalMessageAttachment;
    message.originalMessageAttachmentType =
        messageDataData.originalMessageAttachmentType;
    message.originalMessageAttachmentMIMEType =
        messageDataData.originalMessageAttachmentMIMEType;
    message.originalMessageAttachmentName =
        messageDataData.originalMessageAttachmentName;
    message.originalMessageAttachmentThumbnail =
        messageDataData.originalMessageAttachmentThumbnail;
    message.originalConversationId = messageDataData.originalConversationId;
    message.forwardedFromMessageId = messageDataData.forwardedFromMessageId;
    message.flagCode = messageDataData.flagCode;
    message.flagName = messageDataData.flagName;
    message.flagColorCode = messageDataData.flagColorCode;
    message.flagIcon = messageDataData.flagIcon;
    message.messageDataType = messageDataData.messageDataType;
    message.messageType = messageDataData.messageType;
    message.messageSubType = messageDataData.messageSubType;
    message.createdOn = messageDataData.createdOn;
    message.isGroupConversation = messageDataData.isGroupConversation != null &&
            messageDataData.isGroupConversation!
        ? 1
        : 0;
    message.isReply =
        messageDataData.isReply != null && messageDataData.isReply! ? 1 : 0;
    message.isForwarded =
        messageDataData.isForwarded != null && messageDataData.isForwarded!
            ? 1
            : 0;
    message.isBroadcastType = messageDataData.isBroadcastType != null &&
            messageDataData.isBroadcastType!
        ? 1
        : 0;
    message.myConversationId = messageDataData.myConversationId;
    message.conversationId = messageDataData.conversationId;
    message.message = messageDataData.message;
    message.messageId = messageDataData.messageId;
    message.messageAttachment = messageDataData.messageAttachment;
    message.messageAttachmentType = messageDataData.messageAttachmentType;
    message.mcId = messageDataData.mcId;
    message.messageToId = messageDataData.messageToId;
    message.messageToType = messageDataData.messageToType;
    message.messageReadUTCTime = messageDataData.messageReadUTCTime;
    message.messageSentByName = messageDataData.messageSentByName;
    message.messageById = messageDataData.messageById;
    message.messageByType = messageDataData.messageByType;
    message.messageSentTime = messageDataData.messageSentTime;
    message.messageStatus = messageDataData.messageStatus;
    message.messageAction = messageDataData.messageAction;
    message.messageSentUTCTime = messageDataData.messageSentUTCTime;
    message.messageDeliveredTime = messageDataData.messageDeliveredTime;
    message.messageDeliveredUTCTime = messageDataData.messageDeliveredUTCTime;
    message.messageReadTime = messageDataData.messageReadTime;
    message.updatedDateTime = messageDataData.updatedDateTime;
    message.updatedDateById = messageDataData.updatedDateById;
    message.updatedDateByType = messageDataData.updatedDateByType;
    return message;
  }
}
