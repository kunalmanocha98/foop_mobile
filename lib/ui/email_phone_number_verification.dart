import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



// ignore: must_be_immutable
class EmailPhoneVerification extends StatefulWidget {
  final int? id;
  final bool isEmail;
  final String? contactDetail;
  final Null Function() callBack;

  EmailPhoneVerification(
      {Key? key,
        required this.id,
        required this.isEmail,
        required this.contactDetail,
        required this.callBack
       })
      : super(key: key);

  @override
  _EmailPhoneVerification createState() =>
      _EmailPhoneVerification(id,isEmail,callBack,contactDetail);
}

// ignore: must_be_immutable
class _EmailPhoneVerification extends State<EmailPhoneVerification> {
   int? id;
   bool isEmail;
   Null Function() callBack;
  late BuildContext context;
   String? contactDetail;
  SharedPreferences? prefs;
   String? email;
   String? mobileNo;
  String _otp = "";
  var _otpSymbols = ["0", "0", "0", "0", "0", "0"];
  bool isCalling = false;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    sendOtp();
    setSharedPreferences();
    super.initState();
  }

   void sendOtp() async {
    final body = jsonEncode({"id":id});
     Calls().call(body, context, Config.SEND_OTP_FOR_EMAIL_PHONE_VERIFICATION).then((value) async {
       if (value != null) {
       }
     }).catchError((onError) async {
       ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
     });
   }


   void submit() async {

    if (_otp != null && _otp.length == 6) {
      final body = jsonEncode({"id":id,"token":int.parse(_otp)});
      Calls().call(body, context, Config.EMAIL_PHONE_VERIFICATION_CODE).then((value) async {
        if (value != null) {
          Navigator.pop(context);
          callBack();
        }
      }).catchError((onError) async {
        ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      });
     } else {
       ToastBuilder().showSnackBar(
           AppLocalizations.of(context)!.translate("enter_token"),
           sctx,
           HexColor(AppColors.information));
     }




   }




  getCode(String sms) {
    if (sms != null) {
      final intRegex = RegExp(r'\d+', multiLine: true);
      final code = intRegex.allMatches(sms).first.group(0);

      return code;
    }
    return null;
  }

  late TextStyleElements styleElements;
  late BuildContext sctx;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    FocusScope.of(context).unfocus();
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
            appBar: appAppBar().getCustomAppBar(
              context,
              onBackButtonPress: () {
                Navigator.pop(context);
              },
              appBarTitle: "",
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: HexColor(AppColors.appColorBackground),
            body: new Builder(builder: (BuildContext context) {
              this.sctx = context;
              return new Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[

                      Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 20),
                        child: Text(AppLocalizations.of(context)!.translate(isEmail?'verify_email':'verify_mobile'),
                          textAlign: TextAlign.center,
                          style: styleElements.headline5ThemeScalable(context),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Text(AppLocalizations.of(context)!.translate('otp_des_verification',arguments: {"email":contactDetail ?? "",}),
                          style: styleElements.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                          width: 320.0,
                          height: 160.0,
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, top: 2, bottom: 8),
                          decoration: BoxDecoration(
                            color: HexColor(AppColors.appColorWhite),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              CommonComponents().getShadowforBox(),
                            ],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0)),
                          ),
                          child: Column(
                            children: [
                              /* TextFieldPin(
                                filled: true,
                                filledColor: HexColor(AppColors.appColorWhite),
                                codeLength: 6,
                                boxSize: 1,
                                filledAfterTextChange: false,
                                textStyle: styleElements
                                    .bodyText1ThemeScalable(context),
                                borderStyle: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(34)),
                                onOtpCallback: (code, isAutofill) =>
                                    _onOtpCallBack(code, isAutofill),
                              ),*/
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, top: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[0],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                      Spacer(),
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[1],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                      Spacer(),
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[2],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                      Spacer(),
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[3],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                      Spacer(),
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[4],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                      Spacer(),
                                      new Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: new Text(
                                                  _otpSymbols[5],
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: HexColor(AppColors.appColorGrey50),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10))))),
                                    ],
                                  )),
                              !isCalling
                                  ? Container(
                                width: 260.0,
                                height: 52.0,
                                margin: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0),
                                child: appElevatedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(24.0),
                                      side:
                                      BorderSide(color: HexColor(AppColors.appMainColor))),
                                  onPressed: () {
                                    submit();
                                  },
                                  color:  HexColor(AppColors.appMainColor),
                                  child: Text(AppLocalizations.of(context)!.translate('verify'),
                                    style: styleElements
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(color: HexColor(AppColors.appColorWhite)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              )
                                  : Center(
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator()),
                              ),
                            ],
                          )),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          sendOtp();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 8),
                          child: Text(AppLocalizations.of(context)!.translate('resend_code'),
                            textAlign: TextAlign.center,
                            style: styleElements
                                .subtitle2ThemeScalable(context)
                                .copyWith(color: HexColor(AppColors.appMainColor)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              color: HexColor(AppColors.appColorGrey50),
                              padding: EdgeInsets.all(8),
                              child: Column(children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('1');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_1'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('2');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_2'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('3');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_3'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      )
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('4');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_4'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('5');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_5'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('6');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_6'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      )
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('7');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_7'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('8');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_8'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      ),
                                      appTextButton(
                                        onPressed: () {
                                          _handleKeypadClick('9');
                                        },
                                        child: Text(AppLocalizations.of(context)!.translate('number_9'),
                                            style: styleElements
                                                .headline5ThemeScalable(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal)),
                                      )
                                    ]),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        appTextButton(
                                          onPressed: () {
                                            _handleSubmit();
                                          },
                                          child: Text('',
                                              style: styleElements
                                                  .headline5ThemeScalable(
                                                  context)
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.normal)),
                                        ),
                                        appTextButton(
                                          onPressed: () {
                                            _handleKeypadClick('0');
                                          },
                                          child: Text(AppLocalizations.of(context)!.translate('number_0'),
                                              style: styleElements
                                                  .headline5ThemeScalable(
                                                  context)
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.normal)),
                                        ),
                                        appTextButton(
                                          onPressed: () {
                                            _handleKeypadDel();
                                          },
                                          child: Text('\u{232b}',
                                              style: styleElements
                                                  .headline5ThemeScalable(
                                                  context)
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.normal)),
                                        ),
                                      ]),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
            })));
  }

  void _handleKeypadClick(String val) {
    setState(() {
      if (_otp.length < 6) {
        _otp = _otp + val;

        _otpSymbols[_otp.length - 1] = val;
      }
    });
  }

  void _handleKeypadDel() {
    setState(() {
      if (_otp.length > 0) {
        _otp = _otp.substring(0, _otp.length - 1);
        for (int i = _otp.length; i < 6; i++) _otpSymbols[i] = "0";
      }
    });
  }

  void _handleSubmit() {}


  @override
  void dispose() {
    super.dispose();

  }

  _EmailPhoneVerification(this.id,this.isEmail,this.callBack,this. contactDetail);
}
