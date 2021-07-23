import 'dart:convert';

import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_user_images_list.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/messenger_module/entities/conversation_list_reponse.dart';
import 'package:oho_works_app/messenger_module/entities/messages_response.dart';
import 'package:oho_works_app/messenger_module/entities/user_status.dart';
import 'package:oho_works_app/messenger_module/screens/conversationPageNotifier.dart';
import 'package:oho_works_app/messenger_module/screens/user_room_selection_page.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_history_page.dart';

// ignore: must_be_immutable
class ChatListsPage extends StatefulWidget {
  final String? conversationId;
  Null Function()? homePageUnreadCount;

  ChatListsPage(
   { this.conversationId,
this.homePageUnreadCount}
  );

  @override
  _ChatListsPage createState() => _ChatListsPage(conversationId,homePageUnreadCount);
}

class _ChatListsPage extends State<ChatListsPage>
    with SingleTickerProviderStateMixin {
  String? searchVal;
  String? personName;
  String? conversationId;
  int? id;
  String? ownerType;
  int? ownerId;
  int? instituteId;
  Null Function()? homePageUnreadCount;
  SocketService? socketService = locator<SocketService>();
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<PaginatorState> paginatorKeyChat = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  final db = DatabaseHelper.instance;

  List<CustomTabMaker> list = [];
  // TabController _tabController;
  // int _currentPosition = 0;
  String? pageTitle;
  ConversationNotifier? chatNotifier;
  BuildContext? ctx;
  bool isAlreadySent = false;
  GlobalKey<ChatHistoryPageState> ch = GlobalKey();

  Future<void> _setPref() async {

    prefs = await SharedPreferences.getInstance();
    setState(() {
      ownerId = prefs.getInt(Strings.userId);
      instituteId = prefs.getInt(Strings.instituteId);
      if (socketService!.getSocket() != null) {
        joinChat(ownerId);
        connectToServer();
      }
    });

    if (ownerId != null) {
      ConversationNotifier notifier =
          Provider.of<ConversationNotifier>(context, listen: false);
      notifier.getOlderConversations(db);
      notifier.reload(db, ownerId, instituteId, context, socketService!.getSocket());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _setPref());
  }

/*  @override
  void dispose() {
    print("dispose chat -----------------------------------------------------------");
    if(chatNotifier!=null)
    chatNotifier.dispose();
    super.dispose();
  }*/

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
  }

  void onSearchValueChanged(String value) {
    if (chatNotifier != null && db != null) {
      if (value.isNotEmpty)
        chatNotifier!.getSearchedList(db, value);
      else
        chatNotifier!.getOlderConversations(db);
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    chatNotifier = Provider.of<ConversationNotifier>(context);


    this.ctx = context;
    return SafeArea(
      child: Scaffold(
        appBar:AppBarWithOnlyTitle(
          title: AppLocalizations.of(context)!.translate('messenger'),
          isBackButtonVisible: true,
          backButtonCallback: (){
            Navigator.pop(context);
          },
          actions: [
            IconButton(
                icon: Icon(Icons.add,size: 30,),
                color: HexColor(AppColors.appColorBlack65),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new UserRoomSelectionPage(
                            socket: socketService!.getSocket(),
                            isForward: false,
                            callBackNew: () {
                              print("call backkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkne new");
                              chatNotifier!.reload(db, ownerId,
                                  instituteId, context, socketService!.getSocket());
                            },
                            callBack: () {
                              chatNotifier!.getOlderConversations(db);
                            },
                          )));
                }),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Icon(
            //     Icons.more_vert,
            //     color: HexColor(AppColors.appColorBlack85),
            //   ),
            // ),
          ],
        ),


        body: Column(
          children: [
            SearchBox(
              onvalueChanged: onSearchValueChanged,
              hintText: AppLocalizations.of(context)!.translate("search"),
            ),
            Expanded(
              child: chatNotifier != null &&
                      chatNotifier!.getConversationList() != null &&
                      chatNotifier!.getConversationList()!.isNotEmpty
                  ? TricycleListCard(
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo is ScrollEndNotification &&
                              scrollInfo.metrics.extentAfter == 0) {
                            chatNotifier!.getMore(
                                db, ownerId, instituteId, context, socketService!.getSocket());
                            return true;
                          }
                          return false;
                        },
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),

                            itemCount: chatNotifier!.getConversationList()!.length,
                            cacheExtent: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return listItemBuilder(
                                  chatNotifier!.getConversationList()![index],
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
                          child: TricycleEmptyWidget(
                            message: AppLocalizations.of(context)!
                                .translate('no_conversation'),
                          ),
                        )
                            // EmptyWidget(AppLocalizations.of(context)
                            //     .translate('no_data'),
                            );
                      }),
            )
          ],
        ),
      ),
    );
  }

  Widget listItemBuilder(value, int index) {
    ConversationItemDb item = value;
    joinChat(item.conversationId);
    return  InkWell(

        onTap: () async {
          print("conversation id ++++++++++++++++"+item.toJson().toString());
          var roomListItem;
          if(item.conversationWithType == 'event'){
            item.eventId  =  int.parse(item.conversationWithTypeId!);
            roomListItem = RoomListItem( roomProfileImageUrl:item.conversationImage,roomName:item.conversationName,isEvent: true,id:  int.parse(item.conversationWithTypeId!));
          }else{
            roomListItem = null;
          }
          await db.makeUnreadCountZero(item.conversationId, 0);
          chatNotifier!.getOlderConversations(db);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => new ChatHistoryPage(
                    key:ch,
                        isVisible: true,
                        conversationItem: item,
                        connectionItem: null,
                    type:"normal",
                      homePageUnreadCount:homePageUnreadCount,
                        socket: socketService!.getSocket(),
                    roomListItem: roomListItem,
                    refreshList: () {
                      if (chatNotifier != null)
                        chatNotifier!.reload(db, ownerId, instituteId, context, socketService!.getSocket());
                    },
                        callBack: () {
                          if (chatNotifier != null)
                            chatNotifier!.getOlderConversations(db);
                        },
                        userStatus: item.isOnline == 1 ? "Online" : "Offline",
                      )));
        },
        child:Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              tileColor: HexColor(AppColors.listBg),
              leading: SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  children: [
                    TricycleAvatar(
                      key: UniqueKey(),
                      withBorder: false,
                      size: 56,
                      resolution_type: RESOLUTION_TYPE.R64,
                      service_type:item.isGroupConversation!=null &&item.isGroupConversation==1? SERVICE_TYPE.ROOM:SERVICE_TYPE.PERSON,
                      imageUrl:  item.conversationImageThumbnail ?? "",),
                    Visibility(
                           visible: item.isOnline == 1,
                        child: Align(
                          child: Icon(
                            Icons.circle,
                            color: HexColor(AppColors.onlineColor),
                            size: 18,
                          ),
                          alignment: Alignment.bottomRight,
                        ))
                  ],
                ),
              ),
              title: Text(item.conversationName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: styleElements.subtitle1ThemeScalable(context)),
              subtitle: (item.lastMessage != null)
                  ? Text(item.lastMessage ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: styleElements.bodyText2ThemeScalable(context))
                  : null,
              trailing: Column(
                children: [
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(
                        item.lastMessageTime ?? 0)),
                    style: styleElements.captionThemeScalable(context).copyWith(
                      fontSize: 10,
                      color: HexColor(AppColors.appColorBlack35),
                    ),
                  ),
                  Visibility(
                    visible: item.unreadCount != null && item.unreadCount != 0,
                    child: Card(
                        color: HexColor(AppColors.appMainColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            item.unreadCount.toString(),
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                              color: HexColor(AppColors.appColorWhite),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 2,
              thickness: 0.5,
              indent: 72,
              endIndent: 0,
            ),
          ],
        ));
  }

  _ChatListsPage(this.conversationId,this.homePageUnreadCount);
  Widget roomBuilder() {
    // var userType="";

    // print(Utility().getUrlForImage(value.roomProfileImageUrl, RESOLUTION_TYPE.R64,SERVICE_TYPE.ROOM));
    return  Container(

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TricycleAvatar(
                    key: UniqueKey(),
                    withBorder: false,
                    size: 56,
                    resolution_type: RESOLUTION_TYPE.R64,
                    service_type: SERVICE_TYPE.PERSON,
                    imageUrl: "",)
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8, bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Tarzan Group of Engineering  ",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:styleElements.subtitle1ThemeScalable(context)),
                              ),

                            Visibility(
                              visible: true,
                              child: Icon(
                                Icons.lock,
                                color: HexColor(AppColors.appColorBlack65),
                                size: 16,
                              ),
                            ),

                          ]
                      ),
                      // Text(
                      //   roomData.roomName,
                      //   maxLines: 3,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: styleElements
                      //       .subtitle1ThemeScalable(context)
                      //       .copyWith(fontWeight: FontWeight.bold),
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${"4"} ',style: styleElements.subtitle1ThemeScalable(context).copyWith(
                              color: HexColor(AppColors.appMainColor),
                              fontWeight: FontWeight.bold
                          ),),
                          Visibility(
                            visible: true,
                            child:  RatingBar(
                              initialRating: 4.0,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 15.0,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              ratingWidget: RatingWidget(
                                empty: Icon(
                                  Icons.star_outline,
                                  color: HexColor(AppColors.appMainColor),
                                ),
                                half:  Icon(
                                  Icons.star_half_outlined,
                                  color: HexColor(AppColors.appMainColor),
                                ),
                                full:  Icon(
                                  Icons.star_outlined,
                                  color: HexColor(AppColors.appMainColor),
                                ),
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8,right: 8),
                            child: Container(width: 1,height: 16,
                              color: HexColor(AppColors.appColorBlack35),),),
                          Visibility(
                            visible: true,
                            child: Padding(
                              padding: EdgeInsets.only(top:4,left: 2),
                              child: Container(
                                child: RoomButtons(context: context).moderatorImage,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                  Text(
                        "कल सैलून वाले क़ी दुकान पर एक स्लोगन पढा़ हम दिल का बोझ तो नहीं पर सिर का बोझ जरूर हल्का कर सकते हैं .",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: styleElements.captionThemeScalable(context),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TricycleUserImageList(
                            listOfImages: List.generate(4,(index){
                              return "";
                            }),
                          ),
                          Text(
                            "+22 attending",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),

                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(
                        12254879414)),
                    style: styleElements.captionThemeScalable(context).copyWith(
                      fontSize: 10,
                      color: HexColor(AppColors.appColorBlack35),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Card(
                        color: HexColor(AppColors.appMainColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "22",
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                              color: HexColor(AppColors.appColorWhite),
                            ),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
          const Divider(
            height: 2,
            thickness: 0.5,
            indent: 72,
            endIndent: 0,
          ),
        ],
      ),
    );
  }
  void connectToServer() {

    socketService!.getSocket()!.on('chat_message', receiveNewMessage);
    socketService!.getSocket()!.on('add_conversation', newConversation);
    socketService!.getSocket()!.on('message_status', messageStatusChanged);
    socketService!.getSocket()!.on('typing', onTyping);
    socketService!.getSocket()!.on('user_status', userStatus);
    socketService!.getSocket()!.on('disconnect', (_) => print('disconnect'));
  }

//==========================================Socket metho receiver side

  receiveNewMessage(dynamic payload) {
    MessagePayload messageDataData = MessagePayload.fromJson(payload);
    chatNotifier!.updateUnreadCount(messageDataData, db);
    messageDataData.messageStatus = "delivered";
    messageDataData.isGroupConversation = false;
    messageDataData.messageToId = ownerId.toString();
    messageDataData.messageToType = "person";
    messageDataData.updatedDateById = ownerId.toString();
    messageDataData.updatedDateByType = "person";
    messageDataData.updatedDateTime = DateTime.now().millisecondsSinceEpoch;
    print("update time+chat list page" +
        messageDataData.updatedDateTime.toString());
    print("sent time  +chat list page" +
        messageDataData.messageSentTime.toString());
    socketService!.getSocket()!.emit('update_message', messageDataData);
  }

  newConversation(dynamic payload) {
    chatNotifier!.reload(db, ownerId, instituteId, context, socketService!.getSocket());
  }

  messageStatusChanged(dynamic payload) {

  }

  onTyping(dynamic payload) {}

  userStatus(dynamic payload) async {

    UserStatusPayload userStatusPayload = UserStatusPayload.fromJson(payload);

    print("user status changed --------------------------"+userStatusPayload.personId!);
    await chatNotifier!.updateStatus(userStatusPayload.personId.toString(), userStatusPayload.isOnline! ? 1 : 0, db);
  }

  //=============================Socket methods Sender Side
  joinChat(dynamic personId) {

    socketService!.getSocket()!.emit('join', personId);
  }

  addConversation(dynamic payload) {

    socketService!.getSocket()!.emit('add_conversation', jsonEncode(payload));
  }

  emitMessage(dynamic payload) {

    socketService!.getSocket()!.emit('chat_message', jsonEncode(payload));
  }

  changeMessageStatus(dynamic payload) {
    socketService!.getSocket()!.emit('message_status', jsonEncode(payload));
  }

  typing(dynamic userID, dynamic conversationId) {
    final body = jsonEncode({
      "conversationId": conversationId,
      "personId": userID,
      "isTyping": true
    });
    socketService!.getSocket()!.emit('typing', body);
  }

  sendStatus(dynamic userID) {
    UserStatusPayload userStatusPayload = UserStatusPayload();
    userStatusPayload.isOnline = true;
    userStatusPayload.personId = userID;
    socketService!.getSocket()!.emit('user_status', userStatusPayload);
  }

  Widget popItem(Widget item) {
    return PopupMenuButton<String>(
        onSelected: (String value) {},
        child: item,
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: "Online",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                        child: Icon(
                          Icons.circle,
                          color: HexColor(AppColors.onlineColor),
                          size: 14,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.translate("online"))
                    ],
                  )),
              PopupMenuItem(
                  value: "Offline",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                        child: Icon(
                          Icons.circle,
                          color: HexColor(AppColors.offlineColor),
                          size: 14,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.translate("offline"))
                    ],
                  )),
              PopupMenuItem(
                  value: "Busy",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                        child: Icon(
                          Icons.circle,
                          color: HexColor(AppColors.busyColor),
                          size: 14,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.translate("busy"))
                    ],
                  )),
            ]);
  }
}
