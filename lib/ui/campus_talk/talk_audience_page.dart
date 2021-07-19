import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customgridDelegate.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycle_speaker_component.dart';
import 'package:oho_works_app/components/tricycle_talk_footer_button.dart';
import 'package:oho_works_app/components/tricycle_time_elapsed_widget.dart';
import 'package:oho_works_app/components/tricycle_user_list_tile.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/role_type_enum.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/campus_talk/disruptive_reponse.dart';
import 'package:oho_works_app/models/campus_talk/hand_raise_models.dart';
import 'package:oho_works_app/models/campus_talk/mic_status_payload.dart';
import 'package:oho_works_app/models/campus_talk/participant_list.dart';
import 'package:oho_works_app/models/campus_talk/request_list_models.dart';
import 'package:oho_works_app/models/campus_talk/socket_emit_models.dart';
import 'package:oho_works_app/models/campus_talk/update_moderatore_payload.dart';
import 'package:oho_works_app/models/new_conversation_event.dart';
import 'package:oho_works_app/services/agora_service.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/campus_talk/participant_notifier.dart';
import 'package:oho_works_app/ui/campus_talk/talk_event_profile_page.dart';
import 'package:oho_works_app/ui/campus_talk/test_pojo.dart';
import 'package:oho_works_app/ui/dialogs/accept_reject_request_widget.dart';
import 'package:oho_works_app/ui/dialogs/ratingcarddialog.dart';
import 'package:oho_works_app/ui/dialogs/sorry_rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:background_fetch/background_fetch.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'end_call_dilog.dart';
import 'invite_user_page.dart';

class TalkAudiencePage extends StatefulWidget {
  final int eventId;
  final String authToken;
  final String participantId;
  final bool mute;
  final List<int> participantIds;
  final Function(int count) countCallBack;
  final Function(TALKFOOTERENUM role) roleCallback;
  final Function successCallback;
  final Function(bool) updateHandRaise;
  final Function popCallback;
  final Function(String) conversationCallBack;
  final Function(bool) muteCallback;
  final EventListItem eventModel;
  final Function ratingSuccessCallback;
  final Function closeMinimizeActions;
  final bool hideLoader;
  final TALKFOOTERENUM role;
  final int startTime;

  TalkAudiencePage(
      {Key key,
      this.eventId,
      this.mute,
      this.participantId,
      this.authToken,
      this.conversationCallBack,
      this.participantIds,
      this.roleCallback,
      this.successCallback,
      this.updateHandRaise,
      this.popCallback,
      this.muteCallback,
      this.eventModel,
      this.hideLoader,
      this.role,
      this.startTime,
      this.ratingSuccessCallback,
      this.closeMinimizeActions,
      this.countCallBack})
      : super(key: key);

  @override
  TalkAudiencePageState createState() => TalkAudiencePageState(
      eventId: eventId,
      mute: mute,
      participantId: participantId,
      authToken: authToken,
      hideLoader: hideLoader,
      conversationCallBack: conversationCallBack,
      participantIds: participantIds);
}

class TalkAudiencePageState extends State<TalkAudiencePage> {
  static const String ON_CONVERSATION = "add_conversation_id";
  static const String ON_VIDEO_ON_OFF = "video_status";
  static const String ON_GET_PARTICIPANTS = "get_participants";
  static const String ON_EVENT_ERROR = 'event_error';
  static const String ON_JOIN_SUCCESS = 'join_success';
  static const String ON_MIC_STATUS = 'speaker_mic_status';
  static const String ON_HAND_RAISE_COUNT = "get_requests_count";
  static const String ON_HANDS_RAISE = "hand_raise";
  static const String ON_JOIN = "join";
  static const String ON_LEAVE = "leave";
  static const String ON_GET_REQUEST = "get_requests";
  static const String ON_HAND_RAISE_UPDATE = "hand_raise_update";
  static const String ON_HAND_DOWN = "hand_down";
  static const String ON_EVENT_ENDED = "event_ended";
  static const String EMIT_GET_PARTICIPANTS = "get_participants";
  static const String EMIT_JOIN = "join";
  static const String EMIT_LEAVE = "leave";
  static const String EMIT_HANDS_RAISE = "hand_raise";
  static const String EMIT_GET_REQUEST = "get_requests";
  static const String EMIT_HAND_RAISE_COUNT = "get_requests_count";
  static const String EMIT_ON_UPDATE_MODERATOR = "update_moderator";
  static const String EMIT_ON_UPDATE_ROLE = "update_role";
  static const String EMIT_HAND_RAISE_UPDATE = "hand_raise_update";
  static const String EMIT_ON_REMOVE = "remove_user";
  static const String EMIT_HAND_DOWN = "hand_down";
  static const String EMIT_ON_INVITE_USER = "invite_user";
  static const String EMIT_ON_REPORT = "report_disruptive";
  static const String EMIT_ON_UPDATE_INVITE = "invite_user_update";
  static const String ON_NOTIFICATION = "notification";

  // final _debouncer = Debouncer(200);
  EventBus eventBus = locator<EventBus>();
  final db = DatabaseHelper.instance;
  BuildContext sctx;
  TextStyleElements styleElements;
  int eventId;
  String authToken;
  String token;
  String channelName;
  String participantId;
  bool mute;
  bool isLocalVideo = false;
  bool isFullVideo = false;
  int videoParticipantId;
  List<int> participantIds = [];
  AudioSocketService audioSocketService = locator<AudioSocketService>();
  final CreateDeeplink createDeeplink = locator<CreateDeeplink>();
  SharedPreferences prefs = locator<SharedPreferences>();
  List<ParticipantListItem> listenerList = [];
  List<ParticipantListItem> speakersList = [];
  ParticipantNotifier _participantNotifier;
  GlobalKey<_SearchParticipantsState> searchPageKey = GlobalKey();
  GlobalKey<_RequestsListSheetState> requestPageKey = GlobalKey();
  GlobalKey<AcceptRejectRequestWidgetState> requestWidgetKey = GlobalKey();
  GlobalKey<TricycleClockTimerWidgetState> timerWidgetKey = GlobalKey();
  GlobalKey<AudioPageLoaderPageState> loaderPageKey = GlobalKey();

  AgoraService engine = locator<AgoraService>();
  DateTime startTime;
  bool isSpeaker = false;
  bool isModerator = false;
  bool isShowRequest = true;
  bool isLeft = false;
  bool hideLoader;
  // int _remoteUid = null;
  // bool _switch = false;
  // bool _joined = false;
  bool isVideoOn = false;

  // bool _joined = false;
  // int _remoteUid = null;
  // bool _switch = false;

  int eventStartTime;
  Function(String) conversationCallBack;

  TalkAudiencePageState(
      {this.eventId,
      this.mute,
      this.participantId,
      this.authToken,
      this.hideLoader,
      this.conversationCallBack,
      this.participantIds});

