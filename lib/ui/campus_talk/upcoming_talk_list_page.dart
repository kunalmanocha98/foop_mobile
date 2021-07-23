import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/event_status_code.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/models/campus_talk/talk_event_models.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/ui/campus_talk/talk_audience_list_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_live_event.dart';
import 'package:oho_works_app/ui/dialogs/dialog_wait_event.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invite_user_page.dart';

class UpcomingTalkListPage extends StatefulWidget {
  UpcomingTalkListPage();

  @override
  UpcomingTalkListPageState createState() => UpcomingTalkListPageState();
}

class UpcomingTalkListPageState extends State<UpcomingTalkListPage> {
  static const String ON_EVENT_LIVE = 'event_live';
  static const String ON_EVENT_ENDED = 'event_ended';
  static const String ON_EVENT_MEMBER_STATUS = 'event_member_status';
  static const String EMIT_ON_EVENT_RATING = "event_rating";
  static const String ON_EVENT_CREATE = "event_create";

  List<EventListItem> eventList = [];
  SharedPreferences? prefs = locator<SharedPreferences>();
  SocketService? socketService = locator<SocketService>();
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  List<EventListItem> confirmedList = [];
  PAGINATOR_ENUMS pageEnum = PAGINATOR_ENUMS.LOADING;
  int page = 1;
  int? totalItems = 0;
  bool loadSuggestions = false;
  int i = 0;
  GlobalKey<TalkEventPageState> talk = GlobalKey();

