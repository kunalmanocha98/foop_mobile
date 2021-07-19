import 'dart:convert';

import 'package:GlobalUploadFilePkg/Enums/GlobalSerachEnum.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/TricycleCaughtupComponent.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/searchtypeCardComponent.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/components/tricycle_lesson_card.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/membershipupdaterolestatus.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/global_search/globalsearchmodels.dart';
import 'package:oho_works_app/models/global_search/save_history.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/RoomModule/createRoomPage.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/dialogs/exitRoomConfirmtionDilaog.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/ui/postcardDetail.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class GlobalSearchPersonInstitutePage extends StatefulWidget {
  String searchVal;
  String type;
  Function(int) seeMoreCallBack;
  String entitySubType;

  GlobalSearchPersonInstitutePage(
      {Key key, this.searchVal, this.type, this.seeMoreCallBack, this.entitySubType})
      : super(key: key);

  @override
  GlobalSeachState createState() =>
      GlobalSeachState(searchVal: searchVal, type: type);
}

class GlobalSeachState extends State<GlobalSearchPersonInstitutePage> {
  String searchVal;
  String type;
  SharedPreferences prefs;
  TextStyleElements styleElements;

  GlobalSeachState({this.searchVal, this.type});

  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  List<SearchTypeItem> personList = [];
  List<PostListItem> postList = [];
  List<EventListItem> eventList = [];
  List<SearchTypeItem> institutionList = [];
  List<RoomListItem> roomsList = [];
  GlobalSearchResponseModel globalSearchResponseModel;
  int pageCount = 1;
  bool isSearching = false;

  @override
  void initState() {
    if (type == GLOBAL_SEARCH_ENUM.ALL.type) {
      fetchlist(pageCount);
      setState(() {
        isSearching = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return type == "person" || type == "institution"
        ? TricycleListCard(
        child: Paginator.listView(
          key: paginatorKey,
          pageLoadFuture: fetchlist,
          pageItemsGetter: type == "all"
              ? listItemsAll
              : type == "person" || type == "institution"
              ? listItemsGetter
              : type == "post"
              ? listItemsGetterPost
              : type == "room"
              ? listItemsGetterRoom
              : listItemsGetterEvent,
          listItemBuilder: type == "all"
              ? Container()
              : type == "person" || type == "institution"
              ? listItemGetter
              : type == "post"
              ? listItemBuilderPost
              : type == "room"
              ? listItemGetterRoom
              : listItemBuilderEvent,
          loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
          errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
          emptyListWidgetBuilder:
          CustomPaginator(context).emptyListWidgetMaker,
          totalItemsGetter: CustomPaginator(context).totalPagesGetter,
          pageErrorChecker: CustomPaginator(context).pageErrorChecker,
        ))
        : type == "all"
        ? globalSearchResponseModel != null
        ? NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.extentAfter == 0) {
          return true;
        }
        return false;
      },
      child: listItemBuilderAll(globalSearchResponseModel),
    )
        : Center(
      child: CircularProgressIndicator(),
    )
        : Paginator.listView(
      key: paginatorKey,
      pageLoadFuture: fetchlist,
      pageItemsGetter: type == "all"
          ? listItemsAll
          : type == "person" || type == "institution"
          ? listItemsGetter
          : type == "post"
          ? listItemsGetterPost
          : type == "room"
          ? listItemsGetterRoom
          : listItemsGetterEvent,
      listItemBuilder: type == "all"
          ? Container()
          : type == "person" || type == "institution"
          ? listItemGetter
          : type == "post"
          ? listItemBuilderPost
          : type == "room"
          ? listItemGetterRoom
          : listItemBuilderEvent,
      loadingWidgetBuilder:
      CustomPaginator(context).loadingWidgetMaker,
      errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
      emptyListWidgetBuilder:
      CustomPaginator(context).emptyListWidgetMaker,
      totalItemsGetter: CustomPaginator(context).totalPagesGetter,
      pageErrorChecker: CustomPaginator(context).pageErrorChecker,
    );
  }

