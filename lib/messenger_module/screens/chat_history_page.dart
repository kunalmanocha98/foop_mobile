import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/chat_tool_bar.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_chat_footer.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/messenger_module/entities/conversation_list_reponse.dart';
import 'package:oho_works_app/messenger_module/entities/create_conversation_response.dart';
import 'package:oho_works_app/messenger_module/entities/deletemessage.dart';
import 'package:oho_works_app/messenger_module/entities/forwardMessagePayload.dart';
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/messenger_module/entities/typing_payload.dart';
import 'package:oho_works_app/messenger_module/entities/user_status.dart';
import 'package:oho_works_app/messenger_module/screens/ios_change_provider.dart';
import 'package:oho_works_app/messenger_module/screens/user_room_selection_page.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/edufluencer_data.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/request_response.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/chat/chat_call_models.dart';
import 'package:oho_works_app/models/comment_list_entity.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/services/update_message_status_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/imgevideoFullScreenViewPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/custom_preview_link.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../bubble_type.dart';
import '../chat_bubble.dart';
import '../chat_bubble_clipper_2.dart';
import 'delete_message_dialog.dart';
import 'ios_change_provider.dart';

// ignore: must_be_immutable
class ChatHistoryPage extends StatefulWidget {
  ConnectionItem? connectionItem;
  RoomListItem ?roomListItem;
  ConversationItemDb? conversationItem;
  IO.Socket? socket;
  Null Function()? callBack;
  String? userStatus;
  Null Function()? callBackNew;
  Null Function()? refreshList;
  Null Function()? homePageUnreadCount;
  bool ?isHeaderVisible;
  String? type;
  String? personId;
  bool? isVisible;

  @override
  ChatHistoryPageState createState() => ChatHistoryPageState(
    conversationItem:conversationItem,
    connectionItem:connectionItem,
    callBack:callBack,
    userStatus:userStatus,
    callBackNew:callBackNew,
    roomListItem:roomListItem,
    refreshList:refreshList,
    homePageUnreadCount:homePageUnreadCount,
    type:type,
    personId:personId,
  );

  ChatHistoryPage(
      {required Key key,
        this.conversationItem,
        this.connectionItem,
        this.socket,
        this.personId,
        this.type,
        this.callBack,
        this.refreshList,
        this.roomListItem,
        this.callBackNew,
        this.userStatus,
        this.homePageUnreadCount,
        this.isVisible,
        this.isHeaderVisible = true})
      : super(key: key);
}

class ChatHistoryPageState extends State<ChatHistoryPage> {
  final db = DatabaseHelper.instance;
  Null Function()? callBack;
  ConversationItemDb? conversationItem;
  ConnectionItem? connectionItem;
  SocketService? socketService = locator<SocketService>();
  int? userId;
  String ?personId;
  String? type;
  int? allRoomsId;
  int? eventId=0;
  Null Function()? refreshList;
  String? currentMessageId;
  RoomListItem? roomListItem;
  String ?todayDate;
  Null Function()? callBackNew;
  bool? isNewConversation = false;
  String? userName;
  bool? isRequestApiCalled = false;
  int? callNumber = 0;
  bool? isUserOnCurrentPage = true;
  final UpdateMessageStatusService ?updateMessageService =
  locator<UpdateMessageStatusService>();
  String? conversationWithId;
  String ?conversationWithType = "person";
  String ?conversationId;
  String ?mcId;
  List<MessagePayloadDatabase>? chatList;
  SharedPreferences? prefs;
  String? status = "";
  String? userStatus;
  bool? isOnline = false;
  bool? isLoading = false;
  MessagePayloadDatabase? replyData;
  IosNotifier? _iosNotifier;
  Null Function()? homePageUnreadCount;
  String? myConversationId;
  bool? isGroupConversation = false;
  bool? isRoomAvailable = true;
  String? imageUrl = "";
  GlobalKey<PaginatorState> ?paginatorKey = GlobalKey();
  String? conversationWithName = "";
  int? pageNumber = 1;
  bool ?isAlreadySent = false;
  bool ?isReply = false;
  bool ?isSearch = false;
  String? date = "";
  String? linkPreview;
  EventBus? eventbus = locator<EventBus>();
  AudioSocketService ?audioSocketService = locator<AudioSocketService>();
  EdufluencerRequestData? edufluencerRequestData;
  GlobalKey<ChatHistoryPageState> ch = GlobalKey();
  List<CommentsItem>? listComments = [];
  final commentController = TextEditingController();
  TextStyleElements? styleElements;
  GlobalKey<appChatFooterState>? chatFooterKey = GlobalKey();
  bool ?isVisible;

  ChatHistoryPageState(
     { this.conversationItem,
      this.connectionItem,
      this.callBack,
      this.userStatus,
      this.callBackNew,
      this.roomListItem,
      this.refreshList,
      this.homePageUnreadCount,
      this.type,
      this.personId,}
      );

