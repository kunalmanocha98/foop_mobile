import 'package:oho_works_app/components/app_talk_footer_button.dart';
import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class TalkEventData{
  EventListItem? model;
  bool? showPlayback;
  RtcEngine? engine;
  int? startTime;
  TALKFOOTERENUM? role;
  TalkEventData({this.model,this.showPlayback,this.engine,this.role,this.startTime});
}