import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/models/global_search/globalsearchmodels.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SearchTypeListPage extends StatefulWidget {
  String searchVal;
  String type;
  String subType;

  SearchTypeListPage({Key key, this.searchVal, this.type,this.subType}) : super(key: key);

  @override
  SearchTypeListState createState() =>
      SearchTypeListState(searchVal: searchVal, type: type);
}

class SearchTypeListState extends State<SearchTypeListPage> {
  String searchVal;
  String type;
  SharedPreferences prefs;
  TextStyleElements styleElements;

  SearchTypeListState({this.searchVal, this.type});

  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  List<SearchTypeItem> personList = [];
  List<SearchTypeItem> institutionList = [];

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
      child: Paginator.listView(
        key: paginatorKey,
        pageLoadFuture: fetchlist,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemGetter,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker,
      ),
    );
  }

  Future<GlobalSearchResponse> fetchlist(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    GlobalSearchRequest payload = GlobalSearchRequest();
    payload.institutionId = prefs.getInt(Strings.instituteId);
    payload.searchType = 'person';
    payload.personId = prefs.getInt(Strings.userId);
    payload.searchPage = 'common';
    payload.searchVal = searchVal;
    payload.entityType = type;
    payload.pageNumber = 1;
    payload.pageSize = 10;
    var body = jsonEncode(payload);
    var res = await Calls().call(body, context, Config.GLOBAL_SEARCH);
    return GlobalSearchResponse.fromJson(res);
  }

  List<SearchTypeItem> listItemsGetter(GlobalSearchResponse pageData) {
    if (type == 'person') {
      personList.addAll(pageData.rows.person);
      return pageData.rows.person;
    } else {
      institutionList.addAll(pageData.rows.institution);
      return pageData.rows.institution;
    }
  }

  Widget listItemGetter(itemData, int index) {
    SearchTypeItem item = itemData;
    return InkWell(
      onTap: () {
// print(prefs.getInt("userId").toString()+"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
//
// print(item.id.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileCards(
                      userType: type == 'person'
                          ? (item.id == prefs.getInt("userId")
                              ? "person"
                              : "thirdPerson")
                          : "institution",
                      userId:
                          item.id == prefs.getInt("userId") ? null : item.id,
                      callback: () {},
                      currentPosition: 1,
                      type: null,
                    )));
      },
      child: TricycleUserListTile(
        imageUrl: itemData.avatar,
        title: itemData.title,
        subtitle1: itemData.subtitle1,
        trailingWidget: Visibility(
          visible: !item.isFollowing && prefs.getInt("userId") != item.id,
          child: GenericFollowUnfollowButton(
            actionByObjectType: prefs.getString("ownerType"),
            actionByObjectId: prefs.getInt("userId"),
            actionOnObjectType: type,
            actionOnObjectId: item.id,
            engageFlag: AppLocalizations.of(context).translate('follow'),
            actionFlag: "F",
            actionDetails: [],
            personName: item.title ?? "",
            callback: (isCallSuccess) {
              print(type +
                  "-------------------------------------------------------------++++++++++++++++++++++++++++++++++++++");
              if (type == 'person') {
                personList[index].isFollowing = true;
              } else {
                institutionList[index].isFollowing = true;
              }
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void setSearchVal(String searchVal) {
    this.searchVal = searchVal;
    refresh();
  }

  void refresh() {
    paginatorKey.currentState.changeState(resetState: true);
  }
}
