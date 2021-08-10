import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/models/FollowersData.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AllTabsNetwork extends StatefulWidget {
  String? personName;
  String? type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function() callback;

  AllTabsNetwork(this.personName, this.type, this.id, this.ownerId,
      this.ownerType, this.callback);

  @override
  _FollowingSuggestionPage createState() =>
      _FollowingSuggestionPage(type, id, ownerId, ownerType, callback);
}

class _FollowingSuggestionPage extends State<AllTabsNetwork> {
  _FollowingSuggestionPage(
      this.type, this.id, this.ownerId, this.ownerType, this.callback);

  String? searchVal;
  String? personName;
  String? type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  bool isSuggestionShowed = false;
  bool isFirst = false;
  int j=0;
  bool get wantKeepAlive => true;

  PAGINATOR_ENUMS? pageEnum_suggestion;
  PAGINATOR_ENUMS? pageEnum_following;
  bool isPostDataAvailable = true;
  String? errorMessage;
  List<FollowersItem> followersList = [];
  List<FollowersItem> followingList = [];
  int? totalfollowing = 0;
  int pagefollowing = 1;
  int? totalsuggestions = 0;
  int pageOfFollowers = 1;
  var followingSliverKey = GlobalKey();
  var suggestionSliverKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pageEnum_suggestion = PAGINATOR_ENUMS.LOADING;
    pageEnum_following = PAGINATOR_ENUMS.LOADING;
    initialcallfollowing();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        // appBar: appAppBar().getCustomAppBar(context,
        //     appBarTitle: 'PostCardDetail', onBackButtonPress: () {
        //       Navigator.pop(context);
        //     }),
        body:
        Column(children: [
          Expanded(
            child:RefreshIndicator(
              onRefresh: refreshList,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 4,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 8, bottom: 8),
                      child: Text(AppLocalizations.of(context)!.translate('following'),
                        style: styleElements
                            .headline6ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  getfollowingSliver(),
                  (type == "person" && followingList.length>0)
                      ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 8, bottom: 8),
                      child: Text(AppLocalizations.of(context)!.translate('followers'),
                        style: styleElements
                            .headline6ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                      : SliverToBoxAdapter(),
                  (type == "person" && followingList.length>0) ? getsuggestionSliver() : SliverToBoxAdapter(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  getsuggestionSliver() {
    if (pageEnum_suggestion == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_suggestion == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: suggestionSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < followingList.length) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                appAppBar: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            userType: followingList[index].id == ownerId
                                ? "person"
                                : "thirdPerson",
                            userId: followingList[index].id != ownerId
                                ? followingList[index].id
                                : null,
                            callback: () {
                              if (callback != null) callback();
                            },
                            currentPosition: 1,
                            type: null,
                          )));
                },
                child:  appUserListTile(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: followingList[index].id == ownerId
                                  ? "person"
                                  : followingList[index].listType ==
                                  "person"
                                  ? "thirdPerson"
                                  : "institution",
                              userId: followingList[index].id != ownerId
                                  ? followingList[index].id
                                  : null,
                              callback: () {
                                callback();
                              },
                              currentPosition: 1,
                              type: null,
                            )));
                  },
                  imageUrl: followingList[index].imageUrl,
                  title: followingList[index].name ?? "",
                  subtitleWidget: !(followingList[index].suggestedType !=
                      null &&
                      followingList[index].suggestedType == "suggestion")
                      ? Visibility(
                    visible:
                    !(followingList[index].suggestedType != null &&
                        followingList[index].suggestedType ==
                            "suggestion"),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible:
                            followingList[index].institutionRole !=
                                null &&
                                followingList[index]
                                    .institutionRole!
                                    .isNotEmpty,
                            child: Text(
                              (followingList[index].institutionRole !=
                                  null &&
                                  followingList[index]
                                      .institutionRole!
                                      .isNotEmpty)
                                  ? followingList[index].institutionRole!
                                  : "",
                              style: styleElements
                                  .captionThemeScalable(context),
                            )),
                        Visibility(
                          visible: id == ownerId,
                          child: SizedBox(
                            height: 30,
                            width: 80,
                            child: GenericFollowUnfollowButton(
                              padding: EdgeInsets.only(
                                  right: 8, top: 4, bottom: 4),
                              isRoundedButton: false,
                              actionByObjectType:
                              prefs.getString("ownerType"),
                              actionByObjectId: prefs.getInt("userId"),
                              actionOnObjectType:
                              followingList[index].listType,
                              actionOnObjectId: followingList[index].id,
                              engageFlag: followingList[index]
                                  .isObjectFollowing ??
                                  false
                                  ? AppLocalizations.of(context)!
                                  .translate('following')
                                  : AppLocalizations.of(context)!
                                  .translate('follow'),
                              actionFlag: followingList[index]
                                  .isObjectFollowing ??
                                  false
                                  ? "U"
                                  : "F",
                              actionDetails: [],
                              personName:
                              followingList[index].name ?? "",
                              callback: (isCallSuccess) {
                                if (callback != null) callback();
                                refresh();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Text(followingList[index].subtitle ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      styleElements.subtitle2ThemeScalable(context)),
                  trailingWidget: SizedBox(
                    height: 40,
                    width: 80,
                    child: GenericFollowUnfollowButton(
                      actionByObjectType: prefs.getString("ownerType"),
                      actionByObjectId: prefs.getInt("userId"),
                      actionOnObjectType: followingList[index].listType,
                      actionOnObjectId: followingList[index].id,
                      engageFlag: followingList[index].suggestedType !=
                          null &&
                          followingList[index].suggestedType ==
                              "suggestion"
                          ? AppLocalizations.of(context)!.translate('follow')
                          : id == ownerId
                          ? AppLocalizations.of(context)!
                          .translate('remove')
                          : followingList[index].isObjectFollowing ??
                          false
                          ? AppLocalizations.of(context)!
                          .translate('following')
                          : AppLocalizations.of(context)!
                          .translate('follow'),
                      actionFlag:
                      followingList[index].suggestedType != null &&
                          followingList[index].suggestedType ==
                              "suggestion"
                          ? "F"
                          : id == ownerId
                          ? "M"
                          : followingList[index].isObjectFollowing ??
                          false
                          ? "U"
                          : "F",
                      actionDetails: [],
                      personName: followingList[index].name ?? "",
                      callback: (isCallSuccess) {
                        if (callback != null) callback();
                        refresh();
                      },
                    ),
                  ),
                )
              );
            } else {
              return FutureBuilder(
                future: fetchListsuggestions(pageOfFollowers),
                builder: (BuildContext context,
                    AsyncSnapshot<FollowersData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageOfFollowers++;
                      followingList.addAll(snapshot.data!.rows!);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountsuggestion()),
        ),
      );
    }
  }
  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  getfollowingSliver() {
    if (pageEnum_following == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_following == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: followingSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < followersList.length) {
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType: followersList[index].id == ownerId
                                  ? "person"
                                  : followersList[index].listType ==
                                  "person"
                                  ? "thirdPerson"
                                  : "institution",
                              userId: followersList[index].id != ownerId
                                  ? followersList[index].id
                                  : null,
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

                      getCard(context,index,"following")
                    ],
                  ));
            } else {
              return FutureBuilder(
                future: fetchListfollowings(pagefollowing),
                builder: (BuildContext context,
                    AsyncSnapshot<FollowersData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pagefollowing++;
                      followersList.addAll(snapshot.data!.rows!);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountfollowing()),
        ),
      );
    }
  }
  Widget getCard(BuildContext context,int index, String type){
    return    appUserListTile(
      onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UserProfileCards(
                      userType: followersList[index]
                          .id ==
                          ownerId
                          ? "person"
                          : followersList[index]
                          .listType ==
                          "person"
                          ? "thirdPerson"
                          : "institution",
                      userId: followersList[index]
                          .id !=
                          ownerId
                          ? followersList[index].id
                          : null,
                      callback: () {
                        callback();
                      },
                      currentPosition: 1,
                      type: null,
                    )));
      },
      imageUrl: followersList[index].imageUrl,
      title:followersList[index].name ?? "",
      subtitle1: followersList[index].institutionRole ?? "",
      trailingWidget: SizedBox(
        height: 40,
        child:GenericFollowUnfollowButton(
          actionByObjectType:
          prefs.getString("ownerType"),
          actionByObjectId: prefs.getInt("userId"),
          actionOnObjectType:
          followersList[index].listType ?? "",
          actionOnObjectId: followersList[index].id,
          engageFlag: followersList[index]
              .suggestedType !=
              null &&
              followersList[index].suggestedType ==
                  "suggestion"
              ? AppLocalizations.of(context)!
              .translate('follow')
              : followersList[index].isObjectFollowing!
              ? AppLocalizations.of(context)!
              .translate('following')
              : AppLocalizations.of(context)!
              .translate('follow'),
          actionFlag:
          followersList[index].isObjectFollowing!
              ? "U"
              : "F",
          actionDetails: [],
          personName: prefs.getString("userName"),
          callback: (isCallSuccess) {
            if (callback != null) callback();
            refresh();
          },
        ),
      ),
    );
  }

  void initialcallfollowing() async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": pagefollowing,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.FOLLOWING_LIST);
    var response = FollowersData.fromJson(res);
    totalfollowing = response.total;

    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        followersList.addAll(response.rows!);
        setState(() {
          pageEnum_following = PAGINATOR_ENUMS.SUCCESS;
          pagefollowing++;
        });
      } else {
        if(j==0) {
          j=1;
          initialcallsuggestion();
        }
        setState(() {
          pageEnum_following = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      if(j==0) {
        j=1;
        initialcallsuggestion();
      }
      setState(() {
        pageEnum_following = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int? getItemsCountfollowing() {
    if (totalfollowing! > followersList.length) {
      return followersList.length + 1;
    } else {
      if(j==0) {
        j=1;
        initialcallsuggestion();
      }
      return totalfollowing;
    }
  }

  void initialcallsuggestion() async {
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": pageOfFollowers,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.FOLLOWERS_List);
    var response = FollowersData.fromJson(res);
    totalsuggestions = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        followingList.addAll(response.rows!);
        pageOfFollowers++;
        setState(() {
          pageEnum_suggestion = PAGINATOR_ENUMS.SUCCESS;
        });
      } else {
        setState(() {
          pageEnum_suggestion = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_suggestion = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int? getItemsCountsuggestion() {
    if (totalsuggestions! > followingList.length) {
      return followingList.length + 1;
    } else {
      return totalsuggestions;
    }
  }

  Future<FollowersData> fetchListfollowings(int page) async {
    // if(page==1)
    //   {setState(() {
    //     pagefollowing=2;
    //     page=2;
    //   });}
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": page,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context,  Config.FOLLOWING_LIST);
    return FollowersData.fromJson(res);
  }

  Future<FollowersData> fetchListsuggestions(int page) async {
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": page,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context,  Config.FOLLOWERS_List);
    return FollowersData.fromJson(res);
  }

  getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  void refresh() {
    followersList.clear();
    followingList.clear();
    pagefollowing = 1;
    pageOfFollowers = 1;
    j=0;
    initialcallfollowing();
    // paginatorKey.currentState.changeState(resetState: true);
  }
}