  Widget getPaginator() {
    return Paginator.listView(
      key: paginatorKey,
      pageLoadFuture: fetchlist,
      pageItemsGetter: type == "all"
          ? listItemsAll
          : type == "person" || type == "institution"
          ? listItemsGetter
          : type == "post"
          ? listItemsGetterPost
          : type == "room"
          ? listItemsGetterRoom
          : listItemsGetterEvent,
      listItemBuilder: type == "all"
          ? Container()
          : type == "person" || type == "institution"
          ? listItemGetter
          : type == "post"
          ? listItemBuilderPost
          : type == "room"
          ? listItemGetterRoom
          : listItemBuilderEvent,
      loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
      errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
      emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
      totalItemsGetter: CustomPaginator(context).totalPagesGetter,
      pageErrorChecker: CustomPaginator(context).pageErrorChecker,
    );
  }

  Future<GlobalSearchResponse> fetchlist(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    GlobalSearchRequest payload = GlobalSearchRequest();
    payload.institutionId = prefs.getInt(Strings.instituteId);
    payload.entitySubType = widget.entitySubType;
    payload.searchType = 'person';
    payload.personId = prefs.getInt(Strings.userId);
    payload.searchPage = 'common';
    payload.searchVal = searchVal;
    payload.entityType = type;
    payload.pageNumber = 1;
    payload.pageSize = 10;
    var body = jsonEncode(payload);
    var res = await Calls().call(body, context, Config.GLOBAL_SEARCH);
    setState(() {
      isSearching = false;
      globalSearchResponseModel = GlobalSearchResponse
          .fromJson(res)
          .rows;
    });
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

  GlobalSearchResponseModel listItemsAll(GlobalSearchResponse pageData) {
    return pageData.rows;
  }

  List<RoomListItem> listItemsGetterRoom(GlobalSearchResponse pageData) {
    roomsList.addAll(pageData.rows.rooms);
    return pageData.rows.rooms;
  }

  List<EventListItem> listItemsGetterEvent(GlobalSearchResponse pageData) {
    eventList.addAll(pageData.rows.events);
    return pageData.rows.events;
  }

  List<PostListItem> listItemsGetterPost(GlobalSearchResponse pageData) {
    postList.addAll(pageData.rows.post);
    return pageData.rows.post;
  }

  Widget listItemGetter(itemData, int index) {
    SearchTypeItem item = itemData;
    return TricycleUserListTile(
      onPressed: () {
        saveHistory(jsonDecode(jsonEncode(item)), type);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UserProfileCards(
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
            if (this.mounted) setState(() {});
          },
        ),
      ),
    );
  }

