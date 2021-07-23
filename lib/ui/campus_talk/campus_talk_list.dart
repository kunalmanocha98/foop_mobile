import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/tricycle_event_card.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/event_status_code.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/event_bus/leave_event.dart';
import 'package:oho_works_app/event_bus/make_event_open.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/models/campus_talk/talk_event_models.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/campus_talk/invite_user_page.dart';
import 'package:oho_works_app/ui/campus_talk/talk_audience_list_page.dart';
import 'package:oho_works_app/ui/campus_talk/upcoming_talk_list_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_live_event.dart';
import 'package:oho_works_app/ui/dialogs/dialog_wait_event.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampusTalkListPage extends StatefulWidget {
  final int? eventId;


  CampusTalkListPage(
      {Key? key,
       this.eventId,})
      : super(key: key);
  @override
  CampusTalkPageState createState() => CampusTalkPageState();
}

class CampusTalkPageState extends State<CampusTalkListPage> {

  static const String ON_EVENT_LIVE = 'event_live';
  static const String ON_EVENT_ENDED = 'event_ended';
  static const String ON_EVENT_MEMBER_STATUS = 'event_member_status';
  static const String EMIT_ON_EVENT_RATING = "event_rating";
  static const String ON_EVENT_CREATE = "event_create";

  SharedPreferences? prefs = locator<SharedPreferences>();
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  SocketService? socketService = locator<SocketService>();

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();
  late TextStyleElements styleElements;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  bool isLoading = true;
  List<EventListItem> confirmedList = [];
  List<EventListItem> liveList = [];
  GlobalKey<TalkEventPageState> talk = GlobalKey();
  PAGINATOR_ENUMS pageEnum = PAGINATOR_ENUMS.LOADING;
  int page = 1;
  int? totalItems = 0;
  bool loadSuggestions = false;
  int i = 0;
  EventBus? eventbus = locator<EventBus>();

  late BuildContext sctx;


  CampusTalkPageState();

