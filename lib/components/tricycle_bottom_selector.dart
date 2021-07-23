import 'package:oho_works_app/components/tricycle_talk_footer_button.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/event_bus/event_model.dart';
import 'package:oho_works_app/event_bus/leave_event.dart';
import 'package:oho_works_app/event_bus/make_event_open.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/campus_talk/invite_user_page.dart';
import 'package:oho_works_app/ui/campus_talk/participant_notifier.dart';
import 'package:oho_works_app/ui/campus_talk/talk_audience_list_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/Transitions/transitions.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:nexge_video_conference/nexge_rtc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TricycleBottomSelector extends StatefulWidget {
  final Function(int)? onItemTapped;
  final int? currentIndex;
  final int? chatCount;
  TricycleBottomSelector({Key? key,this.onItemTapped, this.currentIndex,this.chatCount}):super(key: key);

  @override
  TricycleBottomSelectorState createState() => TricycleBottomSelectorState();
}

class TricycleBottomSelectorState extends State<TricycleBottomSelector> {
  late TextStyleElements styleElements;
  bool playbackOptionVisible = false;
  late ParticipantNotifier _participantNotifier;
  final db = DatabaseHelper.instance;
  EventListItem? eventModel;

  EventBus? eventbus = locator<EventBus>();
  AudioSocketService? audioSocketService = locator<AudioSocketService>();
  SharedPreferences? prefs = locator<SharedPreferences>();
  EventBus? eventBus = locator<EventBus>();
  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  TALKFOOTERENUM? role;
  int? startTime;
  @override
  void initState() {
    super.initState();
    eventBus!.on<TalkEventData>().listen((event) {
      this.role = event.role;
      this.startTime = event.startTime;
      print("bottom selector"+startTime.toString());
      if(event.showPlayback!) {
        showPlayback(event.model);
      }else{
        hidePlayback();
      }
    });
    eventbus!.on<TalkEventEnd>().listen((event) {
      if(eventModel!=null && eventModel!.id == event.id){
        hangUp();
        hidePlayback();
      }
    });

    eventbus!.on<TalkEventOpen>().listen((event) {
      Navigator.push(context, TricycleRouteSlideBottom(
          page:  TalkEventPage(
            eventModel: eventModel,
            hideLoader:true,
            role: role,
            startTime: startTime,
            successCallback: (){},
          )
      ));
    });
  }

  void clearData() {
    role = null;
    startTime = 0;
    eventModel = null;
  }