  Widget listItemGetterRoom(item, int index) {
    RoomListItem value = item;
    return GestureDetector(
      onTap: () {},
      child: TricycleEventCard(
        key: UniqueKey(),
        onClickEvent: () {
          saveHistory(jsonDecode(jsonEncode(value)), 'room');
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return RoomDetailPage(
                  value,
                  prefs.getInt(Strings.userId),
                  prefs.getString(Strings.ownerType),
                  prefs.getString(Strings.ownerType),
                  prefs.getInt(Strings.instituteId),
                  prefs.getInt(Strings.userId),
                  null,
                );
              }));
        },
        byTitle: RoomButtons(context: context)
            .getByTitle(value.header.title, value.header.subtitle1),
        byImage: value.header.avatar,
        cardImage: value.roomProfileImageUrl,
        serviceType: SERVICE_TYPE.ROOM,
        title: value.roomName,
        isPrivate: value.isPrivate ?? false,
        cardRating:
        value.otherDetails.rating != null ? value.otherDetails.rating : 0.0,
        isModerator: value.memberRoleType == 'A',
        description: value.roomDescription,
        listofImages: List<String>.generate(value.membersCount, (index) {
          if (index < value.membersList.length) {
            return value.membersList[index].profileImage;
          } else {
            return "";
          }
        }),
        isRated: value.otherDetails.isRated,
        ownerType: value.roomOwnerType,
        ownerId: value.roomOwnerTypeId,
        totalRatedUsers: value.otherDetails.totalRatedUsers,
        showRateCount: false,
        subjectId: value.id,
        subjectType: 'room',
        isShareVisible: true,
        isRoom: true,
        ratingCallback: () {},
        shareCallback: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
          createDeeplink.getDeeplink(
              SHAREITEMTYPE.DETAIL.type,
              prefs.getInt("userId").toString(),
              value.id,
              DEEPLINKTYPE.ROOMS.type,
              context);
        },
        averageRatingCallback: (value) {
          if (this.mounted)
            setState(() {
              roomsList[index].otherDetails.rating = value;
              roomsList[index].otherDetails.totalRatedUsers =
                  roomsList[index].otherDetails.totalRatedUsers + 1;
              roomsList[index].otherDetails.isRated = true;
            });
        },
        actionButton: value.membershipStatus == 'A'
            ? value.memberRoleType == 'A'
            ? RoomButtons(
            context: context,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateRoomPage(
                              value: value,
                              isEdit: true,
                              callback: () {}))).then((value) {});
            }).editButton
            : RoomButtons(
            context: context,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      ExitConfirmationDialog(callback: (isSuccess) {
                        if (isSuccess) {
                          exitRoom(value);
                        }
                      }));
            }).exitButton
            : RoomButtons(
            context: context,
            onPressed: () {
              joingroup(value);
            }).joinButton,
      ),
    );
  }

  Widget listItemBuilderPost(data, int index) {
    PostListItem item = data;
    if (item.postType == 'banner') {
      print("banner");
      return TricycleCaughtUpComponent(
        title: item.postContent.header.title,
        actionTitle: item.postContent.header.subtitle1,
        onClick: () {
          if (item.postContent.header.layout == 'old') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SelectedFeedListPage(
                      isFromProfile: false,
                      appBarTitle: 'Older Posts',
                      postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PostCreatePage(
                      type: 'feed',
                      prefs: prefs,
                    )));
          }
        },
      );
    } else if (item.postType == 'title') {
      print("title");
      return Padding(
        padding: EdgeInsets.only(top: 8, bottom: 16, left: 8),
        child: Text(
          item.postContent.header.title,
          style: styleElements.headline6ThemeScalable(context),
        ),
      );
    } else if (item.postType == 'lesson') {
      return TricycleLessonCard(
        onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return NewNewsAndArticleDetailPage(postData:item);
                }));
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ChapterDetailPage(item: item)));

        },
        headerVisible: true,
        item: item,
        onFollowCallback: (isFollow) {
          _onFollowCallback(isFollow, index);
        },
        hidePostCallback: () {
          removeFromList(index);
        },
        deletePostCallback: () {
          removeFromList(index);
        },
        sharecallBack: () {
          _onShareCallback(item.postId);
        },
        ratingCallback: () {
          _onRatingCallback(index);
        },
        bookmarkCallback: (isBookmarked) {
          _onBookmarkCallback(item.postId, index, isBookmarked);
        },
        commentCallback: () {
          _onCommentCallback(index);
        },
        onTalkCallback: () {
          onTalkCallback(index);
        },
        editCallback: () {
          // editCallback(index);
        },
      );
    } else {
      print("card-----");
      return GestureDetector(
          onTap: () {
            saveHistory(jsonDecode(jsonEncode(item)), 'post');
            if (item.postType == 'lesson' ) {
              return NewNewsAndArticleDetailPage(postData: item);
            } else {
              return PostCardDetailPage(postData: item,);
            }
          },
          child: TricyclePostCard(
              key: UniqueKey(),
              // color: isInView?HexColor(AppColors.appColorBlue)[200]:HexColor(AppColors.appColorWhite),
              preferences: prefs,
              cardData: item,
              isFilterPage: false,
              isDetailPage: false,
              download: () {
                Navigator.pop(context);
              },
              sharecallBack: () {
                _onShareCallback(item.postId);
              },
              ratingCallback: () {
                _onRatingCallback(index);
              },
              bookmarkCallback: (isBookmarked) {
                _onBookmarkCallback(item.postId, index, isBookmarked);
              },
              commentCallback: () {
                _onCommentCallback(index);
              },
              onFollowCallback: (isFollow) {
                _onFollowCallback(isFollow, index);
              },
              hidePostCallback: () {
                removeFromList(index);
              },
              deletePostCallback: () {
                removeFromList(index);
              },
              onTalkCallback: () {
                onTalkCallback(index);
              },
              onAnswerClickCallback: () {
                openAnswerPage(
                    item.postContent.content.contentMeta.title, item.postId);
              },
              onSubmitAnswer: () {
                openSubmitAssignPage(item.postContent.content.contentMeta.title,
                    item.postId, index);
              },
              onVoteCallback: () {
                onVoteCallback(index);
              }));
    }
  }

  Widget listItemBuilderEvent(itemData, int index) {
    EventListItem item = itemData;
    return TricycleEventCard(
      onClickEvent: () {
        saveHistory(jsonDecode(jsonEncode(item)), 'event');
      },
      title: item.title,
      listofImages: List<String>.generate(
          item.participantList != null && item.participantList.isNotEmpty
              ? item.participantList.length
              : 0, (index) {
        return item.participantList != null && item.participantList.isNotEmpty
            ? item.participantList[index].profileImage
            : "";
      }),
      description: item.subtitle,
      dateVisible: true,
      date: DateTime.fromMillisecondsSinceEpoch(item.startTime),
      byTitle: ' by ' + item.header.title + ', ' + item.header.subtitle1,
      byImage: item.header.avatar,
      onlyHeader: false,
      isShareVisible: true,
      isModerator: item.eventRoleType == 'admin',
    );
  }

  Widget listItemBuilderAll(itemData) {
    GlobalSearchResponseModel item = itemData;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (item.person.isNotEmpty)
            SearchTypeCard(
              prefs: prefs,
              typeList: item.person.length > 4
                  ? item.person.sublist(0, 3)
                  : item.person,
              type: "person",
              title: "Person",
              seeMoreCallback: (type) {
                widget.seeMoreCallBack(1);
              },
            ),
          if (item.institution.isNotEmpty)
            SearchTypeCard(
              prefs: prefs,
              typeList: item.institution.length > 4
                  ? item.institution.sublist(0, 3)
                  : item.institution,
              type: "institution",
              title: "Institution",
              seeMoreCallback: (type) {
                widget.seeMoreCallBack(2);
              },
            ),
          if (item.rooms.isNotEmpty)
            getRoomsList(
              item.rooms.length > 4 ? item.rooms.sublist(0, 3) : item.rooms,
            ),
          if (item.events.isNotEmpty)
            getEventList(
              item.events.length > 4 ? item.events.sublist(0, 3) : item.events,
            ),
          if (item.post.isNotEmpty)
            getPostList(
              item.post.length > 4 ? item.post.sublist(0, 3) : item.post,
            )
        ],
      ),
    );
  }

  getPersonsList(List<SearchTypeItem> person, String type) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return index == 0
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(type,
                    style: styleElements.headline6ThemeScalable(context)),
              ),
              TricycleListCard(
                child: listItemGetter(person[index], index),
              ),
            ],
          )
              : TricycleListCard(
            child: listItemGetter(person[index], index),
          ); // might be `data[index]` in practice
        },
        childCount: person.length, // might be `data.length` in practice
      ),
    );
  }

  getPostList(List<PostListItem> posts) {
    return TricycleCard(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).translate("post") ?? "",
                  style: styleElements.headline6ThemeScalable(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: HexColor(AppColors.appColorBlack85)),
                  textAlign: TextAlign.left,
                ),
              )),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: posts.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return listItemBuilderPost(posts[index], index);
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.seeMoreCallBack(4);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      AppLocalizations.of(context).translate('see_more'),
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  getEventList(List<EventListItem> events) {
    return TricycleCard(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).translate("event") ?? "",
                  style: styleElements.headline6ThemeScalable(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: HexColor(AppColors.appColorBlack85)),
                  textAlign: TextAlign.left,
                ),
              )),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return listItemBuilderEvent(events[index], index);
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.seeMoreCallBack(5);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      AppLocalizations.of(context).translate('see_more'),
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  getRoomsList(List<RoomListItem> rooms) {
    return TricycleCard(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).translate("room") ?? "",
                  style: styleElements.headline6ThemeScalable(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: HexColor(AppColors.appColorBlack85)),
                  textAlign: TextAlign.left,
                ),
              )),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rooms.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return listItemGetterRoom(rooms[index], index);
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.seeMoreCallBack(3);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      AppLocalizations.of(context).translate('see_more'),
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void openAnswerPage(String question, int postId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PostCreatePage(
              type: 'answer',
              question: question,
              postId: postId,
              prefs: prefs,
            )));
  }

  void openSubmitAssignPage(String question, int postId, int index) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            PostCreatePage(
              type: 'submit_assign',
              question: question,
              postId: postId,
              prefs: prefs,
            )))
        .then((value) {
      if (value != null) {
        if (value) {
          if (this.mounted)
            setState(() {
              postList[index].isVoted = true;
            });
        }
      }
    });
  }

  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: postList[index].postContent.content.contentMeta.title,
              okCallback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title:
                        postList[index].postContent.content.contentMeta.title,
                      );
                    }));
              },
              cancelCallback: () {});
        });
  }

  void onVoteCallback(int index) {
    // setState(() {
    postList[index].isVoted = true;
    // postList[index].postContent.content.contentMeta.others.totalResponses = postList[index].postContent.content.contentMeta.others.totalResponses+1;
    // });
  }

  void removeFromList(int index) {
    if (this.mounted)
      setState(() {
        print("remove");
        postList.removeAt(index);
      });
  }

  void _onShareCallback(int id) {
    _onShare(id);
  }

  void _onRatingCallback(int index) {
    // setState(() {
    for (var i in postList[index].postContent.header.action) {
      if (i.type == 'is_rated') {
        i.value = true;
      }
    }
    // });
  }

  void _onBookmarkCallback(int postId, int index, bool isBookmarked) {
    bookmarkPost(postId, index, isBookmarked);
  }

  void _onCommentCallback(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PostCardDetailPage(
              postData: postList[index],
            )));
  }

  void _onFollowCallback(bool isFollow, int index) {
    if (this.mounted)
      setState(() {
        print("follow");
        var desiredList = postList.where((element) {
          return element.postOwnerTypeId == postList[index].postOwnerTypeId;
        });
        for (var i in desiredList) {
          for (var j in i.postContent.header.action) {
            if (j.type == 'is_followed') {
              j.value = isFollow;
            }
          }
        }
      });
  }

  void bookmarkPost(int postId, int index, bool isBookMarked) {
    // setState(() {
    postList[index].isBookmarked = isBookMarked;
    // });
  }

  final CreateDeeplink createDeeplink = locator<CreateDeeplink>();

  void _onShare(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
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
            .showToast("success", context, HexColor(AppColors.information));
        refresh();
      } else {
        ToastBuilder()
            .showToast(res.message, context, HexColor(AppColors.information));
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
    item.memberType = 'person';
    item.memberId = prefs.getInt(Strings.userId);
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            "successfully joined", context, HexColor(AppColors.information));
        refresh();
      } else {
        ToastBuilder()
            .showToast(res.message, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void setSearchVal(String searchVal) {
    print("heree----------------------------------------------------");
    this.searchVal = searchVal;
    refresh();
  }

  void refresh() {
    paginatorKey.currentState.changeState(resetState: true);
  }

  void saveHistory(dynamic entity, String type) {
    SaveHistoryRequest payload = SaveHistoryRequest(
        entityType: type,
        pageNumber: 1,
        pageSize: 10,
        institutionId: prefs.getInt(Strings.instituteId),
        personId: prefs.getInt(Strings.userId),
        searchPage: 'common',
        searchType: 'person',
        entityDetails: entity);

    Calls()
        .call(jsonEncode(payload), context, Config.SAVE_HISTORY)
        .then((value) {
      var res = SaveHistoryResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {}
    });
  }
}
