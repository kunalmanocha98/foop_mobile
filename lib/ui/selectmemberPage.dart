import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/memberlistResponse.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
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
class SelectMembersPage extends StatefulWidget {
  final int? roomId;
  final String? selectedRoomType;
  final Null Function()? callback;

  const SelectMembersPage(
      {Key? key,
        this.roomId,
        this.selectedRoomType,
        this.callback})
      : super(key: key);

  @override
  _SelectMembersPage createState() =>
      _SelectMembersPage(roomId, selectedRoomType, callback);
}

class _SelectMembersPage extends State<SelectMembersPage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  List<MembersItem> _selectedList = [];
  // int selectedRadio;
  int? roomId;
  late TextStyleElements styleElements;
  String? searchVal;
  SharedPreferences? prefs;
  List<MemberListItem> memberItemList = [];
  String? selectedRoomType;
  int? total = 0;
  bool isAddAll = false;
  Null Function()? callback;

  _SelectMembersPage(
      this.roomId, this.selectedRoomType, this.callback);

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // paginatorGlobalKey.currentState.changeState(resetState: true);
  }

  @override
  void initState() {
    super.initState();
    // setSharedPreferences();
  }

  void onsearchValueChanged(String value) {
    searchVal = value;
    memberItemList.clear();
    paginatorGlobalKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBarWithSearch(context,
              onSearchValueChanged: onsearchValueChanged,
              hintText: AppLocalizations.of(context)!
                  .translate("search_tricycle_user"),
              appBarTitle: AppLocalizations.of(context)!
                  .translate("select_members"), onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: Stack(
            children: [
              Paginator.listView(
                key: paginatorGlobalKey,
                padding: EdgeInsets.only(bottom: 60),
                pageLoadFuture: getUserList,
                pageItemsGetter: listItemsGetter,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder:
                CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder:
                CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: HexColor(AppColors.appColorWhite),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin:
                            const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                                isAddAll
                                    ? total.toString() + " members selected"
                                    : _selectedList.length.toString() +
                                    " members selected",
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appMainColor),
                                    fontWeight: FontWeight.bold))),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: appElevatedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: HexColor(AppColors.appMainColor))),
                            onPressed: () {
                              addmembers();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => InviteMembersPage()));
                            },
                            color: HexColor(AppColors.appColorWhite),
                            child: Text(
                              AppLocalizations.of(context)!.translate("next"),
                              style: styleElements
                                  .bodyText2ThemeScalable(context)
                                  .copyWith(color: HexColor(AppColors.appMainColor)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<MemberListResponse> getUserList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    MemberListPayload payload = MemberListPayload();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.searchVal = searchVal;
    payload.roomId = roomId;
    // if (selectedRadio == 2 || selectedRadio == 1) {

    // payload.withInInstitution = true;
    // } else if (selectedRadio == 3) {
    //   payload.withInInstitution = false;
    // }
    payload.personId = prefs!.getInt(Strings.userId);
    var data = jsonEncode(payload);
    var value = await Calls().call(data, context, Config.MEMBERSLIST);
    var res = MemberListResponse.fromJson(value);
    if (total == 0) {
      setState(() {
        total = res.total;
      });
    }
    return res;
  }

  List<MemberListItem>? listItemsGetter(MemberListResponse? response) {
    memberItemList.addAll(response!.rows!);
    if (!isAddAll) {
      for (int i = 0; i < memberItemList.length; i++) {
        for (int j = 0; j < _selectedList.length; j++) {
          if (memberItemList[i].id == _selectedList[j].memberId) {
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

  Widget listItemBuilder(value, int index) {
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 1, left: 12, right: 12),
      child: Card(
        child: InkWell(
          onTap: () {},
          child: appUserListTile(
              imageUrl: value.profileImage,
              title: (value.firstName != null && value.lastName != null)
                    ? value.firstName + " " + value.lastName
                    : "",
              subtitle1:value.isFollowing ? "Following" : "",
              trailingWidget : (value.isSelected != null && value.isSelected)
                  ? Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: HexColor(AppColors.appMainColor))
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      memberItemList[index].isSelected = false;
                      _selectedList.removeWhere((element){
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
                  _selectedList.add(item);
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
                  AppLocalizations.of(context)!.translate('add'),
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
              )),
        ),
      ),
    );
  }

  void addmembers() {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = roomId;
    payload.roomInstitutionId = prefs!.getInt(Strings.instituteId);
    payload.isAddAllMembers = false;
    payload.members = _selectedList;
    payload.isAddAllMembers = isAddAll;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder()
            .showToast("success", context, HexColor(AppColors.information));
        if (callback != null) callback!();
        Navigator.pop(context, Strings.success_code);
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void addmember(MemberListItem memberitem, MEMBER_ADD_METHOD method) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = roomId;
    payload.roomInstitutionId = prefs!.getInt(Strings.instituteId);
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = "person";
    item.memberId = memberitem.id;
    item.addMethod = method.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (callback != null) callback!();
        ToastBuilder()
            .showToast("success", context, HexColor(AppColors.information));
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
