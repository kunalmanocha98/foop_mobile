import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/tricycle_chat_footer.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/models/FollowersData.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post_view_response.dart';
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
class FollowersSuggestionsPage extends StatefulWidget {
  String personName;
  String type;
  int id;
  String ownerType;
  int ownerId;
  Null Function() callback;

  FollowersSuggestionsPage(this.personName, this.type, this.id, this.ownerId,
      this.ownerType, this.callback);

  @override
  _FollowersSuggestionPage createState() =>
      _FollowersSuggestionPage(type, id, ownerId, ownerType, callback);
}

class _FollowersSuggestionPage extends State<FollowersSuggestionsPage> {
  _FollowersSuggestionPage(
      this.type, this.id, this.ownerId, this.ownerType, this.callback);

  String searchVal;
  String personName;
  String type;
  int id;
  String ownerType;
  int ownerId;
  Null Function() callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  SharedPreferences prefs;
  TextStyleElements styleElements;
  bool isSuggestionShowed = false;
  bool isFirst = false;
  int j = 0;

  bool get wantKeepAlive => true;

  PostListItem postData;

  int postId;

  GlobalKey<TricycleChatFooterState> chatFooterKey = GlobalKey();
  PAGINATOR_ENUMS pageEnum_suggestion;
  PAGINATOR_ENUMS pageEnum_follower;
  bool isPostDataAvailable = true;
  String errorMessage;
  List<FollowersItem> followersList = [];
  List<Rows> suggestionList = [];
  int totalfollower = 0;
  int pagefollower = 1;
  int totalsuggestions = 0;
  int pagesuggestion = 1;