  @override
  void initState() {
    status = userStatus;
    isUserOnCurrentPage = true;
    isVisible=widget.isVisible;
    connectToServer();

    WidgetsBinding.instance!.addPostFrameCallback((_) => setPref());
    todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startConversationExisting() async {
    isRoomAvailable = conversationItem != null &&
        conversationItem!.isRoomAvailable != null &&
        conversationItem!.isRoomAvailable == 1;
    conversationId = conversationItem!.conversationId;
    conversationWithId = conversationItem!.conversationWithTypeId;
    conversationWithType = conversationItem!.conversationWithType;
    isGroupConversation =
    conversationItem!.isGroupConversation == 1 ? true : false;
    if (conversationItem!.eventId == null)
      allRoomsId = int.parse(conversationItem!.conversationWithTypeId!);
    if (conversationItem!.eventId != null)
      eventId = int.parse(conversationItem!.conversationWithTypeId!);
    mcId = conversationItem!.mcId;
    myConversationId = conversationItem!.sId;
    imageUrl = conversationItem!.conversationImageThumbnail;
    conversationWithName = conversationItem!.conversationName;
    await db.makeUnreadCountZero(conversationId, 0);
    if (socketService!.getSocket() != null &&
        socketService!.getSocket()!.connected) {
      joinChat(conversationId);
      joinChat(userId);
    } else {}
    if (conversationId != null)
      updateMessageService!.updateMessagesStatus(
          db,
          isVisible!=null && !isVisible! ? false:true,
          conversationId!,
          userId.toString(),
          socketService!.getSocket()!,
          conversationWithId!,
          conversationWithType!);
    IosNotifier iosNotifier = Provider.of<IosNotifier>(context, listen: false);
    iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
    iosNotifier.reload(db, conversationId!, userId!, "", eventId!);
    setState(() {});
  }

  void startNewConversation() {
    setState(() {
      isRoomAvailable = true;
      imageUrl = connectionItem!.connectionProfileThumbnailUrl ?? "";
      conversationWithName = connectionItem!.connectionName ?? "";
    });
    if (connectionItem!.isGroupConversation != null &&
        connectionItem!.isGroupConversation!) {
      setState(() {
        isGroupConversation = true;
        allRoomsId = connectionItem!.allRoomsId;
        createConversation(true, false);
      });
    } else
      createConversation(false, false);
  }

  Future<void> setPref() async {
   prefs = await SharedPreferences.getInstance();
    userId = prefs!.getInt(Strings.userId);
    userName = prefs!.getString(Strings.userName);
    await db.makeUnreadCountZero(conversationId, 0);
    if (type != null) {
      switch (type) {
        case "normal":
          if (connectionItem != null) {
            startNewConversation();
          } else if (conversationItem != null) {
           startConversationExisting();
          } else {
            isRoomAvailable = true;
            if (roomListItem != null) {
              setState(() {
                isGroupConversation = true;
                imageUrl = roomListItem!.roomProfileImageUrl ?? "";
                conversationWithName = roomListItem!.roomName ?? "";
              });
              connectionItem = ConnectionItem();
              if (roomListItem!.isEvent != null && roomListItem!.isEvent!)
                createConversation(false, true);
              else
                createConversation(true, false);
            }
          }
          break;
        case "notification":
          conversationItem = await db.getConversationItemFromPeronId(personId!);
          if (conversationItem != null) {
            startConversationExisting();
          } else {
            getPersonProfile(context, personId!);
          }
// using personid check id there is laredy a conversation

          // get user data using perion profile api

          // create conversation

          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    _iosNotifier = Provider.of<IosNotifier>(context);

    return WillPopScope(
      // ignore: missing_return
        onWillPop: () {
          if (isSearch!) {
            setState(() {
              isSearch = false;
              _iosNotifier!.getOlderMessages(
                  db, conversationId!, userId!, eventId!);
            });
          } else {
            setState(() {
              isUserOnCurrentPage = false;
            });
            Navigator.of(context).pop();
            if (homePageUnreadCount != null) homePageUnreadCount!();
          }
          return new Future(() => false);
        },
        child: SafeArea(
          child: Scaffold(
              backgroundColor: HexColor(AppColors.chatBackGround),
              appBar: widget.isHeaderVisible!
                  ? AppBarWithProfileChat(
                isNotificationVisible: false,
                roomId: allRoomsId,
                roomName: userName,
                showCallbuttons: !isGroupConversation!,
                onVideoCallback: () {
                  checkAndInitiateCall('video');
                },
                onCallCallback: () {
                  checkAndInitiateCall('voice');
                },
                callBack: () {
                  if (isSearch!) {
                    setState(() {
                      isSearch = false;
                      _iosNotifier!.getOlderMessages(
                          db, conversationId!, userId!, eventId!);
                    });
                  } else {
                    setState(() {
                      isUserOnCurrentPage = false;
                    });

                    Navigator.of(context).pop();
                    if (homePageUnreadCount != null)
                      homePageUnreadCount!();
                  }
                },
                isSearch: isSearch,
                onSearch: (String value) {
                  _iosNotifier!.reload(
                      db, conversationId!, userId!, value, eventId!);
                },
                onItemSelect: (String value) {
                  handleAppBarItemClick(value);
                },
                imageUrl: imageUrl != null
                    ? (Config.BASE_URL + imageUrl!)
                    : "",
                title: conversationWithName,
                status: isGroupConversation! ? "" : status,
                isGroupConversation: isGroupConversation,
                userType: conversationWithType ?? "",
                userId: int.parse(conversationWithId ?? "0"),
                notificationCount: 0,
              )
                  : null,
              body: Column(
                children: [
                  Expanded(
                      child: _iosNotifier != null &&
                          _iosNotifier!.getMessagesList() != null &&
                          _iosNotifier!.getMessagesList()!.isNotEmpty &&
                          conversationId != null
                          ? Container(
                        child: NotificationListener<ScrollNotification>(
                          onNotification:
                              (ScrollNotification scrollInfo) {
                            if (scrollInfo is ScrollEndNotification &&
                                scrollInfo.metrics.extentAfter == 0) {
                              _iosNotifier!.getMore(
                                  db, conversationId!, userId!, eventId!);
                              return true;
                            }
                            return false;
                          },
                          child: ListView.builder(
                              reverse: true,
                              physics:
                              const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, bottom: 4, top: 8),
                              itemCount: _iosNotifier!.getMessagesList() !=
                                  null
                                  ? _iosNotifier!.getMessagesList()!.length
                                  : 0,
                              cacheExtent: 5,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return listItemBuilder(
                                    _iosNotifier!.getMessagesList()![index],
                                    index);
                              }),
                        ),
                      )
                          : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: appEmptyWidget(
                                    message: AppLocalizations.of(context)!
                                        .translate('no_messages'),
                                  ),
                                )
                              // EmptyWidget(AppLocalizations.of(context)
                              //     .translate('no_data'),

                            );
                          })),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: edufluencerRequestData != null,
                          child: Container(
                            color: HexColor(AppColors.appColorWhite),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 36,
                                          width: 36,
                                          child: CircleAvatar(
                                            radius: 36,
                                            foregroundColor: HexColor(AppColors.appColorWhite),
                                            backgroundColor: HexColor(AppColors.appColorWhite),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: edufluencerRequestData !=
                                                    null
                                                    ? Config.BASE_URL +
                                                    edufluencerRequestData!
                                                        .avatar!
                                                    : "",
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child: Image.asset(
                                                          'assets/appimages/userplaceholder.jpg',
                                                        )),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                edufluencerRequestData != null
                                                    ? edufluencerRequestData!
                                                    .title ??
                                                    ""
                                                    : "",
                                                style: styleElements!
                                                    .subtitle1ThemeScalable(
                                                    context)
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.w600)),
                                            Text(
                                                edufluencerRequestData != null
                                                    ? edufluencerRequestData!
                                                    .subtitle ??
                                                    ""
                                                    : "",
                                                style: styleElements!
                                                    .captionThemeScalable(
                                                    context)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          "View profile",
                                          style: styleElements!
                                              .captionThemeScalable(context)
                                              .copyWith(
                                              color: HexColor(
                                                  AppColors.appColorBlue)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 50,
                                      right: 16,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("edu_request_student"),
                                      style: styleElements!
                                          .captionThemeScalable(context),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 45,
                                        right: 16,
                                        bottom: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        appTextButton(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: HexColor(
                                                      AppColors.appMainColor))),
                                          onPressed: () {
                                            updateRequest(
                                                edufluencerRequestData!.id!,
                                                edufluencerRequestData!.personId!,
                                                userId!,
                                                "A");
                                          },
                                          color: HexColor(
                                              AppColors.appColorTransparent),
                                          child: Text(
                                            "accept",
                                            style: styleElements!
                                                .captionThemeScalable(context)
                                                .copyWith(
                                                color: HexColor(AppColors
                                                    .appMainColor)),
                                          ),
                                        ),
                                        appTextButton(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: HexColor(
                                                      AppColors.appMainColor))),
                                          onPressed: () {
                                            updateRequest(
                                                edufluencerRequestData!.id!,
                                                edufluencerRequestData!.personId!,
                                                userId!,
                                                "R");
                                          },
                                          color: HexColor(
                                              AppColors.appColorTransparent),
                                          child: Text(
                                            "reject",
                                            style: styleElements!
                                                .captionThemeScalable(context)
                                                .copyWith(
                                                color: HexColor(AppColors
                                                    .appMainColor)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        isRoomAvailable!
                            ? appChatFooter(
                          chatFooterKey!,
                          data: replyData,
                          linkPreviewUrl: linkPreview,
                          isEmptyTextAccepted: false,
                          userName: conversationWithName,
                          onCrossCLicked: () {
                            isReply = false;
                            isReply = false;
                            replyData = null;

                            chatFooterKey!.currentState!.data = null;
                            setState(() {});
                          },
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_text"),
                          isShowAddIcon: true,
                          onTyping: (String v) async {
                            if (v.isNotEmpty) getUrl(v);
                            typing(userId.toString(), conversationId);
                          },
                          onValueRecieved: (value) async {
                            try {
                              if (socketService!.getSocket() != null &&
                                  socketService!.getSocket()!.connected &&
                                  value != null &&
                                  isRoomAvailable!) {
                                final message =
                                edufluencerRequestData != null
                                    ? jsonEncode({"message": value})
                                    : value;
                                MessagePayloadDatabase messageData =
                                createMessage(message, "", "");

                                _iosNotifier!.saveData(
                                    messageData,
                                    db,
                                    conversationId!,
                                    userId!,
                                    true,
                                    eventId!);
                                updateConversation(messageData, true);
                                currentMessageId = messageData.messageId;

                                emitMessage(
                                    getMessagePayload(messageData));
                              } else {}
                            } catch (e) {
                              print(e.toString());
                              /*    ToastBuilder().showToast(

                              AppLocalizations.of(context)
                                  .translate("something_wrong_debug"),
                              context,
                              HexColor(AppColors.information));*/
                            }
                          },
                          onReceiveOption: (value) async {
                            handleShareContentOption(value, _iosNotifier!);
                          },
                        )
                            : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(AppLocalizations.of(context)!
                                .translate("ended_event")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  void checkAndInitiateCall(String type) {
    ChatCallallowedRequest payload = ChatCallallowedRequest();
    payload.actionByObjectId = prefs!.getInt(Strings.userId);
    payload.actionByObjectType = prefs!.getString(Strings.ownerType);
    payload.actionOnObjectId = int.parse(conversationWithId!);
    payload.actionOnObjectType = 'person';
    Calls()
        .call(jsonEncode(payload), context, Config.CHAT_CALL_ALLOWED)
        .then((value) {
      var response = ChatCallallowedResponse.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        if (type == 'voice') {
          if (response.rows!.audioCallIsAllowed!) {
          } else {
            ToastBuilder().showToast(
                AppLocalizations.of(context)!.translate('call_cant_proceed'),
                context,
                HexColor(AppColors.information));
          }
        } else if (type == 'video') {
          if (response.rows!.videoCallIsAllowed!) {
          } else {
            ToastBuilder().showToast(
                AppLocalizations.of(context)!.translate('call_cant_proceed'),
                context,
                HexColor(AppColors.information));
          }
        }
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate('call_cant_proceed'),
            context,
            HexColor(AppColors.information));
      }
    });
  }

  // ignore: missing_return
  String? getUrl(String text) {
    if (text != null) {
      RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      Iterable<RegExpMatch> matches = exp.allMatches(text);

      if (matches != null && matches.isNotEmpty) {
        matches.forEach((match) {
          chatFooterKey!.currentState!.linkPreviewUrl =
              text.substring(match.start, match.end);
        });
      }
    }
  }

  Widget popItem(Widget item, MessagePayloadDatabase data, String name) {
    return PopupMenuButton<String>(
        onSelected: (String value) {
          handleClickedOption(value, data, name);
        },
        child: item,
        itemBuilder: (context) => [
          PopupMenuItem(
              value: "Reply",
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.reply),
                  ),
                  Text(AppLocalizations.of(context)!.translate('reply')),
                ],
              )),
          PopupMenuItem(
              value: "Forward",
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.forward),
                  ),
                  Text(AppLocalizations.of(context)!.translate("forward"))
                ],
              )),
          /*    PopupMenuItem(
                  value: "Rate content",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.star_outline),
                      ),
                      Text(AppLocalizations.of(context)
                          .translate("rate_content"))
                    ],
                  )),
              PopupMenuItem(
                  value: "Book mark",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.star_outline),
                      ),
                      Text(AppLocalizations.of(context).translate("bookmark"))
                    ],
                  )),*/
          PopupMenuItem(
              value: "Copy",
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.copy_outlined),
                  ),
                  Text(AppLocalizations.of(context)!.translate("copy"))
                ],
              )),
          PopupMenuItem(
              value: "Delete",
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.delete_outline),
                  ),
                  Text(AppLocalizations.of(context)!.translate("delete"))
                ],
              )),
        ]);
  }

  Widget listItemBuilder(value, int index) {
    MessagePayloadDatabase item = value;

    return GestureDetector(
      onTap: () {},
      // ignore: unrelated_type_equality_checks
      child: item.messageById == userId.toString()
          ? Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            /*await db.dlt();*/
          },
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  popItem(
                      getSenderView(
                          item,
                          ChatBubbleClipper2(type: BubbleType.sendBubble),
                          context),
                      item,
                      userName!),
                ],
              )),
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                popItem(
                    getReceiverView(
                        item,
                        ChatBubbleClipper2(type: BubbleType.receiverBubble),
                        context,
                        index),
                    item,
                    conversationWithName!),
              ],
            )),
      ),
    );
  }

  getReceiverView(
      dynamic item, CustomClipper<Path> clipper, BuildContext context, int index) {
    if (this.mounted && index == 0 && (isVisible==null || isVisible!)) {
      updateMessageService!.updateMessagesStatus(
          db,
          isVisible!,
          conversationId!,
          userId.toString(),
          socketService!.getSocket()!,
          conversationWithId!,
          conversationWithType!);
    }

    if (item.messageDataType != null &&
        item.messageDataType == "object" &&
        item.messageType == "edufluencer" &&
        item.messageSubType == "request" &&
        !isRequestApiCalled! &&
        callNumber == 0) {
      callNumber=callNumber!+1;;
      requestDetails(jsonDecode(item.message)['edufluencer_id'],
          int.parse(conversationWithId!), userId!);
    }

    var textPreview;
    if (item.message != null) {
      RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      Iterable<RegExpMatch> matches = exp.allMatches(item.message);
      if (matches != null && matches.isNotEmpty) {
        matches.forEach((match) {
          textPreview =
          item.messageDataType != null && item.messageDataType == "object"
              ? jsonDecode(item.message)['message']
              .substring(match.start, match.end)
              : item.message.substring(match.start, match.end);
        });
      }
    }
    return ChatBubble(
      clipper: clipper,
      backGroundColor: HexColor(AppColors.appColorWhite),
      margin: EdgeInsets.only(top: 20),

      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: isGroupConversation!,
                child: Text(item.messageSentByName ?? "",
                    style: styleElements!.captionThemeScalable(context)),
              ),
              Visibility(
                visible: textPreview != null,
                child: CustomPreviewLink(
                    context, textPreview ?? "", styleElements),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: item.isReply != null && item.isReply == 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor(AppColors.white_translucent),
                          border: Border.all(
                            color: HexColor(AppColors.white_translucent),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: item.originalMessageAttachment != null &&
                                  item.originalMessageAttachment != "",
                              child: getMediaView(item),
                            ),
                            Text(item.originalMessageSenderName ?? "",
                                style: styleElements!
                                    .subtitle2ThemeScalable(context)),
                            Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'error';
                                }
                              },
                              text: item.originalMessage ?? "",
                              style:
                              styleElements!.subtitle1ThemeScalable(context),
                              linkStyle: TextStyle(
                                  color: HexColor(AppColors.appMainColor)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.messageAttachment != null &&
                        item.messageAttachment != "",
                    child: getMediaView(item),
                  ),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'error';
                      }
                    },
                    text: item.messageDataType != null &&
                        item.messageDataType == "object"
                        ? jsonDecode(item.message)['message']
                        : item.message ?? "",
                    style: styleElements!.subtitle1ThemeScalable(context),
                    linkStyle:
                    TextStyle(color: HexColor(AppColors.appMainColor)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(
                            item.messageSentTime ?? "")),
                        style: styleElements!
                            .captionThemeScalable(context)
                            .copyWith(
                            color: HexColor(AppColors.appColorBlack35)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSenderView(
      dynamic item, ChatBubbleClipper2 clipper, BuildContext context) {
    var textPreview;
    if (item.message != null) {
      RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      Iterable<RegExpMatch> matches = exp.allMatches(item.message);

      if (matches != null && matches.isNotEmpty) {
        matches.forEach((match) {
          textPreview =
          item.messageDataType != null && item.messageDataType == "object"
              ? jsonDecode(item.message)['message']
              .substring(match.start, match.end)
              : item.message.substring(match.start, match.end);
        });
      }
    }

    return ChatBubble(
      clipper: clipper,
      backGroundColor: HexColor(AppColors.orangeBackground),
      margin: EdgeInsets.only(top: 16),
      elevation: 1,
      shadowColor: HexColor(AppColors.appColorBlack35),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            children: [
              Visibility(
                visible: textPreview != null,
                child: CustomPreviewLink(
                    context, textPreview ?? "", styleElements),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: item.isReply != null && item.isReply == 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor(AppColors.white_translucent),
                          border: Border.all(
                            color: HexColor(AppColors.white_translucent),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: item.originalMessageAttachment != null &&
                                  item.originalMessageAttachment != "",
                              child: getMediaView(item),
                            ),
                            Text(item.originalMessageSenderName ?? "",
                                style: styleElements!
                                    .subtitle2ThemeScalable(context)),
                            Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'error';
                                }
                              },
                              text: item.originalMessage ?? "",
                              style:
                              styleElements!.subtitle1ThemeScalable(context),
                              linkStyle: TextStyle(
                                  color: HexColor(AppColors.appMainColor)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.messageAttachment != null &&
                        item.messageAttachment != "",
                    child: getMediaView(item),
                  ),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'error';
                      }
                    },
                    text: item.messageDataType != null &&
                        item.messageDataType == "object"
                        ? jsonDecode(item.message)['message'] ?? ""
                        : item.message ?? "",
                    style: styleElements!.subtitle1ThemeScalable(context),
                    linkStyle:
                    TextStyle(color: HexColor(AppColors.appMainColor)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(
                            item.messageSentTime ?? "")),
                        style: styleElements!
                            .captionThemeScalable(context)
                            .copyWith(
                            color: HexColor(AppColors.appColorBlack35)),
                      ),
                      item.messageStatus == "sent"
                          ? Icon(
                        Icons.check,
                        size: 16.0,
                        color: HexColor(AppColors.appColorBlack35),
                      )
                          : item.messageStatus == "read"
                          ? SizedBox(
                        height: 16,
                        width: 16,
                        child: Image(
                          image: AssetImage(
                              'assets/appimages/blue_double_tick.png'),
                        ),
                      )
                          : SizedBox(
                        height: 16,
                        width: 16,
                        child: Image(
                          image: AssetImage(
                              'assets/appimages/double_tick.png'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFileView(MessagePayloadDatabase item) {
    return GestureDetector(
      child: Stack(
        children: [
          SizedBox(
            height: 100,
            child: Image(
              image: AssetImage(
                item.messageAttachmentType == "pdf"
                    ? 'assets/appimages/pdf.png'
                    : 'assets/appimages/excel.png',
              ),
            ),
          ),
          Visibility(
            visible: item.isUploading == 1,
            child: Center(
              child: Container(
                  margin: const EdgeInsets.all(8),
                  child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  getMediaView(MessagePayloadDatabase item) {
    List<Media> mediaList = [];
    mediaList.add(Media(
        mediaUrl: item.isReply == 0
            ? item.messageAttachment ?? ""
            : item.originalMessageAttachment ?? "",
        mediaType: item.isReply == 0
            ? item.messageAttachmentType ?? ""
            : item.originalMessageAttachmentType ?? ""));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (item.messageAttachmentType == "image" ||
            item.messageAttachmentType == "video" ||
            item.originalMessageAttachmentType == "image" ||
            item.originalMessageAttachmentType == "video")
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImageVideoFullPage(
                  ownerId: userId,
                  ownerType: "person",
                  mediaList: mediaList,
                  isWithOutData: true,
                  isLocalFile: item.isUploading == 1 ? true : false,
                  isMediaPage: true,
                  pageNumber: pageNumber,
                  position: 0,
                  totalItems: 1)));
        else {
          launch(Config.BASE_URL + item.messageAttachment!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        height: 200,
        width: 200,
        child: Stack(
          children: [
            item.isUploading == 1
                ? SizedBox(
              height: 200,
              width: 200,
              child: item.messageAttachmentType == "image" ||
                  item.messageAttachmentType == "video"
                  ? new Image.file(
                item.messageAttachmentType == "image"
                    ? File(item.isReply == 0
                    ? item.messageAttachment ?? ""
                    : item.originalMessageAttachment ?? "")
                    : File(item.isReply == 0
                    ? item.messageAttachmentThumbnail ?? ""
                    : item.originalMessageAttachmentThumbnail ??
                    ""),
                fit: BoxFit.cover,
              )
                  : SizedBox(
                height: 200,
                width: 200,
                child: Image(
                  image: AssetImage(
                    item.messageAttachmentMIMEType == "pdf"
                        ? 'assets/appimages/pdf.png'
                        : 'assets/appimages/excel.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Stack(
              children: [
                new Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: item.messageAttachmentType == "image"
                          ? new NetworkImage(
                        Utility().getUrlForImage(
                            (item.isReply == 0
                                ? item.messageAttachment ?? ""
                                : item.originalMessageAttachment ??
                                ""),
                            RESOLUTION_TYPE.R256,
                            SERVICE_TYPE.PERSON),
                      )
                          : new NetworkImage(Utility().getUrlForImage(
                          (item.isReply == 0
                              ? item.messageAttachmentThumbnail ?? ""
                              : item.originalMessageAttachmentThumbnail ??
                              ""),
                          RESOLUTION_TYPE.R256,
                          SERVICE_TYPE.PERSON)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Visibility(
                  visible: item.messageAttachmentType == "application",
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image(
                        image: AssetImage(
                          item.messageAttachmentMIMEType == "pdf"
                              ? 'assets/appimages/pdf.png'
                              : 'assets/appimages/excel.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: item.isUploading == 1,
              child: Center(
                child: Container(
                    margin: const EdgeInsets.all(8),
                    child: CircularProgressIndicator()),
              ),
            ),
            Visibility(
              visible: (item.messageAttachmentType != null &&
                  item.messageAttachmentType!.contains("video")),
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                    opacity: 0.4,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageVideoFullPage(
                                  ownerId: userId,
                                  ownerType: "person",
                                  mediaList: mediaList,
                                  isLocalFile:
                                  item.isUploading == 1 ? true : false,
                                  isWithOutData: true,
                                  isMediaPage: true,
                                  pageNumber: pageNumber,
                                  position: 0,
                                  totalItems: 1)));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorBlack),
                                shape: BoxShape.circle),
                            margin: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.play_circle_outline,
                                  color: HexColor(AppColors.appColorWhite)),
                            )))),
              ),
            )
          ],
        ),
      ),
    );
  }

  //==================================================functions
  void createConversation(bool isGroup, bool isEvent) async {
    if (isGroup) {
      connectionItem!.isGroupConversation = isGroup;
      connectionItem!.connectionOwnerId = userId.toString();
      connectionItem!.connectionOwnerType = "person";
      connectionItem!.connectionCategory = "group";
      if (roomListItem != null) {
        connectionItem!.allRoomsId = roomListItem!.id;
        allRoomsId = roomListItem!.id;
      }
    } else {
      connectionItem!.isGroupConversation = false;
    }
    if (isEvent) {
      connectionItem!.isGroupConversation = isGroup;
      connectionItem!.isGroupConversation = true;
      connectionItem!.connectionOwnerId = userId.toString();
      connectionItem!.connectionOwnerType = "person";
      connectionItem!.connectionCategory = "group";
      connectionItem!.eventId = roomListItem!.id;
      connectionItem!.connectionId = roomListItem!.id.toString();
      eventId = roomListItem!.id;
    }
    Calls()
        .call(jsonEncode(connectionItem), context, Config.CREATE_CONVERSATION)
        .then((value) async {
      if (value != null) {
        try {
          var data = CreateConversationResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            isNewConversation = true;
            if (data != null && data.rows != null && data.rows!.length > 0) {
              conversationId = data.rows![0].conversationId;
              conversationWithId = data.rows![0].conversationWithTypeId;
              conversationWithType = data.rows![0].conversationWithType;
              mcId = data.rows![0].mcId;
              myConversationId = data.rows![0].sId;
              IosNotifier iosNotifier =
              Provider.of<IosNotifier>(context, listen: false);
              iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
              iosNotifier.reload(db, conversationId!, userId!, "", eventId!);
              await db.makeUnreadCountZero(conversationId, 0);
              callBack!();

              if (isEvent &&
                  audioSocketService!.getSocket() != null &&
                  audioSocketService!.getSocket()!.connected) {
                data.rows![1].eventId = eventId;
                data.rows![1].personId = userId.toString();
                log("nerw event conversation created===========================>" +
                    jsonEncode(data.rows![1]));
                audioSocketService!
                    .getSocket()!
                    .emit('add_conversation_id', data.rows![1]);
              }

              if (socketService!.getSocket() != null &&
                  socketService!.getSocket()!.connected) {
                joinChat(data.rows![0].conversationId.toString());
                if (data.rows!.length > 1) addConversation(data.rows![1]);
              }
              setState(() {});
            }
          } else {}
        } catch (e) {

        }
      }
    }).catchError((onError) {});
  }

  //==========================================Socket metho receiver side
  void connectToServer() {
    new Future.delayed(Duration.zero, () {
      try {
        if (socketService!.getSocket() != null) {
          socketService!.getSocket()!.onDisconnect((_) {
            if (this.mounted)
              setState(() {
                isAlreadySent = false;
              });
          });
          socketService!.getSocket()!.on('join', joinChat);
          socketService!.getSocket()!.on('chat_message', receiveNewMessage);
          socketService!.getSocket()!.on('add_conversation', newConversation);
          socketService!.getSocket()!.on('message_status', messageStatusChanged);
          socketService!.getSocket()!.on('typing', onTyping);
          socketService!.getSocket()!.on('user_status', _userStatus);
          socketService!.getSocket()!.on('message_error', onError);
          socketService!.getSocket()!.on('disconnect', (_) => log('disconnect'));
        }
      } catch (e) {
//---------
      }
    });
  }

  //==========================================Socket metho receiver side
  onError(dynamic payload) {
    log("error        +" + jsonEncode(payload));
    if (refreshList != null) refreshList!();
    // BaseResponse messageDataData = BaseResponse.fromJson(payload);
    //ToastBuilder().showToast(messageDataData.message??"", context, HexColor(AppColors.information));
    // deleteMessages(currentMessageId,conversationId, _iosNotifier);
  }

  receiveNewMessage(dynamic payload) {
    MessagePayload messageDataData = MessagePayload.fromJson(payload);
    print(isVisible.toString()+"--------------------------------------------------------"+(isVisible!=null && isVisible!?"delivered": "read"));
    if (messageDataData.conversationId == conversationId) {
      _iosNotifier!.saveData(getMessageDatabase(messageDataData), db,
          conversationId!, userId!, true, eventId!);

      messageDataData.messageStatus =isVisible!=null && isVisible!?"delivered": "read";
      messageDataData.isGroupConversation = isGroupConversation;
      messageDataData.updatedDateById = userId.toString();
      messageDataData.messageToId = userId.toString();
      messageDataData.messageToType = "person";
      messageDataData.updatedDateByType = "person";
      messageDataData.updatedDateTime = DateTime.now().millisecondsSinceEpoch;
      if (isGroupConversation!) {
        messageDataData.allRoomsId = allRoomsId;
        messageDataData.eventId = eventId ?? allRoomsId;
      }

      log(jsonEncode(messageDataData));
      if (this.mounted)
        socketService!.getSocket()!.emit('update_message', messageDataData);
      updateConversation(getMessageDatabase(messageDataData), true);
    }
  }

  newConversation(dynamic payload) {
    if (callBackNew != null) callBackNew!();
  }

  messageStatusChanged(dynamic payload) async {
    MessagePayload messageDataData = MessagePayload.fromJson(payload);
    if (messageDataData.conversationId == conversationId) {
      await db.updateMessage(getMessageDatabase(messageDataData));
      _iosNotifier!.getOlderMessages(db, conversationId!, userId!, eventId!);
    }
  }

  void updateCurrentVisible(bool isChatVisible)
  {
    setState(() {
      isVisible=isChatVisible;
    });





    print(isVisible.toString()+"--------------------------------------------------------ischatvisible 2");
  }


  void refresh(String cvId) {
    if (cvId != null) {
      print("============================" + cvId);
      setState(() {
        conversationId = cvId;
      });
      _iosNotifier!.getOlderMessages(db, cvId, userId!, eventId!);
      _iosNotifier!.reload(db, cvId, userId!, "", eventId!);
    } else {
      setState(() {
        conversationId = null;
      });
      createConversation(false, true);
    }
  }

  onTyping(dynamic payload) {
    TypingPayload typingPayload = TypingPayload.fromJson(payload);

    if (typingPayload != null && typingPayload.personId == conversationWithId) {
      if (this.mounted) {
        setState(() {
          if (typingPayload.isTyping!)
            status = AppLocalizations.of(context)!.translate("typing");
          else
            status = userStatus ?? "";
        });
      }
    }
  }

  _userStatus(dynamic payload) async {
    UserStatusPayload userStatusPayload = UserStatusPayload.fromJson(payload);
    print(jsonEncode(payload));

    //

/*
    ConversationItem item =
        await db.getConversationWithOnlineStatus(userStatusPayload.personId);
    if (item != null && item.isOnline == 0) joinChat(userId);*/
    if (userStatusPayload.personId == conversationWithId) {
      if (this.mounted) {
        userStatus = userStatusPayload.isOnline!
            ? AppLocalizations.of(context)!.translate("online")
            : "Offline";
      }
      status = userStatus;
    }
    if (this.mounted) setState(() {});
  }

  //=============================Socket methods Sender Side
  joinChat(dynamic personId) {
    socketService!.getSocket()!.emit('join', personId);
  }

  addConversation(dynamic payload) {
    log("add_conversation--" + jsonEncode(payload));
    socketService!.getSocket()!.emit('add_conversation', payload);
  }

  emitMessage(dynamic payload) {
    try {
      chatFooterKey!.currentState!.linkPreviewUrl = null;
      if (socketService!.getSocket() != null &&
          socketService!.getSocket()!.connected) {
        if (isReply!) {
          log("reply++++++++++++++++++++++++++++++++" + jsonEncode(payload));
          socketService!.getSocket()!.emit('reply_message', payload);
          isReply = false;
          replyData = null;
          chatFooterKey!.currentState!.data = null;
          setState(() {});
        } else {
          log("chat_message+++" + jsonEncode(payload));
          socketService!.getSocket()!.emit('chat_message', payload);
        }

        if (isNewConversation!) {
          callBackNew!();
          isNewConversation = false;
        }
      }
    } catch (e) {

    }
  }

  updateConversation(MessagePayloadDatabase messageData, bool isZero) async {
    var conversationItem = await db.getConversationItem(conversationId);
    if (conversationItem != null) {
      conversationItem.conversationImageThumbnail = imageUrl ?? "";
      conversationItem.lastMessageTime = messageData.messageSentTime;
      conversationItem.lastMessage = messageData.message;
      await db.updateConversationData(conversationItem);
      if (isZero && isUserOnCurrentPage!)
        await db.makeUnreadCountZero(conversationId, 0);
      if (callBack != null) callBack!();
    }
  }

  changeMessageStatus(dynamic payload) {
    socketService!.getSocket()!.emit('message_status', payload);
  }

  typing(dynamic userID, dynamic conversationId) {
    TypingPayload typingPayload = TypingPayload();
    typingPayload.conversationId = conversationId;
    typingPayload.isTyping = true;
    typingPayload.personId = userId.toString();

    socketService!.getSocket()!.emit('typing', typingPayload);
    Future.delayed(const Duration(milliseconds: 1000), () {
      typingPayload.isTyping = false;
      setState(() {
        socketService!.getSocket()!.emit('typing', typingPayload);
      });
    });
  }

  sendStatus(dynamic userID) {
    UserStatusPayload userStatusPayload = UserStatusPayload();
    userStatusPayload.isOnline = true;
    userStatusPayload.personId = userID;
    socketService!.getSocket()!.emit('user_status', userStatusPayload);
  }

  handleShareContentOption(String value, IosNotifier _iosNotifier) async {
    switch (value) {
      case "Image":
        {
          _imagePicker(_iosNotifier);
        }
        break;
      case "Video":
        {
          videoPicker(_iosNotifier);
        }
        break;
      case "File":
        {
          filePicker(_iosNotifier);
        }
        break;
      case "Location":
        {}
        break;
    }
  }

  handleAppBarItemClick(String value) {
    switch (value) {
      case "Search Chat":
        setState(() {
          isSearch = true;
        });
        break;

      case "Block":
        blockAction();
        break;
    }
  }

  void blockAction() async {
    GenericFollowUnfollowButtonState().followUnfollowBlock(
        "person",
        prefs!.getInt(Strings.userId),
        conversationWithType,
        int.parse(conversationWithId!),
        "B",
        [""], (isSuccess) {
      if (isSuccess) {}
    }, context);
  }

  handleClickedOption(
      String value, MessagePayloadDatabase data, String name) async {
    switch (value) {
      case "Reply":
        {
          isReply = true;
          replyData = data;
          chatFooterKey!.currentState!.data = data;
          chatFooterKey!.currentState!.userName = name;
          setState(() {});
        }
        break;

      case "Copy":
        {
          Clipboard.setData(new ClipboardData(text: data.message));
          ToastBuilder()
              .showToast("Copied", context, HexColor(AppColors.information));
        }
        break;

      case "Delete":
        {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => DeleteMessageDialog(
                callbackPicker: (bool isSubmit) {
                  if (isSubmit)
                    deleteMessages(
                        data.messageId!, data.conversationId!, _iosNotifier!);
                },
              ));
        }
      case "Forward":
        {
          replyData = data;
          setState(() {});
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new UserRoomSelectionPage(
                      socket: socketService!.getSocket(),
                      isForward: true,
                      callBack: callBack)));

          if (result != null && result['result'] != null) {
            List<ConnectionItem> list = result['result'];
            List<MessagePayload> listMessages = [];
            MessagePayload message = getMessagePayload(replyData!);
            message.forwardMessageId =
                DateTime.now().millisecondsSinceEpoch.toString();
            listMessages.add(message);
            ForwardMessagePayload forwardMessagePayload = ForwardMessagePayload(
                list,
                listMessages,
                conversationId,
                userId.toString(),
                "person",
                userName,
                DateTime.now().millisecondsSinceEpoch);
            log("forward -------------------------------------------" +
                jsonEncode(forwardMessagePayload));
            if (socketService!.getSocket() != null &&
                socketService!.getSocket()!.connected)
              log("forward_message++++++++++++++++++++++++" +
                  jsonEncode(forwardMessagePayload));
            socketService!
                .getSocket()!
                .emit("forward_message", forwardMessagePayload);
            replyData = null;
            setState(() {});
            log("forward_message-----------------------------------" +
                jsonEncode(list[0]));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => new ChatHistoryPage(
                      key:ch,
                        conversationItem: null,
                        type: "normal",
                        isVisible:true,
                        connectionItem: list[0],
                        socket: socketService!.getSocket(),
                        callBack: () {})));
          } else {
            replyData = null;
            setState(() {});
          }
        }
        break;
    }
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
    message.messageDataType = messageDataData.messageDataType;
    message.messageType = messageDataData.messageType;
    message.messageSubType = messageDataData.messageSubType;
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

  MessagePayloadDatabase getMessageDatabase(MessagePayload messageDataData) {
    MessagePayloadDatabase message = MessagePayloadDatabase();
    message.messageAttachmentThumbnail =
        messageDataData.messageAttachmentThumbnail;
    message.messageAttachmentMIMEType =
        messageDataData.messageAttachmentMIMEType;
    message.allRoomsId = messageDataData.allRoomsId;
    message.eventId = messageDataData.eventId ?? messageDataData.allRoomsId;
    message.messageAttachmentName = messageDataData.messageAttachmentName;
    message.replyToMessageId = messageDataData.replyToMessageId;
    message.date = messageDataData.date;
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

  MessagePayloadDatabase createMessage(
      String value, String path, String mimeType) {
    return new MessagePayloadDatabase(
      myConversationId: myConversationId,
      message: value,
      date: todayDate,
      messageDataType: edufluencerRequestData != null ? "object" : "",
      allRoomsId: allRoomsId,
      eventId: eventId ?? allRoomsId,
      isGroupConversation: isGroupConversation! ? 1 : 0,
      conversationId: conversationId,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      messageAttachment: path,
      isUploading: path != "" ? 1 : 0,
      messageAttachmentType: mimeType,
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
      isReply: isReply! ? 1 : 0,
      replyToMessageId: isReply! ? conversationWithId ?? "" : "",
      originalMessage: isReply! ? replyData!.message ?? "" : "",
      originalMessageSenderType: isReply! ? replyData!.messageByType ?? "" : "",
      originalMessageSenderName:
      isReply! ? replyData!.messageSentByName ?? "" : "",
      originalMessageSenderId: isReply! ? replyData!.messageById ?? "" : "",
      originalMessageAttachment:
      isReply! ? replyData!.messageAttachment ?? "" : "",
      originalMessageAttachmentType:
      isReply! ? replyData!.messageAttachmentType ?? "" : "",
      originalMessageAttachmentMIMEType:
      isReply! ? replyData!.messageAttachmentMIMEType ?? "" : "",
      originalMessageAttachmentName:
      isReply! ? replyData!.messageAttachmentName ?? "" : "",
      originalMessageAttachmentThumbnail:
      isReply! ? replyData!.messageAttachmentThumbnail ?? "" : "",
      originalConversationId: isReply! ? replyData!.conversationId ?? "" : "",
    );
  }

  void getPersonProfile(BuildContext context, String personId) async {
    final body = jsonEncode({"person_id": personId});

    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() async {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              Persondata persondata = data.rows!;
              connectionItem = ConnectionItem();
              String userName = persondata.firstName ?? "";
              userName = userName + " " + persondata.lastName!;
              connectionItem!.isGroupConversation = false;
              connectionItem!.connectionProfileThumbnailUrl =
                  persondata.profileImage ?? "";
              connectionItem!.connectionName = userName;
              connectionItem!.connectionId = persondata.userId.toString();
              connectionItem!.connectionOwnerId = userId.toString();
              connectionItem!.connectionType = "person";
              connectionItem!.connectionOwnerType = "person";
              setState(() {
                startNewConversation();
              });
            }
          });
        }
      }
    }).catchError((onError) async {
      print(onError.toString());
    });
  }

  _imagePicker(IosNotifier _iosNotifier) async {
    File pickedFile = (await ImagePickerAndCropperUtil().pickImage(context))!;

    if (pickedFile != null) {
      String profileImageFromPath = pickedFile.path;
      var contentType =
      ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);

      List<Media> mediaList = [];
      mediaList.add(
          Media(mediaUrl: profileImageFromPath, mediaType: contentType[0]));

      var data = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageVideoFullPage(
              ownerId: userId,
              ownerType: "person",
              mediaList: mediaList,
              isLocalFile: true,
              isWithOutData: true,
              isMediaPage: true,
              pageNumber: pageNumber,
              position: 0,
              totalItems: 1)));
      MessagePayloadDatabase messageData = createMessage(
          data['result'] ?? "", profileImageFromPath, contentType[0]);
      messageData.messageAttachmentName = contentType[0];
      messageData.messageAttachmentMIMEType = contentType[1];

      _iosNotifier.saveData(
          messageData, db, conversationId!, userId!, true, eventId!);

      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: userId.toString(),
          contextType: CONTEXTTYPE_ENUM.PROFILE.type,
          ownerId: userId.toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int progress) {},
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        if (imageResponse != null &&
            imageResponse.statusCode == Strings.success_code) {
          messageData.messageAttachment = imageResponse.rows!.fileUrl;
          messageData.messageAttachmentThumbnail =
              imageResponse.rows!.fileThumbnailUrl;
          messageData.messageAttachmentType = contentType[0];
          messageData.isUploading = 0;
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
          currentMessageId = messageData.messageId;
          emitMessage(getMessagePayload(messageData));
        } else {
          messageData.isUploading = 0;
          messageData.isFailed = 1;
          messageData.messageAttachmentType = contentType[0];
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
        }
      }).catchError((onError) async {
        messageData.isUploading = 0;
        messageData.isFailed = 1;
        messageData.messageAttachmentType = contentType[0];
        await db.updateMessage(messageData);
        _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
        log(onError.toString());
      });
    }
  }

  void videoPicker(IosNotifier _iosNotifier) async {
    File pickedFile;
    prefs = await SharedPreferences.getInstance();
    pickedFile = (await ImagePickerAndCropperUtil().pickVideo(context))!;

    if (pickedFile != null) {
      var contentType =
      ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
      String profileImageFromPath = pickedFile.path;
      List<Media> mediaList = [];
      mediaList.add(
          Media(mediaUrl: profileImageFromPath, mediaType: contentType[0]));

      /*  String thumb = await Thumbnails.getThumbnail(
          videoFile: profileImageFromPath,
          imageType: ThumbFormat.PNG,
          quality: 30);*/

      var data = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageVideoFullPage(
              ownerId: userId,
              ownerType: "person",
              mediaList: mediaList,
              isLocalFile: true,
              isWithOutData: true,
              isMediaPage: true,
              pageNumber: pageNumber,
              position: 0,
              totalItems: 1)));
      MessagePayloadDatabase messageData = createMessage(
          data['result'] ?? "", profileImageFromPath, contentType[0]);
      messageData.messageAttachmentName = contentType[0];
      messageData.messageAttachmentMIMEType = contentType[1];
      messageData.messageAttachmentThumbnail = "";
      _iosNotifier.saveData(
          messageData, db, conversationId!, userId!, true, eventId!);

      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId: prefs!.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int progress) {},
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        if (imageResponse != null &&
            imageResponse.statusCode == Strings.success_code) {
          messageData.messageAttachment = imageResponse.rows!.fileUrl;
          messageData.messageAttachmentThumbnail =
              imageResponse.rows!.fileThumbnailUrl;
          messageData.messageAttachmentType = contentType[0];
          messageData.isUploading = 0;
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
          currentMessageId = messageData.messageId;
          emitMessage(getMessagePayload(messageData));
        } else {
          messageData.isUploading = 0;
          messageData.isFailed = 1;
          messageData.messageAttachmentType = contentType[0];
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
        }
      }).catchError((onError) async {
        messageData.isUploading = 0;
        messageData.isFailed = 1;
        messageData.messageAttachmentType = contentType[0];
        await db.updateMessage(messageData);
        _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
        log(onError.toString());
      });
    } else {
      ToastBuilder().showToast(
          "FIle picking failed", context, HexColor(AppColors.information));
    }
  }

  void filePicker(IosNotifier _iosNotifier) async {
    File pickedFile;
    prefs = await SharedPreferences.getInstance();
    pickedFile = (await ImagePickerAndCropperUtil().pickFiles(context))!;

    if (pickedFile != null) {
      var contentType =
      ImagePickerAndCropperUtil().getMimeandContentType(pickedFile.path);
      String profileImageFromPath = pickedFile.path;
      List<Media> mediaList = [];
      mediaList.add(
          Media(mediaUrl: profileImageFromPath, mediaType: contentType[0]));

      MessagePayloadDatabase messageData =
      createMessage("", profileImageFromPath, contentType[0]);
      messageData.messageAttachmentName = contentType[0];
      messageData.messageAttachmentMIMEType = contentType[1];
      _iosNotifier.saveData(
          messageData, db, conversationId!, userId!, true, eventId!);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs!.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId: prefs!.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int progress) {},
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);

        if (imageResponse != null &&
            imageResponse.statusCode == Strings.success_code) {
          messageData.messageAttachment = imageResponse.rows!.fileUrl;
          messageData.messageAttachmentThumbnail =
              imageResponse.rows!.fileThumbnailUrl;
          messageData.messageAttachmentType = contentType[0];
          messageData.isUploading = 0;
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
          currentMessageId = messageData.messageId;
          emitMessage(getMessagePayload(messageData));
        } else {
          messageData.isUploading = 0;
          messageData.isFailed = 1;
          messageData.messageAttachmentType = contentType[0];
          await db.updateMessage(messageData);
          _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
        }
      }).catchError((onError) async {
        log(onError.toString());
        messageData.isUploading = 0;
        messageData.isFailed = 1;
        messageData.messageAttachmentType = contentType[0];
        await db.updateMessage(messageData);
        _iosNotifier.getOlderMessages(db, conversationId!, userId!, eventId!);
      });
    }
  }

  void deleteMessages(
      String id, String conversationId, IosNotifier _iosNotifier) async {
    DeleteMessage deleteMessage = DeleteMessage();
    deleteMessage.conversationId = conversationWithId.toString();
    deleteMessage.conversationOwnerId = userId.toString();
    deleteMessage.conversationOwnerType = "person";
    deleteMessage.messageIds = [id];
    deleteMessage.messageStatus = "deleted";
    deleteMessage.messageDeletedTime = DateTime.now().millisecondsSinceEpoch;
    Calls()
        .call(jsonEncode(deleteMessage), context, Config.DELETE_MESSAGE)
        .then((value) async {
      if (value != null) {
        var data = CreateConversationResponse.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          _iosNotifier.deleteMessage(id, conversationId, db);
        }
        //delete messages
      }
    }).catchError((onError) {});
  }

  void requestDetails(int eduId, int personId, int userId) {
    final body = jsonEncode({
      "edufluencer_id": eduId,
      "person_id": userId,
      "booking_by_type": "person",
      "booking_by_id": personId,
      "conversation_id": conversationId
    });

    Calls()
        .call(body, context, Config.EDUFLUENCER_REQUESTED_PERSON_DETAILS)
        .then((value) {
      var response = RequestDetailEdufluencer.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        setState(() {
          isRequestApiCalled = true;

          edufluencerRequestData = response.rows;
        });
      } else {}
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void updateRequest(int eduId, int personId, int userId, String status) {
    final body = jsonEncode({
      "id": eduId,
      "person_id": userId,
      "booking_by_type": "person",
      "conversation_id": conversationId,
      "booking_status": status
    });
    Calls()
        .call(body, context, Config.EDUFLUENCER_REQUESTED_ACCEPT_REJECT)
        .then((value) {
      var response = RequestResponse.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        print("--------------------------------------->>>");
        setState(() {
          edufluencerRequestData = null;
        });
      } else {
        print("-------------------------++-------------->>>");
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
