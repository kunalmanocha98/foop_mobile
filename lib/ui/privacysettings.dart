import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/enums/DictionaryType.dart';
import 'package:oho_works_app/models/disctionarylist.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/settignsView.dart';
import 'package:oho_works_app/models/settingsUpdate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/buttonTapNotifier.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PrivacySettingsPage extends StatefulWidget {
  String type;
int? rowId;
  _PrivacySettingsPage createState() => _PrivacySettingsPage(type,rowId);

  PrivacySettingsPage(this.type,this.rowId);
}

class _PrivacySettingsPage extends State<PrivacySettingsPage> {
  bool isLoading=false;
  late SharedPreferences prefs;
  List<DictionaryListItem>? listRules = [];
  String type;
  int? rowId;
  _PrivacySettingsPage(this.type,this.rowId);
  PrivacySettingsView settingsView = PrivacySettingsView();
  ButtonTapManager buttonTapManager = ButtonTapManager();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  @override
  initState() {
    super.initState();
    // application.onLocaleChanged = onLocaleChange;
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchSettings());
  }

  void fetchSettings() async {
    setState(() {
      isLoading=true;
    });
    prefs = await SharedPreferences.getInstance();

    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.PRIVACYSETTINGSVIEW).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {
        var data = PrivacySettingsView.fromJson(value);
        // if (this.mounted){
        //   setState(() {
        settingsView = data;
        getList();
        // });
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
  late TextStyleElements styleElements;

  Widget build(BuildContext context) {
    setSharedPreferences();
    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar:appAppBar().getCustomAppBar(context, appBarTitle: getAppBarTitle(), onBackButtonPress: (){
          Navigator.pop(context);
        }),
        body:  isLoading?    PreloadingView(
            url: "assets/appimages/settings.png"): Stack(
          children: <Widget>[
            ListView.builder(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                itemCount: listRules!.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.all(8),
                    title: Text(
                      listRules![index].description!,
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                    value: listRules![index].isSelected,
                    onChanged: (val) {
                      if (this.mounted) {
                        setState(() {
                          if (listRules![index].isSelected!) {
                            listRules![index].isSelected = false;
                          } else {
                            listRules![index].isSelected = true;
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
                        child: appProgressButton(
                          key: progressButtonKey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            update();
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context)!.translate("save_exit"),
                              style: styleElements.buttonThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
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
    final body =
    jsonEncode({"type":type==DictionaryType.profile_visible_to.name?DictionaryType.profile_visible_to.name: DictionaryType.user_privacy_visible_to.name});
    Calls().call(body, context, Config.DICTIONARYLIST).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {

        var data = DictionaryListResponse.fromJson(value);
        if (this.mounted) {
          setState(() {
            listRules = checkData(data.rows);
            for (int i = 0; i < listRules!.length; i++) {
              if (listRules![i].isSelected == null) {
                listRules![i].isSelected = false;
              }
            }
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));
      setState(() {
        isLoading=false;
      });
    });
  }

  List<DictionaryListItem>? checkData(List<DictionaryListItem>? rows) {
    if (type == DictionaryType.goals_objectivies_visible_to.name) {
      for (DictionaryListItem item in rows!) {
        for (DictionaryListItem item1
            in settingsView.rows!.goalsObjectiviesVisibleTo!)
          if (item1.code == item.code) {
            item.isSelected = true;
          }
      }
      return rows;
    } else if (type == DictionaryType.rating_by.name) {
      for (DictionaryListItem item in rows!) {
        for (DictionaryListItem item1 in settingsView.rows!.ratingBy!)
          if (item1.code == item.code) {
            item.isSelected = true;
          }
      }
      return rows;
    } else {
      for (DictionaryListItem item in rows!) {
        for (DictionaryListItem item1 in settingsView.rows!.ratingVisibleTo!)
          if (item1.code == item.code) {
            item.isSelected = true;
          }
      }
      return rows;
    }
  }

  void update() async {
    progressButtonKey.currentState!.show();
    PrivacySettingUpdateRequest model = PrivacySettingUpdateRequest();
    model.personId = prefs.getInt("userId");
    model.id = rowId;
    if (type == DictionaryType.posting_by.name) {
      model.postBy = getData();
    } else if (type == DictionaryType.goals_objectivies_visible_to.name) {
      model.goalsObjectiviesVisibleTo = getData();
    } else if (type == DictionaryType.network_type.name) {
      model.networkType = getData()[0];
    } else if (type == DictionaryType.post_visible_to.name) {
      model.postVisibleTo = getData();
    } else if (type == DictionaryType.rating_by.name) {
      model.ratingBy = getData();
    } else if (type == DictionaryType.user_privacy_visible_to.name) {
      model.goalsObjectiviesVisibleTo = getData();
    } else if (type == DictionaryType.rating_visible_to.name) {
      model.ratingVisibleTo = getData();
    }
    else if (type == DictionaryType.profile_visible_to.name) {
      model.profileVisibleTo = getData();
    }
    var body = jsonEncode(model);
    Calls().call(body, context, Config.UPDATEPRIVACYSETTINGS).then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.rows != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.success));
          Navigator.pop(context);
        }
      }
    }).catchError((onError) async {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));
    });
  }

  List<String?> getData() {
    List<String?> list = [];
    for (int i = 0; i < listRules!.length; i++) {
      if (listRules![i].isSelected!) {
        list.add(listRules![i].code);
      }
    }
    return list;
  }

  String getAppBarTitle() {
    if (type == DictionaryType.rating_by.name) {
      return AppLocalizations.of(context)!.translate("who_can_rate");
    } else if (type == DictionaryType.goals_objectivies_visible_to.name) {
      return AppLocalizations.of(context)!.translate("who_can_see_goals");
    } else if (type == DictionaryType.rating_visible_to.name) {
      return AppLocalizations.of(context)!.translate("who_can_see_rating");
    }
    else if (type == DictionaryType.profile_visible_to.name) {
      return AppLocalizations.of(context)!.translate("who_can_view_profile");
    }


    else {
      return "Select options";
    }
  }
}
