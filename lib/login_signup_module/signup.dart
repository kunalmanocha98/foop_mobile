import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/sign_up_api.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/conversationPage/custom_web_view.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/country_code_response.dart';
import 'package:oho_works_app/models/device_info.dart';
import 'package:oho_works_app/models/register_user_payload.dart';
import 'package:oho_works_app/models/signup_success.dart';
import 'package:oho_works_app/regisration_module/select_language.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'verificationOtp.dart';


class SignUpPage extends StatefulWidget {
  @override
  StateSignUp createState() => new StateSignUp();
}

class StateSignUp extends State<SignUpPage> with SingleTickerProviderStateMixin {
  String facebookId;
  String googleSignInId;
  String userName;
  String imageUrl;
  bool isTermAndConditionAccepted= false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;
  // GoogleSignInAccount _currentUser;
  double startPos = -1.0;
  double endPos = 1.0;
  bool isCalling=false;
  Curve curve = Curves.elasticOut;
  final emailController = TextEditingController();
  final passwordTextController = TextEditingController();
  final mobileController = TextEditingController();
  var countryCodeList = [];
  var mapState = HashMap<String, String>();
  BuildContext context;
  BuildContext stx;
  TextStyleElements styleElements;
  String cCode;
  bool _validate = false;
  TextStyleElements tsE;
  FocusNode _focus = new FocusNode();
  String selectedDate = 'Date Of Birth*';
  String selectedGender;
  int selectedEpoch;
  var items = ['Male', 'Female', 'Transgender'];
  SharedPreferences prefs;



