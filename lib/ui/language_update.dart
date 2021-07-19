import 'dart:convert';
import 'dart:developer';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/models/settignsView.dart';
import 'package:oho_works_app/models/settingsUpdate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/application.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// ignore: must_be_immutable
class UpdateLanguagePage extends StatefulWidget {
  bool isSingleSelection = false;
int rowId;
bool isTranslation=false;
  _UpdateLanguagePage createState() => _UpdateLanguagePage(isSingleSelection,rowId);

  UpdateLanguagePage(this.isSingleSelection,this.rowId,this.isTranslation);
}

class _UpdateLanguagePage extends State<UpdateLanguagePage> {

  bool isCalled = false;
  bool isLoading=false;
  String code;
  String name;
  int id;
  SharedPreferences prefs;
  List<LanguageItem> listRules = [];
  bool isSingleSelection;
  SettingsView settingsView;
  int rowId;
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  _UpdateLanguagePage(this.isSingleSelection,this.rowId);

  @override
  initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchSettings());
  }

  void onLocaleChange(Locale locale) {
    // if (this.mounted) {
    //   Navigator.pop(context);
    // }
  }

  void fetchSettings() async {
   setState(() {
     isLoading=true;
   });
    prefs = await SharedPreferences.getInstance();

    final body = jsonEncode({
      "person_id":prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.SETTINGSVIEW).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {
        var data = SettingsView.fromJson(value);
        settingsView = data;
        getList();
        // if (this.mounted){
        //   setState(() {
        //     settingsView = data;
        //   });
        // }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      setState(() {
        isLoading=false;
      });
    });
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
  TextStyleElements styleElements;
  Widget build(BuildContext context) {
    setSharedPreferences();

    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBar(
            context,
            appBarTitle:  AppLocalizations.of(context).translate("language"),
            onBackButtonPress: (){ Navigator.pop(context);}),
        body: isLoading?    PreloadingView(
            url: "assets/appimages/settings.png"):Stack(
          children: <Widget>[
            ListView.builder(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                itemCount: listRules.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.all(8),
                    // activeColor: HexColor(AppColors.appMainColor),
                    title: Text(
                      listRules[index].languageNameLocal +
                          " (" +
                          listRules[index].languageName +
                          ")",
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                    value: listRules[index].isSelected,
                    onChanged: (val) {
                      if (this.mounted) {
                        setState(() {
                          code=listRules[index].languageCode;
                          name=listRules[index].languageName;
                          id = listRules[index].id;
                          if (isSingleSelection) {
                            prefs.setString(
                                'language_code', listRules[index].languageCode);
                            prefs.setString('country_code', "IN");
                            if (listRules[index].languageName == "Hindi") {
                              prefs.setString(
                                  'language_code', listRules[index].languageCode);
                              prefs.setString('country_code', "IN");
                              // changeLanguage("hi", "IN");
                            } else if (listRules[index].languageName ==
                                "English") {
                              prefs.setString('language_code', "en");
                              prefs.setString('country_code', "US");
                              // changeLanguage("en", "US");
                            }
                            for (int i = 0; i < listRules.length; i++) {
                              if (index == i) {
                                listRules[index].isSelected = val;
                              } else {
                                listRules[i].isSelected = false;
                              }
                            }
                          } else {
                            if (listRules[index].isSelected) {
                              listRules[index].isSelected = false;
                            } else {
                              listRules[index].isSelected = true;
                            }
                          }
                        });
                      }
                    },
                  );
                }),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: HexColor(AppColors.appColorWhite),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: TricycleProgressButton(
                          key: progressButtonKey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            updateLanguage();
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context).translate("save_exit"),
                              style: styleElements.buttonThemeScalable(context).copyWith(
                                  color: HexColor(AppColors.appMainColor))),
                        ),
                      )),
                ))
          ],
        ),
      ),
    );
  }

  void getList() async {
    prefs = await SharedPreferences.getInstance();
  setState(() {
    isLoading=true;
  });

    final body = jsonEncode({});
    Calls().call(body, context, Config.LANGUAGE_LIST).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {

        var data = LanguageList.fromJson(value);

        log(jsonEncode(data));

        if (this.mounted) {
          setState(() {
            listRules = checkdata(data.rows);
            for (int i = 0; i < listRules.length; i++) {
              if (listRules[i].isSelected == null) {
                listRules[i].isSelected = false;
              }
            }
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      setState(() {
        isLoading=false;
      });
    });
  }

  List<LanguageItem> checkdata(List<LanguageItem> rows) {
    if (isSingleSelection) {
      for (LanguageItem item in rows) {
        if(widget.isTranslation) {
          if (settingsView.rows.transLateLanguage!=null &&settingsView.rows.transLateLanguage.id!=null && settingsView.rows.transLateLanguage.id == item.id) {
            code= item.languageCode;
            name = item.languageName;
            id= id;
            item.isSelected = true;
          }
        }else{
          if (settingsView.rows.language.id == item.id) {
            item.isSelected = true;
          }
        }
      }
      return rows;
    }
    else {
      for (LanguageItem item in rows) {
        for (LanguageItem item1 in settingsView.rows.contentLanguage)
          if (item1.id == item.id) {
            item.isSelected = true;
          }
      }
      return rows;
    }
  }

  void changeLanguage() {
    String code = prefs.get("language_code");
    String countryCode = prefs.get("country_code");
    var local = Locale(code, countryCode);
    MainApp.setLocale(context, local);
    Navigator.pop(context);
  }

  void updateLanguage() async {
    progressButtonKey.currentState.show();
    LanguageItemNew languageItem=LanguageItemNew();
    AccountSettingUpdateRequest model = AccountSettingUpdateRequest();
    model.personId = prefs.getInt("userId");

    model.id = rowId;
    if(widget.isTranslation)
    {
      model.id = settingsView.rows.id;
      languageItem.languageCode=code;
      languageItem.languageName=name;
      languageItem.id= id;
      model.transLateLanguage=languageItem;
    }
   else if (isSingleSelection) {
      model.languageId = getLanguageId(isSingleSelection)[0];
    } else {
      model.contentLanguageIds = getLanguageId(isSingleSelection);
    }
    var body = jsonEncode(model);
    Calls().call(body, context, Config.UPDATEACCOUNTSETTING).then((value) async {
      progressButtonKey.currentState.hide();
      if (value != null) {
        progressButtonKey.currentState.hide();
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.rows != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.information));

          if(widget.isTranslation)
            {
              prefs.setString(
                  Strings.translation_code, code);

              prefs.setBool(
                  Strings.isTranslationLanguageSet, true);


              Navigator.of(context).pop({'code': code});
            }
         else if (isSingleSelection) {
            changeLanguage();
          } else {
            Navigator.pop(context);
          }
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      print(onError.toString());
      progressButtonKey.currentState.hide();
    });
  }

  List<int> getLanguageId(bool isSingleSelection) {
    if (isSingleSelection) {
      List<int> listint = [];
      for (int j = 0; j < listRules.length; j++) {
        if (listRules[j].isSelected) {
          listint.add(listRules[j].id);
          break;
        }
      }
      return listint;
    } else {
      List<int> listint = [];
      for (int j = 0; j < listRules.length; j++) {
        if (listRules[j].isSelected) {
          listint.add(listRules[j].id);
        }
      }
      return listint;
    }
  }
}
