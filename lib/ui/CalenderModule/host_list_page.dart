import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/memberlistResponse.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostListPage extends StatefulWidget {
  final String? privacyType;
  final bool isReceiverList;
  final EventCreateRequest? payload;
  final List<MembersItem>? selectedList;
  final RoomListItem? roomItem;
  final Function? refreshCallBack;
  HostListPage({this.privacyType,this.isReceiverList= false,this.payload, this.selectedList,this.roomItem,this.refreshCallBack});
  @override
  HostListPageState createState() => HostListPageState(payload: payload,selectedList: selectedList);
}

class HostListPageState extends State<HostListPage> {
  static const String EVENT_CREATE = "event_create";
  String? searchVal;
  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  bool isAddAll = false;
  List<MemberListItem> memberItemList = [];
  List<MembersItem>? selectedList;
  List<InviteeListItem> inviteeItemList = [];
  EventCreateRequest? payload;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  AudioSocketService? audioSocketService = locator<AudioSocketService>();

  HostListPageState({this.payload,this.selectedList});


  void refresh(){
    memberItemList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
          appBar: appAppBar().getCustomAppBarWithSearch(context,
            onSearchValueChanged: (value) {
            searchVal = value;
            refresh();
            },
            appBarTitle: widget.isReceiverList?'Receiver list':'Select cohost', onBackButtonPress: () {
              Navigator.pop(context);
            },
            actions: [
              appProgressButton(
                key: progressButtonKey,
                onPressed: widget.isReceiverList?createEvent:() {
                  var body = {"type":"list",
                    "value":selectedList
                  };
                  Navigator.pop(context,body);
                },
                shape: StadiumBorder(),
                elevation: 0,
                color: HexColor(AppColors.appColorBackground),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
              ),
            ]

          ),
          body: appListCard(
            child: widget.isReceiverList?
            Paginator<InviteeListResponse>.listView(
                key: paginatorKey,
                pageLoadFuture: fetchListReceiver,
                pageItemsGetter: listItemsGetterReceiver,
                listItemBuilder: listItemBuilderReceiver,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker)
                : Paginator.listView(
                key: paginatorKey,
                pageLoadFuture: fetchList,
                pageItemsGetter: listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ),
        ));
  }
  Future<InviteeListResponse> fetchListReceiver(int page) async {
    if(widget.roomItem == null) {
      MemberListPayload payload = MemberListPayload();
      payload.pageSize = 10;
      payload.pageNumber = page;
      payload.searchVal = searchVal;
      payload.privacyType = widget.privacyType;
      payload.personId = prefs!.getInt(Strings.userId);
      var res = await Calls().call(
          jsonEncode(payload), context, Config.EVENT_INVITEE_SELECT_LIST);
      return InviteeListResponse.fromJson(res);
    }else{
      InviteeListResponse inviteeListResponse = InviteeListResponse();
      inviteeListResponse.total =1;
      inviteeListResponse.message ="SUCCESS";
      inviteeListResponse.statusCode = "S10001";
      inviteeListResponse.rows = [
        InviteeListItem(
          isAllowed: true,
          recipientImage: widget.roomItem!.roomProfileImageUrl,
          recipientType: widget.roomItem!.roomName,
          recipientTypeReferenceId: widget.roomItem!.id,
          recipientTypeDescription: widget.roomItem!.roomDescription,
          recipientTypeCode: 'room'
        )
      ];
      return inviteeListResponse;
    }
  }
  List<InviteeListItem>? listItemsGetterReceiver(InviteeListResponse? response) {
    selectedList ??= [];
    inviteeItemList.addAll(response!.rows!);
    if (!isAddAll) {
      for (int i = 0; i < inviteeItemList.length; i++) {
        for (int j = 0; j < selectedList!.length; j++) {
          if (inviteeItemList[i].recipientTypeReferenceId == selectedList![j].memberId) {
            inviteeItemList[i].isSelected = true;
            break;
          }
        }
      }
    } else {
      for (int i = 0; i < memberItemList.length; i++) {
        memberItemList[i].isSelected = true;
      }
    }
    return response.rows;
  }
  Widget listItemBuilderReceiver(itemData, int index) {
    InviteeListItem value = itemData;
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: appAvatar(
            size: 48,
            resolution_type: RESOLUTION_TYPE.R64,
            service_type: value.recipientTypeCode =='room'?SERVICE_TYPE.ROOM:value.recipientTypeCode =='institution'?SERVICE_TYPE.INSTITUTION:SERVICE_TYPE.PERSON,
            imageUrl: value.recipientImage,
          ),
          title: Text( value.recipientType!,
            style: styleElements.subtitle1ThemeScalable(context),
          ),
          subtitle:value.recipientTypeCode =='room'|| value.recipientTypeCode =='institution'?Text(""): Text(value.recipientTypeDescription!),
          trailing: (value.isSelected != null && value.isSelected!)
              ? Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: HexColor(AppColors.appMainColor))
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  inviteeItemList[index].isSelected = false;
                  selectedList!.removeWhere((element){
                    return element.memberId == inviteeItemList[index].recipientTypeReferenceId;
                  });
                });
              },
              color: HexColor(AppColors.appMainColor),
              icon: Icon(Icons.close),
            ),
          )
              : appElevatedButton(
            onPressed: () {
              // if (value.isFollowing) {


              MembersItem item = MembersItem();
              item.memberType = "person";
              item.memberId = value.recipientTypeReferenceId;
              item.addMethod = MEMBER_ADD_METHOD.DIRECT.type;
              item.profileImage = value.recipientImage;
              item.memberName = value.recipientType;
              item.roleType = value.recipientTypeCode;
              selectedList!.add(item);
              // } else {
              //   MembersItem item = MembersItem();
              //   item.memberType = 'person';
              //   item.memberId = value.id;
              //   item.addMethod = MEMBER_ADD_METHOD.INVITE.type;
              //   _selectedList.add(item);
              // }
              inviteeItemList[index].isSelected = true;
              setState(() {});
            },
            child: Text(
              widget.isReceiverList?AppLocalizations.of(context)!.translate('invite'):AppLocalizations.of(context)!.translate('select'),
              style: styleElements
                  .captionThemeScalable(context)
                  .copyWith(
                  color: HexColor(AppColors.appMainColor),
                  fontWeight: FontWeight.bold),
            ),
            color: HexColor(AppColors.appColorWhite),
            shape: StadiumBorder(
                side: BorderSide(
                    color: HexColor(AppColors.appMainColor))),
          ),
        ),
      ),
    );
  }

  Future<MemberListResponse> fetchList(int page) async {
    MemberListPayload payload = MemberListPayload();
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.searchVal = searchVal ;
    payload.privacyType = widget.privacyType;
    payload.personId = prefs!.getInt(Strings.userId);
    var res = await Calls().call(jsonEncode(payload), context, Config.EVENT_MEMBER_SELECT_LIST);
    return MemberListResponse.fromJson(res);
  }
  List<MemberListItem>? listItemsGetter(MemberListResponse? response) {
    selectedList ??= [];
    memberItemList.addAll(response!.rows!);
    if (!isAddAll) {
      for (int i = 0; i < memberItemList.length; i++) {
        for (int j = 0; j < selectedList!.length; j++) {
          if (memberItemList[i].id == selectedList![j].memberId) {
            memberItemList[i].isSelected = true;
            break;
          }
        }
      }
    } else {
      for (int i = 0; i < memberItemList.length; i++) {
        memberItemList[i].isSelected = true;
      }
    }
    return response.rows;
  }


  Widget listItemBuilder(itemData, int index) {
    MemberListItem value = itemData;
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
            leading: appAvatar(
              size: 48,
              resolution_type: RESOLUTION_TYPE.R64,
              service_type: SERVICE_TYPE.PERSON,
              imageUrl: value.profileImage,
            ),
            title: Text(
              (value.firstName != null && value.lastName != null)
                  ? value.firstName! + " " + value.lastName!
                  : "",
              style: styleElements.subtitle1ThemeScalable(context),
            ),
            subtitle: Text(value.isFollowing! ? "Following" : ""),
            trailing: (value.isSelected != null && value.isSelected!)
                ? Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HexColor(AppColors.appMainColor))
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    memberItemList[index].isSelected = false;
                    selectedList!.removeWhere((element){
                      return element.memberId == memberItemList[index].id;
                    });
                  });
                },
                color: HexColor(AppColors.appMainColor),
                icon: Icon(Icons.close),
              ),
            )
                : appElevatedButton(
              onPressed: () {
                // if (value.isFollowing) {
                MembersItem item = MembersItem();
                item.memberType = "person";
                item.memberId = value.id;
                item.addMethod = MEMBER_ADD_METHOD.DIRECT.type;
                item.profileImage = value.profileImage;
                item.memberName = value.firstName;
                selectedList!.add(item);
                // } else {
                //   MembersItem item = MembersItem();
                //   item.memberType = 'person';
                //   item.memberId = value.id;
                //   item.addMethod = MEMBER_ADD_METHOD.INVITE.type;
                //   _selectedList.add(item);
                // }
                memberItemList[index].isSelected = true;
                setState(() {});
              },
              child: Text(
                widget.isReceiverList?AppLocalizations.of(context)!.translate('invite'):AppLocalizations.of(context)!.translate('select'),
                style: styleElements
                    .captionThemeScalable(context)
                    .copyWith(
                    color: HexColor(AppColors.appMainColor),
                    fontWeight: FontWeight.bold),
              ),
              color: HexColor(AppColors.appColorWhite),
              shape: StadiumBorder(
                  side: BorderSide(
                      color: HexColor(AppColors.appMainColor))),
            ),
        ),
      ),
    );
  }

  void createEvent() async{
    // FocusScope.of(context).requestFocus(FocusNode());
    progressButtonKey.currentState!.show();
    payload!.recipientType = List<String?>.generate(selectedList!.length, (index)  {
      return selectedList![index].roleType;
    });
    payload!.recipientDetails = List<RecipientDetails>.generate(selectedList!.length, (index){
      return RecipientDetails(
        type: widget.isReceiverList?selectedList![index].roleType:selectedList![index].memberType,
        id: selectedList![index].memberId,
      );
    });
    Calls().call(jsonEncode(payload), context, Config.CREATE_EVENT).then((value) {
      progressButtonKey.currentState!.hide();
      var res = CreateEventResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){

        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('event_created_successfully')
        , context, HexColor(AppColors.information));
        var body = {
          "type":"boolean",
          "value":true
        };
        emitCreatePayload(res.rows!.id);
        Navigator.pop(context,body);
        if(widget.refreshCallBack!=null)
          {
            widget.refreshCallBack!();
          }
      }
    }).catchError((onError){
      print(onError);
      progressButtonKey.currentState!.hide();
    });
  }
  void emitCreatePayload(int? eventId) {
    JoinEventPayload payload  = JoinEventPayload();
    payload.personId = prefs!.getInt(Strings.userId);
    payload.eventId = eventId;
    audioSocketService!.getSocket()!.emit(EVENT_CREATE,payload);
  }
}