  var followerSliverKey = GlobalKey();
  var suggestionSliverKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (postId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getPost(postId));
    }
    pageEnum_suggestion = PAGINATOR_ENUMS.LOADING;
    pageEnum_follower = PAGINATOR_ENUMS.LOADING;

    initialcallfollower();
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
          body: Column(children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshList,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    getfollowerSliver(),
                    (type == "person" && suggestionList.length > 0)
                        ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 8, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('suggestions'),
                          style: styleElements
                              .headline6ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                        : SliverToBoxAdapter(),
                    (type == "person" && suggestionList.length > 0)
                        ? getsuggestionSliver()
                        : SliverToBoxAdapter(),
                  ],
                ),
              ),
            ),
          ])),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileCards(
                                userType:
                                suggestionList[index].id == ownerId
                                    ? "person"
                                    : "thirdPerson",
                                userId: suggestionList[index].id != ownerId
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
                          actionByObjectType: prefs.getString("ownerType"),
                          actionByObjectId: prefs.getInt("userId"),
                          actionOnObjectType: "person",
                          actionOnObjectId: suggestionList[index].id,
                          engageFlag:
                          AppLocalizations.of(context).translate('follow'),
                          actionFlag: "F",
                          actionDetails: [],
                          personName: suggestionList[index].title ?? "",
                          callback: (isCallSuccess) {
                            refresh();
                          },
                        )),
                  ));
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
                      suggestionList.addAll(snapshot.data.rows);
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

  getfollowerSliver() {
    if (pageEnum_follower == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_follower == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: followerSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < followersList.length) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: followersList[index].startingOfSuggestion == "yes",
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          AppLocalizations.of(context).translate("suggestions"),
                          style: styleElements
                              .headline6ThemeScalable(context)
                              .copyWith(
                              color: HexColor(AppColors.appColorBlack65))),
                    ),
                  ),
                  TricycleUserListTile(
                    onPressed: () {
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
                    imageUrl: followersList[index].imageUrl,
                    title: followersList[index].name ?? "",
                    subtitleWidget: !(followersList[index].suggestedType !=
                        null &&
                        followersList[index].suggestedType == "suggestion")
                        ? Visibility(
                      visible:
                      !(followersList[index].suggestedType != null &&
                          followersList[index].suggestedType ==
                              "suggestion"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                              visible:
                              followersList[index].institutionRole !=
                                  null &&
                                  followersList[index]
                                      .institutionRole
                                      .isNotEmpty,
                              child: Text(
                                (followersList[index].institutionRole !=
                                    null &&
                                    followersList[index]
                                        .institutionRole
                                        .isNotEmpty)
                                    ? followersList[index].institutionRole
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
                                followersList[index].listType,
                                actionOnObjectId: followersList[index].id,
                                engageFlag: followersList[index]
                                    .isObjectFollowing ??
                                    false
                                    ? AppLocalizations.of(context)
                                    .translate('following')
                                    : AppLocalizations.of(context)
                                    .translate('follow'),
                                actionFlag: followersList[index]
                                    .isObjectFollowing ??
                                    false
                                    ? "U"
                                    : "F",
                                actionDetails: [],
                                personName:
                                followersList[index].name ?? "",
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
                        : Text(followersList[index].subtitle ?? "",
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
                        actionOnObjectType: followersList[index].listType,
                        actionOnObjectId: followersList[index].id,
                        engageFlag: followersList[index].suggestedType !=
                            null &&
                            followersList[index].suggestedType ==
                                "suggestion"
                            ? AppLocalizations.of(context).translate('follow')
                            : id == ownerId
                            ? AppLocalizations.of(context)
                            .translate('remove')
                            : followersList[index].isObjectFollowing ??
                            false
                            ? AppLocalizations.of(context)
                            .translate('following')
                            : AppLocalizations.of(context)
                            .translate('follow'),
                        actionFlag:
                        followersList[index].suggestedType != null &&
                            followersList[index].suggestedType ==
                                "suggestion"
                            ? "F"
                            : id == ownerId
                            ? "M"
                            : followersList[index].isObjectFollowing ??
                            false
                            ? "U"
                            : "F",
                        actionDetails: [],
                        personName: followersList[index].name ?? "",
                        callback: (isCallSuccess) {
                          if (callback != null) callback();
                          refresh();
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return FutureBuilder(
                future: fetchListfollowers(pagefollower),
                builder: (BuildContext context,
                    AsyncSnapshot<FollowersData> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pagefollower++;
                      followersList.addAll(snapshot.data.rows);
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
          }, childCount: getItemsCountfollower()),
        ),
      );
    }
  }

  void getPost(int postId) async {
    final body = jsonEncode({"post_id": postId});

    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          if (res.rows != null) {
            isPostDataAvailable = true;
            postData = res.rows;
          }
        });
      } else if (res.statusCode == "E100002") {
        setState(() {
          if (res.rows != null) {
            isPostDataAvailable = false;
            errorMessage = res.message;
          }
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void initialcallfollower() async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": pagefollower,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.FOLLOWERS_List);
    var response = FollowersData.fromJson(res);
    totalfollower = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total > 0) {
        followersList.addAll(response.rows);
        setState(() {
          pageEnum_follower = PAGINATOR_ENUMS.SUCCESS;
          pagefollower = pagefollower + 1;
        });
      } else {
        if (j == 0) {
          j = 1;
          initialcallsuggestion();
        }
        setState(() {
          pageEnum_follower = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      if (j == 0) {
        j = 1;
        initialcallsuggestion();
      }
      setState(() {
        pageEnum_follower = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int getItemsCountfollower() {
    if (totalfollower > followersList.length) {
      return followersList.length + 1;
    } else {
      if (j == 0) {
        j = 1;
        initialcallsuggestion();
      }
      return totalfollower;
    }
  }

  void initialcallsuggestion() async {
    final body = jsonEncode(
        {"type": "network", "page_size": 20, "page_number": pagesuggestion});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    var response = SuggestionData.fromJson(res);
    totalsuggestions = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total > 0) {
        suggestionList.addAll(response.rows);
        pagesuggestion = 2;
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

  int getItemsCountsuggestion() {
    if (totalsuggestions > suggestionList.length) {
      return suggestionList.length + 1;
    } else {
      return totalsuggestions;
    }
  }

  Future<FollowersData> fetchListfollowers(int page) async {
    final body = jsonEncode({
      "search_val": searchVal,
      "object_type": type == "institution" ? "institution" : "person",
      "object_id": id,
      "page_number": page,
      "page_size": 20,
      "owner_type": ownerType,
      "owner_id": ownerId
    });
    var res = await Calls().call(body, context, Config.FOLLOWERS_List);
    return FollowersData.fromJson(res);
  }

  Future<SuggestionData> fetchListsuggestions(int page) async {
    final body =
    jsonEncode({"type": "network", "page_size": 20, "page_number": page});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);
    return SuggestionData.fromJson(res);
  }

  void refresh() {
    followersList.clear();
    suggestionList.clear();
    pagefollower = 1;
    pagesuggestion = 1;
    j = 0;
    initialcallfollower();
    // paginatorKey.currentState.changeState(resetState: true);
  }
}
