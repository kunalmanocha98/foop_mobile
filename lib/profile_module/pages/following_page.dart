import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/models/FollowersData.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class FollowingPage extends StatefulWidget {
  String personName;
  String type;
  int id;
  String? ownerType;
  int? ownerId;
  Null Function() callback;

  FollowingPage(this.personName, this.type, this.id, this.ownerId,
      this.ownerType, this.callback);

  @override
  _FollowingPage createState() =>
      _FollowingPage(type, id, ownerId, ownerType, callback);
}

class _FollowingPage extends State<FollowingPage>
    with AutomaticKeepAliveClientMixin<FollowingPage> {
  String? searchVal;
  String? personName;
  String? ownerType;
  int? ownerId;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  String type;
  int id;
  bool isSuggestionShowed = false;
  bool isFirst = false;

  @override
  bool get wantKeepAlive => true;

  void setSharedPreferences() async {
    refresh();
  }

  _FollowingPage(
      this.type, this.id, this.ownerId, this.ownerType, this.callback);

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
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
    isFirst = false;
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(
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
          body: Paginator.listView(
              key: paginatorKey,
              padding: EdgeInsets.only(top: 16),
              scrollPhysics: BouncingScrollPhysics(),
              pageLoadFuture: getFollowers,
              pageItemsGetter: listItemsGetter,
              listItemBuilder: listItemBuilderFollowing,
              loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
              errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
              emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
              totalItemsGetter: CustomPaginator(context).totalPagesGetter,
              pageErrorChecker: CustomPaginator(context).pageErrorChecker),
        ));
  }

  Future<FollowersData> getFollowers(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "object_type": type,
      "search_val": searchVal,
      "object_id": id,
      "page_number": page,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.FOLLOWING_LIST);
    return FollowersData.fromJson(res);
  }

  List<FollowersItem>? listItemsGetter(FollowersData ?pageData) {
    if (!isFirst) {
      FollowersItem? val;
      try {
        val = pageData!.rows!.firstWhere((element) {
          return element.suggestedType != null &&
              element.suggestedType == 'suggestion';
        });
      } catch (e) {
        val = null;
      }
      if (val != null) {
        val.isSuggested = true;
        isFirst = true;
      } else {
        isFirst = false;
      }
    }
    return pageData!.rows;
  }

  Widget listItemBuilderFollowing(value, int index) {
    FollowersItem item = value;
    // if (item.suggestedType != null && item.suggestedType == "suggestion") {
    //   if (!isFirst) {
    //     isSuggestionShowed = true;
    //     isFirst = true;
    //   } else {
    //     isSuggestionShowed = false;
    //   }
    // } else {
    //   isSuggestionShowed = false;
    // }

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
                      callback();
                    },
                    currentPosition: 1,
                    type: null,
                  )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.startingOfSuggestion=="yes",
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    AppLocalizations.of(context)!.translate("suggestions"),
                    style: styleElements
                        .headline6ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appColorBlack65))),
              ),
            ),
            appCard(
                padding: EdgeInsets.all(6),
                child: appUserListTile(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: item.id == ownerId
                                  ? "person"
                                  : item.listType == "person"
                                  ? "thirdPerson"
                                  : "institution",
                              userId:
                              item.id != ownerId ? item.id : null,
                              callback: () {
                                callback();
                              },
                              currentPosition: 1,
                              type: null,
                            )));
                  },
                  imageUrl: item.imageUrl ,
                  title: item.name ?? "",
                  subtitle1: item.subtitle ?? "",
                  trailingWidget: SizedBox(
                    height: 40,
                    child: GenericFollowUnfollowButton(
                      actionByObjectType: prefs.getString("ownerType"),
                      actionByObjectId: prefs.getInt("userId"),
                      actionOnObjectType: item.listType ?? "",
                      actionOnObjectId: item.id,
                      engageFlag: item.suggestedType != null &&
                          item.suggestedType == "suggestion"
                          ? AppLocalizations.of(context)!.translate('follow')
                          : item.isObjectFollowing!
                          ? AppLocalizations.of(context)!
                          .translate('following')
                          : AppLocalizations.of(context)!
                          .translate('follow'),
                      actionFlag: item.isObjectFollowing! ? "U" : "F",
                      actionDetails: [],
                      personName: prefs.getString("userName"),
                      callback: (isCallSuccess) {
                        if (callback != null) callback();
                        setSharedPreferences();
                      },
                    ),
                  ),
                )),
          ],
        ));
  }
}