  @override
  void initState() {
    startTime = DateTime.now().toUtc();
    // if (hideLoader != null && hideLoader && loaderPageKey.currentState != null) {
    //   loaderPageKey.currentState.hideLoader();
    // }
    setUpSocket();
    if (Platform.isAndroid) {
      setUpForegourndService();
    }

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getContactPermission();
    });
  }

  void setUpForegourndService() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: widget.eventModel.title,
      notificationText: widget.eventModel.eventRoleType,
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'ic_launcher',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
  }

  Future<void> initPlatformState() async {
    engine.instance().setDefaultAudioRoutetoSpeakerphone(true);
    engine.instance().enableAudioVolumeIndication(500, 3, false);
    engine.instance().setEventHandler(RtcEngineEventHandler(
            joinChannelSuccess: (String channel, int uid, int elapsed) {
          print(
              'joinChannelSuccess----------------------------------------------------- $channel $uid');
          setState(() {
            // _joined = true;
          });
          if (uid == int.parse(participantId)) {
            connectorMuteCall(mute);
          }
        }, userJoined: (int uid, int elapsed) {
          setState(() {
            // _remoteUid = uid;
          });
          print(
              'userJoined------------------------------------------------------------------- $uid' +
                  mute.toString() +
                  participantId.toString());
        }, audioVolumeIndication: (List<AudioVolumeInfo> list, int uid) {
          // print('speaking--------------------------------------------------------------------------'+jsonEncode(list));
          if (list != null && list.isNotEmpty && list[0].uid != 0) {
            _participantNotifier.updateSpeaking(db, list[0].uid, 1);
            Future.delayed(const Duration(milliseconds: 2000), () {
              _participantNotifier.updateSpeakingAll(db);
            });
          }
        }, userOffline: (int uid, UserOfflineReason reason) {
          // _remoteUid = null;
          print(
              'userOffline-------------------------------------------------------------------------- $uid');
          // setState(() {
          // _remoteUid = null;
          // });
        }, audioRouteChanged: (AudioOutputRouting value) {
          print("route changed--------------------------------------------" +
              value.toString());
        }));
    await engine
        .instance()
        .joinChannel(token, channelName, null, int.parse(participantId));
  }

  Future<void> connectorMuteCall(bool isMute) async {
    MicStatusPayload payload = MicStatusPayload();
    payload.personId = prefs.getInt(Strings.userId);
    payload.eventId = eventId;
    payload.isSpeakerOn = isMute ? 0 : 1;
    print(jsonEncode(payload) +
        "------------------------------------------------------------------------------" +
        isMute.toString());
    _participantNotifier.update(
        db, prefs.getInt(Strings.userId), isMute ? 0 : 1);
    audioSocketService.getSocket().emit(ON_MIC_STATUS, payload);
    engine.instance().muteLocalAudioStream(isMute);
    // engine.instance().muteRemoteAudioStream(prefs.getInt(Strings.userId), isMute);
  }

  Future<void> turnOnOffVideo(bool vid) async {
    if (vid) {
      await engine.instance().enableVideo();
      _participantNotifier.updateVideoStatus(
          db, prefs.getInt(Strings.userId), 1);
      updateVideoStatus(1);
    } else {
      await engine.instance().disableVideo();
      _participantNotifier.updateVideoStatus(
          db, prefs.getInt(Strings.userId), 0);
      isLocalVideo = false;
      isFullVideo = false;
      updateVideoStatus(0);
    }

    setState(() {
      isVideoOn = vid;
    });
  }

  @override
  deactivate() {
    // NexgeAudioConference.leave();
    super.deactivate();
  }

  @override
  void dispose() {
    // NexgeAudioConference.leave();
    super.dispose();
  }

  Future<Null> refreshList() async {
    await new Future.delayed(new Duration(seconds: 2));
    getListeners();
    getSpeakers();
    getRequestsCount();
    return null;
  }

  void setUpSocket() async {
    audioSocketService
        .getSocket()
        .on(ON_CONVERSATION, onChatConversationCreate);
    audioSocketService.getSocket().on(ON_VIDEO_ON_OFF, onVideoStatusChange);
    audioSocketService.getSocket().on(ON_GET_PARTICIPANTS, onGetParticipants);
    audioSocketService.getSocket().on(ON_JOIN_SUCCESS, onJoinSuccess);
    audioSocketService.getSocket().on(ON_HAND_RAISE_COUNT, onHandRaiseCount);
    audioSocketService.getSocket().on(ON_MIC_STATUS, onMicStatusChange);
    audioSocketService.getSocket().on(ON_HANDS_RAISE, onHandRaise);
    audioSocketService.getSocket().on(ON_JOIN, onJoin);
    audioSocketService.getSocket().on(ON_LEAVE, onLeave);
    audioSocketService.getSocket().on(ON_GET_REQUEST, onGetRequest);
    audioSocketService.getSocket().on(ON_EVENT_ERROR, onError);
    audioSocketService
        .getSocket()
        .on(EMIT_ON_UPDATE_MODERATOR, getUpdatedModerators);
    audioSocketService.getSocket().on(EMIT_ON_UPDATE_ROLE, getUpdatedUser);
    audioSocketService.getSocket().on(ON_HAND_RAISE_UPDATE, handRaiseUpdate);
    audioSocketService.getSocket().on(EMIT_ON_REMOVE, onRemove);
    audioSocketService.getSocket().on(EMIT_ON_INVITE_USER, getNewSpeaker);
    audioSocketService.getSocket().on(EMIT_ON_REPORT, getDisruptive);
    audioSocketService.getSocket().on(ON_EVENT_ENDED, onEventEnded);
    audioSocketService.getSocket().on(ON_HAND_DOWN, onHandsDown);
    audioSocketService.getSocket().on(ON_NOTIFICATION, onNotification);
  }

  void switchOffSocket() async {
    audioSocketService
        .getSocket()
        .off(ON_CONVERSATION, onChatConversationCreate);
    audioSocketService.getSocket().off(ON_VIDEO_ON_OFF, onVideoStatusChange);
    audioSocketService.getSocket().off(ON_GET_PARTICIPANTS, onGetParticipants);
    audioSocketService.getSocket().off(ON_JOIN_SUCCESS, onJoinSuccess);
    audioSocketService.getSocket().off(ON_HAND_RAISE_COUNT, onHandRaiseCount);
    audioSocketService.getSocket().off(ON_MIC_STATUS, onMicStatusChange);
    audioSocketService.getSocket().off(ON_HANDS_RAISE, onHandRaise);
    audioSocketService.getSocket().off(ON_JOIN, onJoin);
    audioSocketService.getSocket().off(ON_LEAVE, onLeave);
    audioSocketService.getSocket().off(ON_GET_REQUEST, onGetRequest);
    audioSocketService.getSocket().off(ON_EVENT_ERROR, onError);
    audioSocketService
        .getSocket()
        .off(EMIT_ON_UPDATE_MODERATOR, getUpdatedModerators);
    audioSocketService.getSocket().off(EMIT_ON_UPDATE_ROLE, getUpdatedUser);
    audioSocketService.getSocket().off(ON_HAND_RAISE_UPDATE, handRaiseUpdate);
    audioSocketService.getSocket().off(EMIT_ON_REMOVE, onRemove);
    audioSocketService.getSocket().off(EMIT_ON_INVITE_USER, getNewSpeaker);
    audioSocketService.getSocket().off(EMIT_ON_REPORT, getDisruptive);
    audioSocketService.getSocket().off(ON_EVENT_ENDED, onEventEnded);
    audioSocketService.getSocket().off(ON_HAND_DOWN, onHandsDown);
    audioSocketService.getSocket().off(ON_NOTIFICATION, onNotification);
  }

  Widget getHeaders() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(
            'Stage - ${_participantNotifier != null && _participantNotifier.getStageParticipants() != null && _participantNotifier.getStageParticipants().isNotEmpty ? _participantNotifier.getStageParticipants().length : "0"} speakers',
            style: styleElements
                .captionThemeScalable(context)
                .copyWith(color: HexColor(AppColors.appColorBlack65)),
          ),
          Spacer(),
          TricycleClockTimerWidget(
              key: timerWidgetKey, startTime: getStartTime()),
          SizedBox(
            width: 8,
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
                color: HexColor(AppColors.appColorGreen),
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              'LIVE',
              style: styleElements
                  .captionThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorWhite)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    _participantNotifier = Provider.of<ParticipantNotifier>(context);
    return Builder(
      builder: (BuildContext context) {
        this.sctx = context;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: HexColor(AppColors.chatBackGround),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  isFullVideo
                      ? Expanded(
                          child: _fullVideoWidget(
                              isLocalVideo, videoParticipantId))
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshList,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Stage - ${_participantNotifier != null && _participantNotifier.getStageParticipants() != null && _participantNotifier.getStageParticipants().isNotEmpty ? _participantNotifier.getStageParticipants().length : "0"} speakers',
                                          style: styleElements
                                              .captionThemeScalable(context)
                                              .copyWith(
                                                  color: HexColor(AppColors
                                                      .appColorBlack65)),
                                        ),
                                        Spacer(),
                                         TricycleClockTimerWidget(
                                            key: timerWidgetKey,
                                            startTime: getStartTime()),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 8),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 4),
                                          decoration: BoxDecoration(
                                              color: HexColor(
                                                  AppColors.appColorGreen),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            'LIVE',
                                            style: styleElements
                                                .captionThemeScalable(context)
                                                .copyWith(
                                                    color: HexColor(AppColors
                                                        .appColorWhite)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _participantNotifier != null &&
                                        _participantNotifier
                                                .getStageParticipants() !=
                                            null &&
                                        _participantNotifier
                                            .getStageParticipants()
                                            .isNotEmpty
                                    ? SliverPadding(
                                        padding: EdgeInsets.all(12),
                                        sliver:
                                            SliverStaggeredGrid.countBuilder(
                                          crossAxisCount: 24,
                                          itemCount: _participantNotifier
                                              .getStageParticipants()
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            // return Container(color: Colors.purple,child: Center(child: Text("$index"),),);
                                            return GestureDetector(
                                              onTap: () {
                                                openProfilePage(
                                                    isModerator
                                                        ? TALKFOOTERENUM
                                                            .moderator
                                                        : isSpeaker
                                                            ? TALKFOOTERENUM
                                                                .speaker
                                                            : TALKFOOTERENUM
                                                                .audience,
                                                    (_participantNotifier
                                                                    .getStageParticipants()[
                                                                        index]
                                                                    .isModerator !=
                                                                null &&
                                                            _participantNotifier
                                                                    .getStageParticipants()[
                                                                        index]
                                                                    .isModerator ==
                                                                1)
                                                        ? TALKFOOTERENUM
                                                            .moderator
                                                        : TALKFOOTERENUM
                                                            .speaker,
                                                    _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .participantId,
                                                    _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .participantType,
                                                    _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .isModerator,
                                                    _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .isSpeakerOn);
                                              },
                                              child:( _participantNotifier
                                                  .getStageParticipants()[
                                              index]!=null)? TricycleSpeakerComponent(
                                                videoClickCallBack:
                                                    (bool _isLocalVideo,
                                                        int id) {
                                                  setState(() {
                                                    print(_isLocalVideo
                                                        .toString());
                                                    isFullVideo = true;
                                                    isLocalVideo =
                                                        _isLocalVideo;
                                                    videoParticipantId = id;
                                                  });
                                                },
                                                size: (index == 0 || index == 1)
                                                    ? 170
                                                    : 99,
                                                // isVideoOn: _participantNotifier
                                                //     .getStageParticipants()[
                                                //         index]
                                                //     .isVideoOn,
                                                isVideoOn: 0,
                                                participantId:
                                                    _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .participantId,
                                                userId: prefs
                                                    .getInt(Strings.userId),
                                                imageUrl: _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .profileImage !=
                                                        null
                                                    ? Config.BASE_URL +
                                                        _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .profileImage
                                                    : "",
                                                name: _participantNotifier
                                                    .getStageParticipants()[
                                                        index]
                                                    .name,
                                                designation: _participantNotifier
                                                        .getStageParticipants()[
                                                            index]
                                                        .personType ??
                                                    "",
                                                speaking: index == 0,
                                                isSpeaking: _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .isSpeaking ==
                                                        1
                                                    ? true
                                                    : false,
                                                isMute: _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .isSpeakerOn ==
                                                        0
                                                    ? true
                                                    : false,
                                                isModerator: _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .isModerator !=
                                                        null &&
                                                    _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .isModerator ==
                                                        1,
                                              ):Container(),
                                            );
                                          },
                                          staggeredTileBuilder: (int index) {
                                            return StaggeredTile.count(
                                                (index == 0 || index == 1)
                                                    ? 12
                                                    : 8,
                                                (index == 0 || index == 1)
                                                    ? 12
                                                    : 9);
                                          },
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: TricycleEmptyWidget(
                                            assetImage:
                                                'assets/appimages/avatar-default.png',
                                            message: "No Speakers yet!!")),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Floor - ${_participantNotifier != null && _participantNotifier.getFloorsParticipants() != null && _participantNotifier.getFloorsParticipants().isNotEmpty ? _participantNotifier.getFloorsParticipants().length : "0"} listeners',
                                      style: styleElements
                                          .captionThemeScalable(context)
                                          .copyWith(
                                              color: HexColor(
                                                  AppColors.appColorBlack65)),
                                    ),
                                  ),
                                ),
                                SliverFillRemaining(
                                  child: _participantNotifier != null &&
                                          _participantNotifier
                                                  .getFloorsParticipants() !=
                                              null &&
                                          _participantNotifier
                                              .getFloorsParticipants()
                                              .isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                                    crossAxisCount: 4,
                                                    height: 120),
                                            physics: ClampingScrollPhysics(),
                                            itemCount: _participantNotifier
                                                .getFloorsParticipants()
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return  (index <
                                                  _participantNotifier
                                                      .getFloorsParticipants()
                                                      .length? GestureDetector(
                                                onTap: () {
                                                  if (index <
                                                      _participantNotifier
                                                          .getFloorsParticipants()
                                                          .length) {
                                                    openProfilePage(
                                                        isModerator
                                                            ? TALKFOOTERENUM
                                                                .moderator
                                                            : isSpeaker
                                                                ? TALKFOOTERENUM
                                                                    .speaker
                                                                : TALKFOOTERENUM
                                                                    .audience,
                                                        TALKFOOTERENUM.audience,
                                                        _participantNotifier
                                                            .getFloorsParticipants()[
                                                                index]
                                                            .participantId,
                                                        _participantNotifier
                                                            .getFloorsParticipants()[
                                                                index]
                                                            .participantType,
                                                        _participantNotifier
                                                            .getStageParticipants()[
                                                                index]
                                                            .isModerator,
                                                        0);
                                                  }
                                                },
                                                child: TricycleSpeakerComponent(
                                                  size: 64,
                                                  isVideoOn: 0,
                                                  participantId:
                                                      _participantNotifier
                                                          .getStageParticipants()[
                                                              index]
                                                          .participantId,
                                                  userId: prefs
                                                      .getInt(Strings.userId),
                                                  imageUrl: Config.BASE_URL +
                                                      _participantNotifier
                                                          .getFloorsParticipants()[
                                                              index]
                                                          .profileImage,
                                                  name: _participantNotifier
                                                      .getFloorsParticipants()[
                                                          index]
                                                      .name,
                                                  designation: _participantNotifier
                                                          .getFloorsParticipants()[
                                                              index]
                                                          .personType ??
                                                      "",
                                                  speaking: false,
                                                  isMute: true,
                                                  isAudience: true,
                                                ),
                                              ):Container());
                                            },
                                          ),
                                        )
                                      : TricycleEmptyWidgetForAudio(),
                                )
                              ],
                            ),
                          ),
                        ),
                  PostCardActionButtons(
                    isCommentVisible: false,
                    isBookMarkVisible: false,
                    isInviteUserVisible:
                        widget.eventModel.eventPrivacyType == 'public' ||
                            widget.eventModel.eventPrivacyType == 'campus' ||
                            isModerator,
                    inviteuserCallback: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return InviteTalkParticipants(
                          privacyType: widget.eventModel.eventPrivacyType,
                          eventId: eventId,
                        );
                      }));
                    },
                    ratingFunction: rateEvent,
                    ratingCallback: () {},
                    sharecallBack: () {
                      createDeeplink.getDeeplink(
                          SHAREITEMTYPE.DETAIL.type,
                          prefs.getInt(Strings.userId).toString(),
                          eventId,
                          DEEPLINKTYPE.CALENDAR.type,
                          context);
                    },
                    isShareVisible: true,
                    isRated: getIsRated(widget.eventModel.header),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AcceptRejectRequestWidget(requestWidgetKey),
            ),
            Visibility(
              visible: hideLoader == null || !hideLoader,
              child: AudioPageLoaderPage(
                key: loaderPageKey,
              ),
            ),
          ],
        );
      },
    );
  }

  bool getIsRated(Header header) {
    bool isRated;
    for (var i in header.action) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }

  void menuCalls(String value) {
    if (value == 'search') {
      openSearchParticipantsPage();
    } else {
      // openProfilePage();
    }
  }

  void _getContactPermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      print("notpermotttedd==============================");
      final result = await Permission.microphone.request();
      if (result.isGranted) {
        print("dennnieddddd==============================");
        joinEvent();
      } else {
        print("grant==============================");
        Navigator.pop(context);
      }
    } else {
      if (hideLoader != null && hideLoader) {
        widget.roleCallback(widget.role);
        getSpeakers();
        getListeners();
        getRequestsCount();
        this.eventStartTime = widget.startTime;
        // Future.delayed(Duration(seconds: 1), () {
        //   timerWidgetKey.currentState.startTimer(
        //       DateTime.fromMillisecondsSinceEpoch(widget.startTime));
        // });
      } else {
        joinEvent();
      }
    }
  }

  void openProfilePage(TALKFOOTERENUM firstPerson, TALKFOOTERENUM secondPerson,
      int id, String type, int isModerator, int isSpeakerOn) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TalkParticipantProfilePage(
        userType: id == prefs.getInt(Strings.userId) ? type : 'thirdPerson',
        userId: id,
        isModerator: isModerator,
        isSpeakerOn: isSpeakerOn,
        moderatorCallback: (int userId, int isModerator, String type) {
          updateModerators(isModerator, userId, type);
        },
        updateRole: (int userId, String role, String userType) {
          updateRole(userId, role, userType);
        },
        inviteUser: (int userId, String userType) {
          inviteSpeaker(userId, userType);
        },
        removeUser: (int userId, String userType) {
          removeUser(userId, userType);
        },
        reportUser: (int userId, String userType) {
          reportUser(userId, userType);
        },
        mute: (int userId, String userType) {
          muteUser(userId, userType);
        },
        firstPerson: firstPerson,
        secondPerson: secondPerson,
      );
    }));
  }

  void openSearchParticipantsPage() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (BuildContext context) {
          return _SearchParticipantsSheet(
              key: searchPageKey, callback: searchCallback);
        });
  }

  void handRaiseRequestList() {
    requestWidgetKey.currentState.hideCard();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (BuildContext context) {
          return _RequestsListSheet(
              key: requestPageKey,
              onUserUpdateCallback: (requestPayload) {
                requestPayload.personId = prefs.getInt(Strings.userId);
                requestPayload.eventId = eventId;
                updateHandRaise(requestPayload);
              },
              callback: () {
                getRequests();
              });
        });
  }

  void _connect() async {
    print('participantId => ' +
        widget.participantId +
        ', roomId => ' +
        widget.eventId.toString());
    widget.muteCallback(mute);
    if (Platform.isAndroid) {
      bool success = await FlutterBackground.enableBackgroundExecution();
      print(
          "--------------------------------success+++++++++++++++---------------------------" +
              success.toString());
    } else if (Platform.isIOS) {
      BackgroundFetch.scheduleTask(
          TaskConfig(taskId: 'com.tricycle.life', delay: 5000, periodic: true));
    }
    await initPlatformState();
  }

  void handRaise() {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('handRaise--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_HANDS_RAISE, payload);
  }

  /// socket.emit method for exit event
  hangUp() async {
    try {
      engine.instance().leaveChannel();
      await db.deleteParticipants();
      _participantNotifier.getOlderMessages(db);
      print("Hangup.......");
    } catch (e) {
      print(e +
          "------------------------------------------------------P_O)O)O)O_");
    }
  }

  /// socket.emit method for get_request
  void getRequests() async {
    // hangUp();
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print("get Requests-----------" + jsonEncode(payload));
    audioSocketService.getSocket().emit(EMIT_GET_REQUEST, payload);
  }

  /// socket.emit method for update moderators
  void updateModerators(int isModerator, int userId, String type) {
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.participantId = userId;
    payload.participantType = type;
    payload.isModerator = isModerator;
    payload.personId = prefs.getInt(Strings.userId);

    print(jsonEncode(payload));
    audioSocketService.getSocket().emit(EMIT_ON_UPDATE_MODERATOR, payload);
  }

  /// socket.emit method for invite speaker
  void inviteSpeaker(int userId, String userType) {
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.participantId = userId;
    payload.participantType = userType;
    payload.personId = prefs.getInt(Strings.userId);
    print(jsonEncode(payload));
    audioSocketService.getSocket().emit(EMIT_ON_INVITE_USER, payload);
  }

  /// socket.emit method mute user
  void muteUser(int userId, String userType) {
    MicStatusPayload payload = MicStatusPayload();
    payload.personId = userId;
    payload.eventId = eventId;
    payload.isSpeakerOn = 0;
    print(jsonEncode(payload) +
        "------------------------------------------------------------------------------mute user ");
    _participantNotifier.update(db, userId, 0);
    audioSocketService.getSocket().emit(ON_MIC_STATUS, payload);
    // engine.instance().muteRemoteAudioStream(userId, true);
/*    audioSocketService.getSocket().emit(EMIT_ON_REPORT, payload);*/
  }

  /// socket.emit method mute user
  void updateVideoStatus(int isVideoOn) {
    MicStatusPayload payload = MicStatusPayload();
    payload.personId = prefs.getInt(Strings.userId);
    payload.eventId = eventId;
    payload.isVideoOn = isVideoOn;
    print(jsonEncode(payload));
    audioSocketService.getSocket().emit(ON_VIDEO_ON_OFF, payload);
  }

  /// socket.emit method for invite speaker
  void reportUser(int userId, String userType) {
    print("repoting disruptive");
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.participantId = userId;
    payload.participantType = userType;
    payload.personId = prefs.getInt(Strings.userId);
    print(jsonEncode(payload));
    audioSocketService.getSocket().emit(EMIT_ON_REPORT, payload);
  }

  /// socket.emit method for accept reject speaker
  void acceptRejectSpeaker(bool isAccepted) {
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    payload.isAccepted = isAccepted;
    print(jsonEncode(payload) + "accept reject");
    audioSocketService.getSocket().emit(EMIT_ON_UPDATE_INVITE, payload);
  }

  /// socket.emit method for update role
  void updateRole(int userId, String role, String userType) {
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.participantId = userId;
    payload.participantType = userType;
    payload.role = role;
    payload.personId = prefs.getInt(Strings.userId);
    print(jsonEncode(payload));
    audioSocketService.getSocket().emit(EMIT_ON_UPDATE_ROLE, payload);
  }

  /// socket.emit method for update role
  void removeUser(int userId, String userType) {
    UpdateModeratorPayload payload = UpdateModeratorPayload();
    payload.eventId = eventId;
    payload.participantId = userId;
    payload.participantType = userType;
    payload.personId = prefs.getInt(Strings.userId);
    print(jsonEncode(payload) +
        "removingggggggggggggggggggggggggggggggggggggggggggggggggg");
    audioSocketService.getSocket().emit(EMIT_ON_REMOVE, payload);
  }

  /// socket.emit method for remove user
  void onRemove(dynamic data) {
    log(jsonEncode(data) + "received remove");
    var res = NewParticipant.fromJson(data);
    _participantNotifier.deleteSingleItem(
        db, res.rows.participantId, res.rows.personType);
    if (res.rows.participantId == int.parse(participantId)) {
      leave();
    }
  }

  /// socket.emit method for receiving update moderators
  void getDisruptive(dynamic data) {
    log(jsonEncode(data) + "received update Disruptive");
    var res = InviteDisruptiveUser.fromJson(data);
    requestWidgetKey.currentState.update(
        id: res.participantId,
        message: res.notification ?? "",
        okButtonText: res.actions != null && res.actions.length > 0
            ? res.actions[0].actionText ?? ""
            : "",
        cancelButtonText: res.actions != null && res.actions.length > 1
            ? res.actions[1].actionText ?? ""
            : "",
        actionButtonColor: HexColor(AppColors.white_translucent),
        okButtonCallback: () {
          requestWidgetKey.currentState.hideCard();
        },
        cancelButtonCallback: () {
          requestWidgetKey.currentState.hideCard();
        },
        showCard: true,
        backgroundColor: HexColor(AppColors.appMainColor),
        isButtonView: true);
  }

  /// socket.emit method for receiving update moderators
  void getUpdatedUser(dynamic data) {
    log(jsonEncode(data) + "received speaker invite");
    var res = ParticipantListItem.fromJson(data);
    res.isSpeakerOn = 0;
    print('res----------------------------' + jsonEncode(res.toJson()));
    _participantNotifier.updateRole(
        db, res, res.role == EVENT_ROLE_TYPE.listener.type ? "floor" : "stage");
    if (int.parse(participantId) == res.participantId) {
      {
        widget.roleCallback(res.role == EVENT_ROLE_TYPE.listener.type
            ? TALKFOOTERENUM.audience
            : TALKFOOTERENUM.speaker);
        if (res.participantId == int.parse(participantId) &&
            res.role == EVENT_ROLE_TYPE.listener.type) {
          // setState(() {
          isSpeaker = false;
          isModerator = false;
          connectorMuteCall(true);
          widget.updateHandRaise(false);
        }
        // });
        if (res.participantId == int.parse(participantId) &&
            res.role != EVENT_ROLE_TYPE.listener.type) {
          // setState(() {
          isSpeaker = true;
          isModerator = false;
          connectorMuteCall(true);
          widget.muteCallback(true);
          requestWidgetKey.currentState.checkandHide(res.participantId);
        }
        // });
      }
    }
  }

  void getNewSpeaker(dynamic data) {
    log(jsonEncode(data) + "received speaker invite");
    var res = InviteDisruptiveUser.fromJson(data);
    if (res.participantId != int.parse(participantId) &&
        requestWidgetKey.currentState != null) {
      requestWidgetKey.currentState.update(
          id: res.participantId,
          message: res.notification ?? "",
          okButtonText: res.actions != null && res.actions.length > 0
              ? res.actions[0].actionText ?? ""
              : "",
          cancelButtonText: res.actions != null && res.actions.length > 1
              ? res.actions[1].actionText ?? ""
              : "",
          okButtonCallback: () {
            acceptRejectSpeaker(true);
            requestWidgetKey.currentState.hideCard();
          },
          cancelButtonCallback: () {
            acceptRejectSpeaker(false);
            requestWidgetKey.currentState.hideCard();
          },
          showCard: true,
          backgroundColor: HexColor(AppColors.appColorGreen),
          isButtonView: true);
    }

    /*  _participantNotifier.updateRole(db, res,res.role == EVENT_ROLE_TYPE.listener.type ? "floor" : "stage");
    widget.roleCallback(TALKFOOTERENUM.audience);*/
  }

  /// socket.emit method for receiving update moderators
  void getUpdatedModerators(dynamic data) {
    log(jsonEncode(data) + "received update moderators");
    var res = ParticipantListItem.fromJson(data);

    if (res.participantId == int.parse(participantId)) {
      if (res.isModerator != null && res.isModerator == 1) {
        isModerator = true;
        widget.roleCallback(TALKFOOTERENUM.moderator);
        print("true");
      } else {
        isModerator = false;
        widget.roleCallback(TALKFOOTERENUM.speaker);
        print("false");
      }
    }
    _participantNotifier.updateModerators(
        db, res.participantId, res.isModerator);
  }

  void rateEvent() {
    var nowTime = DateTime.now().toUtc();
    int diff =
        nowTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
    if (getMinutes(diff) >= 3) {
      showDialog(
          context: context,
          barrierColor: HexColor(AppColors.appColorTransparent),
          barrierDismissible: true,
          builder: (BuildContext context) => RatingCardDialog(
                contextId: widget.eventModel.eventOwnerId,
                contexType: widget.eventModel.eventOwnerType,
                subjectId: widget.eventModel.id,
                subjectType: 'event',
              )).then((value) {
        Future.delayed(Duration(seconds: 1), () {
          widget.ratingSuccessCallback();
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SorryRateDialog();
          });
    }
  }

  /// socket.emit method for exit event
  Future<void> leaveEvent() async {
    var nowTime = DateTime.now().toUtc();
    int diff =
        nowTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
    bool isModerator = await db.getMember(int.parse(participantId));
    List<ParticipantListItem> listModerators = await db.getModerators();

    if (getMinutes(diff) >= 3) {
      showDialog(
          context: sctx,
          builder: (BuildContext context) {
            return RatingCardDialog(
              contextId: widget.eventModel.eventOwnerId,
              contexType: widget.eventModel.eventOwnerType,
              subjectId: widget.eventModel.id,
              subjectType: 'event',
            );
          }).then((value) {
        Future.delayed(Duration(seconds: 1), () {
          widget.ratingSuccessCallback();
        });
        if (isModerator && listModerators.length <= 1)
          showDialog(
              context: sctx,
              builder: (BuildContext context) => EndCallDilog(
                  callBack: () {
                    leave();
                  },
                  callBackCancel: () {}));
        else
          leave();
      });
    } else {
      if (isModerator && listModerators.length <= 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) => EndCallDilog(
                callBack: () {
                  leave();
                },
                callBackCancel: () {}));
      } else
        leave();
    }
  }

  int getMinutes(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    return minutes;
  }

  void leaveOnlyEmit() {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('Leave--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_LEAVE, payload);
    print('after Leaving');
  }

  void leave() async {
    if (Platform.isAndroid) {
      FlutterBackground.disableBackgroundExecution();
    } else if (Platform.isIOS) {
      BackgroundFetch.stop("com.tricycle.life");
    }
    print(
        "--------------------------------disabled+++++++++++++++---------------------------");
    // hangUp();
    await engine.instance().leaveChannel();
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('Leave--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_LEAVE, payload);
    print('after Leaving');
    prefs.remove(Strings.current_event);
    try {
      await db.deleteParticipants();
      _participantNotifier.getOlderMessages(db);
    } catch (e) {
      print(e +
          "------------------------------------------------------P_O)O)O)O_");
    }
    if (!isLeft) {
      isLeft = true;
      widget.popCallback();
    }
  }

  /// socket.emit method for join
  void joinEvent() {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('join--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_JOIN, payload);
    print('after join');
  }

  /// socket.emit method for get_members(listeners)
  void getListeners() {
    print(participantIds.toString());
    GetMemberEventPayload model = GetMemberEventPayload();
    model.eventId = eventId;
    model.personId = prefs.getInt(Strings.userId);
    model.listType = 'floor';
    print('get_speakers--------' + jsonEncode(model));
    audioSocketService.getSocket().emit(EMIT_GET_PARTICIPANTS, model);
    print('after emitting');

    Future.delayed(Duration(seconds: 3), () {
      if (loaderPageKey.currentState != null) {
        loaderPageKey.currentState.hideLoader();
      }
    });
  }

  /// socket.emit method for get_members(speakers)
  void getSpeakers() {
    print(participantIds.toString());
    GetMemberEventPayload model = GetMemberEventPayload();
    model.eventId = eventId;
    model.personId = prefs.getInt(Strings.userId);
    model.listType = 'stage';
    print('get_speakers--------' + model.toJson().toString());
    print('get is connected' +
        audioSocketService.getSocket().connected.toString());
    audioSocketService.getSocket().emit(EMIT_GET_PARTICIPANTS, model);
    print('after emitting');
  }

  searchCallback(String searchVal) {
    print(participantIds.toString());
    GetMemberEventPayload model = GetMemberEventPayload();
    model.eventId = eventId;
    model.personId = prefs.getInt(Strings.userId);
    model.searchValue = searchVal;
    model.listType = null;
    print('get all --------' + model.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_GET_PARTICIPANTS, model);
  }

  /// socket.on method for on_error
  onError(dynamic data) {
    log("Error-----------" + data.toString());
    var res = JoinEventResponse.fromJson(data);
    ToastBuilder()
        .showSnackBar(res.message ?? "", sctx, HexColor(AppColors.information));
    return data;
  }

  /// socket.on method for video status
  onVideoStatusChange(dynamic data) async {
    // await engine.instance().enableVideo();
    // log(jsonEncode(data) +
    //     "===============================================================+++++++++++++++++++++++++");
    // var res = ParticipantListItem.fromJson(data);
    // if (res != null && res.participantId != null && res.isVideoOn != null)
    //   _participantNotifier.updateVideoStatus(db, res.participantId, res.isVideoOn);
  }

  /// socket.on method for get_members
  onGetParticipants(dynamic data) {
    log(jsonEncode(data) +
        "===============================================================+++++++++++++++++++++++++");
    var res = ParticipantListResponse.fromJson(data);
    if (res.rows.listType != null) {
      Future(() {
        if (res.rows.membersList != null && res.rows.membersList.isNotEmpty) {
          if (res.rows.membersList.any((element) {
            return element.participantId.toString() == participantId;
          })) {
            var index = res.rows.membersList.indexWhere((element) {
              return element.participantId.toString() == participantId;
            });
            res.rows.membersList[index].isSpeakerOn = mute ? 0 : 1;
            isModerator = res.rows.membersList[index].isModerator == 1;
            isSpeaker = res.rows.membersList[index].role == 'speaker';
          }
          _participantNotifier.saveData(
              db, res.rows.membersList, res.rows.listType);
        }
      });
    } else {
      if (searchPageKey.currentState.mounted) {
        searchPageKey.currentState.addValues(res.rows.membersList);
      }
    }
  }

  /// socket.on method for chat conversation
  onChatConversationCreate(dynamic data) {
    log("new conversation------------------------------------------------------------------------------------------------" +
        jsonEncode(data));
    var res = NewConversationEvent.fromJson(data);
    if (conversationCallBack != null) conversationCallBack(res.conversationId);
  }

  /// socket.on method for join_success
  onJoinSuccess(dynamic data) {
    log("JoinSuccess------------------------------------------------------------------------------------------------" +
        data.toString());
    var res = JoinEventResponse.fromJson(data);
    if (res.statusCode == Strings.success_code) {
      prefs.setInt(Strings.current_event, eventId);
      token = res.rows.token ?? null;
      channelName = res.rows.channelName ?? null;
      isModerator = res.rows.isModerator != null && res.rows.isModerator == 1;
      isSpeaker = !isModerator ? res.rows.role == 'speaker' : false;
      widget.roleCallback(isModerator
          ? TALKFOOTERENUM.moderator
          : isSpeaker
              ? TALKFOOTERENUM.speaker
              : TALKFOOTERENUM.audience);
      widget.successCallback();
      conversationCallBack(res.rows.conversationId);
      _connect();
      getSpeakers();
      getListeners();
      getRequestsCount();


      this.eventStartTime = res.rows.startTime;
      log("JoinSuccess------------------------------------------------------------------------------------------------" +
          res.rows.startTime.toString());
      Future.delayed(Duration(seconds: 1), () {
        timerWidgetKey.currentState.startTimer(
            DateTime.fromMillisecondsSinceEpoch(res.rows.startTime));
      });
      if (res != null) {
        var participant = ParticipantListItem.fromJson(res.rows.toJson());
        _participantNotifier.saveSingleItem(db, participant,
            res.rows.role == EVENT_ROLE_TYPE.listener.type ? "floor" : "stage");
      }
    } else {
      ToastBuilder()
          .showSnackBar(res.message, sctx, HexColor(AppColors.information));
    }
  }

  void getRequestsCount() async {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('get_request count--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_HAND_RAISE_COUNT, payload);
    print('after sending request for hand raise count');
  }

  /// socket.on method for join_success
  onHandRaiseCount(dynamic data) {
    log("handRaiseCount-----------" + data.toString());
    var res = JoinEventResponse.fromJson(data);
    if (res.statusCode == Strings.success_code) {
      if (res.total != null) {
        widget.countCallBack(res.total);
      } else {
        widget.countCallBack(0);
      }
    }
  }

  /// socket.on method for on_mic_status
  onMicStatusChange(dynamic data) {
    log("onMicStatusChange------------------------------------------------------------------------------" +
        jsonEncode(data) +
        "-------------------------------------------");
    var res = ParticipantListItem.fromJson(data);
    if (res != null && res.participantId != null && res.isSpeakerOn != null)
      _participantNotifier.update(db, res.participantId, res.isSpeakerOn);

    if (res.participantId == int.parse(participantId)) {
      log(jsonEncode(data) + "-------------------------------------------");
      engine
          .instance()
          .muteLocalAudioStream(res.isSpeakerOn == 1 ? false : true);
      widget.muteCallback(res.isSpeakerOn == 1 ? false : true);
    }
  }

  /// socket.on method for hand_raise
  onHandRaise(data) {
    print("on hand Raised" + data.toString());
    if (isShowRequest) {
      isShowRequest = false;
      print("on hand Raised" + data.toString());
      var res = OnHandRaiseResponse.fromJson(data);
      requestWidgetKey.currentState.update(
          id: res.participantId,
          message: res.notification ?? "",
          okButtonText: res.actions.firstWhere((element) {
            return element.actionCode == 'A';
          }).actionText,
          cancelButtonText: res.actions.firstWhere((element) {
            return element.actionCode == 'R';
          }).actionText,
          okButtonCallback: () {
            updateHandRaise(UpdateHandRaiseRequest(
                isAccepted: true,
                participantId: res.participantId,
                participantType: res.participantType,
                role: 'speaker',
                eventId: eventId,
                personId: prefs.getInt(Strings.userId)));
            requestWidgetKey.currentState.hideCard();
          },
          cancelButtonCallback: () {
            updateHandRaise(UpdateHandRaiseRequest(
                isAccepted: false,
                participantId: res.participantId,
                participantType: res.participantType,
                role: 'speaker',
                eventId: eventId,
                personId: prefs.getInt(Strings.userId)));
            requestWidgetKey.currentState.hideCard();
          },
          showCard: true,
          backgroundColor: HexColor(AppColors.appColorGreen),
          isButtonView: true);
    }
    getRequestsCount();
  }

  /// socket.on method for join
  onJoin(data) {
    print(jsonEncode(data) +
        "user joinedddddddddddddddddddddddddddddddddddddddddddddddddddd");
    var res = NewParticipant.fromJson(data);
    res.rows.isSpeakerOn = 0;
    if (res != null)
      _participantNotifier.saveSingleItem(db, res.rows,
          res.rows.role == EVENT_ROLE_TYPE.listener.type ? "floor" : "stage");
  }

  /// socket.on method for leave
  onLeave(data) {
    print(jsonEncode(data));
    var res = NewParticipant.fromJson(data);
    if (res != null)
      _participantNotifier.deleteSingleItem(
          db, res.rows.participantId, "floor");
  }

  /// socket.on method for get_request
  onGetRequest(data) {
    print("getRequest--" + jsonEncode(data));
    var res = RequestListResponse.fromJson(data);
    if (requestPageKey.currentState != null &&
        requestPageKey.currentState.mounted) {
      requestPageKey.currentState.addValues(res.rows);
    }
  }

  checkTotalModerators() async {
    List<ParticipantListItem> list = [];
    list = await db.getModerators();
    if (list != null && list.length > 1) {
    } else {}
  }

  handRaiseUpdate(data) async {
    getRequestsCount();
    print(
        "onhandRaiseUpdate------------------------------------------------------------------------" +
            jsonEncode(data));
    var res = UpdateHandRaiseResponse.fromJson(data);
    if (res.isAccepted) {
      // await _participantNotifier.deleteSingleItem(
      //     db, res.participantId, 'floor');
      var item = ParticipantListItem(
        role: 'speaker',
        participantId: res.participantId,
        participantType: res.participantType,
        personType: res.personType,
        profileImage: res.profileImage,
        isSpeakerOn: 0,
        isModerator: 0,
        name: res.name,
      );
      await _participantNotifier.updateRole(db, item, 'stage');
      await _participantNotifier.updateModerators(
          db, item.participantId, item.isModerator);
      // await _participantNotifier.saveSingleItem(db, item, 'stage');
      if (int.parse(participantId) == res.participantId) {
        widget.roleCallback(TALKFOOTERENUM.speaker);
        widget.muteCallback(true);
        connectorMuteCall(true);
      }
    } else {
      if (int.parse(participantId) == res.participantId) {
        ToastBuilder()
            .showSnackBar('Rejected', sctx, HexColor(AppColors.information));
        widget.updateHandRaise(false);
      }
    }
  }

  updateHandRaise(UpdateHandRaiseRequest requestPayload) {
    print("hand Raise update Request " + jsonEncode(requestPayload));
    audioSocketService.getSocket().emit(EMIT_HAND_RAISE_UPDATE, requestPayload);
    getRequestsCount();
  }

  onEventEnded(data) {
    print(
        'Event ended called+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    var res = EventListItem.fromJson(data);
    if (res.id == eventId) {
      widget.closeMinimizeActions();
      _participantNotifier.deleteSingleItem(
          db,
          int.parse(participantId),
          isModerator
              ? 'stage'
              : isSpeaker
                  ? 'stage'
                  : 'floor');
      ToastBuilder().showToast(
          AppLocalizations.of(sctx).translate('event_ended'),
          sctx,
          HexColor(AppColors.information));
      leave();
    }
  }

  void handDown() {
    JoinEventPayload payload = JoinEventPayload();
    payload.eventId = eventId;
    payload.personId = prefs.getInt(Strings.userId);
    print('hand down--------' + payload.toJson().toString());
    audioSocketService.getSocket().emit(EMIT_HAND_DOWN, payload);
  }

  onHandsDown(data) {
    print('on hands down-------------------' + jsonEncode(data));
    requestWidgetKey.currentState.hideCard();
    getRequestsCount();
    getRequests();
  }

  onNotification(data) {
    print('on notification-------------------' + jsonEncode(data));
    var res = TalkNotificationResponse.fromJson(data);
    ToastBuilder().showSnackBar(
        res.notification,
        sctx,
        HexColor(
          res.colorCode ?? AppColors.information,
        ),
        textColor: HexColor(AppColors.appColorWhite));
  }

  int getStartTime() {
    return eventStartTime;
  }

  Widget _fullVideoWidget(bool isLocal, int id) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            child: isLocal
                ? RtcLocalView.SurfaceView()
                : RtcRemoteView.SurfaceView(uid: id),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isLocalVideo = false;
                    isFullVideo = false;
                  });
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: HexColor(AppColors.appColorBlack),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SearchParticipantsSheet extends StatefulWidget {
  final Function(String) callback;

  _SearchParticipantsSheet({Key key, this.callback}) : super(key: key);

  @override
  _SearchParticipantsState createState() => _SearchParticipantsState();
}

class _SearchParticipantsState extends State<_SearchParticipantsSheet> {
  List<ParticipantListItem> participantList = [];
  String SearchVal;

  void addValues(List<ParticipantListItem> list) {
    setState(() {
      participantList.clear();
      participantList.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.callback("");
    });
  }

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);

    return Container(
      height: 800,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('search_des'),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBox(
              onvalueChanged: (value) {
                this.SearchVal = value;
                widget.callback(SearchVal);
              },
              hintText: 'Search participants',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: participantList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TricycleUserListTile(
                  imageUrl:  participantList[index].profileImage,
                  title: participantList[index].name,
                  subtitle1: participantList[index].role,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _RequestsListSheet extends StatefulWidget {
  final Function callback;
  final Function(UpdateHandRaiseRequest request) onUserUpdateCallback;

  _RequestsListSheet({Key key, this.callback, this.onUserUpdateCallback})
      : super(key: key);

  @override
  _RequestsListSheetState createState() => _RequestsListSheetState();
}

class _RequestsListSheetState extends State<_RequestsListSheet> {
  List<RequestListItem> participantList = [];

  void addValues(List<RequestListItem> list) {
    setState(() {
      participantList.clear();
      participantList.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Container(
      height: 800,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).translate('manage_speaker'),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: participantList.length > 0
                ? ListView.builder(
                    itemCount: participantList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          contentPadding: EdgeInsets.all(8),
                          leading: TricycleAvatar(
                            imageUrl: participantList[index].profileImage,
                            service_type: SERVICE_TYPE.PERSON,
                            size: 56,
                            resolution_type: RESOLUTION_TYPE.R64,
                            key: UniqueKey(),
                          ),
                          title: Text(
                            participantList[index].name,
                            style:
                                styleElements.subtitle1ThemeScalable(context),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TricycleTextButton(
                                  onPressed: () {
                                    widget.onUserUpdateCallback(
                                        UpdateHandRaiseRequest(
                                            isAccepted: false,
                                            participantId:
                                                participantList[index]
                                                    .requestedById,
                                            participantType:
                                                participantList[index]
                                                    .requestedByType,
                                            role: 'speaker'));
                                    participantList.removeAt(index);
                                    if (participantList.length == 0) {
                                      Navigator.pop(context);
                                    } else {
                                      Future.microtask(() {
                                        setState(() {});
                                      });
                                    }
                                  },
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                        color:
                                            HexColor(AppColors.appColorWhite)),
                                  ),
                                  child: Text(
                                    'Reject',
                                    style: styleElements
                                        .captionThemeScalable(context)
                                        .copyWith(
                                            color: HexColor(
                                                AppColors.appMainColor)),
                                  )),
                              TricycleTextButton(
                                  onPressed: () {
                                    widget.onUserUpdateCallback(
                                        UpdateHandRaiseRequest(
                                            isAccepted: true,
                                            participantId:
                                                participantList[index]
                                                    .requestedById,
                                            participantType:
                                                participantList[index]
                                                    .requestedByType,
                                            role: 'speaker'));
                                    participantList.removeAt(index);
                                    if (participantList.length == 0) {
                                      Navigator.pop(context);
                                    } else {
                                      Future.microtask(() {
                                        setState(() {});
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Allow',
                                    style: styleElements
                                        .captionThemeScalable(context)
                                        .copyWith(
                                            color: HexColor(
                                                AppColors.appMainColor)),
                                  ))
                            ],
                          ));
                    },
                  )
                : CustomPaginator(context).emptyListWidgetMaker(null),
          ),
        ],
      ),
    );
  }
}

class AudioPageLoaderPage extends StatefulWidget {
  AudioPageLoaderPage({Key key}) : super(key: key);

  @override
  AudioPageLoaderPageState createState() => AudioPageLoaderPageState();
}

class AudioPageLoaderPageState extends State<AudioPageLoaderPage> {
  bool isShowing = true;

  void hideLoader() {
    setState(() {
      isShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isShowing,
      child: Column(
        children: [
          Expanded(
            child: Container(
                color: HexColor(AppColors.appColorBackground),
                child: CustomPaginator(context).loadingWidgetMaker()),
          )
        ],
      ),
    );
  }
}