  @override
  void initState() {
    super.initState();
    setUpSocket();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initialFutureCall();
    });
  }

  void refresh() {
    page = 1;
    totalItems = 0;
    loadSuggestions = false;
    i = 0;
    confirmedList.clear();
  }

  void setUpSocket() {
    audioSocketService!.getSocket()!.on(ON_EVENT_LIVE, onEventLive);
    audioSocketService!.getSocket()!.on(EMIT_ON_EVENT_RATING, onEventRating);
    audioSocketService!.getSocket()!.on(ON_EVENT_CREATE, onEventCreate);
  }

  void switchOffSocket() {
    audioSocketService!.getSocket()!.off(ON_EVENT_LIVE, onEventLive);
    audioSocketService!.getSocket()!.off(EMIT_ON_EVENT_RATING, onEventRating);
    audioSocketService!.getSocket()!.off(ON_EVENT_CREATE, onEventCreate);
  }

  void initialFutureCall() async {
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.ACTIVE.status;
    payload.listType = 'general';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST);
    var response = EventListResponse.fromJson(res);
    if (response.statusCode == Strings.success_code) {
      if(response.rows!=null && response.rows!.length >0) {
        setState(() {
          confirmedList.addAll(response.rows!);
          totalItems = response.total;
          pageEnum = PAGINATOR_ENUMS.SUCCESS;
        });
      }else{
        setState(() {
          pageEnum = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            switchOffSocket();
            return Future.value(true);
          },
          child: Scaffold(
              appBar: TricycleAppBar().getCustomAppBar(
                context,
                appBarTitle:
                AppLocalizations.of(context)!.translate('upcoming_talks'),
                onBackButtonPress: () {
                  switchOffSocket();
                  Navigator.pop(context);
                },
              ),
              body: _buildList()),
        ));
  }

  int? _getItemCount() {
    if (!loadSuggestions) {
      if (totalItems! > confirmedList.length) {
        print("count ${confirmedList.length + 1}");
        return confirmedList.length + 1;
      } else {
        loadSuggestions = true;
        page = 0;
        print("count ${confirmedList.length + 1}");
        return confirmedList.length + 1;
      }
    } else {
      if (totalItems! > confirmedList.length) {
        print("count ${confirmedList.length + 1}");
        return confirmedList.length + 1;
      } else {
        print("count $totalItems");
        return totalItems;
      }
    }
  }

  Widget _buildList() {
    if (pageEnum == PAGINATOR_ENUMS.SUCCESS) {
      return ListView.builder(
        itemCount: _getItemCount(),
        itemBuilder: itemBuilder,
      );
    } else if (pageEnum == PAGINATOR_ENUMS.LOADING) {
      return CustomPaginator(context).loadingWidgetMaker();
    } else {
      return emptyListWidgetMaker();
    }
  }

  Widget emptyListWidgetMaker() {
    return CustomPaginator(context).emptyListWidgetMaker(null,
        message: AppLocalizations.of(context)!.translate('no_events_found'),
        assetImage: 'assets/appimages/live.png');
  }

  Widget itemBuilder(BuildContext context, int index) {
    if (index < confirmedList.length) {
      return listItemBuilder(confirmedList[index], index);
    } else {
      return FutureBuilder(
        future: loadSuggestions
            ? fetchListSuggestions(page + 1)
            : fetchList(page + 1),
        builder:
            (BuildContext context, AsyncSnapshot<EventListResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CustomPaginator(context).loadingWidgetMaker();
            case ConnectionState.done:
              {
                if (snapshot.data!.rows != null) {
                  confirmedList.addAll(snapshot.data!.rows!);
                }
                page++;
                Future.microtask(() {
                  setState(() {});
                });
                return CustomPaginator(context).loadingWidgetMaker();
              }
            default:
              return CustomPaginator(context).loadingWidgetMaker();
          }
        },
      );
    }
  }

  List<EventListItem>? listItemsGetter(EventListResponse pageData) {
    eventList.addAll(pageData.rows!);
    return pageData.rows;
  }

  Future<EventListResponse> fetchList(int page) async {
    TalkEventListRequest payload = TalkEventListRequest();
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.ACTIVE.status;
    payload.listType = 'general';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST);
    return EventListResponse.fromJson(res);
  }

  Future<EventListResponse> fetchListSuggestions(int page) async {
    TalkEventListRequest payload = TalkEventListRequest();
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.ACTIVE.status;
    payload.listType = 'suggestions';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST);
    var response = EventListResponse.fromJson(res);
    if (response.statusCode == Strings.success_code) {
      if (i == 0) {
        i++;
        totalItems = totalItems! + response.total!;
      }
    }
    return response;
  }

  Widget listItemBuilder(itemData, int index) {
    // EventListItem item = itemData;
    return TricycleEventCard(
      cardHeight: 240,
      title: confirmedList[index].title,
      description: confirmedList[index].subtitle,
      dateVisible: true,
      date: DateTime.fromMillisecondsSinceEpoch(confirmedList[index].startTime!),
      isLive: false,
      byTitle: ' by ' +
          confirmedList[index].header!.title! +
          ', ' +
          confirmedList[index].header!.subtitle1!,
      byImage: confirmedList[index].header!.avatar,
      onlyHeader: false,
      isShareVisible: true,
      cardRating: confirmedList[index].header!.rating ?? 0.0,
      isRated: getIsRated(confirmedList[index].header!),
      shareCallback: () {
        shareCallback(confirmedList[index].id);
      },
      isModerator: (confirmedList[index].isModerator != null &&
          confirmedList[index].isModerator == 1),
      ownerId: confirmedList[index].eventOwnerId,
      ownerType: confirmedList[index].eventOwnerType,
      subjectId: confirmedList[index].id,
      inviteUsersVisible: confirmedList[index].eventPrivacyType == 'public' ||
          confirmedList[index].eventPrivacyType == 'campus' || (confirmedList[index].isModerator != null &&
          confirmedList[index].isModerator == 1),
      inviteUsersCallback: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return InviteTalkParticipants(
                eventId: confirmedList[index].id,
                privacyType: confirmedList[index].eventPrivacyType,
              );
            }));
      },
      subjectType: 'event',
      showRateCount: false,
      isRatingVisible: false,
      isHorizontalCard: true,
      ratingCallback: () {
        Future.delayed(Duration(seconds: 1), () {
          emitRatingSuccess(confirmedList[index].id);
        });
        // for (var i in confirmedList[index]
        //     .header
        //     .action) {
        //   if (i.type == 'is_rated') {
        //     i.value = true;
        //   }
        // }
      },
      onClickEvent: () {
        if (confirmedList[index].isModerator != null &&
            confirmedList[index].isModerator == 1) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogLiveEvent(
                  date: Utility().getDateFormat(
                      'dd MMM yyyy HH:mm',
                      DateTime.fromMillisecondsSinceEpoch(
                          confirmedList[index].startTime!)),
                  okCallback: () {
                    Navigator.push(
                        context,
                        TricycleRouteSlideBottom(
                            page: TalkEventPage(
                              key: talk,
                              socket: socketService!.getSocket(),
                              eventModel: confirmedList[index],
                              successCallback: refresh,
                            )));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder:
                    //         (BuildContext
                    //     context) {
                    //       return TalkEventPage(
                    //         key: talk,
                    //         socket: socketService.getSocket(),
                    //         eventModel: confirmedList[index],
                    //         successCallback: refresh,
                    //       );
                    //     })).then((value) {
                    //   setUpSocket();
                    //   refresh();
                    // });
                  },
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogWaitEvent(
                  date: Utility().getDateFormat(
                      'dd MMM yyyy HH:mm',
                      DateTime.fromMillisecondsSinceEpoch(
                          confirmedList[index].startTime!)),
                );
              });
        }
      },
    );
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void shareCallback(int? eventId) {
    createDeeplink!.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs!.getInt(Strings.userId).toString(),
        eventId,
        DEEPLINKTYPE.CALENDAR.type,
        context);
  }

  bool getIsRated(Header header) {
    bool? isRated;
    for (var i in header.action!) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }

  emitRatingSuccess(int? id) {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = id;
    payload.personId = prefs!.getInt(Strings.userId);
    audioSocketService!.getSocket()!.emit(EMIT_ON_EVENT_RATING, payload);
  }

  onEventRating(data) {
    log("OnEvent--Rated-campus page-----" + jsonEncode(data));
    var res = EventListItem.fromJson(data);
    log("OnEvent--Rated-campus page-----" + res.header!.rating.toString());
    if (confirmedList.any((element) {
      return element.id == res.id;
    })) {
      var index = confirmedList.indexWhere((element) {
        return element.id == res.id;
      });
      confirmedList[index].header = res.header;
      Future.microtask(() {
        setState(() {});
      });
    }
  }

  onEventLive(data) {
    log("OnEventLive------" + jsonEncode(data));
    var res = EventListItem.fromJson(data);
    if (confirmedList.any((element) {
      return element.id == res.id;
    })) {
      var index = confirmedList.indexWhere((element) {
        return element.id == res.id;
      });
      confirmedList.removeAt(index);
      totalItems=totalItems!-1;
      Future.microtask(() {
        setState(() {});
      });
    }
  }

  onEventCreate(data) {
    log("OnEventCreated------" + jsonEncode(data));
    var res = EventListItem.fromJson(data);
    if (!confirmedList.any((element) {
      return element.id == res.id;
    })) {
      if (res.eventOwnerId != prefs!.getInt(Strings.userId)) {
        confirmedList.insert(0, res);
        totalItems=totalItems!+1;
        Future.microtask(() {
          setState(() {});
        });
      }
    }
  }
}
