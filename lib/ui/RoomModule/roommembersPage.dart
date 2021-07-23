import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/Rooms/memberlistResponse.dart';
import 'package:oho_works_app/models/Rooms/membershipupdaterolestatus.dart';
import 'package:oho_works_app/models/Rooms/roommemberlist.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/dialogs/common_ok_cancel_dialog.dart';
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

// ignore: must_be_immutable
class RoomMembersPage extends StatefulWidget {
  int? roomId;
  String? roleType;
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  RoomMembersPage(this.roomId, this.roleType,this.ownerId,this.ownerType,this.userType,this.instituteId,this.id);

  @override
  _RoomMembersPage createState() => _RoomMembersPage(roomId, roleType,ownerId,ownerType,userType,instituteId,id);
}

class _RoomMembersPage extends State<RoomMembersPage> {
  int? roomId;
  String? roleType;
  late TextStyleElements styleElements;
  int? id;
  int? instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  _RoomMembersPage(this.roomId, this.roleType,this.ownerId,this.ownerType,this.userType,this.instituteId,this.id);

  String? searchVal;
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  SharedPreferences? prefs;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    refresh();
  }

  refresh() {
    paginatorGlobalKey.currentState!.changeState(resetState: true);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _showPopupMenu(RoomMemberListItem item) {
    return Visibility(
      visible: roleType == "A",
      child: PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: item.memberRoleType != 'A',
            value: 1,
            child: Text(AppLocalizations.of(context)!.translate('make_admin')),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(item.memberId == ownerId
                ? AppLocalizations.of(context)!.translate('exit')
                : AppLocalizations.of(context)!.translate('remove')),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            showDialog(context: context,builder: (BuildContext context)=> CommonOkCancelDialog(
                    (){makeAdmin(item);},AppLocalizations.of(context)!.translate('make_admin_des',arguments:{"name":item.firstName})
            ));
          } else if (value == 2) {
            showDialog(context: context,builder: (BuildContext context)=> CommonOkCancelDialog(
              (){removeMember(item);},AppLocalizations.of(context)!.translate('remove_member',arguments:{"name":item.firstName})
            ));
          }
        },
        icon: Icon(
          Icons.more_vert,
          size: 24,
          color: HexColor(AppColors.appColorBlack85),
        ),
      ),
    );
  }

  void onSearchValueChanged(String value) {
    searchVal = value;
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setSharedPreferences();
    return SafeArea(
      child: Scaffold(
        appBar:TricycleAppBar().getCustomAppBar(context,
            appBarTitle:AppLocalizations.of(context)!.translate("members"),
            onBackButtonPress: (){
          Navigator.pop(context);
            }),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SearchBox(
                      onvalueChanged: onSearchValueChanged,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),
                  )
                ];
              },
              body: TricycleListCard(
                child: Paginator.listView(
                  shrinkWrap: true,
                    key: paginatorGlobalKey,
                    scrollPhysics: BouncingScrollPhysics(),
                    pageLoadFuture: getMemberList,
                    pageItemsGetter: CustomPaginator(context).listItemsGetter,
                    listItemBuilder: listItemBuilder,
                    loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                    errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                    emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                    totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                    pageErrorChecker: CustomPaginator(context).pageErrorChecker),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<RoomMemberListResponse> getMemberList(int page) async {
    MemberListPayload payload = MemberListPayload();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.searchVal = "";
    payload.roomId = roomId;
    payload.personId = ownerId;
    payload.searchVal = searchVal;
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.ROOMMEMBERLIST);
    return RoomMemberListResponse.fromJson(value);
  }

  Widget listItemBuilder(item, int index) {
    RoomMemberListItem value = item;
    var firstName=value.firstName??"";
    var lastName=value.lastName??"";

    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileCards(
                  userType: value.memberId==ownerId?"person":value.memberType=="person"?"thirdPerson":value.memberType,
                  userId: value.memberId==ownerId?null:value.memberId,
                  callback: () {
                  },
                  currentPosition: 1,
                  type: null,
                )));
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileCards(
                      userType: value.memberId==ownerId?"person":value.memberType=="person"?"thirdPerson":value.memberType,
                      userId: value.memberId==ownerId?null:value.memberId,
                      callback: () {

                      },
                      currentPosition: 1,
                      type: null,
                    )));
          },
          child: TricycleAvatar(
            size: 48,
            service_type: SERVICE_TYPE.PERSON,
            resolution_type: RESOLUTION_TYPE.R64,
            imageUrl:value.profileImage,
          ),
        ),

        title: getTitle('$firstName  $lastName',value.memberRoleType == "A"),
        subtitle: getSubtitle(value),
        trailing: _showPopupMenu(value),
      ),
    );
  }
  Widget getTitle(String name, bool isAdmin){
    return Row(
      children: [
        Flexible(child: Text(name,style: styleElements.subtitle1ThemeScalable(context),)),
        Visibility(
          visible: isAdmin,
          child: Padding(
            padding:  EdgeInsets.only(left:8.0),
            child: RoomButtons(context: context).moderatorImage,
          ),
        )
      ],
    );
  }

  Widget getSubtitle(RoomMemberListItem item) {
    return Row(
      children: [
        Visibility(
          visible: item.institutionRole!=null,
          child: Flexible(
            child: Text(
              item.institutionRole!,
              style: styleElements.captionThemeScalable(context),
            ),
          )
        ),
      ],
    );
  }

  void makeAdmin(RoomMemberListItem item) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = roomId;
    payload.memberId = item.memberId;
    payload.memberType = item.memberType;
    payload.isAdmin = true;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_ROLE_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.information));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void removeMember(RoomMemberListItem item) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = roomId;
    payload.memberId = item.memberId;
    payload.memberType = item.memberType;
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast("success", context,HexColor(AppColors.information));
        refresh();
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
