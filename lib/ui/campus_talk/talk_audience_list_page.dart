import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/app_event_card.dart';
import 'package:oho_works_app/components/app_talk_footer.dart';
import 'package:oho_works_app/components/app_talk_footer_button.dart';
import 'package:oho_works_app/event_bus/event_model.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/models/notification_count_response.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/models/unread_messages_count.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/campus_talk/event_post_screen.dart';
import 'package:oho_works_app/ui/campus_talk/nexge_video_audience_page.dart';
import 'package:oho_works_app/ui/campus_talk/talk_audience_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../postcreatepage.dart';
import 'campus_talk_list.dart';
import 'event_chat_screen.dart';

class TalkEventPage extends StatefulWidget {
  final IO.Socket? socket;
  final EventListItem? eventModel;
  final Function? successCallback;
  final bool? hideLoader;
  final TALKFOOTERENUM? role;
  final int? startTime;

  TalkEventPage(
      {Key? key,
      this.socket,
      this.eventModel,
      this.successCallback,
      this.hideLoader,
      this.role,
      this.startTime})
      : super(key: key);

  @override
  TalkEventPageState createState() => TalkEventPageState(
      socket: socket,
      eventModel: eventModel,
      hideLoader: hideLoader,
      role: role);
}

class TalkEventPageState extends State<TalkEventPage> {
  static const String EMIT_ON_EVENT_RATING = "event_rating";
  TextStyleElements? styleElements;
  BuildContext? sctx;
  final IO.Socket? socket;
  EventListItem? eventModel;
  int _selectedIndex = 0;
  int chatCount = 0;
  final db = DatabaseHelper.instance;
  bool? hideLoader;

  TalkEventPageState(
      {this.socket, this.eventModel, this.hideLoader, this.role});

  String? conversationId;
  SharedPreferences? prefs = locator<SharedPreferences>();
  List<int> participantIds = [];
  GlobalKey<TalkAudiencePageNexgeState> audiencePageKey = GlobalKey();
  GlobalKey<EventChatScreenPageState> chatPageKey = GlobalKey();
  GlobalKey<appTalkFooterState> footerKey = GlobalKey();
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  EventBus? eventbus = locator<EventBus>();
  GlobalKey<EventPostScreenPageState> postScreenKey = GlobalKey();

  TALKFOOTERENUM? role;

  List<Widget> get _widgetOptions => [


    TalkAudiencePageNexge(
            key: audiencePageKey,
            eventId: eventModel!.id,
            authToken: "",
            hideLoader: hideLoader,
            role: role,
            startTime: widget.startTime,
            eventModel: eventModel,
            participantId: prefs!.getInt(Strings.userId).toString(),
            mute: eventModel!.isMute ?? true,
            participantIds: participantIds,
            countCallBack: countUpdate,
            successCallback: widget.successCallback,
            updateHandRaise: updateHandRaise,
            muteCallback: updateMuteStatus,
            popCallback: () {
              Navigator.pop(context);
            },
            conversationCallBack: (String? id) {
              print(id ??
                  "-----------------------------------------------------");
              // setState(() {
                conversationId = id;
                if (conversationId != null) getCount(conversationId!);
              // });
            },
            ratingSuccessCallback: emitRatingSuccess,
            closeMinimizeActions: closeMinimizeActions,
            roleCallback: roleCallback),
        EventChatScreenPage(
          key: chatPageKey,
          conversationId: conversationId,
          eventName: eventModel!.title,
          eventImage: eventModel!.eventImage,
          eventId: eventModel!.id,
          participantId: prefs!.getInt(Strings.userId),
        ),
        EventPostScreenPage(
          key: postScreenKey,
          eventId: eventModel!.id,
        )
      ];

  @override
  void initState() {
    audioSocketService!.getSocket()!.on(EMIT_ON_EVENT_RATING, onEventRating);
    super.initState();
  }

  /* _hangUp() async {
    await db.deleteParticipants();
    NexgeAudioConference.close();
    print("Hangup.......");
  }*/
  @override
  void dispose() {
    super.dispose();
  }

