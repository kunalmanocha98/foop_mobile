import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/messenger_module/entities/conversation_list_payload.dart';
import 'package:oho_works_app/messenger_module/entities/conversation_list_reponse.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
class ConversationNotifier extends ChangeNotifier {
  int _pageNumber = 1;
  // bool _hasMorePokemon = true;
  List<ConversationItemDb>? _listConversations;
  // bool _loading = false;

  Future<void> reload(DatabaseHelper db, int? userId, int? instituteId,
      BuildContext context, IO.Socket? socket) async {
    _listConversations = <ConversationItemDb>[];
    _pageNumber = 1;
    await getConversations(_pageNumber, db, userId, instituteId, context,socket);
  }

  Future<void> getMore(DatabaseHelper db, int? userId, int? instituteId,
      BuildContext context,IO.Socket? socket) async {
    // _loading = true;
    await getConversations(_pageNumber, db, userId, instituteId, context,socket);
    // _loading = false;
  }
  List<ConversationItemDb>? getConversationList() {
    return _listConversations;
  }
  Future<void> getOlderConversations(DatabaseHelper db) async {
    _listConversations ??= <ConversationItemDb>[];
    _listConversations = await db.allConversations();

    notifyListeners();
  }
  Future<void> getSearchedList(DatabaseHelper db,String search) async {
    _listConversations ??= <ConversationItemDb>[];
    _listConversations = await db.searchedList(search);

    notifyListeners();
  }
  Future<void> uploadPost(
      ConversationItem conversationTableData, DatabaseHelper db) async {
    _listConversations ??= <ConversationItemDb>[];
    await db.insertConversation(getDbItem(conversationTableData));
    _listConversations = await db.allConversations();
    notifyListeners();
  }

  Future<void> getConversations(int page, DatabaseHelper db, int? userId,
      int? instituteId, BuildContext context, IO.Socket? socket) async {
    _listConversations ??= <ConversationItemDb>[];
    int pageNumber = page;
    ConversationListPayload conversationListPayload = ConversationListPayload();
    conversationListPayload.conversationOwnerId = userId.toString();
    conversationListPayload.conversationOwnerType = "person";
    conversationListPayload.pageNumber = pageNumber;
    conversationListPayload.personId = userId.toString();
    conversationListPayload.institutionId = instituteId.toString();
    conversationListPayload.pageSize = 50;

    Calls()
        .call(jsonEncode(conversationListPayload), context,
            Config.LIST_CONVERSATION)
        .then((v) async {
      if (v != null) {
        var data = ConversationListResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            if (_pageNumber == 1) _listConversations!.clear();
            pageNumber++;
            _pageNumber = pageNumber;
            for (var item in data.rows!) {
              _listConversations!.add(getDbItem(item));
              await saveData(item, db);
            }
           notifyListeners();

            if(socket!=null)
            socket.emit('join', userId);
          }
        }
      } else {}
    }).catchError((onError) {});
  }

  Future<void> saveData(
      ConversationItem conversationItem, DatabaseHelper db) async {
    var message = await db.getConversationItem(conversationItem.conversationId);

    if (message != null) {
      print("update ""=1123 -----------------------------------------------------------"+(message.isOnline==1?"online":"offline"));
      if(message.isOnline!=null && message.isOnline==1)
        conversationItem.isOnline=1;
      await db.updateConversationData(getDbItem(conversationItem));
      getOlderConversations(db);
    } else {
      print("new ""=1123 -----------------------------------------------------------");
      await db.insertConversation(getDbItem(conversationItem));
      getOlderConversations(db);
    }
  }
  ConversationItemDb getDbItem(ConversationItem conversationItem)
  {
    ConversationItemDb conversationItemDb=ConversationItemDb();
    conversationItemDb.sId=conversationItem.sId;
    conversationItemDb.isOnline=conversationItem.isOnline;
    conversationItemDb.conversationOwnerType=conversationItem.conversationOwnerType;
    conversationItemDb.conversationOwnerId=conversationItem.conversationOwnerId;
  conversationItemDb.mcId=conversationItem.mcId;
  conversationItemDb.isGroupConversation=conversationItem.isGroupConversation!?1:0;
    conversationItemDb.isRoomAvailable=conversationItem.isRoomAvailable!?1:0;
    conversationItemDb.conversationId=conversationItem.conversationId;
    conversationItemDb.conversationWithType=conversationItem.conversationWithType;
    conversationItemDb.conversationWithTypeId=conversationItem.conversationWithTypeId;
  conversationItemDb.conversationWithName=conversationItem.conversationWithName;
  conversationItemDb.conversationImageThumbnail=conversationItem.conversationImageThumbnail;
    conversationItemDb.conversationImage=conversationItem.conversationImage;
    conversationItemDb.conversationName=conversationItem.conversationName;
    conversationItemDb.lastMessageByType=conversationItem.lastMessageByType;
  conversationItemDb.lastMessageById=conversationItem.lastMessageById;
  conversationItemDb.lastMessageByName=conversationItem.lastMessageByName;
    conversationItemDb.lastMessage=conversationItem.lastMessage;
    conversationItemDb.lastMessageIcon=conversationItem.lastMessageIcon;
    conversationItemDb.lastMessageTime=conversationItem.lastMessageTime;
  conversationItemDb.lastMessageUTCTime=conversationItem.lastMessageUTCTime;

  conversationItemDb.unreadCount=conversationItem.unreadCount;
  return conversationItemDb;
  }
  Future<void> updateStatus(String userId, int status, DatabaseHelper db) async {
    await db.updateStatus(userId, status);
    _listConversations ??= <ConversationItemDb>[];
    _listConversations = await db.allConversations();
    notifyListeners();
  }

  Future<void> updateUnreadCount(

      MessagePayload messagePayload, DatabaseHelper db) async {

    var message = await db.getConversationItem(messagePayload.conversationId);
    if (message != null) {
      int unreadCount = message.unreadCount ?? 0;
      unreadCount = unreadCount + 1;
      message.conversationImageThumbnail = message.conversationImageThumbnail;
      message.lastMessageTime = messagePayload.messageSentTime;
      message.unreadCount = unreadCount;
      message.lastMessage = messagePayload.message;
      print("update count --------------------------------------------------------"+message.unreadCount.toString());
      await db.updateConversationData(message);
      await db.makeUnreadCountZero(message.conversationId,unreadCount);
      getOlderConversations(db);
    }
  }
}
