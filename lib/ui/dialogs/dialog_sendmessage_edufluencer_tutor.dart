import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/messenger_module/entities/create_conversation_response.dart';
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/edufluencer_list.dart';
import 'package:oho_works_app/models/edufluencer_tutor_create_models.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EdufluencerTutorDialog extends StatefulWidget {
  final EdufluencerListItem edufluncerItem;
  final String userName;
  final String userId;
  EdufluencerTutorDialog({Key key,
     this.edufluncerItem,
     this.userName,
     this.userId,
})
      : super(key: key);

  _EdufluencerTutorDialog createState() =>
      _EdufluencerTutorDialog(edufluncerItem,userId,userName);
}
// ignore: must_be_immutable
class _EdufluencerTutorDialog extends State<EdufluencerTutorDialog> {
  final EdufluencerListItem edufluncerItem;
  final String userId;
  BuildContext context;
  String conversationId;
  String mcId;
  String myConversationId;
  bool isLoading=false;
  SocketService socketService = locator<SocketService>();
  String conversationWithId;
  String todayDate;
  String conversationWithType = "person";
  String userName;
  final messageController = TextEditingController();

  _EdufluencerTutorDialog(this.edufluncerItem, this.userId, this.userName);

  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    this.context = context;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).translate('send_message'),
              style: styleElements
                  .headline6ThemeScalable(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HexColor(AppColors.appColorBackground)),
              child: TextField(
                maxLines: 6,
                controller: messageController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context).translate('enter_text'),
                    hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty)
                      createConversation(messageController.text);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('send'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Padding(
                    padding: const EdgeInsets.only(left:16.0,right: 16.0),
                    child: SizedBox(
                      height: 20,
                        width: 20,
                        child: CircularProgressIndicator()),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  onError(dynamic payload) {
    log("error        +" + jsonEncode(payload));

  }
  void createConversation(String message) async {

    setState(() {
      isLoading=true;
    });
    if (socketService.getSocket() != null) {
      socketService.getSocket().on('message_error', onError);
    }
    ConnectionItem connectionItem = ConnectionItem();
    connectionItem.isGroupConversation = false;
    connectionItem.connectionOwnerId = userId;
    connectionItem.connectionOwnerType = "person";
    connectionItem.connectionCategory = "contact";
    connectionItem.connectionType = "person";
    connectionItem.connectionName = edufluncerItem.name ?? "";
    connectionItem.connectionMobile = "";
    connectionItem.connectionEmail = "";
    connectionItem.connectionProfileThumbnailUrl = "";
    connectionItem.connectionId = edufluncerItem.personId.toString(); // edufluncerItem.id.toString();

    Calls()
        .call(jsonEncode(connectionItem), context, Config.CREATE_CONVERSATION)
        .then((value) async {
      if (value != null) {
        try {
          var data = CreateConversationResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            if (data != null && data.rows != null && data.rows.length > 0) {
              conversationId = data.rows[0].conversationId;
              conversationWithId = data.rows[0].conversationWithTypeId;
              conversationWithType = data.rows[0].conversationWithType;
              mcId = data.rows[0].mcId;
              myConversationId = data.rows[0].sId;

              addConversation(data.rows[1], message);
              print(
                  "success=======================================================================");
            }
          } else {
            setState(() {
              isLoading=false;
            });
          }
        } catch (e) {
          log(e +
              "error in create conversation==========================================================");
        }
      }
    }).catchError((onError) {});
  }

  addConversation(dynamic payload, String message) async {
    log("add_conversation--" + jsonEncode(payload));
    if (socketService.socket.connected) {
      socketService.getSocket().emit('add_conversation', payload);
      socketService.getSocket().emit('join', conversationId);
      todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final body =
          jsonEncode({"message": message, "edufluencer_id": edufluncerItem.id});
      MessagePayloadDatabase messageData =
           createMessage(body, null, null);
      emitMessage(getMessagePayload(messageData));
    }
    else{
      setState(() {
        isLoading=true;
      });
    }
  }

  emitMessage(dynamic payload) {
    try {
      if (socketService.getSocket() != null &&
          socketService.getSocket().connected) {
        log("chat_message+++" + jsonEncode(payload));
        socketService.getSocket().emit('chat_message', payload);

        create();
      }
    } catch (e) {
      log(e);
      setState(() {
        isLoading=true;
      });
    }
  }

  MessagePayloadDatabase createMessage(
      String value, String path, String mimeType) {
    return new MessagePayloadDatabase(
      myConversationId: myConversationId,
      message: value,
      date: todayDate,
      allRoomsId: null,
      eventId: null,
      isGroupConversation: 0,
      conversationId: conversationId,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      messageAttachment: path ?? "",
      isUploading: path != null ? 1 : 0,
      messageAttachmentType: mimeType ?? "",
      mcId: mcId,
      messageToId: conversationWithId,
      messageToType: conversationWithType,
      messageAction: "",
      messageSentUTCTime: "",
      messageDeliveredTime: 0,
      messageDeliveredUTCTime: "",
      messageReadTime: 0,
      messageReadUTCTime: "",
      messageById: userId.toString(),
      messageByType: "person",
      messageSentByName: userName,
      updatedDateTime: 0,
      updatedDateById: "",
      updatedDateByType: "",
      messageSentTime: DateTime.now().millisecondsSinceEpoch,
      messageStatus: "sent",
      isReply: 0,
      replyToMessageId: "",
      originalMessage: "",
      originalMessageSenderType: "",
      originalMessageSenderName: "",
      originalMessageSenderId: "",
      originalMessageAttachment: "",
      originalMessageAttachmentType: "",
      originalMessageAttachmentMIMEType: "",
      originalMessageAttachmentName: "",
      originalMessageAttachmentThumbnail: "",
      originalConversationId: "",
    );
  }

  MessagePayload getMessagePayload(MessagePayloadDatabase messageDataData) {
    MessagePayload message = MessagePayload();
    message.messageAttachmentThumbnail =
        messageDataData.messageAttachmentThumbnail;
    message.allRoomsId = messageDataData.allRoomsId;
    message.eventId = messageDataData.eventId ?? messageDataData.allRoomsId;
    message.messageAttachmentMIMEType =
        messageDataData.messageAttachmentMIMEType;
    message.messageAttachmentName = messageDataData.messageAttachmentName;
    message.date = messageDataData.date;
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
    message.messageDataType = "object";
    message.messageType = "edufluencer";
    message.messageSubType = "request";
    message.createdOn = messageDataData.createdOn;
    message.isGroupConversation = messageDataData.isGroupConversation != null &&
            messageDataData.isGroupConversation == 1
        ? true
        : false;
    message.isReply =
        messageDataData.isReply != null && messageDataData.isReply == 1
            ? true
            : false;
    message.isForwarded =
        messageDataData.isForwarded != null && messageDataData.isForwarded == 1
            ? true
            : false;
    message.isBroadcastType = messageDataData.isBroadcastType != null &&
            messageDataData.isBroadcastType == 1
        ? true
        : false;
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

  void create() {
    final body = jsonEncode({
      "edufluencer_id": edufluncerItem.id,
      "person_id": edufluncerItem.personId,
      "booking_by_type": "person",
      "booking_by_id": int.parse(userId),
      "conversation_id": conversationId
    });
    Calls().call(body, context, Config.EDUFLUENCER_REQUEST).then((value) {
      var response = CreateEdufluencerResponse.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, true);

        ToastBuilder().showToast(
            response.message, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