  Widget _simplePopup() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        size: 24,
        color: HexColor(AppColors.appColorBlack65),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) =>
          CampusTalkDropMenu(context: context).eventMenuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'search':
            {
              audiencePageKey.currentState!.menuCalls('search');
              break;
            }
          case 'menu':
            {
              audiencePageKey.currentState!.menuCalls('menu');
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

  closeMinimizeActions() {
    print("minimie actions closed");
    eventbus!.fire(TalkEventData(
        model: null,
        showPlayback: false,
        engine: null));
  }

  void newMessage() {
    print("event_message-----------------------------------------------step3");
    chatCountIncrementUpdate();
    // setState(() {
    //   chatCount = chatCount + 1;
    // });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 1 || _selectedIndex == 2) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          setState(() {
            roleCallback(role);
            _selectedIndex = 0;
          });
          return false;
        } else {
          audiencePageKey.currentState!.switchOffSocket();
          eventbus!.fire(
              TalkEventData(
              model: eventModel,
              showPlayback: true,
              role: role,
              startTime: audiencePageKey.currentState!.getStartTime(),
              engine: null));
          // Navigator.pop(context);
          // audiencePageKey.currentState.leaveEvent();
          // eventbus.fire(TalkEventData(
          //     model: null,
          //     showPlayback: false,
          //     engine: audiencePageKey.currentState.engine.instance()));
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: appTalkFooter(
              key: footerKey,
              chatCount: chatCount,
              role: role,
              isMute: eventModel!.isMute ?? true,
              postCreateCallback: () {
                _showPostBottomSheet(context);
              },
              exitCallback: () {
                audiencePageKey.currentState?.leaveEvent();
                eventbus!.fire(TalkEventData(
                    model: null,
                    showPlayback: false,
                    engine: null));
              },
              postCallback: () {
                chatPageKey.currentState!.setCurrentVisible(false);
                setState(() {
                  postScreenKey.currentState!.refresh();
                  footerKey.currentState!.updateType(TALKFOOTERENUM.post);
                  _selectedIndex = 2;
                });
              },
              muteCallBack: (bool micOn) {
                eventModel!.isMute = !micOn;
                audiencePageKey.currentState?.connectorMuteCall(!micOn);
              },
              videoCallBack: (bool isVideoOn) {


                print(isVideoOn.toString()+"-------------------------------------------!");
                audiencePageKey.currentState?.turnOnOffVideo(isVideoOn);
              },
              talkCallback: () {
                chatPageKey.currentState!.setCurrentVisible(false);
                setState(() {
                  roleCallback(role);
                  if(_selectedIndex==1)
                   chatCountReset();
                  _selectedIndex = 0;

                });
              },
              chatCallback: () {
                setState(() {
                  footerKey.currentState!.updateType(TALKFOOTERENUM.chat);
                  chatPageKey.currentState!.refresh(conversationId);
                  chatPageKey.currentState!.setCurrentVisible(true);

                  chatCountReset();

                  _selectedIndex = 1;
                });
              },
              handRaisebyOthersCallback: (value) {
                if (value) {
                  audiencePageKey.currentState!.handRaise();
                } else {
                  audiencePageKey.currentState!.handDown();
                }
              },
              handRaiseCallback: () {
                audiencePageKey.currentState!.handRaiseRequestList();
              },
            ),
            body: Builder(
              builder: (BuildContext context) {
                this.sctx = context;
                return _widgetOptions.length > 0
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onLongPress: () {},
                                    onTap: () {
                                      // audiencePageKey.currentState.leaveEvent();
                                      // widget.callback(true,eventModel);
                                      if (_selectedIndex == 0) {
                                        audiencePageKey.currentState!
                                            .switchOffSocket();
                                        eventbus!.fire(TalkEventData(
                                            model: eventModel,
                                            showPlayback: true,
                                            role: role,
                                            startTime: audiencePageKey
                                                .currentState!
                                                .getStartTime(),
                                            engine: null));
                                        Navigator.pop(context);
                                      } else {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        setState(() {
                                          roleCallback(role);
                                          _selectedIndex = 0;
                                        });
                                      }
                                    },
                                    child: (_selectedIndex == 0)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, left: 12),
                                            child: RotatedBox(
                                              quarterTurns: 1,
                                              child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: HexColor(AppColors
                                                      .appColorBlack65)),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, left: 12),
                                            child: Icon(
                                                Icons
                                                    .keyboard_backspace_rounded,
                                                color: HexColor(
                                                    AppColors.appColorBlack65)),
                                          ),
                                  ),
                                  Flexible(
                                    child: appEventCard(
                                      key: UniqueKey(),
                                      withCard: false,
                                      title: eventModel!.title,
                                      byImage: eventModel!.header!.avatar,
                                      byTitle: ' by ' +
                                          eventModel!.header!.title! +
                                          ', ' +
                                          eventModel!.header!.subtitle1!,
                                      cardRating:
                                          eventModel!.header!.rating ?? 0.0,
                                      isModerator:
                                          eventModel!.eventRoleType == 'admin',
                                      onlyHeader: true,
                                    ),
                                  ),
                                  (_selectedIndex == 0)
                                      ? _simplePopup()
                                      : Container()
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top:16.0,right:12),
                                  //   child: Icon(Icons.more_vert,color: HexColor(AppColors.appColorBlack65)),
                                  // ),
                                ],
                              ),
                              Expanded(
                                  child: IndexedStack(
                                children: _widgetOptions,
                                index: _selectedIndex,
                              ))
                            ],
                          ),
                        ),
                      )
                    : CustomPaginator(context).loadingWidgetMaker();
              },
            )),
      ),
    );
  }

  void getCount(String conversationId) async {
    GetUnreadCount unreadCount = GetUnreadCount();
    unreadCount.conversationId = conversationId;
    unreadCount.conversationOwnerId = prefs!.getInt(Strings.userId).toString();
    unreadCount.conversationOwnerType = "person";
    Calls()
        .call(
            jsonEncode(unreadCount), context, Config.CHAT_MESSAGES_UNREAD_COUNT)
        .then((value) async {
      if (value != null) {
        var res = NotificationCountResponse.fromJson(value);
        print(value.toString());
        // setState(() {
        if(res.total!=null)
        chatCountUpdate(res.total);
        else
        chatCountUpdate(0);
        // });
        //delete messages
      }
    }).catchError((onError) {});
  }

  countUpdate(int? count) {
    Future.delayed(Duration(milliseconds: 500), () {
      footerKey.currentState!.countUpdate(count!);
    });
  }

  chatCountUpdate(int? count){
    footerKey.currentState!.chatcountUpdate(count);
  }
  chatCountIncrementUpdate(){
    print("event_message-----------------------------------------------step4");
    footerKey.currentState!.incrementChatCount();
  }
  chatCountReset(){
    footerKey.currentState!.resetChatCount();
  }

  roleCallback(TALKFOOTERENUM? role) {
    Future.delayed(Duration(milliseconds: 10), () {
      this.role = role;
      footerKey.currentState!.updateType(role);
      // updateMuteStatus(eventModel.isMute ?? true);
    });

    // Future.delayed(Duration(milliseconds: 900), () {
    //   this.role = role;
    //   footerKey.currentState.updateMuteStatus(eventModel.isMute ?? true);
    // });
  }

  updateHandRaise(bool handRaise) {
    Future.delayed(Duration(milliseconds: 500), () {
      footerKey.currentState!.updateHandRaise(handRaise);
    });
  }

  void updateMuteStatus(bool? b) {
    Future.delayed(Duration(milliseconds: 300), () {
      log("mute status =========" + b.toString());
      footerKey.currentState!.updateMuteStatus(b!);
    });
  }

  emitRatingSuccess() {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventModel!.id;
    payload.personId = prefs!.getInt(Strings.userId);
    audioSocketService!.getSocket()!.emit(EMIT_ON_EVENT_RATING, payload);
    print('rating emitted');
  }

  onEventRating(data) {
    log("OnEvent--Rated------" + jsonEncode(data));
    var res = EventListItem.fromJson(data);
    log("OnEvent--Rated------" + res.header!.rating.toString());
    if (eventModel!.id == res.id) {
      setState(() {
        log("OnEvent--Rated same id ------" + res.header!.rating.toString());
        eventModel!.header!.rating = res.header!.rating;
      });
    }
  }

  void _showPostBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        var postRecieverListItem = PostReceiverListItem(
          allowedMsg: "",
          isAllowed: true,
          isSelected: true,
          recipientTypeReferenceId: eventModel!.id,
          recipientTypeDescription: "",
          recipientType: eventModel!.title,
          recipientTypeCode: 'event',
        );
        return CreateNewBottomSheet(
            prefs: prefs,
            isRoomsVisible: false,
            onClickCallback: (value) {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => PostCreatePage(
                            type: value,
                            selectedReceiverData: postRecieverListItem,
                            prefs: prefs,
                          )))
                  .then((value) {
                if (value != null && value) {
                  setState(() {
                    // if (_selectedIndex == 2) {
                    postScreenKey.currentState!.refresh();
                    // }
                  });
                }
              });
            });
        // return BottomSheetContent();
      },
    );
  }
}
