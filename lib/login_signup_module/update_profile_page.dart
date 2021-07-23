import 'dart:async';
import 'dart:convert';
import 'dart:convert' show json;

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/api_calls/sign_up_api.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/device_info.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/profileEditRequest.dart';
import 'package:oho_works_app/models/register_user_payload.dart';
import 'package:oho_works_app/regisration_module/select_language.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/camera_module/photo_preview_screen.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePage createState() => new _UpdateProfilePage();
}

class _UpdateProfilePage extends State<UpdateProfilePage>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  bool isTermAndConditionAccepted = false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;

  // GoogleSignInAccount _currentUser;
  double startPos = -1.0;
  double endPos = 1.0;
  bool isCalling = false;
  Curve curve = Curves.elasticOut;
  String? selectedImage;

  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final instituteName = TextEditingController();
  final relationShip = TextEditingController();
  final location = TextEditingController();
  final teacherCount = TextEditingController();
  final studentCount = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  late BuildContext context;
  BuildContext? stx;
  late TextStyleElements styleElements;

  TextStyleElements? tsE;
  FocusNode _focus = new FocusNode();
  String selectedDate = 'Date Of Birth*';
  int? selectedGender;
  int? selectedEpoch;
  var items = ['Male', 'Female', 'Transgender'];
  SharedPreferences? prefs;

  String? studentType;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool("isProfileUpdated", false);
    if (prefs != null && prefs!.getString("imageUrl") != null) {
      setState(() {
        imageUrl = prefs!.getString("imageUrl");
      });
    }
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    if (_focus.hasFocus) _selectDate(context);
  }

  // ignore: missing_return

  Future<void> _selectDate(BuildContext context) async {
    // var newDate;

    // newDate = new DateTime(
    //     DateTime.now().year - 4, DateTime.now().month, DateTime.now().day);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        builder: (BuildContext context, Widget? child) {
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
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        lastDate: DateTime.now());
    if (picked != null) {
      var diff = DateTime.now().year - picked.year;
      if (diff >= 4) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          selectedEpoch = picked.millisecondsSinceEpoch;
          selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        });
      }else{
        ToastBuilder().showToast('You should be minimum 4 years old.', stx, HexColor(AppColors.information));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    _focus.addListener(_onFocusChange);

    tsE = TextStyleElements(context);

    final dob = GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: Container(
            padding: EdgeInsets.all(16.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: HexColor(AppColors.appColorGrey500),
                  width: 1.0.w,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedDate != "Date Of Birth*"
                      ? DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(selectedDate))
                      : "Date Of Birth*",
                  textAlign: TextAlign.left,
                  style: selectedDate != "Date Of Birth*"?
                  styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(fontSize: 14.sp)
                      :styleElements
                      .bodyText2ThemeScalable(context)
                      .copyWith(fontSize: 14.sp),
                ))));

    final firstName = TextField(
      controller: firstNameController,
      keyboardType: TextInputType.text,
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp(
          "[a-z,A-Z,]",
        )),
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          firstNameController.text = text.toUpperCase();
          firstNameController.selection = TextSelection.fromPosition(
              TextPosition(offset: firstNameController.text.length));
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('first_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp,color: HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(
                Icons.person,
                color: HexColor(AppColors.appColorGrey500),
                size: 20.h,
              )),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.h,
            ),
          )),
    );
    final lastName = TextField(
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        controller: lastNameController,
        inputFormatters: [
          new FilteringTextInputFormatter.allow(RegExp(
            "[a-z,A-Z]",
          )),
          FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
        ],
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            lastNameController.text = text.toUpperCase();
            lastNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameController.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('last_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp,
          color: HexColor(AppColors.appColorBlack35)),
        ));

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: new Builder(builder: (BuildContext context) {
              this.stx = context;
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 12.h, top: 50),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("update_profile"),
                                style: styleElements
                                    .headline5ThemeScalable(context)
                                    .copyWith(fontSize: 24.sp),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                margin: EdgeInsets.all(4.h),
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("update_profile_text"),
                                  style: styleElements
                                      .bodyText2ThemeScalable(context),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoPreviewScreen(
                                          registerUserAs: null, from: null),
                                    ));

                                if (result != null) {
                                  if (result["imageUrl"] != null)
                                    imageUrl = result["imageUrl"];
                                  if (result["selectPath"] != null)
                                    selectedImage = result["selectPath"];
                                  setState(() {});
                                }
                              },
                              child: Container(
                                alignment: Alignment(0, 0.1),
                                child: Container(
                                    margin: EdgeInsets.only(top: 25.h),
                                    child: Container(
                                      width: 96.w,
                                      height: 96.w,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 96.w,
                                            height: 96.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: HexColor(
                                                  AppColors.appColorWhite),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      Utility().getUrlForImage(
                                                          imageUrl,
                                                          RESOLUTION_TYPE
                                                              .R128,
                                                          SERVICE_TYPE
                                                              .PERSON)),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0, right: 4.0),
                                            child: Align(
                                                alignment:
                                                Alignment.bottomRight,
                                                child: Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                )),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: firstName,
                                    )),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: lastName,
                                    ))
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  padding:
                                  EdgeInsets.only(left: 8.h, right: 8.0.h),
                                  child: dob),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 16.h,
                                      right: 8.0.h,
                                      top: 16.0,
                                      bottom: 8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("select_gender"),
                                    style: styleElements
                                        .bodyText2ThemeScalable(context)
                                        .copyWith(fontSize: 14.sp),
                                  )),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      focusColor:
                                      HexColor(AppColors.appColorBlack35),
                                      onTap: () {
                                        setState(() {
                                          selectedGender = 1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Column(
                                          children: [
                                            Image(
                                              width: 30,
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/appimages/man.png'),
                                            ),
                                            Opacity(
                                                opacity:
                                                selectedGender != null &&
                                                    selectedGender == 1
                                                    ? 1.0
                                                    : 0.0,
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  color: HexColor(
                                                      AppColors.appColorGreen),
                                                  size: 15,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      focusColor:
                                      HexColor(AppColors.appColorBlack35),
                                      onTap: () {
                                        setState(() {
                                          selectedGender = 2;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Column(
                                          children: [
                                            Image(
                                              width: 30,
                                              height: 30,
                                              image: AssetImage(
                                                  'assets/appimages/woman.png'),
                                            ),
                                            Opacity(
                                                opacity:
                                                selectedGender != null &&
                                                    selectedGender == 2
                                                    ? 1.0
                                                    : 0.0,
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  color: HexColor(
                                                      AppColors.appColorGreen),
                                                  size: 15,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        focusColor:
                                        HexColor(AppColors.appColorBlack35),
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 3;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Column(
                                            children: [
                                              Image(
                                                width: 30,
                                                height: 30,
                                                image: AssetImage(
                                                    'assets/appimages/bigender.png'),
                                              ),
                                              Opacity(
                                                  opacity: selectedGender !=
                                                      null &&
                                                      selectedGender == 3
                                                      ? 1.0
                                                      : 0.0,
                                                  child: Icon(
                                                    Icons.check_circle_outline,
                                                    color: HexColor(AppColors
                                                        .appColorGreen),
                                                    size: 15,
                                                  ))
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            !isCalling
                                ? Container(
                                margin:
                                EdgeInsets.only(bottom: 4.h, top: 4.h),
                                alignment: Alignment(0.w, 0.3.w),
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  alignment: Alignment(0, 0.4),
                                  child: LargeButton(
                                    name: AppLocalizations.of(context)!
                                        .translate("proceed"),
                                    offsetX: 96.66.w,
                                    offsetY: 12.93.w,
                                    callback: () {
                                      if (imageUrl != null) {
                                        _profileUpdate();
                                      } else
                                        ToastBuilder().showToast(
                                            AppLocalizations.of(context)!
                                                .translate("upload_image_"),
                                            context,
                                            HexColor(
                                                AppColors.information));
                                    },
                                  ),
                                ))
                                : Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })));
  }

  // ignore: missing_return

  _profileUpdate() async {
    ProfileEditPayload payload = ProfileEditPayload();
    if (firstNameController.text != null && firstNameController.text != "") {
      if (lastNameController.text != null && lastNameController.text != "") {
        if (selectedDate != null && selectedDate != "Date Of Birth*") {
          if (selectedGender != null) {
            payload.firstName = firstNameController.text;
            payload.lastName = lastNameController.text;
            payload.gender = selectedGender;
            payload.dateOfBirth = selectedDate;
            // payload.lastName = "";
            var data = jsonEncode(payload);
            setState(() {
              isCalling = true;
            });
            Calls().call(data, context, Config.PROFILEEDIT).then((value) async {
              DynamicResponse resposne = DynamicResponse.fromJson(value);
              setState(() {
                isCalling = false;
              });
              if (resposne.statusCode == Strings.success_code) {
                prefs!.setBool("isProfileUpdated", true);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => WelComeScreen()),
                        (Route<dynamic> route) => false);
              } else {
                ToastBuilder().showToast(
                    resposne.message!, context, HexColor(AppColors.information));
              }
            }).catchError((onError) async {
              setState(() {
                isCalling = false;
              });

              ToastBuilder().showToast(
                  onError.toString(), context, HexColor(AppColors.information));
            });
          } else {
            ToastBuilder().showToast(
                AppLocalizations.of(context)!.translate("gender_required"),
                context,
                HexColor(AppColors.information));
          }
        } else {
          ToastBuilder().showSnackBar(
              AppLocalizations.of(context)!.translate("dob_required"),
              stx!,
              HexColor(AppColors.information));
        }
      } else {
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("last_name_required"),
            stx!,
            HexColor(AppColors.information));
      }
    } else {
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context)!.translate("first_name_required"),
          stx!,
          HexColor(AppColors.information));
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
      DeviceInfo deviceInfo = DeviceInfo();
      if (prefs!.getString("DeviceInfo") != null) {
        Map<String, dynamic> map =
        json.decode(prefs!.getString("DeviceInfo") ?? "");
        deviceInfo = DeviceInfo.fromJson(map);
      }

      if (prefs!.getDouble("lat") != null)
        deviceInfo.gpsInfo = "Latitude :" +
            prefs!.getDouble("lat").toString() +
            ", Longitude : " +
            prefs!.getDouble("longi").toString();
      deviceInfo.fcmId = prefs!.getString("fcmId");

      SignUpApi()
          .activate(jsonEncode(registerUserPayload.toJson()), context,
          jsonEncode(deviceInfo))
          .then((value) async {
        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            if (data.message != null && data.message != "Invalid OTP") {
              if (data.message != null)
                await prefs!.setString('expiry', data.rows!.expiry ?? "");
              await prefs!.setString('token', data.rows!.token ?? "");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SelectLanguage(true)),
                      (Route<dynamic> route) => false);
            } else {
              if (data.message != null)
                ToastBuilder().showSnackBar(
                    data.message!, stx!, HexColor(AppColors.information));
            }
          } else {
            setState(() {
              isCalling = false;
            });
            if (data.message != null)
              ToastBuilder().showSnackBar(
                  data.message!, stx!, HexColor(AppColors.information));
            else
              ToastBuilder().showSnackBar(
                  AppLocalizations.of(context)!.translate("try_again"),
                  stx!,
                  HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        setState(() {
          isCalling = false;
        });
        print(onError.toString());
        ToastBuilder()
            .showSnackBar(onError.toString(), stx!, HexColor(AppColors.failure));
      });
    } else {
      ToastBuilder().showSnackBar(
          AppLocalizations.of(context)!.translate("enter_token"),
          stx!,
          HexColor(AppColors.information));
    }
  }
}
