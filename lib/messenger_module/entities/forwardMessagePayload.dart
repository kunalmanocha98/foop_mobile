import 'connect_list_response_entity.dart';
import 'messages_response.dart';

class ForwardMessagePayload {
  List<ConnectionItem> toConnectionsList;
  List<MessagePayload> messageList;
  String fromConversationId;
  String forwardedById;
  String forwardedByType;
  String forwardedByName;
  int forwardedTime;
  String forwardMessageId;

  ForwardMessagePayload(
      this.toConnectionsList,
      this.messageList,
      this.fromConversationId,
      this.forwardedById,
      this.forwardedByType,
      this.forwardedByName,
      this.forwardedTime,
    );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forwardedTime'] = this.forwardedTime;
    data['forwardMessageId'] = this.forwardMessageId;
    data['forwardedByName'] = this.forwardedByName;
    data['forwardedByType'] = this.forwardedByType;
    data['forwardedById'] = this.forwardedById;
    data['fromConversationId'] = this.fromConversationId;
    if (this.messageList != null) {
      data['messageList'] = this.messageList.map((v) => v.toJson()).toList();
    }
    if (this.toConnectionsList != null) {
      data['toConnectionsList'] =
          this.toConnectionsList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ForwardMessagePayload.fromJson(Map<String, dynamic> json) {
    forwardMessageId = json['forwardMessageId'];
    forwardedByName = json['forwardedByName'];
    forwardedTime = json['forwardedTime'];
    forwardedByType = json['forwardedByType'];
    forwardedById = json['forwardedById'];
    fromConversationId = json['fromConversationId'];
    if (json['messageList'] != null) {
      toConnectionsList = [];//ConnectionItem>();
      json['messageList'].forEach((v) {
        toConnectionsList.add(new ConnectionItem.fromJson(v));
      });
    }
    if (json['messageList'] != null) {
      messageList = [];//MessagePayload>();
      json['messageList'].forEach((v) {
        messageList.add(new MessagePayload.fromJson(v));
      });
    }
  }
}
