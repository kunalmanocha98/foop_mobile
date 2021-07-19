import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/ui/dashboardhomepage.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TextStyles/TextStyleElements.dart';
import 'app_localization.dart';
import 'colors.dart';
import 'hexColors.dart';

// ignore: must_be_immutable
class CustomDialogue extends StatelessWidget {
  String title;
  String subtitle;
  SharedPreferences prefs;
  String type;
  bool  isVerified;
  TextStyleElements styleElements;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  CustomDialogue({
    Key key,
    @required this.type,
    @required this.title,
    @required this.subtitle,
    @required this.isVerified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setSharedPreferences();
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 50),
                    child: Text(
                      AppLocalizations.of(context).translate("congratulations"),
                      style: styleElements.headline5ThemeScalable(context),
                    ),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Image(
                        image: AssetImage('assets/appimages/handshake.png'),
                        fit: BoxFit.contain,
                        width: 78,
                        height: 78,
                      )),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, top: 30),
                    child: Text(
                      title,
                      style: styleElements.subtitle1ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      subtitle,
                      style: styleElements.subtitle2ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),

              Visibility(
                visible: !isVerified,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        AppLocalizations.of(context).translate("non_verified_person"),
                        style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),


              Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: TricycleElevatedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: HexColor(AppColors.appColorGreen))),
                      onPressed: () {
                        prefs.setString("create_institute", "successFullyCreated");
                        prefs.setBool("isProfileCreated",true);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => UserProfileCards(
                                  userType: "person",
                                    userId: null,
                                    isFromRegisration:true,
                                    type: type, currentPosition: 1)),
                            (Route<dynamic> route) => false);
                      },
                      color: HexColor(AppColors.appColorGreen),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("continueWithProfileSettings"),
                        style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 20),
                child: SizedBox(
                    width: double.infinity,
                    child: TricycleElevatedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: HexColor(AppColors.appMainColor))),
                      onPressed: () {
                        prefs.setString("create_institute", "successFullyCreated");
                        prefs.setBool("isProfileCreated",true);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                            (Route<dynamic> route) => false);
                      },
                      color: HexColor(AppColors.appMainColor),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("take_me_to_home"),
                        style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
                    )),
              )
            ],
          ),
        ));
  }
}