  @override
  void initState() {
    super.initState();
    getCounrtyCode();
  }


  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      prefs.setString("fcmId", token);
      getDeviceDetails(prefs);
    });
  }
  static Future<List<String>> getDeviceDetails(SharedPreferences prefs) async {
    String deviceName;
    String deviceVersion;
    String identifier;
    DeviceInfo deviceInfo;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        deviceInfo = DeviceInfo();
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        prefs.setString('UUID', build.androidId); //UUID for Android
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
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name.toString();
        deviceVersion = data.systemVersion.toString();
        prefs.setString('UUID', data.identifierForVendor.toString()); //UUID for iOS
        deviceInfo.machineCode = data.identifierForVendor.toString();
        deviceInfo.deviceInfo = data.name.toString().trim();
        deviceInfo.deviceType = "ios";
        deviceInfo.deviceVendor = data.identifierForVendor.toString();
        deviceInfo.osType = data.systemName.toString();
        deviceInfo.osVersion = data.systemVersion.toString();
        deviceInfo.applicationType = "flutter ios";
        var dataIos = jsonEncode(deviceInfo);
        prefs.setString("DeviceInfo", dataIos);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }
  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    if (_focus.hasFocus) _selectDate(context);
  }


  // ignore: missing_return

  Future<void> _selectDate(BuildContext context) async {
    var newDate;

    newDate = new DateTime(DateTime.now().year - 4, DateTime.now().month, DateTime.now().day);


    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: DateTime(1900),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HexColor(AppColors.appColorBlack),
              accentColor: HexColor(AppColors.appColorBlack),
              colorScheme: ColorScheme.dark(
                primary: HexColor(AppColors.appColorBlack),
                onPrimary: HexColor(AppColors.appColorWhite),
                surface: HexColor(AppColors.appColorWhite),
                onSurface: HexColor(AppColors.appColorBlack),
              ),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child,
          );
        },
        lastDate: newDate);
    if (picked != null)
      setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        selectedEpoch = picked.millisecondsSinceEpoch;
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    _focus.addListener(_onFocusChange);
    setSharedPreferences();
    List<DropdownMenuItem> countryCodes = [];
    _getCountryCodes() {
      for (int i = 0; i < countryCodeList.length; i++) {
        countryCodes.add(DropdownMenuItem(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                countryCodeList[i].flagIconUrl??"",
                style: styleElements.bodyText2ThemeScalable(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0),
                child: Text(
                  countryCodeList[i].dialCode,
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ],
          ),
          value: countryCodeList[i].dialCode,
        ));
      }
      return countryCodes;
    }

    tsE =TextStyleElements(context);

    final codes = DropdownButtonFormField(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(4.0.w, 15.0.h, 4.0.w, 15.0.h),

        border: InputBorder.none,

      ),
      hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(cCode ??
              AppLocalizations.of(context).translate("code"),
            style: styleElements.bodyText2ThemeScalable(context),)
      ),

      items: _getCountryCodes(),
      onChanged: (value) {
        setState(() {
          cCode = value ?? cCode;
        });
      },
    );

    final emailField = Form(
      child: TextFormField(
        controller: emailController,
        style: tsE.subtitle1ThemeScalable(context).copyWith(
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
            hintText: AppLocalizations.of(context).translate('email'),
            hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0.h),
                child: Icon(Icons.email, color: HexColor(AppColors.appColorGrey500),size: 20.w,)),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0.w,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String value) {
          email = value;
        },
      ),
    );
    final passwordField = Form(
        child: TextFormField(
          obscureText: true,
          style: tsE.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack65)
          ),
          onChanged: (v){

            setState(() {
              v.trim().length<8?_validate=false:_validate=true; return null;
            });
          },
          onSaved: (String value) {},
          controller: passwordTextController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
              hintText: AppLocalizations.of(context).translate('password'),
              errorText:!_validate?AppLocalizations.of(context).translate("min_character"):null,
              hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0.h),
                  child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500),size: 20.h)),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.0.h,
                ),
              )),
        ));
    final mobile = TextField(
      enableInteractiveSelection: false,
      obscureText: false,
      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: mobileController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
        hintText: AppLocalizations.of(context).translate('mobile_number'),
        hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),

        border: InputBorder.none,),
    );



    return new WillPopScope(
        onWillPop: _onBackPressed,
        child:
        SafeArea(
          child:Scaffold(
            // resizeToAvoidBottomInset: false,
              appBar: TricycleAppBar().getCustomAppBar(context,
                appBarTitle: '',
                onBackButtonPress: (){
                  Navigator.pop(context);
                },
              ),

              body: new Builder(builder: (BuildContext context) {
                this.stx = context;
                return new  SingleChildScrollView(
                  child: Stack(
                    children: [
                      Visibility(
                          visible: !isGoogleOrFacebookDataReceived,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Container(
                                    // margin:  EdgeInsets.only(top: 16.h),
                                      child: Image(
                                        image: AssetImage('assets/appimages/logo.png'),
                                        fit: BoxFit.contain,
                                        width: 72.w,
                                        height: 72.h,
                                      )),
                                ),
                                Container(
                                  margin:  EdgeInsets.only(bottom: 30.h),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context).translate("sign_up"),
                                    style: styleElements.headline5ThemeScalable(context)
                                        .copyWith(fontSize: 24.sp),
                                  ),
                                ),

                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 12.w, right: 12.w, top: 12.h,bottom: 8.h),
                                      child: emailField,
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 12.w, right: 12.w, top: 12.h,bottom: 2.h),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left :15.0),
                                            child: Container(
                                              child: Icon(
                                                Icons.call,
                                                color: HexColor(AppColors.appColorGrey500),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Container(
                                              child: codes,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(

                                              child: mobile,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 12.w, right: 12.w,),
                                  child: SizedBox(
                                    height: 1.0,
                                    child: new Center(
                                      child: new Container(
                                        height: 1.0,
                                        color: HexColor(AppColors.appColorBlack35),
                                      ),
                                    ),
                                  ),
                                )
                                ,
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 12.w, right: 12.w, top: 12.h,bottom: 8.h),
                                      child: passwordField,
                                    )),


                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: <Widget>[
                                          Checkbox(value: isTermAndConditionAccepted,
                                            activeColor: HexColor(AppColors.appMainColor),
                                            onChanged: (bool v){
                                              setState(() {
                                                isTermAndConditionAccepted=v;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => CustomWebView(
                                                            selectedUrl:
                                                            "https://www.tricycle.life/privacy-policy")));

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: Container(
                                                    child: new RichText(
                                                      text: new TextSpan(

                                                        style: new TextStyle(
                                                          fontSize: 10.0,
                                                          color: HexColor(AppColors.appColorBlack),
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(text: 'By registering or signing in, you agree with our'),
                                                          new TextSpan(text: 'Terms of Service, Privacy Policy & Cookie Policy',style: styleElements.overlineThemeScalable(context)
                                                              .copyWith(fontWeight:FontWeight.bold, color: HexColor(AppColors.appMainColor)),),
                                                          new TextSpan(text: 'You may receive SMS notifications from us'),



                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                !isCalling ? Container(
                                    margin:  EdgeInsets.only(bottom: 4.h, top: 4.h),
                                    alignment: Alignment(0.w, 0.3.w),
                                    child: Container(
                                      margin:  EdgeInsets.only(top: 20.h),
                                      alignment: Alignment(0, 0.4),
                                      child: LargeButton(
                                        name: "Sign Up",
                                        offsetX: 96.66.w,
                                        offsetY: 12.93.w,
                                        callback: (){
                                          if(isTermAndConditionAccepted)
                                            signUp();
                                          else
                                            ToastBuilder().showSnackBar(AppLocalizations.of(context).translate("accept_term_condition"), stx,HexColor(AppColors.information));
                                        },),
                                    )):Center(child: SizedBox(

                                    height:30,
                                    width:30,
                                    child: CircularProgressIndicator()),),



                              ],
                            ),
                          )),
                      Visibility(
                          visible: isGoogleOrFacebookDataReceived,
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment(0, 0.1),
                                child: Container(
                                  margin:  EdgeInsets.only(top: 25.h),
                                  child: Container(
                                    width: 96.w,
                                    height: 96.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor(AppColors.appMainColor),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(imageUrl ?? ""),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin:  EdgeInsets.only(
                                      left: 16.w, right: 16.w, bottom: 7.w, top: 12.w),
                                  child: Text(
                                    userName ?? "",
                                    style: styleElements.headline5ThemeScalable(context).copyWith(fontSize: 20.sp),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin:  EdgeInsets.only(
                                        left: 16.w, right: 16.w, bottom: 16.w),
                                    child: Text(AppLocalizations.of(context).translate('please_update_details'),
                                      style: styleElements.subtitle1ThemeScalable(context),
                                    ),
                                  )),
                              Visibility(
                                  visible: email == "",
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin:  EdgeInsets.only(
                                            left: 20.0.w, right: 20.0.w, top: 20.w),
                                        child: emailField,
                                      ))),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20.0.w, right: 20.0.w, top: 20.w),
                                    child: mobile,
                                  )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin:EdgeInsets.only(
                                        left: 20.0.w, right: 20.0.w, top: 20.w),
                                    child: passwordField,
                                  )),

                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: Container(
                                        margin:  EdgeInsets.only(top: 50.w),
                                        alignment: Alignment(0, 0.4),
                                        child: LargeButton(
                                          name: "Update Details",
                                          offsetX: 75.66,
                                          offsetY: 12.93,
                                          callback: (){
                                            signUp();
                                          },),
                                      ))),
                            ],
                          ))
                    ],
                  ),
                );
              }
              )),

        ));
  }

  void getCounrtyCode() async {

    final body = jsonEncode({
      "country": "IN",
    });
    Calls().calWithoutToken(body, context, Config.COUNTRY_CODES).then((value) async {
      if (value != null) {
        var data = CountryCodeResponse.fromJson(value);
        countryCodeList=data.rows;
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });

  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    if (isGoogleOrFacebookDataReceived) {
      setState(() {
        isGoogleOrFacebookDataReceived = false;
      });
    } else
      Navigator.of(context).pop(true);
  }

  void signUp() async {


    if (emailController.text.trim().isNotEmpty &&
        EditProfileMixins().validateEmail(emailController.text) == null) {
      if (passwordTextController.text.trim().isNotEmpty &&
          EditProfileMixins()
              .validatePassword(passwordTextController.text) ==
              null) {
        {
          {
            RegisterUserPayload registerUserPayload = RegisterUserPayload();
            if(mobileController.text.isNotEmpty)
            {
              if(cCode==null || cCode.isEmpty)
              {
                ToastBuilder().showSnackBar(AppLocalizations.of(context).translate("country_code"), stx,HexColor(AppColors.information));
                return;
              }
              else
                registerUserPayload.mobileCountryCode=cCode;

            }


            registerUserPayload.email = emailController.text;

            try {
              registerUserPayload.mobile = int.parse(mobileController.text);
            } catch (e) {
              print(e);
            }
            registerUserPayload.email = emailController.text;
            registerUserPayload.password = passwordTextController.text;
            print(registerUserPayload.toJson().toString());
            setState(() {
              isCalling=true;
            });
            SignUpApi()
                .signUp(jsonEncode(registerUserPayload.toJson()), context)
                .then((value) async {

              if (value != null) {
                var data = SignUpSuccess.fromJson(value);
                if (data.statusCode == Strings.success_code) {


                  if (data.rows != null) {
                    activate(int.parse((data.rows)), emailController.text);
                  } else {

                    setState(() {
                      isCalling=false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Verification(
                            email: emailController.text.toString(),
                            mobileNo:
                            mobileController.text.trim().toString(),
                            isRecoverPassword: false,
                          ),
                        ));
                  }
                }
                else {
                  setState(() {
                    isCalling=false;
                  });
                  if (data.message != null)
                    ToastBuilder().showSnackBar(data.message, stx,HexColor(AppColors.information));
                  else
                    ToastBuilder().showSnackBar(
                        AppLocalizations.of(context).translate("try_again"),
                        stx,HexColor(AppColors.information));
                }
              }
            }).catchError((onError) async {
              setState(() {
                isCalling=false;
              });
              print(onError.toString());
              ToastBuilder().showSnackBar(onError.toString(), stx,HexColor(AppColors.failure));
            });
          }
        }
      } else {
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context).translate("login_password_empty"),
            stx,HexColor(AppColors.information));
      }
    } else {
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context).translate("email_required"),
          stx,HexColor(AppColors.information));
    }


  }


  void activate(int code, String email) async {
    if (code != null) {

      RegisterUserPayload registerUserPayload = RegisterUserPayload();
      registerUserPayload.email = email;
      try {
        registerUserPayload.token = code;
      } catch (e) {
        print(e);

      }
      print(registerUserPayload.toJson().toString());
      DeviceInfo deviceInfo=DeviceInfo();
      if (prefs.getString("DeviceInfo") != null) {
        Map<String, dynamic> map =
        json.decode(prefs.getString("DeviceInfo") ?? "");
        deviceInfo = DeviceInfo.fromJson(map);
      }

      if (prefs.getDouble("lat")!= null)
        deviceInfo.gpsInfo ="Latitude :"+ prefs.getDouble("lat").toString() + ", Longitude : " + prefs.getDouble("longi").toString();
      deviceInfo.fcmId=prefs.getString("fcmId");


      SignUpApi()
          .activate(jsonEncode(registerUserPayload.toJson()), context,jsonEncode(deviceInfo))
          .then((value) async {

        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            if (data.message != null && data.message != "Invalid OTP") {
              if (data.message != null)
                await prefs.setString('expiry', data.rows.expiry ?? "");
              await prefs.setString('token', data.rows.token ?? "");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SelectLanguage(true)),
                      (Route<dynamic> route) => false);
            } else {
              if (data.message != null)
                ToastBuilder().showSnackBar(data.message, stx,HexColor(AppColors.information));
            }
          } else {
            setState(() {
              isCalling=false;
            });
            if (data.message != null)
              ToastBuilder().showSnackBar(data.message, stx,HexColor(AppColors.information));
            else
              ToastBuilder().showSnackBar(
                  AppLocalizations.of(context).translate("try_again"), stx,HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        setState(() {
          isCalling=false;
        });
        print(onError.toString());
        ToastBuilder().showSnackBar(onError.toString(), stx,HexColor(AppColors.failure));
      });
    } else {
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context).translate("enter_token"), stx,HexColor(AppColors.information));
    }
  }
}


