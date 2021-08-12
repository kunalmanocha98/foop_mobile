import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/login_signup_module/update_profile_page.dart';
import 'package:oho_works_app/models/app_update.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/confirm_details_institute.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/contact_detail_institute_page.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/domain.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/institute_location_page.dart';
import 'package:oho_works_app/ui/dashboardhomepage.dart';
import 'package:oho_works_app/ui/dialogs/app_update_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:oho_works_app/utils/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'guided_screens.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = HexColor(AppColors.appColorWhite);

  // final TextStyle styleTextUnderTheLoader = TextStyle(
  //     fontSize: 18.0, fontWeight: FontWeight.bold, color: HexColor(AppColors.appColorBlack));

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
  BuildContext? ctx;
  late TextStyleElements styleElements;

  Future<void> navigationPage(BuildContext context) async {


    prefs = await SharedPreferences.getInstance();
    prefs.remove(Strings.current_event);
    if (prefs.getString("token") != null) {
      if (prefs.getBool("isProfileCreated") != null &&
          prefs.getBool("isProfileCreated")!) {
        if (prefs.getString("create_entity") == "ConfirmDetails") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => ConfirmDetails(
                      instId: prefs.getInt("createdSchoolId"),
                      fromPage: "registration")),
                  (Route<dynamic> route) => false);
        }
        else if (prefs.getString("create_entity") == "Address") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => InstituteLocationAddressPage(
                      instId:  prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        }
        else if (prefs.getString("create_entity") == "Contact") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => ContactsDetailsPageInstitute(
                      instId: prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        }
        else if (prefs.getString("create_entity") == "Domain") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) =>
                      DomainPage(instId: prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        }
        else if (prefs.getString("create_entity") == "created") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => WelComeScreen()),
                  (Route<dynamic> route) => false);
        } else if (prefs.getBool("isProfileUpdated") != null &&
            !prefs.getBool("isProfileUpdated")!) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                  (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => DashboardPage()),
                  (Route<dynamic> route) => false);
        }
      } else {
        if (prefs.getString("create_entity") == "ConfirmDetails") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => ConfirmDetails(
                      instId: prefs.getInt("createdSchoolId"),
                      fromPage: "registration")),
                  (Route<dynamic> route) => false);
        } else if (prefs.getString("create_entity") == "Address") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => InstituteLocationAddressPage(
                      instId:  prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        } else if (prefs.getString("create_entity") == "Contact") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => ContactsDetailsPageInstitute(
                      instId: prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        } else if (prefs.getString("create_entity") == "Domain") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) =>
                      DomainPage(instId: prefs.getInt("createdSchoolId"))),
                  (Route<dynamic> route) => false);
        } else if (prefs.getString("create_entity") == "created") {
          print(
              ":++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => WelComeScreen()),
                  (Route<dynamic> route) => false);
        } else if (prefs.getBool("isProfileUpdated") != null &&
            !prefs.getBool("isProfileUpdated")!) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                  (Route<dynamic> route) => false);
        } else {
          print(
              ":ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => WelComeScreen()),
                  (Route<dynamic> route) => false);
        }
      }
    } else {
      if (prefs.getBool("isLogout") != null && prefs.getBool("isLogout")!) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => Home()),
                (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => OnBoarding()),
                (Route<dynamic> route) => false);
      }
    }
  }

  void setSharedPreferences() async {
    var status = await Permission.contacts.status;
    prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () {
      checkUpdate();
      // navigationPage(context);
    });
  }

  void checkUpdate() async {
    var packageInfo = await PackageInfo.fromPlatform();
    Calls().call(jsonEncode({}), context, Config.APP_UPDATE).then((value) {
      var response = AppUpdateResponse.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        log(response.rows!.toJson().toString());
        checkVersion(packageInfo, response.rows);
      } else {

        navigationPage(context);
      }
    }).catchError((onError) {
      log(onError.toString());
      navigationPage(context);
    });
  }

  void checkVersion(PackageInfo packageInfo, AppUpdateModel? model) {
    try {
      log("**** AppName ****");
      log("**** PackageName ****" + packageInfo.packageName);
      log("**** BuildNumber ****" + packageInfo.buildNumber);
      log("**** Version ****" + packageInfo.version);
      var currentVersion = Version(packageInfo.version);
      var versionFromServer = Version(
          Platform.isAndroid ? model!.androidBuildNumber! : model!.iosBuildNumber!);
      if (Platform.isAndroid) {
        if (needsUpdate(currentVersion, versionFromServer)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AppUpdateDialog(
                  showCancelButton: !model.isAndroidForceUpdate!,
                  // note: model.androidNotes,
                  note: model.androidNotes,
                  cancelButton: () {
                    navigationPage(context);
                  },
                  updateButton: () {
                    try {
                      launch("market://details?id=" + packageInfo.packageName);
                    } on PlatformException catch (e) {
                      print(e);
                      launch("https://play.google.com/store/apps/details?id=" +
                          packageInfo.packageName);
                    } finally {
                      launch("https://play.google.com/store/apps/details?id=" +
                          packageInfo.packageName);
                    }
                  },
                );
              });
        } else {
          navigationPage(context);
        }
      } else if (Platform.isIOS) {
        if (needsUpdate(currentVersion, versionFromServer)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AppUpdateDialog(
                  showCancelButton: !model.isIosForceUpdate!,
                  note: model.iosNotes,
                  cancelButton: () {
                    navigationPage(context);
                  },
                  updateButton: () {
                    try {
                      launch(
                          "https://apps.apple.com/us/app/tricycle/id1549493904");
                    } on PlatformException catch (e) {
                      print(e);
                      launch(
                          "https://apps.apple.com/us/app/tricycle/id1549493904");
                    } finally {
                      launch(
                          "https://apps.apple.com/us/app/tricycle/id1549493904");
                    }
                  },
                );
              });
        } else {
          navigationPage(context);
        }
      }
    } catch (error) {
      navigationPage(context);
      print(error.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.ctx = context;
    Utility().screenUtilInit(context);
    styleElements = TextStyleElements(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(AppColors.appColorWhite),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image(
                        image: AssetImage('assets/appimages/india.png'),
                      )),
                  Text(
                    AppLocalizations.of(context)!
                        .translate('handcrafted_in_india'),
                    style: styleElements.captionThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appColorBlack85),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(

                            child: Center(
                              child: Container(
                                height: 60.w,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/appimages/logo.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: null /* add child content here */,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0.h),
                          ),
                        ],
                      )),

                  Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    alignment: Alignment(0, -0.76),
                    child: Text(
                      AppLocalizations.of(context)!.translate("logo_slogan"),
                      style: styleElements
                          .bodyText1ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appColorBlack85)),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  bool needsUpdate(Version currentVersion, Version versionFromServer) {
    if (currentVersion.major! < versionFromServer.major!) {
      print('here--dgdsgsg--');
      return true;
    } else if (currentVersion.major == versionFromServer.major) {
      if (currentVersion.minor! < versionFromServer.minor!) {
        print('here--dgfdg--');
        return true;
      } else if (currentVersion.minor == versionFromServer.minor) {
        if(currentVersion.patch<versionFromServer.patch){
          print('here-sdgsafdgsfd---');
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    } else {
      return false;
    }
  }
}
