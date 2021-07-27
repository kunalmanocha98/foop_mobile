import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/application.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../ui/dashboardhomepage.dart';

// ignore: must_be_immutable
class SelectLanguage extends StatefulWidget {
  bool isSignUp = false;

  _SelectLanguage createState() => _SelectLanguage(isSignUp);

  SelectLanguage(this.isSignUp);
}

class _SelectLanguage extends State<SelectLanguage> {

  bool isSignUp;
  bool isCalled = false;
  SharedPreferences? prefs;
  List<LanguageItem>? listRules = [];

  @override
  initState() {
    super.initState();

    application.onLocaleChanged = onLocaleChange;
    WidgetsBinding.instance!.addPostFrameCallback((_) => getList());
  }

  void onLocaleChange(Locale locale) {
    if (this.mounted) {
      setState(() {});
    }
  }
late BuildContext sctx;
  final body = jsonEncode({
    "conversationOwnerId": '1580807502972',
    "conversationOwnerType": 'personal',
    "businessId": '145274578',
    "registeredUserId": '145274578',
    "pageNo": 0,
    "pageNumber": 1,
    "pageSize": 5
  });

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
  late TextStyleElements styleElements;
  Widget build(BuildContext context) {
    setSharedPreferences();
    styleElements = TextStyleElements(context);

    return
     SafeArea(child:  Scaffold(
       resizeToAvoidBottomInset: false,
       backgroundColor: HexColor(AppColors.appColorBackground),
       // AppLocalizations.of(context).translate("language")
       appBar: appAppBar().getCustomAppBar(context,
           appBarTitle: AppLocalizations.of(context)!.translate("language"),
           onBackButtonPress: (){_onBackPressed();},
         ),
       body:
       new Builder(builder: (BuildContext context) {
         this.sctx = context;
         return new   Stack(
           children: <Widget>[
             listRules!=null && listRules!.length!=0 ? ListView.builder(
                 padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                 itemCount: listRules!.length,
                 itemBuilder: (BuildContext context, int index) {
                   return CheckboxListTile(
                     checkColor: HexColor(AppColors.appColorWhite),
                     activeColor: HexColor(AppColors.appMainColor),
                     title: Text(listRules![index].languageNameLocal! +
                         " (" +
                         listRules![index].languageName! +
                         ")",

                         style: styleElements.subtitle1ThemeScalable(context)
                     ),
                     value: listRules![index].isSelected,
                     onChanged: (val) {
                       if (this.mounted) {
                         setState(() {
                           if (listRules![index].languageName == "Hindi") {
                             prefs!.setString('language_code', "hi");
                             prefs!.setString('country_code', "IN");
                             changeLanguage("hi", "IN");
                           } else if (listRules![index].languageName == "English") {
                             prefs!.setString('language_code', "en");
                             prefs!.setString('country_code', "US");
                             changeLanguage("en", "US");
                           }

                           for (int i = 0; i < listRules!.length; i++) {
                             if (index == i) {
                               listRules![index].isSelected = val;
                             } else {
                               listRules![i].isSelected = false;
                             }
                           }
                         });
                       }
                     },
                   );
                 }):Center(child: CircularProgressIndicator()),
             Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                   height: 60,
                   color: HexColor(AppColors.appColorWhite),
                   child: Align(
                       alignment: Alignment.centerRight,
                       child: Container(
                         margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                         child: appElevatedButton(
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(18.0),
                               side: BorderSide(color: HexColor(AppColors.appMainColor))),
                           onPressed: () {
                             if (isSignUp) {
                               if (getSelectedItem()) {
                                 Navigator.of(context).pushAndRemoveUntil(
                                     MaterialPageRoute(
                                         builder: (context) => WelComeScreen()),
                                         (Route<dynamic> route) => false);
                               } else {
                                 ToastBuilder()
                                     .showSnackBar("Please select language", sctx,HexColor(AppColors.information));
                               }
                             } else {
                               if (prefs!.getString("token") != null &&
                                   prefs!.getString("token") != "") {
                                 prefs!.setBool("isProfileCreated",true);
                                 Navigator.of(context).pushAndRemoveUntil(
                                     MaterialPageRoute(
                                         builder: (context) => DashboardPage()),
                                         (Route<dynamic> route) => false);
                               } else {
                                 Navigator.of(context).pushAndRemoveUntil(
                                     MaterialPageRoute(
                                         builder: (context) => WelComeScreen()),
                                         (Route<dynamic> route) => false);
                               }
                             }
                           },
                           color: HexColor(AppColors.appColorWhite),
                           child: Text(
                               AppLocalizations.of(context)!.translate("next"),
                               style: styleElements.buttonThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
                         ),
                       )),
                 ))
           ],
         );
       })

     ,
     ))
     ;
  }

  bool getSelectedItem() {
    bool itemSelected = false;
    for (var item in listRules!) {
      if (item.isSelected!) {
        itemSelected = true;
      }
    }
    return itemSelected;
  }

  void getList() async {
    prefs = await SharedPreferences.getInstance();

    if (isSignUp && prefs != null)
      prefs!.setBool("isProfileCreated", false);
    final body = jsonEncode({});
    Calls().call(body, context, Config.LANGUAGE_LIST).then((value) async {

      if (value != null) {

        var data = LanguageList.fromJson(value);

        if (this.mounted) {
          setState(() {
            listRules = data.rows;
            for (int i = 0; i < listRules!.length; i++) {
              if (listRules![i].languageName!.isNotEmpty &&
                  listRules![i].languageName == "English")
                listRules![i].isSelected = true;
              else
                listRules![i].isSelected = false;
            }
          });
        }
      }
    }).catchError((onError) {
      ToastBuilder().showSnackBar(onError.toString(), sctx,HexColor(AppColors.information));

    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
                AppLocalizations.of(context)!.translate('are_you_sure')),
            content: new Text(
                AppLocalizations.of(context)!.translate('exit_app')),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.translate('no')),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(AppLocalizations.of(context)!.translate('yes')),
              ),
            ],
          ),
        ).then((value) => value as bool);
  }

  void changeLanguage(String code, String countryCode) {
    var local = Locale(code, countryCode);
    MainApp.setLocale(context, local);
  }

  _SelectLanguage(this.isSignUp);
}
