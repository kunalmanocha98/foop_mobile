import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class TricycleTalkFooterButton extends StatefulWidget {
  final TALKFOOTERENUM? type;
  final Function(bool)? muteCallBack;

  final Function? handRaiseCallback;
  final Function(bool)? handRaisedByOthersCallback;

  final Function? postCreateCallback;
  final Function(bool)? videoCallBack;
  final bool? isMute;

  TricycleTalkFooterButton(
      {Key? key,
        this.type,
        this.isMute = true,
        this.muteCallBack,
        this.handRaiseCallback,
        this.videoCallBack,
        this.handRaisedByOthersCallback,
        this.postCreateCallback})
      : super(key: key);

  @override
  TricycleTalkFooterButtonState createState() =>
      TricycleTalkFooterButtonState(isMute!);
}

enum TALKFOOTERENUM { speaker, moderator, audience, chat, post }

class TricycleTalkFooterButtonState extends State<TricycleTalkFooterButton> {
  bool _handRaise = false;
  bool _speakerOn = false;
   bool _videoOn = false;

  int count = 0;

  TricycleTalkFooterButtonState(bool isMute) {
    _speakerOn = !isMute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 4),

        child: Padding(
          padding: const EdgeInsets.only(bottom:6.0),
          child: Stack(
            children: [
              Visibility(
                visible: widget.type == TALKFOOTERENUM.audience,
                child: _audienceButton,
              ),
              Visibility(
                visible: widget.type == TALKFOOTERENUM.speaker,
                child: _speakersButtons,
              ),
              Visibility(
                visible: widget.type == TALKFOOTERENUM.post,
                child: _postButton,
              ),
              Visibility(
                visible: widget.type == TALKFOOTERENUM.moderator,
                child: _moderatorButton,
              ),
            ],
          ),
        ));
  }

  // Widget get _buildButton {
  //   if (widget.type == TALKFOOTERENUM.audience) {
  //     return _audienceButton;
  //   } else if (widget.type == TALKFOOTERENUM.speaker) {
  //     return _speakerButton;
  //   } else if (widget.type == TALKFOOTERENUM.post) {
  //     return _postButton;
  //   } else {
  //     return _moderatorButton;
  //   }
  // }

  Widget get _speakersButtons => Row(
    children: [
      _speakerButton,
      SizedBox(
        width: 12,
      ),
    /*  _videoButton,
      SizedBox(
        width: 12,
      ),*/

    ],
  );


  Widget get _videoButton => Row(
    children: [
      FloatingActionButton(
        heroTag: null,
        backgroundColor: !_videoOn
            ? HexColor(AppColors.appMainColor)
            : HexColor(AppColors.appColorWhite),
        onPressed: () {
          print(_videoOn.toString());
          if (!_videoOn) {
            widget.videoCallBack!(true);
            setState(() {
              _videoOn = !_videoOn;
            });
          } else {
            widget.videoCallBack!(false);
            setState(() {
              _videoOn = !_videoOn;
            });
          }
        },
        child: Icon(
          _videoOn ? Icons.videocam_outlined : Icons.videocam_off_outlined,
          color: !_videoOn
              ?HexColor(AppColors.appColorWhite)
              : HexColor(AppColors.appColorBlack65),
        ),
      )
    ],
  );

  Widget get _audienceButton => Row(
    children: [
      FloatingActionButton(
        heroTag: null,
        backgroundColor: !_handRaise
            ? HexColor(AppColors.appMainColor)
            : HexColor(AppColors.appColorWhite),
        onPressed: () {
          if (!_handRaise) {
            widget.handRaisedByOthersCallback!(true);
            setState(() {
              _handRaise = !_handRaise;
            });
          } else {
            widget.handRaisedByOthersCallback!(false);
            setState(() {
              _handRaise = !_handRaise;
            });
          }
        },
        child: Icon(
          _handRaise ? Icons.pan_tool : Icons.pan_tool_outlined,
          color: !_handRaise
              ? HexColor(AppColors.appColorWhite)
              : HexColor(AppColors.appColorBlack65),
        ),
      )
    ],
  );

  Widget get _speakerButton => Row(
    children: [
      FloatingActionButton(
        heroTag: null,
        backgroundColor: !_speakerOn
            ?HexColor(AppColors.appMainColor)
            : HexColor(AppColors.appColorWhite),
        onPressed: () {
          widget.muteCallBack!(!_speakerOn);
          setState(() {
            _speakerOn = !_speakerOn;
          });
        },
        child: Icon(
          _speakerOn ? Icons.mic_none_outlined : Icons.mic_off_outlined,
          color: !_speakerOn
              ?HexColor(AppColors.appColorWhite)
              : HexColor(AppColors.appColorBlack65),
        ),
      )
    ],
  );

  Widget get _postButton => Row(
    children: [
      FloatingActionButton(
        heroTag: null,
        onPressed: widget.postCreateCallback as void Function()?,
        backgroundColor: HexColor(AppColors.appColorWhite),
        child: Icon(
          Icons.add_circle_outline_outlined,
          color: HexColor(AppColors.appColorBlack65),
        ),
      )
    ],
  );




  Widget get _moderatorButton => Row(
    children: [
      FloatingActionButton(
        heroTag: null,
        backgroundColor: !_speakerOn
            ? HexColor(AppColors.appMainColor)
            : HexColor(AppColors.appColorWhite),
        onPressed: () {
          widget.muteCallBack!(!_speakerOn);
          setState(() {
            _speakerOn = !_speakerOn;
          });
        },
        child: Icon(
          _speakerOn ? Icons.mic_none_outlined : Icons.mic_off_outlined,
          color: !_speakerOn
              ?HexColor(AppColors.appColorWhite)
              : HexColor(AppColors.appColorBlack65),
        ),
      ),
      SizedBox(
        width: 12,
      ),
      _videoButton,
      SizedBox(
        width: 12,
      ),
      Stack(
        children: [
          FloatingActionButton(
              heroTag: null,
              backgroundColor: count>0
                  ? HexColor(AppColors.appColorWhite)
                  : HexColor(AppColors.appMainColor),
              onPressed: widget.handRaiseCallback as void Function()?,
              child: Icon(
                Icons.pan_tool_outlined,
                color: count>0
                    ?HexColor(AppColors.appColorBlack65)
                    : HexColor(AppColors.appColorWhite),
              )),
          Visibility(
            visible: count > 0,
            child: new Positioned(
              right: 4,
              top: 4,
              child: new Container(
                padding: EdgeInsets.all(2),
                decoration: new BoxDecoration(
                  color:  HexColor(AppColors.appMainColor),
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    "$count",
                    style: TextStyle(
                        color:  HexColor(AppColors.appColorWhite)
                         ,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      )
    ],
  );

  void updateCount(int count) {
    setState(() {
      this.count = count;
    });
  }

  void updateHandRaise(bool handRaise) {
    setState(() {
      this._handRaise = handRaise;
    });
  }

  void updateMuteStatus(bool b) {
    setState(() {
      this._speakerOn = !b;
    });
  }
}