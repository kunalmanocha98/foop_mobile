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

class ChatNotifier extends ValueNotifier<List<MessagePayloadDatabase>> {
  ChatNotifier(this.conversationId, this.userId, this.context, this.db)
      : super(null);
  String conversationId;
  int userId;
  DatabaseHelper db;
  BuildContext context;
  int _pageNumber = 1;
  // bool _hasMorePokemon = true;
  List<MessagePayloadDatabase> _listMessages;
  // bool _loading = false;
  bool isDisposed = false;

  @override
  List<MessagePayloadDatabase> get value => _value;
  List<MessagePayloadDatabase> _value;

  @override
  void dispose() {
    ToastBuilder().showToast(
        "Chat Notifier is disposed",
        context,
        HexColor(AppColors.information));
    isDisposed = true;
    super.dispose();
  }

  @override
  set value(List<MessagePayloadDatabase> newValue) {
    _value = newValue;
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<void> reload() async {
    _listMessages = <MessagePayloadDatabase>[];
    _pageNumber = 1;
    await getMessages(_pageNumber);
  }

  Future<void> getMore() async {
    // _loading = true;
    await getMessages(_pageNumber);
    // _loading = false;
  }

  Future<void> getOlderMessages() async {
    _listMessages ??= <MessagePayloadDatabase>[];
    _listMessages = await db.getMessages(conversationId);
    print(_listMessages.length.toString() +
        "older messages ========================================================================================");
    value = _listMessages;
  }

  Future<void> uploadPost(MessagePayloadDatabase message, DatabaseHelper db,
      String conversationId) async {
    _listMessages ??= <MessagePayloadDatabase>[];
    await db.insertMessage(message);
    getOlderMessages();
  }

  setPostList(List<MessagePayloadDatabase> postList) {
    value = postList;
  }

  Future<void> getMessages(int page) async {
    _listMessages ??= <MessagePayloadDatabase>[];
    int pageNumber = page;
    MessagesPayload messagesPayload = MessagesPayload();
    messagesPayload.conversationId = conversationId;
    messagesPayload.conversationOwnerType = "person";
    messagesPayload.conversationOwnerId = userId.toString();
    messagesPayload.pageSize = "50";
    messagesPayload.pageNumber = pageNumber.toString();
    Calls()
        .call(jsonEncode(messagesPayload), context, Config.LIST_MESSAGES)
        .then((v) async {
      if (v != null) {
        var data = MessagesResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows.isNotEmpty) {
            if (_pageNumber == 1) _listMessages.clear();
            pageNumber++;
            _pageNumber = pageNumber;
            try {
              for (var item in data.rows) {

                            _listMessages.add(getMessagePayload(item));
                           saveData(getMessagePayload(item));
                          }
            } catch (e) {
              print(e);
            }

            value = _listMessages;
          }
        }
      } else {}
    }).catchError((onError) {});
  }

  Future<void> saveData(MessagePayloadDatabase messageDataData) async {
    var message =
    await db.getMessageItem(conversationId, messageDataData.messageId);

    if (message != null) {
      print("update"+"----------------------------------------------------------------------------");
      await db.updateMessage(messageDataData);
    } else
      await db.insertMessage(messageDataData);
  }

  MessagePayloadDatabase getMessagePayload(MessagePayload messageDataData) {
    MessagePayloadDatabase message = MessagePayloadDatabase();

    message.messageAttachmentThumbnail = messageDataData.messageAttachmentThumbnail;
    message.messageAttachmentMIMEType = messageDataData.messageAttachmentMIMEType;
    message.messageAttachmentName = messageDataData.messageAttachmentName;
    message.replyToMessageId = messageDataData.replyToMessageId;
    message. originalMessage  = messageDataData.originalMessage;
    message. originalMessageSenderType = messageDataData.originalMessageSenderType;
    message. originalMessageSenderName = messageDataData.originalMessageSenderName;
    message. originalMessageSenderId = messageDataData.originalMessageSenderId;
    message. originalMessageAttachment = messageDataData.originalMessageAttachment;
    message. originalMessageAttachmentType = messageDataData.originalMessageAttachmentType;
    message. originalMessageAttachmentMIMEType = messageDataData.originalMessageAttachmentMIMEType;
    message. originalMessageAttachmentName = messageDataData.originalMessageAttachmentName;
    message. originalMessageAttachmentThumbnail = messageDataData.originalMessageAttachmentThumbnail;
    message. originalConversationId = messageDataData.originalConversationId;
    message. forwardedFromMessageId = messageDataData.forwardedFromMessageId;
    message. flagCode = messageDataData.flagCode;
    message. flagName = messageDataData.flagName;
    message. flagColorCode = messageDataData.flagColorCode;
    message. flagIcon = messageDataData.flagIcon;
    message. messageDataType = messageDataData.messageDataType;
    message. messageType = messageDataData.messageType;
    message. messageSubType = messageDataData.messageSubType;
    message. createdOn = messageDataData.createdOn;
    message.isGroupConversation = messageDataData.isGroupConversation!=null&&messageDataData.isGroupConversation ? 1 : 0;
    message.isReply = messageDataData.isReply!=null&&messageDataData.isReply ? 1 : 0;
    message.isForwarded = messageDataData.isForwarded!=null&&messageDataData.isForwarded ? 1 : 0;
    message.isBroadcastType = messageDataData.isBroadcastType!=null&&messageDataData.isBroadcastType ? 1 : 0;
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
