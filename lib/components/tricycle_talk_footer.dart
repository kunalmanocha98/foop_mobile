import 'package:oho_works_app/components/tricycle_talk_footer_button.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleTalkFooter extends StatefulWidget {
  final Function exitCallback;
  final Function chatCallback;
  final Function postCallback;
  final Function talkCallback;
  final Function handRaiseCallback;
  final Function(bool) muteCallBack;
  final Function(bool) handRaisebyOthersCallback;
  final Function postCreateCallback;
  final bool isMute;
  final int chatCount;
  final Function(bool) videoCallBack;
  final TALKFOOTERENUM role;
  TricycleTalkFooter(
      { Key key,
        this.chatCallback,
        this.postCallback,
        this.talkCallback,
        this.muteCallBack,
        this.chatCount,
        this.role,
        this.videoCallBack,
        this.handRaiseCallback,
        this.isMute = true,
        this.handRaisebyOthersCallback,
        this.postCreateCallback,
        this.exitCallback,}):super(key: key);
  @override
  TricycleTalkFooterState createState() => TricycleTalkFooterState(isMute: isMute,role: role,chatCount: chatCount);

}
class TricycleTalkFooterState extends State<TricycleTalkFooter>{
  TextStyleElements styleElements;
  BuildContext context;
  GlobalKey<TricycleTalkFooterButtonState> buttonState = GlobalKey();
  TALKFOOTERENUM type;
  bool isMute;
  int chatCount;
  TricycleTalkFooterState({this.isMute,TALKFOOTERENUM role,this.chatCount =0}){
    this.type = role ?? TALKFOOTERENUM.audience;
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    // return Container(
    //   padding: EdgeInsets.only(top: 1, bottom: 1),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       (type == TALKFOOTERENUM.chat || type == TALKFOOTERENUM.post)?_talkButton:_exitButton,
    //       Visibility(
    //           visible: (type != TALKFOOTERENUM.chat),
    //           child: TricycleTalkFooterButton(key: buttonState,postCreateCallback:widget.postCreateCallback,type: type,muteCallBack:widget.muteCallBack,handRaiseCallback: widget.handRaiseCallback,
    //             handRaisedByOthersCallback: widget.handRaisebyOthersCallback,)),
    //       (type==TALKFOOTERENUM.post)? _postButton : _chatButton
    //     ],
    //   ),
    // );
    return Container(
      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (type == TALKFOOTERENUM.chat || type == TALKFOOTERENUM.post)?_talkButton:_exitButton,
          Visibility(
              visible: (type != TALKFOOTERENUM.chat),
              child: TricycleTalkFooterButton(key: buttonState,
                type: type,
                  isMute: isMute
                  ,postCreateCallback:widget.postCreateCallback,muteCallBack:(b){
                isMute = !b;

                widget.muteCallBack(b);
              },handRaiseCallback: widget.handRaiseCallback,
                videoCallBack:widget.videoCallBack,
              handRaisedByOthersCallback: widget.handRaisebyOthersCallback,)),
          (type==TALKFOOTERENUM.chat)? _postButton : _chatButton
        ],
      ),
    );
  }

  Widget get _talkButton =>
      InkWell(
        onTap: widget.talkCallback,
        borderRadius: BorderRadius.circular(45),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AbsorbPointer(
              child: IconButton(icon: Icon(Icons.mic_none),
                  onPressed
                  :widget.talkCallback,
                  color: HexColor(AppColors.appColorBlack65)),
            ),
            Text(AppLocalizations.of(context).translate('talk'),
              style: styleElements.subtitle1ThemeScalable(context),),
          ],
        ),
      );

  Widget get _exitButton =>
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: widget.exitCallback,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotatedBox(quarterTurns: 2,
                child: AbsorbPointer(
                  child: IconButton(icon: Icon(Icons.logout),
                      onPressed: widget.exitCallback,
                      color: HexColor(AppColors.appColorBlack65)),
                )),
            Text(AppLocalizations.of(context).translate('leave'),
              style: styleElements.subtitle1ThemeScalable(context),)
          ],
        ),
      );

  Widget get _chatButton =>
      InkWell(
        onTap: widget.chatCallback,
        borderRadius: BorderRadius.circular(45),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).translate('chat'),
              style: styleElements.subtitle1ThemeScalable(context),),
            Stack(
              children: [
                AbsorbPointer(
                  child: IconButton(icon: Icon(Icons.message_outlined),
                      onPressed: widget.chatCallback,
                      color: HexColor(AppColors.appColorBlack65)),
                ),
                Visibility(
                  visible: chatCount>0,
                  child: new Positioned(
                    right: 4,
                    top: 4,
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
                        child: Text(chatCount.toString()??"",
                          style: TextStyle(
                              color: HexColor(AppColors.appColorWhite),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );

  Widget get _postButton =>
      InkWell(
        onTap: widget.postCallback,
        borderRadius: BorderRadius.circular(45),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).translate('post'),
              style: styleElements.subtitle1ThemeScalable(context),),
            AbsorbPointer(
              child: IconButton(icon: Icon(Icons.article_outlined),
                  onPressed: widget.postCallback,
                  color: HexColor(AppColors.appColorBlack65)),
            ),
          ],
        ),
      );

  void countUpdate(int count) {
    buttonState.currentState.updateCount(count);
  }

  void updateType(TALKFOOTERENUM role) {
    setState(() {
    if(role!=null) {
      type = role;
      // if (role == EVENT_ROLE_TYPE.speaker.type) {
      //   type = TALKFOOTERENUM.speaker;
      // } else if (role == EVENT_ROLE_TYPE.host.type || role == EVENT_ROLE_TYPE.cohost.type) {
      //   type = TALKFOOTERENUM.moderator;
      // }else if (role == 'post') {
      //   type = TALKFOOTERENUM.post;
      // }else if (role == 'chat') {
      //   type = TALKFOOTERENUM.chat;
      // } else {
      //   type = TALKFOOTERENUM.moderator;
      // }
    }else{
      type = TALKFOOTERENUM.audience;
    }

    });
  }

  void updateHandRaise(bool handRaise) {
    buttonState.currentState.updateHandRaise(handRaise);
  }

  void updateMuteStatus(bool b) {
    buttonState.currentState.updateMuteStatus(b);
  }

  void chatcountUpdate(int count) {
    Future.microtask((){
      setState(() {
        chatCount = count;
      });
    });
  }

  void incrementChatCount() {
    print("event_message-----------------------------------------------step5"+chatCount.toString());
    Future.microtask((){
      setState(() {
        chatCount = chatCount +1;
      });
    });
  }

  void resetChatCount() {
    Future.microtask((){
      setState(() {
        chatCount = 0;
      });
    });
  }

}