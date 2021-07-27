import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/login_apis.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/login_signup_module/update_profile_page.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/device_info.dart';
import 'package:oho_works_app/models/login_payload.dart';
import 'package:oho_works_app/models/login_response.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/dashboardhomepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);*/

class LoginPage extends StatefulWidget {
  @override
  StateLoginPage createState() => new StateLoginPage();
}

// ignore: must_be_immutable
class StateLoginPage extends State<LoginPage> {
  late TextStyleElements styleElements;
  final emailController = TextEditingController();
  final passwordTextController = TextEditingController();
  late BuildContext context;
  late BuildContext sctx;

  SharedPreferences? prefs;
  bool isCalling = false;

  @override
  void initState() {
    super.initState();
  }

  static Future<List<String?>> getDeviceDetails(SharedPreferences? prefs) async {
    String? deviceName;
    String? deviceVersion;
    String? identifier;
    DeviceInfo deviceInfo;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        deviceInfo = DeviceInfo();
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        prefs!.setString('UUID', build.androidId); //UUID for Android
        deviceInfo.machineCode = build.androidId;
        deviceInfo.deviceInfo = build.device;
        deviceInfo.deviceType = "android";
        deviceInfo.deviceVendor = build.manufacturer;
        deviceInfo.macId = build.id;
        deviceInfo.manufacturer = build.manufacturer;
        deviceInfo.applicationType = "flutter android";
        var data = jsonEncode(deviceInfo);
        prefs.setString("DeviceInfo", data);
      } else if (Platform.isIOS) {
         deviceInfo = DeviceInfo();
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name.toString();
        deviceVersion = data.systemVersion.toString();
        deviceInfo.deviceInfo = " ";
         deviceInfo.machineCode = data.identifierForVendor.toString();
        deviceInfo.deviceType = "ios";
        deviceInfo.osType = data.systemName.toString();
        deviceInfo.osVersion = data.systemVersion.toString();
        deviceInfo.applicationType = "flutter ios";
        var dataIos = jsonEncode(deviceInfo);
        prefs!.setString("DeviceInfo", dataIos);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  void login() async {
    DeviceInfo deviceInfo = DeviceInfo();
    if (prefs!.getString("DeviceInfo") != null) {
      Map<String, dynamic> map = json.decode(prefs!.getString("DeviceInfo") ?? "");
      deviceInfo = DeviceInfo.fromJson(map);
    }

    if (prefs!.getDouble("lat") != null && deviceInfo != null)
      deviceInfo.gpsInfo = "Latitude :" +
          prefs!.getDouble("lat").toString() +
          ", Longitude : " +
          prefs!.getDouble("longi").toString();

    if (Platform.isAndroid &&
        prefs!.getString("fcmId") != null &&
        deviceInfo != null)
      deviceInfo.fcmId = prefs!.getString("fcmId");
    else {
      deviceInfo.deviceType = "ios";
      if (prefs!.getString("fcmId") != null)
        deviceInfo.fcmId = prefs!.getString("fcmId");
      deviceInfo.applicationType = "flutter ios";
    }

    if (emailController.text.trim().isNotEmpty &&
        EditProfileMixins().validateEmail(emailController.text) == null) {
      if (passwordTextController.text.trim().isNotEmpty) {
        setState(() {
          isCalling = true;
        });
        LoginPayLoad loginPayLoad = LoginPayLoad();
        loginPayLoad.username = emailController.text;
        loginPayLoad.password = passwordTextController.text;
        LoginApis().loginApi(jsonEncode(loginPayLoad.toJson()), context, jsonEncode(deviceInfo)).then((value) async {
          setState(() {
            isCalling = false;
          });
          if (value != null) {
            var data = LoginResponse.fromJson(value);
            if (data.statusCode == Strings.success_code) {
              print('printing success message ');
              if (data.rows!.expiry != null)
                await prefs!.setString('expiry', data.rows!.expiry ?? "");
              if (data.rows!.token != null) {
                await prefs!.setString('token', data.rows!.token ?? "");
                getPersonProfile(context);
              }
            } else {
              if (data.message != null) {
                ToastBuilder().showSnackBar(
                    data.message!, sctx, HexColor(AppColors.information));
              }
            }
          }
        }).catchError((onError) async {
          setState(() {
            isCalling = false;
          });
          print('printing error message   ');
          ToastBuilder().showSnackBar(
              onError.toString(), sctx, HexColor(AppColors.information));
        });
      } else
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("login_password_empty"),
            sctx,
            HexColor(AppColors.information));
    } else
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context)!.translate("login_username_empty"),
          sctx,
          HexColor(AppColors.information));
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // _getCurrentLocation();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      prefs!.setString("fcmId", token!);
      getDeviceDetails(prefs);
    });
  }

