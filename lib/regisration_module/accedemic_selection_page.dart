import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/accedemic_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/application.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// ignore: must_be_immutable
class SelectAcademic extends StatefulWidget {
  bool isSignUp = false;
  int? instituteId;

  _SelectAcademic createState() => _SelectAcademic(instituteId);

  SelectAcademic(this.instituteId);
}

class _SelectAcademic extends State<SelectAcademic> {
  int? instituteId;

  _SelectAcademic(this.instituteId);
bool isCalling=false;

  bool? isSignUp;
  bool isCalled = false;
  SharedPreferences? prefs;
  List<AccedemicItem>? listAccedemic = [];
  List<AccedemicItem> selectYear = [];
  late TextStyleElements styleElements;

  @override
  initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    WidgetsBinding.instance!.addPostFrameCallback((_) => getList(""));
  }

  void onLocaleChange(Locale locale) {
    if (this.mounted) {
      setState(() {});
    }
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isSearching = false;

  Widget build(BuildContext context) {
    setSharedPreferences();
    styleElements = TextStyleElements(context);

    // ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: OhoAppBar().getCustomAppBarWithSearch(context,
            appBarTitle: AppLocalizations.of(context)!.translate('select_academic_header'), onBackButtonPress: () {
          Navigator.pop(context);
        }, onSearchValueChanged: (value) {
          setState(() {
            isSearching = true;
          });

          getList(value);
        }),
        body: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 70),
              child: appListCard(
                child: ListView.builder(
                    itemCount: listAccedemic!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(listAccedemic![index].yearName!),
                        value: listAccedemic![index].isSelected,
                        onChanged: (val) {
                          if (this.mounted) {
                            setState(() {
                              for (int i = 0; i < listAccedemic!.length; i++) {
                                if (index == i) {
                                  listAccedemic![index].isSelected = val;
                                } else {
                                  listAccedemic![i].isSelected = false;
                                }
                              }
                            });
                          }
                        },
                      );
                    }),
              ),
            ),
            Visibility(
              visible: isCalling,
                child: Center(child: CircularProgressIndicator(),)),
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
                            for (var item in listAccedemic!) {
                              if (item.isSelected!) {
                                Navigator.of(context).pop({
                                  'result': item.yearName,
                                  "id": item.id.toString()
                                });
                              }
                            }
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context)!.translate("next"),
                              style: styleElements
                                  .buttonThemeScalable(context)
                                  .copyWith(
                                      color: HexColor(AppColors.appMainColor))),
                        ),
                      )),
                ))
          ],
        ),
      ),
    );
  }

  void getList(String value) async {
    setState(() {
      isCalling=true;
    });
    prefs = await SharedPreferences.getInstance();


    final body = jsonEncode(
        {"type": 1, "searchVal": value,

          "institution_id":instituteId,

          "page_size": 150, "page_number": 1});
    Calls().call(body, context, Config.ACMC_API).then((value) async {

      if (value != null) {

        setState(() {
          isCalling=false;
        });
        var data = AccedemicList.fromJson(value);
        if (data.statusCode == Strings.success_code && data.rows!.length > 0) {
          if (this.mounted) {
            setState(() {
              isSearching = false;
              listAccedemic = data.rows;
              final DateFormat formatter = DateFormat('yyyy');
              setSharedPreferences();
              final DateTime now = DateTime.now();
              var currentYear = formatter.format(now);
              var nextYear = (int.parse(currentYear) + 1).toString();
              for (int i = 0; i < listAccedemic!.length; i++) {
                if (listAccedemic![i].yearName!.contains(nextYear))
                  listAccedemic![i].isSelected = true;
                else
                  listAccedemic![i].isSelected = false;
              }
            });
          }
        }
      }
    }).catchError((onError) async {
      setState(() {
        isSearching = false;
        isCalling=false;

      });

    });
  }

  bool contains(int id) {
    for (var item in selectYear) {
      if (item.id == id) return true;
    }
    return false;
  }

  void changeLanguage(String code, String countryCode) {
    var local = Locale(code, countryCode);
    MainApp.setLocale(context, local);
  }
}
