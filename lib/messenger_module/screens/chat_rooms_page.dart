import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_rooms_card.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/messenger_module/entities/connect_list_response_entity.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/membershipupdaterolestatus.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/ui/RoomModule/createRoomPage.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/dialogs/exitRoomConfirmtionDilaog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_history_page.dart';

// ignore: must_be_immutable
class ChatRoomsPage extends StatefulWidget {
  String type;
  IO.Socket socket;
  bool isForward;
  Null Function() callBackNew;
  Null Function() callBack;
  Null Function(ConnectionItem) addConnectionCallBack;
  Null Function(String) removeCallBack;

  ChatRoomsPage(
      {Key key,
      this.type,
      this.socket,
      this.isForward,
      this.callBack,
      this.callBackNew,
      this.addConnectionCallBack,
      this.removeCallBack})
      : super(key: key);

  @override
  _ChatRoomsPage createState() => _ChatRoomsPage(type, socket, isForward,
      callBackNew, callBack, addConnectionCallBack, removeCallBack);
}

class _ChatRoomsPage extends State<ChatRoomsPage> {
  bool isForward;
  Null Function() callBackNew;
  Null Function() callBack;
  int ownerId;
  String type;
  IO.Socket socket;
  String searchVal;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences prefs;
  TextStyleElements styleElements;
  Null Function(ConnectionItem) addConnectionCallBack;
  Null Function(String) removeCallBack;

  void setSharedPreferences() async {
    refresh();
  }

  void setPref() async {
    prefs ??= await SharedPreferences.getInstance();
    ownerId = prefs.getInt(Strings.userId);
    setState(() {});
  }

  @override
  void initState() {
    setPref();
    super.initState();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState.changeState(resetState: true);
    if (callback != null) callback();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SearchBox(
              onvalueChanged: onsearchValueChanged,
              hintText: AppLocalizations.of(context).translate('search'),
            ),
          ),
        ];
      },
      body: Paginator.listView(
          key: paginatorKey,
          padding: EdgeInsets.only(top: 16),
          scrollPhysics: BouncingScrollPhysics(),
          pageLoadFuture: getRoomsList,
          pageItemsGetter: CustomPaginator(context).listItemsGetter,
          listItemBuilder: listItemBuilder,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker),
    ));
  }

  Future<RoomListResponse> getRoomsList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    RoomListPayload payload = RoomListPayload();
    payload.isPrivate = null;
    payload.roomInstitutionId = prefs.getInt(Strings.instituteId);
    payload.memberId = prefs.getInt(Strings.userId);
    payload.memberType = "person";
    payload.pageSize = 20;
    payload.requestedByType = "person";
    payload.requestedById = prefs.getInt(Strings.userId);
    payload.isOwn = true;
    payload.pageNumber = page;
    payload.searchVal = searchVal;
    payload.institutionId = prefs.getInt(Strings.instituteId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMS_LIST);
    return RoomListResponse.fromJson(value);
  }

  Widget listItemBuilder(item, int index) {
    RoomListItem value = item;
    // print(Utility().getUrlForImage(value.roomProfileImageUrl, RESOLUTION_TYPE.R64,SERVICE_TYPE.ROOM));
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
          onTap: () {
            if (value.membershipStatus == 'A') {
              if (isForward==null || !isForward) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new ChatHistoryPage(
                            roomListItem: value,
                            conversationItem: null,
                            connectionItem: null,
                            socket: socket,
                            type:"normal",
                            callBack: callback,
                            callBackNew: callBackNew)));
              }
              else
                {
                  ConnectionItem connectionItem=ConnectionItem();
                  connectionItem.connectionOwnerId = prefs.getInt(Strings.userId).toString();
                  connectionItem.connectionOwnerType = "person";
                  connectionItem.connectionCategory = "group";
                  connectionItem.allRoomsId = value.id;
                  connectionItem.isGroupConversation = true;
                  connectionItem.isSelected=true;
                  connectionItem.connectionName=value.roomName;
                  addConnectionCallBack(connectionItem);
                }
            } else {
              ToastBuilder().showToast(
                  AppLocalizations.of(context).translate("join_to_chat"),
                  context,
                  HexColor(AppColors.success));
            }
          },
          child: TricycleRoomCalenderCard(
            roomData: value,

            actionButton: ownerId != null
                ? value.membershipStatus == 'A'
                    ? value.memberRoleType == "A"
                        ? RoomButtons(
                            context: context,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateRoomPage(
                                          value: value,
                                          isEdit: true,
                                          callback: () {}))).then((value) {
                                refresh();
                              });
                            }).editButton
                        : RoomButtons(
                            context: context,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ExitConfirmationDialog(
                                          callback: (isSuccess) {
                                        if (isSuccess) {
                                          exitRoom(value);
                                        }
                                      }));
                            }).exitButton
                    : RoomButtons(
                        context: context,
                        onPressed: () {
                          joingroup(value);
                        }).joinButton
                : Visibility(
                    visible: !value.isRequestedByMember,
                    child: RoomButtons(
                        context: context,
                        onPressed: () {
                          if (!value.isRequestedByMember) {
                            joingroup(value);
                          }
                        }).joinButton),
          )),
    );
  }

  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = prefs.getInt(Strings.userId);
    payload.memberType = "person";
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder()
            .showToast("success", context, HexColor(AppColors.success));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = prefs.getInt(Strings.instituteId);
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = "person";
    item.memberId = prefs.getInt(Strings.userId);
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            "successfully joined", context, HexColor(AppColors.success));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  _ChatRoomsPage(this.type, this.socket, this.isForward, this.callBack,
      this.callBackNew, this.addConnectionCallBack, this.removeCallBack);
}
