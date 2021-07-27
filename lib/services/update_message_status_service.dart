
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UpdateMessageStatusService {
  // final NavigationService _navigationService = locator<NavigationService>();

  void updateMessagesStatus(DatabaseHelper db,bool isVisible, String conversationId,
      String userId, IO.Socket socket,String messageToId,String messageWithType) async {
    List<MessagePayloadDatabase>? listMessages =
        await db.getMessages(conversationId);

    if (listMessages != null && listMessages.length > 0) {
      for (var item in listMessages) {
        if (item.messageById!=userId &&( item.messageStatus != null && item.messageStatus == "sent" || item.messageStatus == "delivered")) {
          MessagePayload messageDataData = getMessagePayload(item,userId,messageToId,messageWithType);
          socket.emit('update_message', messageDataData);
          item.messageStatus = "read";
          item.updatedDateById = userId.toString();
          item.updatedDateByType = "person";
          item.updatedDateTime = DateTime.now().millisecondsSinceEpoch;
          await db.updateMessage(item);
          await db.makeUnreadCountZero(conversationId, 0);
        }
      }
    }
  }

  MessagePayload getMessagePayload(MessagePayloadDatabase messageDataData,String userId,String messageToId,String messageWithType) {
    MessagePayload message = MessagePayload();
    message.isGroupConversation = messageDataData.isGroupConversation != null &&
            messageDataData.isGroupConversation == 1
        ? true
        : false;
    message.myConversationId = messageDataData.myConversationId;
    message.conversationId = messageDataData.conversationId;
    message.message = messageDataData.message;
    message.messageId = messageDataData.messageId;
    message.messageAttachment = messageDataData.messageAttachment;
    message.messageAttachmentType = messageDataData.messageAttachmentType;
    message.mcId = messageDataData.mcId;
    message.messageToId = userId;
    message.messageToType ="person";
    message.messageReadUTCTime = messageDataData.messageReadUTCTime;
    message.messageSentByName = messageDataData.messageSentByName;
    message.messageById = messageDataData.messageById;
    message.messageByType = messageDataData.messageByType;
    message.messageSentTime = messageDataData.messageSentTime;
    message.messageAction = messageDataData.messageAction;
    message.messageSentUTCTime = messageDataData.messageSentUTCTime;
    message.messageDeliveredTime = messageDataData.messageDeliveredTime;
    message.messageDeliveredUTCTime = messageDataData.messageDeliveredUTCTime;
    message.messageReadTime = messageDataData.messageReadTime;
    message.messageStatus = "read";
    message.updatedDateById = userId.toString();
    message.updatedDateByType = "person";
    message.updatedDateTime = DateTime.now().millisecondsSinceEpoch;
    return message;
  }
}