  @override
  void initState() {
    if(audioSocketService!.getSocket()!.disconnected){
      audioSocketService!.getSocket()!.connect();
    }
    _getContactPermission();
    if(Platform.isAndroid) {
      _getForegroundPermission();
    }
    setUpSocket();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchUpcomingList();
      if(widget.eventId!=null){
        fetchEventDetails();
      }
      // initialFutureCall();
    });
  }




  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.microphone.status;
    // final camera = await Permission.camera.status;

 await Permission.camera.request();

    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      return result;
    } else {
      return status;
    }


  }
  void setUpSocket(){
    audioSocketService!.getSocket()!.clearListeners();
    audioSocketService!.getSocket()!.on(ON_EVENT_LIVE,onEventLive);
    audioSocketService!.getSocket()!.on(ON_EVENT_ENDED, onEventEnded);
    audioSocketService!.getSocket()!.on(ON_EVENT_MEMBER_STATUS, onEventMemberStatusChanged);
    audioSocketService!.getSocket()!.on(EMIT_ON_EVENT_RATING, onEventRating);
    audioSocketService!.getSocket()!.on(ON_EVENT_CREATE, onEventCreate);
  }
  void switchOffSocket(){
    audioSocketService!.getSocket()!.off(ON_EVENT_LIVE,onEventLive);
    audioSocketService!.getSocket()!.off(ON_EVENT_ENDED, onEventEnded);
    audioSocketService!.getSocket()!.off(ON_EVENT_MEMBER_STATUS, onEventMemberStatusChanged);
    audioSocketService!.getSocket()!.off(EMIT_ON_EVENT_RATING, onEventRating);
    audioSocketService!.getSocket()!.off(ON_EVENT_CREATE, onEventCreate);
  }


  @override
  void dispose() {
    super.dispose();
  }

  void refresh(){
    page = 1;
    totalItems = 0;
    loadSuggestions = false;
    i=0;
    confirmedList.clear();
    liveList.clear();
    fetchUpcomingList();
  }

  Widget _simplePopup() {
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 30,
        color: HexColor(AppColors.appColorBlack65),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => CampusTalkDropMenu(context: context).menuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'voice':
            {
              break;
            }
          case 'upcoming':
            {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return UpcomingTalkListPage();
                  })).then((value){
                setUpSocket();
                refresh();
              });
              break;
            }
          case 'bookmark':
            {
              break;
            }
          default:
            {
              break;
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(

        appBar: AppBarWithOnlyTitle(
          title: AppLocalizations.of(context)!.translate('campus_talk'),
          actions: [
            IconButton(
                icon: Icon(Icons.add,size: 30,),
                color: HexColor(AppColors.appColorBlack65),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CreateEventPage(
                          type: 'talk',
                          standardEventId: 5,
                        );
                      })).then((value) {
                        setUpSocket();
                        refresh();
                  });
                }),
            _simplePopup()
          ],
        ),
        body: Builder(
          builder: (BuildContext context){
            this.sctx = context;
            return NestedScrollView(

                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    (confirmedList.length > 0)
                        ? SliverToBoxAdapter(
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Upcoming Talks',
                            style:
                            styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              switchOffSocket();
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return UpcomingTalkListPage();
                                  })).then((value){
                                    setUpSocket();
                                    refresh();
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('see_more'),
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(
                                  color:
                                  HexColor(AppColors.appMainColor)),
                            ))
                      ]),
                    )
                        : SliverToBoxAdapter(
                      child: Container(
                        height: 10,
                      ),
                    ),
                    isLoading
                        ? SliverToBoxAdapter(
                      child: PreLoadingShimmerCard(),
                    )
                        : (confirmedList.length > 0)
                        ? SliverToBoxAdapter(
                      child: SizedBox(
                        height: 240,
                        child: ListView.builder(
                          itemCount: confirmedList.length < 10 ? confirmedList.length : 10,
                          itemExtent: 400,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
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
                              cardRating:
                              confirmedList[index].header!.rating ??
                                  0.0,
                              isRated: getIsRated(confirmedList[index].header!),
                              shareCallback: (){
                                shareCallback(confirmedList[index].id);
                              },
                              isModerator: (confirmedList[index].isModerator!=null &&  confirmedList[index].isModerator == 1),
                              ownerId: confirmedList[index].eventOwnerId,
                              ownerType: confirmedList[index].eventOwnerType,
                              subjectId: confirmedList[index].id,
                              inviteUsersVisible: confirmedList[index].eventPrivacyType == 'public' || confirmedList[index].eventPrivacyType == 'campus' || (confirmedList[index].isModerator!=null &&  confirmedList[index].isModerator == 1),
                              inviteUsersCallback: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
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
                                Future.delayed(Duration(seconds: 1),(){
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
                                if (confirmedList[index].isModerator!=null && confirmedList[index].isModerator == 1) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogLiveEvent(
                                          date: Utility().getDateFormat(
                                              'dd MMM yyyy HH:mm',
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  confirmedList[index]
                                                      .startTime!)),
                                          okCallback: () {
                                            Navigator.push(context, TricycleRouteSlideBottom(
                                              page: TalkEventPage(
                                                        key: talk,
                                                        socket: socketService!.getSocket(),
                                                        eventModel: confirmedList[index],
                                                        successCallback: refresh,
                                                      )
                                            )).then((value){
                                                setUpSocket();
                                                refresh();
                                            });
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
                                                  confirmedList[index]
                                                      .startTime!)),
                                        );
                                      });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    )
                        : SliverToBoxAdapter(
                      child: Container(),
                    )
                  ];
                },
                body: _buildList());
          },
        ));
  }

  void initialFutureCall() async {
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.LIVE.status;
    payload.listType = 'general';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST);
    var response = EventListResponse.fromJson(res);
    if (response.statusCode == Strings.success_code) {
      setState(() {
        liveList.addAll(response.rows!);
        totalItems = response.total;
        pageEnum = PAGINATOR_ENUMS.SUCCESS;
      });
    } else {
      setState(() {
        pageEnum = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int? _getItemCount() {
    if (!loadSuggestions) {
      if (totalItems! > liveList.length) {
        return liveList.length + 1;
      } else {
        loadSuggestions = true;
        page = 0;
        return liveList.length + 1;
      }
    } else {
      if (totalItems! > liveList.length) {
        return liveList.length + 1;
      } else {
        return totalItems;
      }
    }
  }

  Widget _buildList() {
    if (pageEnum == PAGINATOR_ENUMS.SUCCESS) {
      var count = _getItemCount();
      return count !=0?ListView.builder(
        padding: EdgeInsets.only(bottom: 160),
        itemCount: count,
        itemBuilder: itemBuilder,
      ):emptyListWidgetMaker();
    } else if (pageEnum == PAGINATOR_ENUMS.LOADING) {
      return CustomPaginator(context).loadingWidgetMaker();
    } else {
      return emptyListWidgetMaker();
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    if (index < liveList.length) {
      print('here');
      return listItemBuilder(liveList[index], index);
    } else {
      print('there');
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
                liveList.addAll(snapshot.data!.rows!);
                page++;
                Future.microtask(() {
                  setState(() {
                    print("itembuilder");
                  });
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

  Widget emptyListWidgetMaker() {
    return Center(
      child: TricycleEmptyWidgetForAudioList(
            message: AppLocalizations.of(context)!.translate('no_audio_events'),
            assetImage: 'assets/appimages/live.png'),
    );
    // );
    // return CustomPaginator(context).emptyListWidgetMaker(
    //     null,

  }

  Future<EventListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    // payload.eventDate= Utility().getDateFormat('yyyy-MM-dd',DateTime.now());
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.LIVE.status;
    payload.listType = loadSuggestions ? 'suggestions' : 'general';
    var res = await Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST);
    return EventListResponse.fromJson(res);
  }

  Future<EventListResponse> fetchListSuggestions(int page) async {
    // sleep(Duration(seconds: 1));
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    // payload.eventDate= Utility().getDateFormat('yyyy-MM-dd',DateTime.now());
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.LIVE.status;
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

  Widget listItemBuilder(EventListItem item, int index) {
    return TricycleEventCard(
      title: item.title,
      listofImages: item.participantList != null
          ? List<String?>.generate(item.participantList!.length, (index) {
        return item.participantList![index].profileImage;
      })
          : null,
      description: item.subtitle,
      dateVisible: true,
      // date: DateTime.parse(item.startTime),
      isLive: true,
      byTitle: ' by ' + item.header!.title! + ', ' + item.header!.subtitle1!,
      byImage: item.header!.avatar,
      onlyHeader: false,
      isShareVisible: true,
      isRatingVisible: true,
      cardRating: item.header!.rating ?? 0.0,
      isRated: getIsRated(item.header!),
      isModerator: item.isModerator!=null && item.isModerator ==1,
      inviteUsersVisible: item.eventPrivacyType == 'public' || item.eventPrivacyType == 'campus' || (item.isModerator!=null && item.isModerator ==1),
      inviteUsersCallback: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return InviteTalkParticipants(
            eventId: item.id,
            privacyType: item.eventPrivacyType,
          );
        }));
      },
      shareCallback: (){
        shareCallback(item.id);
      },
      ownerId: item.eventOwnerId,
      ownerType: item.eventOwnerType,
      subjectId: item.id,
      subjectType: 'event',
      showRateCount: false,
      ratingCallback: () {
        Future.delayed(Duration(seconds: 1),(){
          emitRatingSuccess(item.id);
        });
        // for (var i in liveList[index].header.action) {
        //   if (i.type == 'is_rated') {
        //     i.value = true;
        //   }
        // }
      },
      onClickEvent: () {
        if(prefs!.containsKey(Strings.current_event)){
          if(prefs!.getInt(Strings.current_event) == liveList[index].id){
            eventbus!.fire(TalkEventOpen());
          }else{
            ToastBuilder().showSnackBar(AppLocalizations.of(sctx)!.translate('event_warning'), context, HexColor(AppColors.failure));
          }
        }else {
          Navigator.push(context, TricycleRouteSlideBottom(
              page: TalkEventPage(
                key: talk,
                socket: socketService!.getSocket(),
                eventModel: liveList[index],
                successCallback: refresh,
              )
          )).then((value) {
            setUpSocket();
            refresh();
          });
        }
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) {
        //       return TalkEventPage(
        //         key: talk,
        //         socket: socketService.getSocket(),
        //         eventModel: liveList[index],
        //         successCallback: refresh,
        //       );
        //     })).then((value) {

        // });
      },
    );
  }

  void shareCallback(int? eventId){
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs!.getInt(Strings.userId).toString(),
        eventId,
        DEEPLINKTYPE.CALENDAR.type,
        context);
  }

  void fetchUpcomingList() async {
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    // payload.eventDate= Utility().getDateFormat('yyyy-MM-dd',DateTime.now());
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = 1;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.ACTIVE.status;
    payload.listType = 'general';
    Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST)
        .then((value) {
      var res = EventListResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        confirmedList.addAll(res.rows!);
        fetchUpcomingListSuggestions();
      } else {
        fetchUpcomingListSuggestions();
      }
    });
  }

  void fetchUpcomingListSuggestions() async {
    prefs ??= await SharedPreferences.getInstance();
    TalkEventListRequest payload = TalkEventListRequest();
    // payload.eventDate= Utility().getDateFormat('yyyy-MM-dd',DateTime.now());
    payload.eventOwnerId = prefs!.getInt(Strings.userId);
    payload.eventOwnerType = 'person';
    payload.pageNumber = 1;
    payload.pageSize = 10;
    payload.eventStatus = EVENT_STATUS.ACTIVE.status;
    payload.listType = 'suggestions';
    Calls()
        .call(jsonEncode(payload), context, Config.TALK_EVENT_LIST)
        .then((value) {
      initialFutureCall();
      var res = EventListResponse.fromJson(value);
      Future(() {
        isLoading = false;
        setState(() {
          if (res.statusCode == Strings.success_code) {
            confirmedList.addAll(res.rows!);
          }
        });
      });
    }).catchError((onError){
      Future(() {
        isLoading = false;
        setState(() {
        });
      });
      initialFutureCall();
    });
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

  emitRatingSuccess(int? id ) {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = id;
    payload.personId = prefs!.getInt(Strings.userId);
    audioSocketService!.getSocket()!.emit(EMIT_ON_EVENT_RATING,payload);
  }

  onEventRating(data) {
    log("OnEvent--Rated-campus page-----"+ jsonEncode(data));
    var res = EventListItem.fromJson(data);
    log("OnEvent--Rated-campus page-----"+ res.header!.rating.toString());
    if(confirmedList.any((element){return element.id == res.id;})){
      var index = liveList.indexWhere((element) {return element.id == res.id;});
      confirmedList[index].header = res.header;
      Future.microtask(() {
        setState(() {});
      });
    }else if(liveList.any((element){return element.id == res.id;})){
      var index = liveList.indexWhere((element) {return element.id == res.id;});
      liveList[index].header = res.header;
      Future.microtask(() {
        setState(() {});
      });
    }
  }

  onEventLive(data) {
    log("OnEventLive------"+ jsonEncode(data));
    var res = EventListItem.fromJson(data);
    if(confirmedList.any((element){return element.id == res.id;})){
      var index = confirmedList.indexWhere((element) {return element.id == res.id;});
      var confirmedItem  = confirmedList.elementAt(index);
      confirmedList.removeAt(index);
      res.isModerator = confirmedItem.isModerator;
      liveList.add(res);
      totalItems = totalItems! +1 ;
      Future.microtask(() {
        setState(() {});
      });
    }else{
      liveList.add(res);
      totalItems = totalItems! +1 ;
      Future.microtask(() {
        setState(() {});
      });
    }
  }

  onEventEnded(data) {
    log("OnEventEnded------"+ jsonEncode(data));
    var res = EventListItem.fromJson(data);
    try {
      var index = liveList.indexWhere((element) {
        return element.id == res.id;
      });
      liveList.removeAt(index);
      totalItems = totalItems! - 1;
      eventbus!.fire(TalkEventEnd(id: res.id));
      Future.microtask(() {
        setState(() {});
      });
    }catch(onError){
      log(onError.toString());
    }
  }
  void newMessage()
  {
    print("event_message-----------------------------------------------step2");
   talk.currentState!.newMessage();
  }
  onEventMemberStatusChanged(data) {
    log("onMemberStatus Changed------"+ jsonEncode(data));
    var res = EventListItem.fromJson(data);
    try {
      var index = liveList.indexWhere((element) {
        return element.id == res.id;
      });
      liveList[index].participantList = res.participantList;
      Future.microtask(() {
        setState(() {});
      });
    // ignore: empty_catches
    }catch(onError){

    }
  }
  onEventCreate(data) {
    log("OnEventCreated------"+ jsonEncode(data));
    var res = EventListItem.fromJson(data);
    if(!confirmedList.any((element){return element.id == res.id;})){
      if(res.eventOwnerId != prefs!.getInt(Strings.userId)) {
        confirmedList.insert(0, res);
        Future.microtask(() {
          setState(() {});
        });
      }
    }
  }

  void fetchEventDetails() async{
    var payload  = {
      "event_id":widget.eventId
    };
    var res  = await Calls().call(jsonEncode(payload), context, Config.TALK_EVENT_VIEW);
    var response  = EventViewResponse.fromJson(res);
    if(response.rows!.eventStatus == EVENT_STATUS.ACTIVE.status){
      ToastBuilder().showSnackBar('Event has not started yet', sctx, HexColor(AppColors.information));
    }else if(response.rows!.eventStatus == EVENT_STATUS.LIVE.status) {

      Navigator.push(context, TricycleRouteSlideBottom(
          page: TalkEventPage(
            key: talk,
            socket: socketService!.getSocket(),
            eventModel: response.rows,
            successCallback: refresh,
          )
      )).then((value) {
        setUpSocket();
        refresh();
      });
    }else if(response.rows!.eventStatus == EVENT_STATUS.ENDED.status) {
      ToastBuilder().showSnackBar('Event has ended', sctx, HexColor(AppColors.failure));
    }else{
      ToastBuilder().showSnackBar('Event has ended', sctx, HexColor(AppColors.failure));
    }
  }

  void _getForegroundPermission() async{
    FlutterBackground.initialize();
  }


}

