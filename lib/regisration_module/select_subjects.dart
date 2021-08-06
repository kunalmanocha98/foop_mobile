/*
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/add_new_skill.dart';
import 'package:oho_works_app/models/add_new_skill_response.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SelectSubject extends StatefulWidget {
  int instituteId;
  RegisterUserAs registerUserAs;

  SelectSubject(this.instituteId, this.registerUserAs);

  _SelectSubject createState() => _SelectSubject(instituteId, registerUserAs);
}

class _SelectSubject extends State<SelectSubject>
    with SingleTickerProviderStateMixin {
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  RegisterUserAs registerUserAs;
  SharedPreferences prefs;
  var pageTitle = "";
  TextStyleElements styleElements;
  var color1 = HexColor(AppColors.appMainColor);
  int instituteId;
  var color2 = HexColor(AppColors.appColorWhite);
  var isSearching = false;
  String type = "";
  int userId;
  final _debouncer = Debouncer(500);
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<int> teachingSubjects = [];
  List<Subjects> listOfSubjects = [];
  List<Subjects> selectedSubjects = [];
  List<int> personTypeList = [];
  bool _enabled = true;
  String searchVal;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    registerUserAs.personTypeList[0] == 2 ? type = "teacher" : type = "student";
    WidgetsBinding.instance.addPostFrameCallback((_) => getRoles(null));
    setSharedPreferences();
    super.initState();
  }

  void _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  bool contains(int id) {
    for (var item in selectedSubjects) {
      if (item.id == id) return true;
    }
    return false;
  }

  void getRoles(String searchValue) async {
    final body = jsonEncode({
      "business_id": registerUserAs.institutionId,
      "search_val": searchValue,
    });
    Calls().call(body, context, Config.SUBJECT_LIST).then((value) async {
      isSearching = false;
      if (value != null) {
        var data = SubjectList.fromJson(value);
        listOfSubjects.clear();
        setState(() {
          _enabled = false;
          if (data.rows.length > 0) {
            if (listOfSubjects.length > 0) {
              {
                for (var i = 0; i < data.rows.length; i++) {
                  if (contains(data.rows[i].id))
                    data.rows[i].isSelected = true;
                  else
                    data.rows[i].isSelected = false;
                }
              }
            } else {
              for (var i = 0; i < data.rows.length; i++) {
                data.rows[i].isSelected = false;
              }
            }
            listOfSubjects = data.rows;
          }

          isSearching = false;
        });
      }
    }).catchError((onError) {});
  }

  BuildContext sctx;

  Widget build(BuildContext context) {
    // ScreenUtil.init(context);
    styleElements = TextStyleElements(context);
    pageTitle = AppLocalizations.of(context).translate("subjects");

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _onBackPressed();
      },
      child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: HexColor(AppColors.appColorBackground),
            appBar: appAppBar().getCustomAppBar(context,
                appBarTitle: pageTitle, onBackButtonPress: () {
                  _onBackPressed();
                }),
            body: new Builder(builder: (BuildContext context) {
              this.sctx = context;
              return new Container(
                  child: Scaffold(
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
                                        onvalueChanged: (String text) {
                                          _debouncer.run(() {
                                            setState(() {
                                              isSearching = true;
                                              searchVal = text;
                                              getRoles(text);
                                            });
                                          });
                                        },
                                        progressIndicator: isSearching,
                                        hintText: AppLocalizations.of(context)
                                            .translate('search'),
                                      ),
                                    ),
                                  ];
                                },
                                body: Stack(
                                  children: <Widget>[
                                    Visibility(
                                      visible: _enabled,
                                      child: PreloadingView(
                                          url: "assets/appimages/dice.png"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 65),
                                      child:
                                      listOfSubjects != null &&
                                          listOfSubjects.isNotEmpty
                                          ? ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 8,
                                              top: 8),
                                          itemCount: listOfSubjects.length,
                                          itemBuilder:
                                              (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              child: Column(
                                                children: <Widget>[
                                                  Visibility(
                                                      visible: index == 0,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        margin:
                                                        const EdgeInsets
                                                            .only(
                                                            bottom: 4),
                                                        decoration: BoxDecoration(
                                                            color: HexColor(AppColors.appMainColor33),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                    4.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    4.0))),
                                                        child: Container(
                                                          margin:
                                                          const EdgeInsets
                                                              .all(16),
                                                          child: Text(
                                                              registerUserAs.personTypeList[0] ==
                                                                  2
                                                                  ? AppLocalizations.of(
                                                                  context)
                                                                  .translate(
                                                                  "teacher_sub_info")
                                                                  : registerUserAs.personTypeList[0] ==
                                                                  3
                                                                  ? AppLocalizations.of(context).translate(
                                                                  "student_subj_inf")
                                                                  : "",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: styleElements
                                                                  .captionThemeScalable(
                                                                  context)),
                                                        ),
                                                      )),
                                                  ListTile(
                                                      tileColor: HexColor(
                                                          AppColors.listBg),
                                                      title: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          listOfSubjects[
                                                          index]
                                                              .subjectName ??
                                                              "",
                                                          style: styleElements
                                                              .subtitle1ThemeScalable(
                                                              context),
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                      ),
                                                      subtitle: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          listOfSubjects[
                                                          index]
                                                              .subjectDescription ??
                                                              "",
                                                          style: styleElements
                                                              .subtitle2ThemeScalable(
                                                              context),
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                      ),
                                                      trailing: Checkbox(
                                                        activeColor: HexColor(
                                                            AppColors
                                                                .appMainColor),
                                                        value:
                                                        listOfSubjects[
                                                        index]
                                                            .isSelected,
                                                        onChanged: (val) {
                                                          if (this
                                                              .mounted) {
                                                            setState(() {
                                                              if (val ==
                                                                  true) {
                                                                {
                                                                  setState(
                                                                          () {
                                                                        listOfSubjects[index].isSelected =
                                                                        true;
                                                                        selectedSubjects
                                                                            .add(listOfSubjects[index]);
                                                                      });
                                                                }
                                                              } else {
                                                                listOfSubjects[
                                                                index]
                                                                    .isSelected = false;
                                                                removeSelected(
                                                                    listOfSubjects[index]
                                                                        .id);
                                                              }
                                                            });
                                                          }
                                                        },
                                                      ))
                                                ],
                                              ),
                                              onTap: () {},
                                            );
                                          })
                                          : Center(
                                          child: appEmptyWidget(
                                            message:
                                            "No data Found, Click next to add this subject",
                                          )),
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
                                                child: appProgressButton(
                                                  key: progressButtonKey,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                      side: BorderSide(
                                                          color: HexColor(AppColors
                                                              .appMainColor))),
                                                  onPressed: () {
                                                    for (var item
                                                    in selectedSubjects) {
                                                      teachingSubjects.add(item.id);
                                                    }
                                                    registerUserAs.personSubjects =
                                                        teachingSubjects;
                                                    if (listOfSubjects != null &&
                                                        listOfSubjects.isEmpty &&
                                                        searchVal != null &&
                                                        searchVal.isNotEmpty) {
                                                      addNewLangSkill(searchVal);
                                                    } else if (teachingSubjects
                                                        .isNotEmpty) {
                                                      Navigator.of(context).pop({
                                                        'registerUserAs': registerUserAs
                                                      });
register(
                                                          prefs.getInt("userId"));

                                                    } else {
                                                      ToastBuilder().showSnackBar(
                                                          "Select subject",
                                                          sctx,
                                                          HexColor(AppColors
                                                              .information));
                                                    }
                                                  },
                                                  color: HexColor(
                                                      AppColors.appColorWhite),
                                                  textColor: HexColor(
                                                      AppColors.appMainColor),
                                                  child: Text(
                                                      AppLocalizations.of(context)
                                                          .translate('next'),
                                                      style: styleElements
                                                          .subtitle2ThemeScalable(
                                                          context)
                                                          .copyWith(
                                                          color: HexColor(AppColors
                                                              .appMainColor))),
                                                ),
                                              )),
                                        ))
                                  ],
                                ))),
                      )));
            }),
          )),
    );
  }

  void addNewLangSkill(String searchValue) async {
    AddNewSkillLangEntity addNewSkillLangEntity = AddNewSkillLangEntity();
    addNewSkillLangEntity.categoryType = "subject";
    addNewSkillLangEntity.instituteId = registerUserAs.institutionId;
    addNewSkillLangEntity.valueCode = searchValue;
    addNewSkillLangEntity.valueName = searchValue;
    addNewSkillLangEntity.valueDescription = searchValue;
    progressButtonKey.currentState.show();
    Calls()
        .call(
        jsonEncode(addNewSkillLangEntity), context, Config.COMMON_NEW_ENTRY)
        .then((value) {
      progressButtonKey.currentState.hide();
      var res = AddNewSkillLangResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows.id != null) {
          getRoles(searchValue);
        }
      } else {}
    }).catchError((onError) {
      print(onError);
      progressButtonKey.currentState.hide();
    });
  }

  void register(int userId) async {
    registerUserAs.personId = userId;
    final body = jsonEncode(registerUserAs);
    progressButtonKey.currentState.show();
    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        progressButtonKey.currentState.hide();
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                      type: type,
                      isVerified: data.rows.isVerified,
                      title: AppLocalizations.of(context)
                          .translate('you_are_added_as') +
                          type,
                      subtitle: type == "parent"
                          ? ((data.rows.studentName != null
                          ? "of" + data.rows.studentName
                          : "") +
                          (data.rows.institutionName != null
                              ? " of " + data.rows.institutionName
                              : ""))
                          : (data.rows.institutionName != null
                          ? " of " + data.rows.institutionName
                          : ""))),
                  (Route<dynamic> route) => false);
        } else
          ToastBuilder().showSnackBar(
              data.message, sctx, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(
          onError.toString(), sctx, HexColor(AppColors.information));
      progressButtonKey.currentState.hide();
    });
  }

  removeSelected(int id) {
    for (var i = 0; i < selectedSubjects.length; i++) {
      if (id == selectedSubjects[i].id) {
        selectedSubjects.removeAt(i);
        break;
      }
    }
  }

  _SelectSubject(this.instituteId, this.registerUserAs);
}
*/
