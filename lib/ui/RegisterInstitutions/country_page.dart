import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/application.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/countries.dart';


// ignore: must_be_immutable
class CountryPage extends StatefulWidget {
  bool isSignUp = false;

  _CountryPage createState() => _CountryPage();

  CountryPage();
}

class _CountryPage extends State<CountryPage> {
bool isLoading =false;
  bool? isSignUp;
  bool isCalled = false;
  SharedPreferences? prefs;
  List<LanguageItem>  listRules = [];

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

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
  late TextStyleElements styleElements;
  Widget build(BuildContext context) {
    setSharedPreferences();

    // ScreenUtil.init(context);
    styleElements = TextStyleElements(context);

    return
      SafeArea(child:  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        // AppLocalizations.of(context).translate("language")
        appBar: TricycleAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context)!.translate('select_country'),
          onBackButtonPress: (){
            Navigator.of(context).pop();
          },
        ),
        body:
        new Builder(builder: (BuildContext context) {
          this.sctx = context;
          return new   Stack(
            children: <Widget>[
              isLoading?    PreloadingView(
                  url: "assets/appimages/settings.png"): ListView.builder(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  itemCount: listRules.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      checkColor: HexColor(AppColors.appColorWhite),
                      activeColor: HexColor(AppColors.appMainColor),
                      title: Text(listRules[index].languageName!,

                          style: styleElements.subtitle1ThemeScalable(context)
                      ),
                      value: listRules[index].isSelected,
                      onChanged: (val) {
                        if (this.mounted) {
                          setState(() {


                            for (int i = 0; i < listRules.length; i++) {
                              if (index == i) {
                                listRules[index].isSelected = val;
                              } else {
                                listRules[i].isSelected = false;
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
                          child: TricycleElevatedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: HexColor(AppColors.appMainColor))),
                            onPressed: () {
                              if (getSelectedItem()!=null) {
                                Navigator.of(context).pop({'result': getSelectedItem()});

                              } else {
                                ToastBuilder()
                                    .showSnackBar("Please select country", sctx,HexColor(AppColors.information));
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

  LanguageItem? getSelectedItem() {

    for (var item in listRules) {
      if (item.isSelected!) {
        return item;
      }
    }
    return null;
  }

  void getList() async {
    prefs = await SharedPreferences.getInstance();
  setState(() {
    isLoading=true;
  });
    final body = jsonEncode({});
    Calls().calWithoutToken(body, context, Config.COUNTRIES).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {

        var data = Country.fromJson(value);
        if (this.mounted) {
          for (int i = 0; i < data.rows!.length; i++) {
            LanguageItem languageItem=LanguageItem();
            languageItem.languageCode=data.rows![i][0];
            languageItem.languageName=data.rows![i][1];
            languageItem.isSelected=false;
            listRules.add(languageItem);
          }
          setState(() {
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(onError.toString(), sctx,HexColor(AppColors.information));

    });
  }




  _CountryPage();
}