class CampusTalkDropMenu {
  late TextStyleElements styleElements;
  BuildContext context;

  CampusTalkDropMenu({required this.context}) {
    styleElements = TextStyleElements(context);
  }

  List<PopupMenuItem> get menuList {
    List<PopupMenuItem> list = [];
    list.add(PopupMenuItem(
        enabled: false,
        value: '',
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.translate('campus_talk'),
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));

    // list.add(PopupMenuItem(
    //     value: 'voice',
    //     child: PostListMenu(context: context).getUiElement(
    //         AppLocalizations.of(context).translate('voice_channel'),
    //         AppLocalizations.of(context).translate('voice_channel_des'),
    //         'assets/appimages/general-post.png')));

    list.add(PopupMenuItem(
        value: 'upcoming',
        child: PostListMenu(context: context).getUiElement(
            AppLocalizations.of(context)!.translate('upcoming_talks'),
            AppLocalizations.of(context)!.translate('upcoming_talks_des'),
            'assets/appimages/create-articles.png')));

    // list.add(PopupMenuItem(
    //     value: 'bookmark',
    //     child: PostListMenu(context: context).getUiElement(
    //         AppLocalizations.of(context).translate('bookmarked'),
    //         AppLocalizations.of(context).translate('bookmarked_des'),
    //         'assets/appimages/create-ask.png')));

    return list;
  }

  List<PopupMenuItem> get eventMenuList {
    List<PopupMenuItem> list = [];

    list.add(PopupMenuItem(
        enabled: false,
        value: '',
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.translate('event'),
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));

    list.add(PopupMenuItem(
        value: 'search',
        child: PostListMenu(context: context).getUiElement(
            AppLocalizations.of(context)!.translate('search'),
            AppLocalizations.of(context)!.translate('search_des'),
            'assets/appimages/general-post.png')));

    // list.add(PopupMenuItem(
    //     value: 'menu',
    //     child: PostListMenu(context: context).getUiElement(
    //         AppLocalizations.of(context).translate('search'),
    //         AppLocalizations.of(context).translate('search_des'),
    //         'assets/appimages/general-post.png')));
    return list;
  }
}
