import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/FollowersData.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BlockedUsersList extends StatefulWidget {
  @override
  _BlockedUsersList createState() => _BlockedUsersList();
}

class _BlockedUsersList extends State<BlockedUsersList> {
  String? searchVal;
  String? personName;
  String? type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId = prefs.getInt("userId");
    ownerType = prefs.getString("ownerType");
  }

  @override
  void initState() {
    super.initState();

    _setPref();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!
                .translate('blocked_users'), onBackButtonPress: () {
              if (callback != null) callback!();
              Navigator.pop(context);
            }),
        body: Container(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: SearchBox(
                      onvalueChanged: onsearchValueChanged,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),
                  )
                ];
              },
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    child: ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.translate("blocked_user_des"),
                        style: styleElements
                            .bodyText2ThemeScalable(context)
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Paginator.listView(
                        key: paginatorKey,
                        padding: EdgeInsets.only(top: 16),
                        scrollPhysics: BouncingScrollPhysics(),
                        pageLoadFuture: getblockedusers,
                        pageItemsGetter: CustomPaginator(context).listItemsGetter,
                        listItemBuilder: listItemBuilder,
                        loadingWidgetBuilder:
                        CustomPaginator(context).loadingWidgetMaker,
                        errorWidgetBuilder:
                        CustomPaginator(context).errorWidgetMaker,
                        emptyListWidgetBuilder:
                        CustomPaginator(context).emptyListWidgetMaker,
                        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                        pageErrorChecker:
                        CustomPaginator(context).pageErrorChecker),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<FollowersData> getblockedusers(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": ownerType,
      "object_id": ownerId,
      "page_number": page,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.BLOCKED_USERS_LIST);
    
    return FollowersData.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    FollowersItem item = value;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileCards(
                  userType: item.id == ownerId
                      ? "person"
                      : item.listType == "person"
                      ? "thirdPerson"
                      : "institution",
                  userId: item.id != ownerId ? item.id : null,
                  callback: () {
                    callback!();
                  },
                  currentPosition: 1,
                  type: null,
                )));
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: item.id == ownerId
                                  ? "person"
                                  : item.listType == "person"
                                  ? "thirdPerson"
                                  : "institution",
                              userId: item.id != ownerId ? item.id : null,
                              callback: () {
                                callback!();
                              },
                              currentPosition: 1,
                              type: null,
                            )));
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TricycleAvatar(
                        size: 52,
                        key: UniqueKey(),
                        resolution_type: RESOLUTION_TYPE.R64,
                        service_type: SERVICE_TYPE.PERSON,
                        imageUrl: item.imageUrl),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 0,
                            left: 16,
                            right: 8,
                          ),
                          child: Text(item.name ?? "",
                              style: styleElements
                                  .subtitle1ThemeScalable(context)),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: item.id != ownerId,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GenericFollowUnfollowButton(
                      isRoundedButton: true,
                      actionByObjectType: prefs.getString("ownerType"),
                      actionByObjectId: prefs.getInt("userId"),
                      actionOnObjectType: item.listType,
                      actionOnObjectId: item.id,
                      engageFlag:
                      AppLocalizations.of(context)!.translate('unblock'),
                      actionFlag: "N",
                      actionDetails: [],
                      personName: item.name ?? "",
                      callback: (isCallSuccess) {
                        setSharedPreferences();
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