/*  _getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData.latitude.toString() +
        "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    if (_locationData != null) {
      prefs.setDouble("lat", _locationData.latitude);
      prefs.setDouble("longi", _locationData.longitude);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    setSharedPreferences();
    final emailField = Form(
      child: TextFormField(
        controller: emailController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
          fontWeight: FontWeight.w900,
          color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
            hintText: AppLocalizations.of(context)!.translate('email'),
            hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack35)
            ),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0.h),
                child: Icon(
                  Icons.email,
                  color: HexColor(AppColors.appColorGrey500),
                  size: 20.w,
                )),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0.w,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String? value) {},
      ),
    );
    final passwordField = TextField(
      obscureText: true,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          fontWeight: FontWeight.w900,
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: passwordTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0.w, 15.0.h, 8.0.w, 15.0.h),
          hintText: Strings.input_pass,
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack35)
          ),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.w),
              child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500))),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.w,
            ),
          )),
    );
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: appAppBar().getCustomAppBar(context, appBarTitle: '',
                onBackButtonPress: () {
              Navigator.pop(context);
            }),
            body: new Builder(builder: (BuildContext context) {
              this.sctx = context;
              return new Center(
                child: SingleChildScrollView(
                  child: Container(
                    // margin: EdgeInsets.only(top: 72.h),
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Container(
                          alignment: Alignment(0, -0.6),
                          child: Image.asset("assets/appimages/logo.png",
                              height: 150.w, width: 200.w)),

                      Container(
                        child: Text(
                          AppLocalizations.of(context)!.translate("sign_in"),
                          style: styleElements.headline5ThemeScalable(context),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 50.h,
                                left: 30.w,
                                right: 30.w,
                                bottom: 15.h),
                            // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                            child: emailField,
                            width: screenWidth,
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 15.h,
                                left: 30.w,
                                right: 30.w,
                                bottom: 15.h),
                            // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                            child: passwordField,
                            width: screenWidth,
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/recover_password');
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  top: 8.h, bottom: 16.h, right: 32.w),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("forgot_pass"),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                        color: HexColor(AppColors.appMainColor)),
                              ))),
                      !isCalling
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: Center(
                                child: appElevatedButton(
                                  onPressed: () {
                                    login();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("log_in"),
                                        style: styleElements
                                            .subtitle2ThemeScalable(context)
                                            .copyWith(
                                                color: HexColor(AppColors.appColorWhite),
                                                fontSize: 14.sp),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            ),
                      /*  Container(
                        margin: EdgeInsets.only(top: 16.h, bottom: 16.h),
                        child: Text(
                          AppLocalizations.of(context).translate("static_or"),
                          style: styleElements.bodyText2ThemeScalable(context),
                        )),
                    GestureDetector(
                      onTap: () {
                        _handleSignIn();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4, top: 8),
                        child: Facebookbutton(
                            name: AppLocalizations.of(context)
                                .translate("google_in")),
                      ),
                    ),*/
                    ]),
                  ),
                ),
              );
            })));
  }



  void getPersonProfile(BuildContext context) async {
    final body = jsonEncode({"person_id": null});
    setState(() {
      isCalling = true;
    });
    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        setState(() {
          isCalling = false;
        });
        if (this.mounted) {
          setState(() async {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              setState(() {
                isCalling = false;
              });
              Persondata? persondata = data.rows;
              DataSaveUtils().saveUserData(prefs, persondata);
              if(data.rows!.firstName !=null && data.rows!.firstName!.isNotEmpty) {
                if (data.rows!.institutions != null &&
                    data.rows!.institutions!.isNotEmpty &&
                    isProfileCreated(data.rows!.institutions!)) {
                  prefs!.setBool("isProfileCreated", true);
                  prefs!.setBool("isProfileUpdated", true);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                          (Route<dynamic> route) => false);
                }
                else {
                  if (data.rows!.firstName != null)
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => WelComeScreen()),
                            (Route<dynamic> route) => false);
                }
              }else{
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                        (Route<dynamic> route) => false);
              }
            }
          });
        }
      }
    }).catchError((onError) async {
      setState(() {
        isCalling = false;
      });
      print(onError.toString());

    });
  }

  bool isProfileCreated(List<Institutions> institutions) {
    for (var item in institutions) {
      if (item.personType == "T" ||
          item.personType == "S" ||
          item.personType == "P" ||
          item.personType == "L") {
        return true;
      }
    }
    return false;
  }
}
