import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/models/FollowersData.dart';
import 'package:oho_works_app/models/suggestion_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class FollowingSuggestionsPage extends StatefulWidget {
  String? personName;
  String? type;
  int? id;
  String? ownerType;
  int? ownerId;
  Null Function() callback;

  FollowingSuggestionsPage(this.personName, this.type, this.id, this.ownerId,
      this.ownerType, this.callback);

  @override
  _FollowingSuggestionPage createState() =>
      _FollowingSuggestionPage(type, id, ownerId, ownerType, callback);
}

class _FollowingSuggestionPage extends State<FollowingSuggestionsPage> {
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
  List<Rows> suggestionList = [];
  int? totalfollowing = 0;
  int pagefollowing = 1;
  int? totalsuggestions = 0;
  int pagesuggestion = 1;
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
        // appBar: TricycleAppBar().getCustomAppBar(context,
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
                          height: 16,
                        ),
                      ),
                      getfollowingSliver(),
                      (type == "person" && suggestionList.length>0)
                          ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 8, bottom: 8),
                          child: Text(AppLocalizations.of(context)!.translate('suggestions'),
                            style: styleElements
                                .headline6ThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                          : SliverToBoxAdapter(),
                      (type == "person" && suggestionList.length>0) ? getsuggestionSliver() : SliverToBoxAdapter(),
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
            if (index < suggestionList.length) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            userType: suggestionList[index].id == ownerId
                                ? "person"
                                : "thirdPerson",
                            userId: suggestionList[index].id != ownerId
                                ? suggestionList[index].id
                                : null,
                            callback: () {
                              if (callback != null) callback();
                            },
                            currentPosition: 1,
                            type: null,
                          )));
                },
                child: TricycleUserListTile(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileCards(
                              userType:
                              suggestionList[index].id ==
                                  ownerId
                                  ? "person"
                                  : "thirdPerson",
                              userId:
                              suggestionList[index].id !=
                                  ownerId
                                  ? suggestionList[index].id
                                  : null,
                              callback: () {
                                callback();
                              },
                              currentPosition: 1,
                              type: null,
                            )));
                  },
                  imageUrl: suggestionList[index].avatar,
                  title: suggestionList[index].title ?? "",
                  subtitle1: suggestionList[index].subtitle ?? "",
                  trailingWidget: Visibility(
                    visible: suggestionList[index].id !=
                        prefs.getInt(Strings.userId),
                    child: GenericFollowUnfollowButton(
                      actionByObjectType:
                      prefs.getString("ownerType"),
                      actionByObjectId: prefs.getInt("userId"),
                      actionOnObjectType: "person",
                      actionOnObjectId: suggestionList[index].id,
                      engageFlag: AppLocalizations.of(context)!
                          .translate('follow'),
                      actionFlag: "F",
                      actionDetails: [],
                      personName: suggestionList[index].title ?? "",
                      callback: (isCallSuccess) {
                        refresh();
                      },
                    ),
                  ),
                ),
              );
            } else {
              return FutureBuilder(
                future: fetchListsuggestions(pagesuggestion),
                builder: (BuildContext context,
                    AsyncSnapshot<SuggestionData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pagesuggestion++;
                      suggestionList.addAll(snapshot.data!.rows!);
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
                      Visibility(
                        visible:
                        followersList[index].startingOfSuggestion == "yes",
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate("suggestions"),
                              style: styleElements
                                  .headline6ThemeScalable(context)
                                  .copyWith(color: HexColor(AppColors.appColorBlack65))),
                        ),
                      ),
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
    return    TricycleUserListTile(
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
    final body = jsonEncode(
        {"type": "network", "page_size": 20, "page_number": pagesuggestion});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    var response = SuggestionData.fromJson(res);
    totalsuggestions = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        suggestionList.addAll(response.rows!);
        pagesuggestion++;
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
    if (totalsuggestions! > suggestionList.length) {
      return suggestionList.length + 1;
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

  Future<SuggestionData> fetchListsuggestions(int page) async {
    final body =
    jsonEncode({"type": "network", "page_size": 20, "page_number": page});

    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    return SuggestionData.fromJson(res);
  }

  getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  void refresh() {
    followersList.clear();
    suggestionList.clear();
    pagefollowing = 1;
    pagesuggestion = 1;
    j=0;
    initialcallfollowing();
    // paginatorKey.currentState.changeState(resetState: true);
  }
}
