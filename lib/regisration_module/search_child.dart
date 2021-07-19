import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/UserList.dart';
import 'package:oho_works_app/regisration_module/verify_child.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SearchChild extends StatefulWidget {
  RegisterUserAs registerUserAs;
  int instituteId;

  SearchChild(this.registerUserAs);

  _SearchChild createState() => _SearchChild(registerUserAs);
}

class _SearchChild extends State<SearchChild>
    with SingleTickerProviderStateMixin {

  SharedPreferences prefs;
  RegisterUserAs registerUserAs;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int idStudent;
  TextStyleElements styleElements;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<User> listUser = [];
  List<String> personList = [];
  List<int> teachingClasses = [];
  var isSearching = false;
  bool _enabled = true;
  String previousYear;
  String currentYear;
  String acedemicYear;
  String type = "";
BuildContext sctx;
  @override
  void initState() {
    final DateFormat formatter = DateFormat('yyyy');
    final DateTime now = DateTime.now();
    personList.add("S");
    currentYear = formatter.format(now);
    previousYear = (int.parse(currentYear) - 1).toString();
    acedemicYear = previousYear + "-" + currentYear;
    WidgetsBinding.instance.addPostFrameCallback((_) => getRoles(null));
    super.initState();
  }

  void getRoles(String searchValue) async {

    final body = jsonEncode({
      "institution_id": registerUserAs.institutionId,
      "searchVal": searchValue,
      "person_type": personList,
      "class_id": registerUserAs.personClasses[0]
    });

    Calls().call(body, context, Config.USER_LIST).then((value) async {

      _enabled = false;
      isSearching = false;
      if (value != null) {
        var data = UserList.fromJson(value);
        if (data != null) {
          if (data.rows != null && data.rows.isNotEmpty) {
            for (int i = 0; i < data.rows.length; i++) {
              // already selected institute mark red
              if (idStudent != null) {
                if (data.rows[i].id == idStudent)
                  data.rows[i].isSelected = true;
                else
                  data.rows[i].isSelected = false;
              } else {
                data.rows[i].isSelected = false;
              }
            }
            listUser = data.rows;
            setState(() {});
          } else {}
        } else {
          setState(() {});
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(onError.toString(), sctx,HexColor(AppColors.failure));

    });
  }
  void _onBackPressed() {
    Navigator.of(context).pop(true);
  }
  Widget build(BuildContext context) {
    // ScreenUtil.init(context);
    styleElements = TextStyleElements(context);
    pageTitle = AppLocalizations.of(context).translate('select_child');
    return
      SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          body:
          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new  Container(
                child: Scaffold(

                    appBar:TricycleAppBar().getCustomAppBar(context,
                        appBarTitle: pageTitle,
                        onBackButtonPress: (){
                          _onBackPressed();
                        }),
                    resizeToAvoidBottomInset: false,
                    backgroundColor: HexColor(AppColors.appColorBackground),
                    body: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: HexColor(AppColors.appColorBackground),
                          body: NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverToBoxAdapter(
                                    child: SearchBox(
                                      onvalueChanged: (text){
                                        isSearching = true;
                                        getRoles(text);
                                      },
                                      progressIndicator: isSearching,
                                      hintText: AppLocalizations.of(context).translate('search'),
                                    ),
                                  ),
                                ];
                              },
                              body: Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _enabled,
                                    child: PreloadingView(
                                        url: "assets/appimages/classroom.png"),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8, bottom: 8, top: 8),
                                        itemCount: listUser.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            child: Card(
                                                child: Column(
                                                  children: <Widget>[
                                                    Visibility(
                                                        visible: index == 0,
                                                        child: Container(
                                                          width: double.infinity,
                                                          margin: const EdgeInsets.only(
                                                              bottom: 4),
                                                          decoration: BoxDecoration(
                                                              color: HexColor(AppColors.appColorRed50),
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topRight:
                                                                  Radius.circular(
                                                                      4.0),
                                                                  topLeft:
                                                                  Radius.circular(
                                                                      4.0))),
                                                          child: Container(
                                                            margin:
                                                            const EdgeInsets.all(16),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                  context)
                                                                  .translate(
                                                                  "parent_search_child"),
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: styleElements.captionThemeScalable(context),),
                                                          ),
                                                        )),
                                                    Container(
                                                      margin: const EdgeInsets.only(
                                                        left: 16,
                                                        bottom: 16,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              children: <Widget>[
                                                                Align(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  child: Text(
                                                                    listUser[index]
                                                                        .firstName +
                                                                        listUser[
                                                                        index]
                                                                            .lastName ??
                                                                        "",
                                                                    style: styleElements.subtitle1ThemeScalable(context),
                                                                    textAlign:
                                                                    TextAlign.left,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                            const EdgeInsets.all(16),
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerRight,
                                                                child: Checkbox(
                                                                  activeColor:
                                                                  HexColor(AppColors.appMainColor),
                                                                  value: listUser[index]
                                                                      .isSelected,
                                                                  onChanged: (val) {
                                                                    if (this.mounted) {
                                                                      setState(() {
                                                                        if (val == true) {
                                                                          for (int i = 0;
                                                                          i <
                                                                              listUser
                                                                                  .length;
                                                                          i++) {
                                                                            if (i ==
                                                                                index) {
                                                                              idStudent =
                                                                                  listUser[i]
                                                                                      .id;

                                                                              listUser[i]
                                                                                  .isSelected =
                                                                              true;
                                                                            } else
                                                                              listUser[i]
                                                                                  .isSelected =
                                                                              false;
                                                                          }
                                                                        } else {
                                                                          listUser[index]
                                                                              .isSelected =
                                                                          false;
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                )

                                                              /*
                                                   SizedBox(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          for (int i = 0; i < listUser.length;i++) {
                                                            if (i == index) {
                                                              instituteId = listUser[i].id;
                                                              isInstituteSelected = true;
                                                              listUser[i].isSelected = true;
                                                              getRoles(null, instituteId);

                                                              selectedSchool = listUser[i].name ?? "";
                                                              selectedSchoolDec = listUser[i].description ?? "";
                                                            } else
                                                              listUser[i]
                                                                  .isSelected =
                                                              false;
                                                          }
                                                        });
                                                      },
                                                      elevation: 2.0,
                                                      child: Icon(
                                                        Icons.done,
                                                        size: 10,
                                                        color: HexColor(AppColors.appColorWhite),
                                                      ),
                                                      fillColor:
                                                      listUser[index]
                                                          .isSelected
                                                          ? HexColor(AppColors.appColorLightGreen)
                                                          : HexColor(AppColors.appColorWhite),
                                                      padding: EdgeInsets.all(
                                                          4.0),
                                                      shape: CircleBorder(
                                                          side: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .lightGreen,
                                                          )),
                                                    ),
                                                  ),*/
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            onTap: () {},
                                          );
                                        }),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 60,
                                        color: HexColor(AppColors.appColorWhite),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: TricycleElevatedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(18.0),
                                                    side: BorderSide(
                                                        color: HexColor(AppColors.appMainColor))),
                                                onPressed: () {
                                                  var ids = isItemSelected();
                                                  if (ids != null) {
                                                    registerUserAs.childId = ids;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              VerifyChild(
                                                                  0, registerUserAs),
                                                        ));
                                                  } else {
                                                    ToastBuilder().showSnackBar(
                                                        "Please select child name",
                                                        sctx,HexColor(AppColors.information));
                                                  }
                                                },
                                                color: HexColor(AppColors.appColorWhite),
                                                child: Text(AppLocalizations.of(context).translate('next'),
                                                  style: styleElements.subtitle2ThemeScalable(context).copyWith(color:HexColor(AppColors.appMainColor)),),
                                              ),
                                            )),
                                      ))
                                ],
                              ))),
                    )));
          })

         ,
        ),
      )
      ;
  }

  int isItemSelected() {
    for (var item in listUser) {
      if (item.isSelected) {
        return item.id;
      }
    }
    return null;
  }

  _SearchChild(this.registerUserAs);
}
