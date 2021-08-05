import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/recover_password.dart';
import 'package:oho_works_app/api_calls/sign_up_api.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/login_signup_module/update_profile_page.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/device_info.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
import 'package:oho_works_app/models/register_user_payload.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new_password.dart';

// ignore: must_be_immutable
class Verification extends StatefulWidget {
  final String email;
  final String mobileNo;
  bool isRecoverPassword = false;
  final bool isEmailRecovery;

  Verification(
      {Key? key,
        required this.email,
        required this.mobileNo,
        required this.isEmailRecovery,
        required this.isRecoverPassword})
      : super(key: key);

  @override
  _Verification createState() =>
      _Verification(isRecoverPassword, email, mobileNo);
}

// ignore: must_be_immutable
class _Verification extends State<Verification> {
  bool isRecoverPassword = false;
 late  BuildContext context;

  late SharedPreferences prefs;
  final String email;
  final String mobileNo;
  String _otp = "";
  var _otpSymbols = ["0", "0", "0", "0", "0", "0"];
  bool isCalling = false;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _getSignatureCode();
    setSharedPreferences();
    super.initState();
  }

  _getSignatureCode() async {

  }

  void recoverPassword() async {
    if (_otp.length == 6) {
      setState(() {
        isCalling = true;
      });
      var code = _otp;
      RegisterUserPayload loginPayLoad = RegisterUserPayload();
      loginPayLoad.email = email;
      loginPayLoad.token = int.parse(code.trim());
      if(widget.isEmailRecovery){
        Calls().call(jsonEncode(loginPayLoad), context, Config.EMAIL_FORGOT_PASSWORD_OTP).then((value) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code){
            Navigator.pop(context,true);
          }
        }).catchError((onError){
          setState(() {
            isCalling = false;
          });
          ToastBuilder().showSnackBar(
              AppLocalizations.of(context)!.translate("try_again"),
              sctx,
              HexColor(AppColors.information));
        });
      }else {
        RecoverPasswordApis()
            .recoverPasswordOtp(context, jsonEncode(loginPayLoad.toJson()))
            .then((value) async {
          setState(() {
            isCalling = false;
          });
          if (value != null) {
            var data = CommonBasicResponse.fromJson(value);

            if (data.statusCode == Strings.success_code &&
                data.message == Strings.success) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewPassword(
                          email: email,
                        ),
                  ));
            } else {
              if (data.message != null)
                ToastBuilder().showSnackBar(
                    data.message!, sctx, HexColor(AppColors.information));
              else
                ToastBuilder().showSnackBar(
                    AppLocalizations.of(context)!.translate("try_again"),
                    sctx,
                    HexColor(AppColors.information));
            }
          }
        }).catchError((onError) async {
          setState(() {
            isCalling = false;
          });
          ToastBuilder().showSnackBar(
              AppLocalizations.of(context)!.translate("try_again"),
              sctx,
              HexColor(AppColors.information));
        });
      }
    } else
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context)!.translate("enter_otp"),
          sctx,
          HexColor(AppColors.information));
  }

  void resendOtp() async {
    setState(() {
      isCalling = true;
    });
    RegisterUserPayload loginPayLoad = RegisterUserPayload();
    loginPayLoad.email = email;
    loginPayLoad.reason = "USERREGISTRATION";
    if(widget.isEmailRecovery) {
      var data = jsonEncode({"email_id": email});
      Calls().call(data, context, Config.EMAIL_FORGOT_PASSWORD).then((value) {
        var res = CreateEmailUserResponse.fromJson(value);
        if (res.statusCode == Strings.success_code) {
          setState(() {
            isCalling = false;
          });
          ToastBuilder().showSnackBar(
              "Otp sent again", sctx, HexColor(AppColors.information));
        }
      }).catchError((onError){
        setState(() {
          isCalling = false;
        });
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("try_again"),
            sctx,
            HexColor(AppColors.information));
      });;
    }else {
      RecoverPasswordApis()
          .resendOtp(context, jsonEncode(loginPayLoad.toJson()))
          .then((value) async {
        setState(() {
          isCalling = false;
        });
        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);

          if (data.statusCode == Strings.success_code &&
              data.message == Strings.success) {
            print(
                data.statusCode! +
                    "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
            print(data.message! + "*****************************************");
            ToastBuilder().showSnackBar(
                data.message!, sctx, HexColor(AppColors.information));
          } else {
            if (data.message != null)
              ToastBuilder().showSnackBar(
                  data.message!, sctx, HexColor(AppColors.information));
            else
              ToastBuilder().showSnackBar(
                  AppLocalizations.of(context)!.translate("try_again"),
                  sctx,
                  HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        setState(() {
          isCalling = false;
        });
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("try_again"),
            sctx,
            HexColor(AppColors.information));
      });
    }
  }

  void activate(String? _code) async {
    String code = "";
    if (_code != null) {
      code = _code;
    } else {
      code = _otp;
    }

    if (code != null && code.length == 6) {
      setState(() {
        isCalling = true;
      });
      RegisterUserPayload registerUserPayload = RegisterUserPayload();
      registerUserPayload.email = email;
      try {
        registerUserPayload.token = int.parse(code);
      } catch (e) {
        print(e);
        setState(() {
          isCalling = false;
        });
      }
      DeviceInfo deviceInfo =DeviceInfo();
      if (prefs.getString("DeviceInfo") != null) {
        Map<String, dynamic> map =
        json.decode(prefs.getString("DeviceInfo") ?? "");
        deviceInfo = DeviceInfo.fromJson(map);
      }

      if (prefs.getDouble("lat") != null)
        deviceInfo.gpsInfo = "Latitude :" +
            prefs.getDouble("lat").toString() +
            ", Longitude : " +
            prefs.getDouble("longi").toString();


      if(prefs.getString("fcmId")!=null)
        deviceInfo.fcmId = prefs.getString("fcmId");




      print( jsonEncode(deviceInfo));
      SignUpApi()
          .activate(jsonEncode(registerUserPayload.toJson()), context,
          jsonEncode(deviceInfo))
          .then((value) async {
        setState(() {
          isCalling = false;
        });

        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            if (data.message != null && data.message != "Invalid OTP") {
              await prefs.setString('expiry', data.rows!.expiry ?? "");
              await prefs.setString('token', data.rows!.token ?? "");
              await  prefs.setInt(Strings.userId, data.rows!.userId!);
              prefs.setBool("isProfileUpdated", false);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                      (Route<dynamic> route) => false);
            } else {
              if (data.message != null)
                ToastBuilder().showSnackBar(
                    data.message!, sctx, HexColor(AppColors.information));
            }
          } else {
            if (data.message != null)
              ToastBuilder().showSnackBar(
                  data.message!, sctx, HexColor(AppColors.information));
            else
              ToastBuilder().showSnackBar(
                  AppLocalizations.of(context)!.translate("try_again"),
                  sctx,
                  HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        setState(() {
          isCalling = false;
        });
        print(onError.toString());
        ToastBuilder().showSnackBar(
            "please try again", sctx, HexColor(AppColors.information));
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
            appBar: OhoAppBar().getCustomAppBar(
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
                      /* Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Image(
                      image: AssetImage('assets/appimages/otp.jpg'),
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                    )),*/
                      Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 20),
                        child: Text(AppLocalizations.of(context)!.translate('verification'),
                          textAlign: TextAlign.center,
                          style: styleElements.headline5ThemeScalable(context),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Text(AppLocalizations.of(context)!.translate('otp_des',arguments: {"email":email,"mobileNo":mobileNo}),
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
                                    if (isRecoverPassword)
                                      recoverPassword();
                                    else
                                      activate(null);
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
                          resendOtp();
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

  _Verification(this.isRecoverPassword, this.email, this.mobileNo);
}