  void endConf(){
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventModel!.id;
    payload.personId = prefs!.getInt(Strings.userId);
    print('Leave--------' + payload.toJson().toString());
    audioSocketService!.getSocket()!.emit('leave', payload);
    prefs!.remove(Strings.current_event);
    hangUp();

  }
  hangUp() async {
    try {
      await db.deleteParticipants();
      _participantNotifier.getOlderMessages(db);
      await NexgeRTC.leave();
      print("Hangup.......");
    // ignore: empty_catches
    } catch (e) {

    }

    clearData();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    _participantNotifier = Provider.of<ParticipantNotifier>(context);
    return Container(
      padding: EdgeInsets.only(top: 1, bottom: 1),
      color: HexColor(AppColors.appColorWhite),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Visibility(
            visible: playbackOptionVisible,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, TricycleRouteSlideBottom(
                    page:  TalkEventPage(
                      eventModel: eventModel,
                      hideLoader:true,
                      role: role,
                      startTime: startTime,
                      successCallback: (){},
                    )
                ));

                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                //   return TalkEventPage(
                //     eventModel: eventModel,
                //     hideLoader:true,
                //     role: role,
                //     startTime: startTime,
                //     successCallback: (){},
                //   );
                // }));
              },
              child: Container(
                color: HexColor(AppColors.appColorRed50),
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 2,
                      child: IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: HexColor(AppColors.appColorBlack65),
                          ),
                          onPressed: () {
                            endConf();
                            setState(() {
                              playbackOptionVisible=false;
                            });
                          }),
                    ),
                    TricycleAvatar(
                      size: 36,
                      key: UniqueKey(),
                      imageUrl: eventModel!=null ? eventModel!.header!.avatar:"",
                      isFullUrl: false,
                      service_type: SERVICE_TYPE.PERSON,
                      resolution_type: RESOLUTION_TYPE.R64,
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            eventModel!=null?eventModel!.title!:"",
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                          color: HexColor(AppColors.appColorBlack65),
                        ),
                        onPressed: shareEvent
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.group_add_outlined,
                          color: HexColor(AppColors.appColorBlack65),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return InviteTalkParticipants(
                                  eventId: eventModel!.id,
                                  privacyType: eventModel!.eventPrivacyType,
                                );
                              }
                          ));
                        })
                  ],
                ),
              ),
            ),
          ),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 70,
                margin:EdgeInsets.only(top:8,bottom:4,right: 0),
                child: Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 28,
                            color: widget.currentIndex == 0
                                ? HexColor(AppColors.appMainColor)
                                : HexColor(AppColors.appColorBlack)
                                .withOpacity(0.5),
                          ),
                          Text("Home",style: styleElements.captionThemeScalable(context).copyWith(
                              color: widget.currentIndex == 0
                                  ? HexColor(AppColors.appMainColor)
                                  : HexColor(AppColors.appColorBlack) .withOpacity(0.5),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped!(0);
                      }),
                ),
              ),
              Container(
                width: 70,
                margin:EdgeInsets.only(left: 0,top:8,bottom:4),
                child: Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mic_none_rounded,
                            size: 28,
                            color: widget.currentIndex == 1
                                ? HexColor(AppColors.appMainColor)
                                : HexColor(AppColors.appColorBlack)
                                .withOpacity(0.5),
                          ),
                          Text("Talk",style: styleElements.captionThemeScalable(context).copyWith(
                              color: widget.currentIndex == 1
                                  ? HexColor(AppColors.appMainColor)
                                  : HexColor(AppColors.appColorBlack) .withOpacity(0.5),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped!(1);
                      }),
                ),
              ),
              Container(
                width: 65,
                margin:EdgeInsets.only(top:8,bottom:4),
                child:Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            size: 45,
                            color:  widget.currentIndex == 2
                                ? HexColor(AppColors.appMainColor)
                                : HexColor(AppColors.appColorBlack)
                          ),
                          Text("Create",style: styleElements.captionThemeScalable(context).copyWith(
                              color:  widget.currentIndex == 2
                                  ? HexColor(AppColors.appMainColor)
                                  : HexColor(AppColors.appColorBlack),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped!(2);
                      }),
                )

                /* widget.currentIndex == 2
                    ? Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            size: 35,
                            color: HexColor(AppColors.appMainColor),
                          ),
                          Text("Create",style: styleElements.captionThemeScalable(context).copyWith(
                              color: HexColor(AppColors.appMainColor),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped(3);
                      }),
                )
                    : Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 28,
                            color: HexColor(AppColors.appColorBlack)
                                .withOpacity(0.5),
                          ),
                          Text("Feed",style: styleElements.captionThemeScalable(context).copyWith(
                              color: HexColor(AppColors.appColorBlack)  .withOpacity(0.5),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped(2);
                      }),
                ),*/
              ),
              Container(
                width: 70,
                margin:EdgeInsets.only(right: 0,top:0,bottom:4),
                child: InkWell(
                  onTap: (){ widget.onItemTapped!(3);},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:8,right: 4),
                            child: AbsorbPointer(
                              child:
                              Icon(
                                Icons.school_outlined,
                                size: 28,
                                color: widget.currentIndex == 3
                                    ? HexColor(AppColors.appMainColor)
                                    : HexColor(AppColors.appColorBlack)
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: new Positioned(
                              right: 0,
                              top: 0,
                              child: new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: HexColor(AppColors.appMainColor),
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(widget.chatCount.toString(),
                                    style: TextStyle(
                                        color: HexColor(AppColors.appColorWhite),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(AppLocalizations.of(context)!.translate("lessons"),style: styleElements.captionThemeScalable(context).copyWith(
                          color: widget.currentIndex == 3
                              ? HexColor(AppColors.appMainColor)
                              : HexColor(AppColors.appColorBlack)
                              .withOpacity(0.5),
                          fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                ),
              ),
              Container(
                width: 73,
                margin:EdgeInsets.only(left: 0,top:8,bottom:4,),
                child: Center(
                  child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 28,
                            color: widget.currentIndex == 4
                                ? HexColor(AppColors.appMainColor)
                                : HexColor(AppColors.appColorBlack)
                                .withOpacity(0.5),
                          ),
                          Text(AppLocalizations.of(context)!.translate("circle"),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.captionThemeScalable(context).copyWith(
                              color: widget.currentIndex == 4
                                  ? HexColor(AppColors.appMainColor)
                                  : HexColor(AppColors.appColorBlack).withOpacity(0.5),
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                      onTap: () {
                        widget.onItemTapped!(4);
                      }),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  void showPlayback(EventListItem? model) {
    setState(() {
      this.eventModel = model;
      playbackOptionVisible = true;
    });
  }

  void hidePlayback() {
    if(mounted) {
      setState(() {
        playbackOptionVisible = false;
      });
    }
  }

  void shareEvent() {
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs!.getInt(Strings.userId).toString(),
        eventModel!.id,
        DEEPLINKTYPE.CALENDAR.type,
        context);
  }


}
