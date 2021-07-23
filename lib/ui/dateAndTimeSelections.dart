import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/models/dateFormatItem.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/settignsView.dart';
import 'package:oho_works_app/models/settingsUpdate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DateSelectionPage extends StatefulWidget {
  int? rowId;
  @override
  _DateSelectionPage createState() => _DateSelectionPage(rowId);

  DateSelectionPage(this.rowId);
}

class _DateSelectionPage extends State<DateSelectionPage> {
  List<DateFormatItem> dateList = [];
  SettingsView settingsView = SettingsView();
  int? rowId;
  bool isLoading=false;
  late SharedPreferences prefs;
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchSettings());
  }

  void fetchSettings() async {
    prefs = await SharedPreferences.getInstance();
 setState(() {
   isLoading=true;
 });
    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.SETTINGSVIEW).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {
        var data = SettingsView.fromJson(value);
        settingsView = data;
        getDateFormats();
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      setState(() {
        isLoading=false;
      });
    });
  }

  getDateFormats() async {
    setState(() {
      isLoading=true;
    });
    final body = jsonEncode({});
    Calls().call(body, context, Config.DATEFORMATLIST).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {

        var data = DateFormat.fromJson(value);
        if (this.mounted) {
          setState(() {
            dateList = checkData(data.rows!);
            for (DateFormatItem item in dateList) {
              item.isSelected ??= false;
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

  List<DateFormatItem> checkData(List<DateFormatItem> rows) {
    for (DateFormatItem item in rows) {
      if (item.format == settingsView.rows!.dateFormat) {
        item.isSelected = true;
      }
    }
    return rows;
  }

  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle:  AppLocalizations.of(context)!.translate("select_date"),
              onBackButtonPress: (){
                Navigator.pop(context);
              }),
          body: isLoading?    PreloadingView(
              url: "assets/appimages/settings.png"):Stack(
            children: [
              ListView.builder(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  itemCount: dateList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.only(left:4,right: 4,bottom: 1),
                      child: InkWell(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(8),
                          value: dateList[index].isSelected,
                          onChanged: (val) {
                            if (this.mounted) {
                              setState(() {
                                for (int i = 0; i < dateList.length; i++) {
                                  if (index == i) {
                                    dateList[index].isSelected = val;
                                  } else {
                                    dateList[i].isSelected = false;
                                  }
                                }
                              });
                            }
                          },
                          title: Text(
                            dateList != null ? dateList[index].format! : "",
                            style: styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                      ),
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
                              updatedateFormat();
                            },
                            color: HexColor(AppColors.appColorWhite),
                            child: Text(
                                AppLocalizations.of(context)!
                                    .translate("save_exit"),
                                style:styleElements.buttonThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appMainColor))),
                          ),
                        )),
                  ))
            ],
          )),
    );
  }

  void updatedateFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    progressButtonKey.currentState!.show();
    AccountSettingUpdateRequest model = AccountSettingUpdateRequest();
    model.personId = prefs.getInt("userId");
    model.id = rowId;
    model.dateFormat = getselected();
    var body = jsonEncode(model);
    Calls().call(body, context, Config.UPDATEACCOUNTSETTING).then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.rows != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.information));
          Navigator.pop(context);
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }

  String? getselected() {
    String? format;
    for (DateFormatItem item in dateList) {
      if (item.isSelected!) {
        format = item.format;
        break;
      }
    }
    return format;
  }

  _DateSelectionPage(this.rowId);
}

// ignore: must_be_immutable
class TimeSelectionPage extends StatefulWidget {
  int? rowId;
  @override
  _TimeSelectionPage createState() => _TimeSelectionPage(rowId);

  TimeSelectionPage(this.rowId);
}

class _TimeSelectionPage extends State<TimeSelectionPage> {
  List<DateFormatItem> timeList = [];
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  late SettingsView settingsView;
  int? rowId;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchSettings());
  }

  void fetchSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading=true;
    });
    final body = jsonEncode({
      "person_id": prefs.getInt("userId"),
    });
    Calls().call(body, context, Config.SETTINGSVIEW).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {
        var data = SettingsView.fromJson(value);
        settingsView = data;
        fetchTimeData();
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      setState(() {
        isLoading=false;
      });
    });
  }

  void fetchTimeData() {
    timeList.add(DateFormatItem(id: 1, code: "12:00", format: "12"));
    timeList.add(DateFormatItem(id: 2, code: "24:00", format: "24"));
    setState(() {
      timeList = checkData(timeList);
      for (DateFormatItem item in timeList) {
        item.isSelected ??= false;
      }
    });
  }

  List<DateFormatItem> checkData(List<DateFormatItem> rows) {
    for (DateFormatItem item in rows) {
      if (item.format == settingsView.rows!.timeFormat) {
        item.isSelected = true;
      }
    }
    return rows;
  }
  late TextStyleElements styleElements;
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle:  AppLocalizations.of(context)!.translate("select_date"),
              onBackButtonPress: (){
                Navigator.pop(context);
              }),
          body: isLoading?    PreloadingView(
              url: "assets/appimages/settings.png"):Stack(
            children: [
              ListView.builder(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  itemCount: timeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.only(left:4,right: 4,bottom: 1),
                      child: InkWell(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(8),
                          value: timeList[index].isSelected,
                          onChanged: (val) {
                            if (this.mounted) {
                              setState(() {
                                for (int i = 0; i < timeList.length; i++) {
                                  if (index == i) {
                                    timeList[index].isSelected = val;
                                  } else {
                                    timeList[i].isSelected = false;
                                  }
                                }
                              });
                            }
                          },
                          title: Text(
                            timeList != null ? timeList[index].code! : "",
                            style: styleElements.subtitle1ThemeScalable(context),
                          ),
                        ),
                      ),
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
                              updatetimeFormat();
                            },
                            color: HexColor(AppColors.appColorWhite),
                            child: Text(
                                AppLocalizations.of(context)!
                                    .translate("save_exit"),
                                style:styleElements.buttonThemeScalable(context)
                                    .copyWith(
                                        color: HexColor(AppColors.appMainColor))),
                          ),
                        )),
                  ))
            ],
          )),
    );
  }

  Future<void> updatetimeFormat() async {
    prefs = await SharedPreferences.getInstance();
    progressButtonKey.currentState!.show();
    AccountSettingUpdateRequest model = AccountSettingUpdateRequest();
    model.personId = prefs.getInt("userId");
    model.id = rowId;
    model.timeFormat = getselected();
    var body = jsonEncode(model);
    Calls().call(body, context, Config.UPDATEACCOUNTSETTING).then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.rows != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.information));
          Navigator.pop(context);
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }

  String? getselected() {
    String? format;
    for (DateFormatItem item in timeList) {
      if (item.isSelected!) {
        format = item.format;
        break;
      }
    }
    return format;
  }

  _TimeSelectionPage(this.rowId);
}
