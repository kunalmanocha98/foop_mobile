import 'dart:convert';

import 'package:GlobalUploadFilePkg/Enums/GlobalSerachEnum.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/customtabview.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/components/tricycle_find_card.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/member%20enums.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/Rooms/memberAdd.dart';
import 'package:oho_works_app/models/Rooms/membershipupdaterolestatus.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/global_search/globalsearchmodels.dart';
import 'package:oho_works_app/models/global_search/save_history.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/suggestion_data.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/search_module/global_serach_institute_person_page.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/RoomModule/createRoomPage.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/dialogs/exitRoomConfirmtionDilaog.dart';
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
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class GlobalSearchNew extends StatefulWidget {
  String? entitySubType;
  bool isSearching;
  bool onlyOneSearch;

  GlobalSearchNew(
      {this.entitySubType,
        this.isSearching = false,
        this.onlyOneSearch = false});

  _GlobalSearchNew createState() =>
      _GlobalSearchNew(entitySubType: entitySubType, isSearching: isSearching);
}

class _GlobalSearchNew extends State<GlobalSearchNew>
    with TickerProviderStateMixin {
  List<CustomTabMaker> list = [];
  late TabController _tabController;
  late TextStyleElements styleElements;
  String? type;
  int? id;
  bool isSearching;
  SharedPreferences? prefs;
  String? ownerType;
  int? ownerId;
  int _currentPosition = 0;
  String? pageTitle;
  Null Function()? callback;
  String? imageUrl;
  String? searchVal = "search";
  GlobalKey<GlobalSeachState> searchPageKey = GlobalKey();
  GlobalKey<GlobalSeachState> searchPageKeyPerson = GlobalKey();
  List<GlobalSearchHistoryItem>? searchHistory;
  List<Rows>? suggestions;
  String? entitySubType;

  _GlobalSearchNew({this.isSearching = false, this.entitySubType});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  onPositionChange() {
    if (!_tabController.indexIsChanging && this.mounted) {
      setState(() {
        _currentPosition = _tabController.index;
      });
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    id = prefs!.getInt("userId");
    imageUrl = Utility().getUrlForImage(
        prefs!.getString(Strings.profileImage),
        RESOLUTION_TYPE.R64,
        prefs!.getString("ownerType") == "institution"
            ? SERVICE_TYPE.INSTITUTION
            : SERVICE_TYPE.PERSON);
    type = prefs!.getString("ownerType") == "institution"
        ? "institution"
        : "person";

    pageTitle = prefs!.getString(Strings.firstName);

    ownerType = prefs!.getString("ownerType");
    ownerId = prefs!.getInt("userId");

    getHistory();
    getSuggestion();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    list.clear();
    if (widget.onlyOneSearch && entitySubType == 'lesson') {
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            key: UniqueKey(),
            searchVal: searchVal,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            type: GLOBAL_SEARCH_ENUM.POST.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('post')));
    } else {
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            key: UniqueKey(),
            searchVal: searchVal,
            type: GLOBAL_SEARCH_ENUM.ALL.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('all')));
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            searchVal: searchVal,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            key: UniqueKey(),
            type: GLOBAL_SEARCH_ENUM.PERSON.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('person')));
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            searchVal: searchVal,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            key: UniqueKey(),
            type: GLOBAL_SEARCH_ENUM.INSTITUTION.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('entity_title')));
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            key: UniqueKey(),
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            searchVal: searchVal,
            type: GLOBAL_SEARCH_ENUM.ROOM.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('room')));
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            key: UniqueKey(),
            searchVal: searchVal,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            type: GLOBAL_SEARCH_ENUM.EVENT.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('events')));
      list.add(new CustomTabMaker(
          statelessWidget: new GlobalSearchPersonInstitutePage(
            entitySubType: entitySubType,
            key: UniqueKey(),
            searchVal: searchVal,
            seeMoreCallBack: (int val) {
              setState(() {
                _currentPosition = val;
              });
            },
            type: GLOBAL_SEARCH_ENUM.POST.type,
          ),
          tabName: AppLocalizations.of(context)!.translate('post')));
    }

    setState(() {
      _tabController = TabController(vsync: this, length: list.length);
      _tabController.addListener(onPositionChange);
    });

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace_rounded,
                            size: 20,
                            // add custom icons also
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                        Expanded(
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 2, bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  HexColor(AppColors.appColorWhite),
                                  HexColor(AppColors.appColorWhite),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              boxShadow: [CommonComponents().getShadowforBox_01_3()],
                            ),
                            child: Center(
                              child: Container(
                                  child: Row(
                                    children: <Widget>[

                                     
                                      Expanded(
                                        child: TypeAheadField(
                                          suggestionsBoxDecoration:
                                          SuggestionsBoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          animationDuration: Duration(seconds: 1),
                                          textFieldConfiguration: TextFieldConfiguration(
                                              style: styleElements
                                                  .subtitle1ThemeScalable(context)
                                                  .copyWith(
                                                  color: HexColor(
                                                      AppColors.appColorBlack65)),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.only(top: 12, left: 16),
                                                border: InputBorder.none,
                                                hintText: AppLocalizations.of(context)!
                                                    .translate('search'),
                                                hintStyle: styleElements
                                                    .bodyText2ThemeScalable(context)
                                                    .copyWith(
                                                    color: HexColor(
                                                        AppColors.appColorBlack35)),
                                                prefixIcon: Padding(
                                                    padding: EdgeInsets.all(0.0),
                                                    child: Icon(Icons.search,
                                                        color: HexColor(
                                                            AppColors.appColorGrey500))),
                                              ),
                                              onSubmitted: (value) {
                                                setState(() {
                                                  isSearching = true;
                                                  searchVal = value;
                                                });
                                              }),
                                          suggestionsCallback: (String? pattern) async {
                                            if (pattern!.isEmpty &&
                                                searchHistory != null &&
                                                searchHistory!.isNotEmpty) {
                                              return searchHistory!;
                                            } else {
                                              return searchHistory!;
                                            }
                                          },
                                          itemBuilder: (context, dynamic suggestion) {
                                            GlobalSearchHistoryItem item = suggestion;
                                            return ListTile(
                                              leading: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                child: Icon(Icons.access_time_rounded),
                                              ),
                                              title: Text(item.searchVal != null
                                                  ? item.searchVal!
                                                  : ""),
                                            );
                                          },
                                          onSuggestionSelected: (dynamic suggestion) {
                                            print(
                                                "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii" +
                                                    suggestion.searchVal);

                                            try {
                                              setState(() {
                                                isSearching = true;
                                                searchVal = suggestion.searchVal;
                                              });
                                            } catch (e) {
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: isSearching
                ? DefaultTabController(
              length: list.length,
              child: CustomTabView(
                marginTop: const EdgeInsets.only(top: 1.0),
                currentPosition: _currentPosition,
                itemCount:
                list != null && list.isNotEmpty ? list.length : 0,
                tabBuilder: (context, index) => Visibility(
                  visible: !widget.onlyOneSearch,
                  child: TricycleTabButton(
                    onPressed: () {
                      setState(() {
                        //loadPages(searchVal);
                        _currentPosition = index;
                      });
                    },
                    tabName: list[index].tabName,
                    isActive: index == _currentPosition,
                  ),
                ),
                pageBuilder: (context, index) =>
                list[index].statelessWidget!,
                onPositionChange: (index) {
                  setState(() {
                    // loadPages(searchVal);
                    _currentPosition = index!;
                  });
                },
                onScroll: (position) => print('$position'),
              ),
            )
                : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TricycleFindCard(
                    title: "Who do you want to study together?",
                    subtitle:
                    "Search for friends who can support you to learn together",
                    image: Image.asset(
                      'assets/appimages/report_content_icon.png',
                      height: 150,
                      width: 150,
                    ),
                    color: HexColor("#F8FEF2"),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: searchHistory != null &&
                        searchHistory!.isNotEmpty
                        ? Text(
                      AppLocalizations.of(context)!
                          .translate('recently_searhced'),
                      style: styleElements
                          .subtitle1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                        : Container(),
                  ),
                ),
                searchHistory != null && searchHistory!.isNotEmpty
                    ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (searchHistory![index].entityType ==
                            'person' ||
                            searchHistory![index].entityType ==
                                'institution') {
                          EntityDetails? details =
                          searchHistory![index].entityDetails != null
                              ? EntityDetails.fromJson(jsonDecode(
                              jsonEncode(searchHistory![index]
                                  .entityDetails)))
                              : null;
                          // searchHistory[index].entityDetails;
                          return TricycleUserListTile(
                            imageUrl: (details != null)
                                ? details.avatar
                                : null,
                            service_type:
                            searchHistory![index].entityType ==
                                'person'
                                ? SERVICE_TYPE.PERSON
                                : SERVICE_TYPE.INSTITUTION,
                            callBack: (int? userId) {
                              setState(() {
                                isSearching = true;
                                searchVal =
                                    searchHistory![index].searchVal;
                              });
                            },
                            iconWidget: (details != null)
                                ? null
                                : Container(
                              child: Icon(
                                Icons.access_time_rounded,
                                color: HexColor(
                                    AppColors.appColorBlack35),
                              ),
                            ),
                            isFullImageUrl: false,
                            title: searchHistory![index].searchVal ?? "",
                            subtitle1: (details != null)
                                ? details.subtitle1
                                : null,
                            padding: EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                                left: 12,
                                right: 12),
                            margin: EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                color:
                                HexColor(AppColors.appColorWhite),
                                borderRadius: BorderRadius.only(
                                  topLeft: (index == 0)
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  topRight: (index == 0)
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  bottomLeft: (index == 4)
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  bottomRight: (index == 4)
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                )),
                          );
                        } else if (searchHistory![index].entityType ==
                            'post') {
                          if (searchHistory![index].entityDetails !=
                              null) {
                            PostListItem item = PostListItem.fromJson(
                                jsonDecode(jsonEncode(
                                    searchHistory![index]
                                        .entityDetails)));
                            return GestureDetector(
                                onTap: () {
                                  saveHistory(
                                      jsonDecode(jsonEncode(item)),
                                      'post');
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostCardDetailPage(
                                                postData: item,
                                              )));
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
                                      _onShare(item.postId);
                                    },
                                    ratingCallback: () {
                                      for (var i in item
                                          .postContent!.header!.action!) {
                                        if (i.type == 'is_rated') {
                                          i.value = true;
                                        }
                                      }
                                    },
                                    bookmarkCallback: (isBookmarked) {
                                      item.isBookmarked = isBookmarked;
                                    },
                                    commentCallback: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostCardDetailPage(
                                                    postData: item,
                                                  )));
                                    },
                                    onFollowCallback: (isFollow) {
                                      if (this.mounted)
                                        setState(() {
                                          print("follow");
                                          for (var j in item.postContent!
                                              .header!.action!) {
                                            if (j.type ==
                                                'is_followed') {
                                              j.value = isFollow;
                                            }
                                          }
                                        });
                                    },
                                    hidePostCallback: () {},
                                    deletePostCallback: () {},
                                    onTalkCallback: () {
                                      showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return AudioPostDialog(
                                                title: item
                                                    .postContent!
                                                    .content!
                                                    .contentMeta!
                                                    .title,
                                                okCallback: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (BuildContext
                                                          context) {
                                                            return CreateEventPage(
                                                              type: 'talk',
                                                              standardEventId:
                                                              5,
                                                              title: item
                                                                  .postContent!
                                                                  .content!
                                                                  .contentMeta!
                                                                  .title,
                                                            );
                                                          }));
                                                },
                                                cancelCallback: () {});
                                          });
                                    },
                                    onAnswerClickCallback: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostCreatePage(
                                                    type: 'answer',
                                                    question: item
                                                        .postContent!
                                                        .content!
                                                        .contentMeta!
                                                        .title,
                                                    postId: item.postId,
                                                    prefs: prefs,
                                                  )));
                                    },
                                    onSubmitAnswer: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                              PostCreatePage(
                                                type:
                                                'submit_assign',
                                                question: item
                                                    .postContent!
                                                    .content!
                                                    .contentMeta!
                                                    .title,
                                                postId: item.postId,
                                                prefs: prefs,
                                              )))
                                          .then((value) {
                                        if (value != null) {
                                          if (value) {
                                            if (this.mounted)
                                              setState(() {
                                                item.isVoted = true;
                                              });
                                          }
                                        }
                                      });
                                    },
                                    onVoteCallback: () {
                                      item.isVoted = true;
                                    }));
                          } else {
                            return Container();
                          }
                        } else if (searchHistory![index].entityType ==
                            'room') {
                          RoomListItem value = RoomListItem.fromJson(
                              searchHistory![index].entityDetails);
                          return GestureDetector(
                            onTap: () {},
                            child: TricycleEventCard(
                              onClickEvent: () {
                                saveHistory(
                                    jsonDecode(jsonEncode(value)),
                                    'room');
                                Navigator.push(context,
                                    MaterialPageRoute(builder:
                                        (BuildContext context) {
                                      return RoomDetailPage(
                                        value,
                                        prefs!.getInt(Strings.userId),
                                        prefs!.getString(Strings.ownerType),
                                        prefs!.getString(Strings.ownerType),
                                        prefs!.getInt(Strings.instituteId),
                                        prefs!.getInt(Strings.userId),
                                        null,
                                      );
                                    }));
                              },
                              key: UniqueKey(),
                              byTitle: RoomButtons(context: context)
                                  .getByTitle(value.header!.title,
                                  value.header!.subtitle1),
                              byImage: value.header!.avatar,
                              cardImage: value.roomProfileImageUrl,
                              serviceType: SERVICE_TYPE.ROOM,
                              title: value.roomName,
                              isPrivate: value.isPrivate ?? false,
                              cardRating:
                              value.otherDetails!.rating != null
                                  ? value.otherDetails!.rating
                                  : 0.0,
                              isModerator: value.memberRoleType == 'A',
                              description: value.roomDescription,
                              listofImages: List<String?>.generate(
                                  value.membersCount!, (index) {
                                if (index < value.membersList!.length) {
                                  return value
                                      .membersList![index].profileImage;
                                } else {
                                  return "";
                                }
                              }),
                              isRated: value.otherDetails!.isRated,
                              ownerType: value.roomOwnerType,
                              ownerId: value.roomOwnerTypeId,
                              totalRatedUsers:
                              value.otherDetails!.totalRatedUsers,
                              showRateCount: false,
                              subjectId: value.id,
                              subjectType: 'room',
                              isShareVisible: true,
                              isRoom: true,
                              ratingCallback: () {},
                              shareCallback: () async {
                                SharedPreferences prefs =
                                await SharedPreferences
                                    .getInstance();
                                final CreateDeeplink createDeeplink =
                                locator<CreateDeeplink>();
                                createDeeplink.getDeeplink(
                                    SHAREITEMTYPE.DETAIL.type,
                                    prefs.getInt("userId").toString(),
                                    value.id,
                                    DEEPLINKTYPE.ROOMS.type,
                                    context);
                              },
                              averageRatingCallback: (value) {
                                // if (this.mounted)
                                //   setState(() {
                                //     roomsList[index].otherDetails.rating = value;
                                //     roomsList[index].otherDetails.totalRatedUsers =
                                //         roomsList[index].otherDetails.totalRatedUsers + 1;
                                //     roomsList[index].otherDetails.isRated = true;
                                //   });
                              },
                              actionButton: value.membershipStatus ==
                                  'A'
                                  ? value.memberRoleType == 'A'
                                  ? RoomButtons(
                                  context: context,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateRoomPage(
                                                    value:
                                                    value,
                                                    isEdit:
                                                    true,
                                                    callback:
                                                        () {}))).then(
                                            (value) {});
                                  }).editButton
                                  : RoomButtons(
                                  context: context,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext
                                        context) =>
                                            ExitConfirmationDialog(
                                                callback:
                                                    (isSuccess) {
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
                        } else if (searchHistory![index].entityType ==
                            'event') {
                          EventListItem item = EventListItem.fromJson(
                              jsonDecode(jsonEncode(
                                  searchHistory![index].entityDetails)));
                          return TricycleEventCard(
                            onClickEvent: () {
                              saveHistory(jsonDecode(jsonEncode(item)),
                                  'event');
                            },
                            title: item.title,
                            listofImages: List<String?>.generate(
                                item.participantList != null &&
                                    item.participantList!.isNotEmpty
                                    ? item.participantList!.length
                                    : 0, (index) {
                              return item.participantList != null &&
                                  item.participantList!.isNotEmpty
                                  ? item.participantList![index]
                                  .profileImage
                                  : "";
                            }),
                            description: item.subtitle,
                            dateVisible: true,
                            date: DateTime.fromMillisecondsSinceEpoch(
                                item.startTime!),
                            byTitle: ' by ' +
                                item.header!.title! +
                                ', ' +
                                item.header!.subtitle1!,
                            byImage: item.header!.avatar,
                            onlyHeader: false,
                            isShareVisible: true,
                            isModerator: item.eventRoleType == 'admin',
                          );
                        } else {
                          return TricycleUserListTile(
                            imageUrl: null,
                            onPressed: () {
                              setState(() {
                                isSearching = true;
                                searchVal =
                                    searchHistory![index].searchVal;
                              });
                            },
                            service_type:
                            searchHistory![index].entityType ==
                                'person'
                                ? SERVICE_TYPE.PERSON
                                : SERVICE_TYPE.INSTITUTION,
                            iconWidget: Container(
                              child: Icon(
                                Icons.access_time_rounded,
                                color:
                                HexColor(AppColors.appColorBlack35),
                              ),
                            ),
                            isFullImageUrl: false,
                            title: searchHistory![index].searchVal ?? "",
                            subtitle1: null,
                            padding: EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                                left: 12,
                                right: 12),
                            margin: EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                color:
                                HexColor(AppColors.appColorWhite),
                                borderRadius: BorderRadius.circular(12)
                              // borderRadius: BorderRadius.only(
                              //   topLeft: (index == 0)
                              //       ? Radius.circular(12)
                              //       : Radius.circular(0),
                              //   topRight: (index == 0)
                              //       ? Radius.circular(12)
                              //       : Radius.circular(0),
                              //   bottomLeft: (index == 4)
                              //       ? Radius.circular(12)
                              //       : Radius.circular(0),
                              //   bottomRight: (index == 4)
                              //       ? Radius.circular(12)
                              //       : Radius.circular(0),
                              // )
                            ),
                          );
                        }

                        /* ListTile(
                        leading: Container(
                          margin: const EdgeInsets.only(
                            right: 8,
                          ),
                          child: Icon(Icons.access_time_rounded),
                        ),
                        title: Text(searchHistory[index].searchVal),
                      )*/
                      }, childCount: searchHistory!.length),
                )
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: suggestions != null && suggestions!.isNotEmpty
                        ? Text(
                      AppLocalizations.of(context)!
                          .translate('suggested_connections'),
                      style: styleElements
                          .subtitle1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                        : Container(),
                  ),
                ),
                suggestions != null && suggestions!.isNotEmpty
                    ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return TricycleUserListTile(
                          imageUrl: Config.BASE_URL +
                              suggestions![index].avatar!,
                          isFullImageUrl: true,
                          userId: suggestions![index].id,
                          trailingWidget: suggestions![index].id !=
                              ownerId &&
                              !suggestions![index].isFollowed!
                              ? GenericFollowUnfollowButton(
                            actionByObjectType:
                            prefs!.getString("ownerType"),
                            actionByObjectId:
                            prefs!.getInt("userId"),
                            actionOnObjectType: "person",
                            actionOnObjectId:
                            suggestions![index].id,
                            engageFlag:
                            AppLocalizations.of(context)!
                                .translate('follow'),
                            actionFlag: "F",
                            actionDetails: [],
                            personName:
                            suggestions![index].title ?? "",
                            callback: (isCallSuccess) {
                              setState(() {
                                suggestions![index].isFollowed =
                                true;
                              });
                            },
                          )
                              : null,
                          callBack: (int? userId) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileCards(
                                          userType: userId == ownerId
                                              ? "person"
                                              : "thirdPerson",
                                          userId: userId != ownerId
                                              ? userId
                                              : null,
                                          callback: () {
                                            if (callback != null)
                                              callback!();
                                          },
                                          currentPosition: 1,
                                          type: null,
                                        )));
                          },
                          title: suggestions![index].title ?? "",
                          subtitle1: suggestions![index].subtitle,
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 12, right: 12),
                          margin: EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                              color: HexColor(AppColors.appColorWhite),
                              borderRadius: BorderRadius.only(
                                topLeft: (index == 0)
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                                topRight: (index == 0)
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                                bottomLeft: (index == 4)
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                                bottomRight: (index == 4)
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                              )),
                        );
                      }, childCount: suggestions!.length),
                )
                    : SliverToBoxAdapter(),
              ],
            ),
          )),
    );
  }

  String getPageTitle() {
    var vals = pageTitle!.split(' ');
    if (vals.length > 0)
      return vals[0];
    else
      return '';
  }

  Future<void> getSuggestion() async {
    prefs = await SharedPreferences.getInstance();
    final body =
    jsonEncode({"type": "network", "page_size": 20, "page_number": 1});
    var res = await Calls().call(body, context, Config.SUGGESTIONS);

    setState(() {
      suggestions = SuggestionData.fromJson(res).rows;
    });
  }

  Future<void> getHistory() async {
    GlobalSearchRequest payload = GlobalSearchRequest();
    payload.institutionId = prefs!.getInt(Strings.instituteId);
    payload.personId = prefs!.getInt(Strings.userId);
    payload.pageNumber = 1;
    payload.pageSize = 5;
    payload.searchType = 'person';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.GLOBAL_SEARCH_HISTORY);
    setState(() {
      searchHistory = GlobalSearchHistoryResponse.fromJson(res).rows;
    });
  }

  void exitRoom(RoomListItem value) {
    MembershipRoleStatusPayload payload = MembershipRoleStatusPayload();
    payload.roomId = value.id;
    payload.memberId = prefs!.getInt(Strings.userId);
    payload.memberType = "person";
    payload.action = MEMBERSHIP_ROLE.remove.type;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.MEMBERSHIP_STATUS_UPDATE).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder()
            .showToast("success", context, HexColor(AppColors.information));
        // refresh();
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void joingroup(RoomListItem value) {
    MemberAddPayload payload = MemberAddPayload();
    payload.roomId = value.id;
    payload.roomInstitutionId = prefs!.getInt(Strings.instituteId);
    payload.isAddAllMembers = false;
    List<MembersItem> list = [];
    MembersItem item = MembersItem();
    item.memberType = 'person';
    item.memberId = prefs!.getInt(Strings.userId);
    item.addMethod = MEMBER_ADD_METHOD.JOIN.type;
    list.add(item);
    payload.members = list;
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.MEMBER_ADD).then((value) {
      var res = DynamicResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            "successfully joined", context, HexColor(AppColors.information));
        // refresh();
      } else {
        ToastBuilder()
            .showToast(res.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void _onShare(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
  }

  void saveHistory(dynamic entity, String type) {
    SaveHistoryRequest payload = SaveHistoryRequest(
        entityType: type,
        pageNumber: 1,
        pageSize: 10,
        institutionId: prefs!.getInt(Strings.instituteId),
        personId: prefs!.getInt(Strings.userId),
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
