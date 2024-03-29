import 'dart:async';

import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OtpView extends StatefulWidget {
  final String email;
  final String newEmail;
  final bool? isGuestCheckOut;

  const OtpView({
    Key? key,
    required this.email,
    this.newEmail = "",
    this.isGuestCheckOut,
  }) : super(key: key);

  @override
  _OtpViewState createState() => new _OtpViewState();
}

class _OtpViewState extends State<OtpView> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 5;
  AnimationController? _controller;
  late TextStyleElements styleElements;
  // Variables
  late Size _screenSize;
  int? _currentDigit;
  int? _firstDigit;
  int? _secondDigit;
  int? _thirdDigit;
  int? _fourthDigit;

  Timer? timer;
  int? totalTimeInSeconds;
  late bool _hideResendButton;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  // Returns "Appbar"
  // get _getAppbar {
  //   return appAppBar().getCustomAppBar(context, appBarTitle: '', onBackButtonPress: (){Navigator.pop(context);});
  // }

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return Text(AppLocalizations.of(context)!.translate('verification_code'),
      textAlign: TextAlign.center,
      style: styleElements.headline5ThemeScalable(context),
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return Text(AppLocalizations.of(context)!.translate('please_enter_otp'),
      textAlign: TextAlign.center,
      style: styleElements.subtitle1ThemeScalable(context),
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getVerificationCodeLabel,
        _getEmailLabel,
        _getInputField,
        _hideResendButton ? _getTimerText : _getResendButton,
        _getOtpKeyboard
      ],
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.access_time),
            SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, HexColor(AppColors.appColorBlack))
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return Container(
      height: 50,
      width: 200,
      child: MaterialButton(
          splashColor: HexColor(AppColors.appMainColor).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: HexColor(AppColors.appColorBlueAccent),
          onPressed: () {
            // Resend you OTP via API or anything
            clearOtp();
            _startCountdown();
          },
          child: Text(AppLocalizations.of(context)!.translate('resend_otp'),
            style: styleElements.subtitle1ThemeScalable(context),
          )),
    );
  }

  // Returns "Resend" button
  // get _getVerifyButton {
  //   return Container(
  //     height: 50,
  //     width: 200,
  //     child: MaterialButton(
  //         splashColor: HexColor(AppColors.HexColor(AppColors.appMainColor)).withOpacity(0.5),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(50.0),
  //         ),
  //         color: HexColor(AppColors.appBlueAccent),
  //         onPressed: () {
  //           // You can dall OTP verification API.
  //         },
  //         child: Text(
  //           "Verify OTP",
  //           style: TextStyle(fontWeight: FontWeight.bold, color: HexColor(AppColors.appColorWhite)),
  //         )),
  //   );
  // }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return Container(
        height: _screenSize.width - 80,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _fourthDigit != null,
                    child: _otpKeyboardActionButton(
                        label: Icon(
                          Icons.check_circle,
                          color: HexColor(AppColors.appColorBlack),
                        ),
                        onPressed: () {
                          // you can dall OTP verification API.
                        }),
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: Icon(
                        Icons.backspace,
                        color: HexColor(AppColors.appColorBlack),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller!.reverse(
        from: _controller!.value == 0.0 ? 1.0 : _controller!.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    _screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:appAppBar().getCustomAppBar(
            context,
            appBarTitle: '',
            onBackButtonPress: (){
              Navigator.pop(context);
            }),
        backgroundColor: HexColor(AppColors.appColorWhite),
        body: Container(
          width: _screenSize.width,
          //        padding: new EdgeInsets.only(bottom: 16.0),
          child: _getInputPart,
        ),
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int? digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? digit.toString() : "",
        style: styleElements.headline4ThemeScalable(context),
      ),
      decoration: BoxDecoration(
          //            color: HexColor(AppColors.appColorGrey500).withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: HexColor(AppColors.appColorBlack),
      ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({required String label, VoidCallback? onPressed}) {
    return Material(
      color: HexColor(AppColors.appColorTransparent),
      child: InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: styleElements.headline4ThemeScalable(context),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget? label, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else _fourthDigit ??= _currentDigit;
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller!.reverse(
        from: _controller!.value == 0.0 ? 1.0 : _controller!.value);
  }

  void clearOtp() {
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

// ignore: must_be_immutable
class OtpTimer extends StatelessWidget {
  final AnimationController? controller;
  double fontSize;
  Color timeColor = HexColor(AppColors.appColorBlack);
  late TextStyleElements styleElements;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller!.duration! * controller!.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration {
    Duration? duration = controller!.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return AnimatedBuilder(
        animation: controller!,
        builder: (BuildContext context, Widget? child) {
          return Text(
            timerString,
            style: styleElements.subtitle2ThemeScalable(context),
          );
        });
  }
}
