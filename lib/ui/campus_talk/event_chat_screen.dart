import 'package:oho_works_app/messenger_module/entities/conversation_list_reponse.dart';
import 'package:oho_works_app/messenger_module/screens/chat_history_page.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:flutter/material.dart';

class EventChatScreenPage extends StatefulWidget {
  final int participantId;
  final int eventId;
  final String  eventName;
  final String eventImage;
final    String conversationId;
  EventChatScreenPage(
      {Key key,
        this.participantId, this.eventId,this.eventName,this.eventImage,this.conversationId})
      : super(key: key);
  @override
  EventChatScreenPageState createState() =>
      EventChatScreenPageState(participantId: participantId, eventId: eventId,eventImage:eventImage,eventName:eventName,conversationId:conversationId);
}

class EventChatScreenPageState extends State<EventChatScreenPage> {
  int participantId;
  int eventId;
  String  eventName;
  String eventImage;
  String conversationId;
  GlobalKey<ChatHistoryPageState> chatPageKey = GlobalKey();
  EventChatScreenPageState({this.participantId, this.eventId,this.eventName,this.eventImage,this.conversationId});

  @override
  Widget build(BuildContext context) {
    return ChatHistoryPage(
      key: chatPageKey,
      conversationItem: conversationId!=null?ConversationItemDb(conversationId:conversationId,conversationWithTypeId:eventId.toString(),conversationImage:eventImage,conversationWithName: eventName,isGroupConversation: 1,eventId:eventId ):null,
      isHeaderVisible: false,
      connectionItem:null,
      roomListItem:conversationId==null?  RoomListItem( roomProfileImageUrl:eventImage,roomName:eventName,isEvent: true,id: eventId):null,
      refreshList: () {},
      callBack: () {},
      type:"normal",
      userStatus: "Online",
    );
  }
  
  void refresh(String conversationId)
  {

    setState(() {
      chatPageKey.currentState.refresh(conversationId);
    });
  }

  void setCurrentVisible(bool isChatVisible)
  {

    setState(() {
      chatPageKey.currentState.updateCurrentVisible(isChatVisible);
    });
  }
}
