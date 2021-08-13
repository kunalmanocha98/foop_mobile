import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/disctionarylist.dart';
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
class SelectCompanyType extends StatefulWidget {
  bool isSignUp = false;

  _SelectCompanyType createState() => _SelectCompanyType();

  SelectCompanyType();
}

class _SelectCompanyType extends State<SelectCompanyType> {
  bool isLoading =false;
  bool? isSignUp;
  bool isCalled = false;
  SharedPreferences? prefs;
  List<DictionaryListItem>  listRules = [];

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
        appBar: appAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context)!.translate('entity_type'),
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
                      title: Text(listRules[index].description!,

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
                          child: appElevatedButton(
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

  DictionaryListItem? getSelectedItem() {

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
    final body = jsonEncode({"type":"BUSTYPE"});
    Calls().call(body, context, Config.DICTIONARYLIST).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {

        var data = DictionaryListResponse.fromJson(value);
        listRules= data.rows!;

      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(onError.toString(), sctx,HexColor(AppColors.information));

    });
  }




  _SelectCompanyType();
}
