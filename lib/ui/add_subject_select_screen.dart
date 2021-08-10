import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/subject_experties.dart';
import 'package:oho_works_app/profile_module/pages/expertise_classes.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
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
class AddSelectSubject extends StatefulWidget {
  int? instituteId;
  RegisterUserAs? registerUserAs;
  bool fromBasicProfileFLow;
  Null Function()? callbackPicker;

  AddSelectSubject(
      this.instituteId, this.fromBasicProfileFLow, this.callbackPicker);

  _SelectSubject createState() =>
      _SelectSubject(instituteId, fromBasicProfileFLow, callbackPicker);
}

class _SelectSubject extends State<AddSelectSubject>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late SharedPreferences prefs;
  var pageTitle = "";
  late TextStyleElements styleElements;
  var color1 = HexColor(AppColors.appMainColor);
  int? instituteId;
  var color2 = HexColor(AppColors.appColorWhite);
  var isSearching = false;
  String type = "";
  int? userId;
  String? subjectId;
  final _debouncer = Debouncer(500);
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<String> teachingSubjects = [];
  List<SubjectItem>? listOfSubjects = [];
  List<SubjectItem> selectedSubjects = [];
  List<int> personTypeList = [];
  bool _enabled = true;
  bool empty = false;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    setSharedPreferences();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getRoles(null));

    super.initState();
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  bool contains(int? id) {
    for (var item in selectedSubjects) {
      if (item.id == id) return true;
    }
    return false;
  }

  void getRoles(String? searchValue) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    final body = jsonEncode({
      "search_val": searchValue,
      "person_id": prefs.getInt("userId").toString(),
      "business_id": instituteId,
      "page_number": 1,
      "page_size": 250
    });
    Calls().call(body, context, Config.SUBJECT_EXPERTIES).then((value) async {
      setState(() {
        isLoading = false;
      });
      isSearching = false;
      if (value != null) {
        setState(() {
          isLoading = false;
        });
        var data = SubjectExperties.fromJson(value);
        setState(() {
          _enabled = false;
          if (data.rows != null && data.rows!.length > 0) {
            if (listOfSubjects!.length > 0) {
              {
                for (var i = 0; i < data.rows!.length; i++) {
                  if (contains(data.rows![i].id))
                    data.rows![i].isSelected = true;
                  else
                    data.rows![i].isSelected = false;
                }
              }
            } else {
              for (var i = 0; i < data.rows!.length; i++) {
                data.rows![i].isSelected = false;
              }
            }
            listOfSubjects = data.rows;
          } else {
            empty = true;
          }

          isSearching = false;
        });
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    // ScreenUtil.init(context);
    styleElements = TextStyleElements(context);
    pageTitle = AppLocalizations.of(context)!.translate("subjects");

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(AppColors.appColorBackground),
      appBar: appAppBar().getCustomAppBar(context, appBarTitle: pageTitle,
          onBackButtonPress: () {
        _onBackPressed();
      }),
      body: Container(
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
                                      getRoles(text);
                                    });
                                  });
                                },
                                progressIndicator: isSearching,
                                hintText: AppLocalizations.of(context)!.translate('search'),
                              ),
                            ),
                          ];
                        },
                        body: isLoading
                            ? PreloadingView(
                                url: "assets/appimages/settings.png")
                            : Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _enabled,
                                    child: PreloadingView(
                                        url: "assets/appimages/dice.png"),
                                  ),
                                  Center(
                                    child: Visibility(
                                      visible: empty,
                                      child: appEmptyWidget(
                                        message: AppLocalizations.of(context)!
                                            .translate('no_data'),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 65),
                                    child: appListCard(
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 8,
                                              top: 8),
                                          itemCount: listOfSubjects!.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return GestureDetector(
                                              child: Column(
                                                children: <Widget>[
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
                                                              listOfSubjects![
                                                                          index]
                                                                      .standardExpertiseCategoryId ??
                                                                  "",
                                                              style: styleElements
                                                                  .subtitle1ThemeScalable(
                                                                      context),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              listOfSubjects![
                                                                          index]
                                                                      .expertiseTypeDescription ??
                                                                  "",
                                                              style: styleElements
                                                                  .subtitle2ThemeScalable(
                                                                      context),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Checkbox(
                                                            activeColor:
                                                                HexColor(AppColors.appMainColor),
                                                            value:
                                                                listOfSubjects![
                                                                        index]
                                                                    .isSelected,
                                                            onChanged: (val) {
                                                              if (this
                                                                  .mounted) {
                                                                setState(() {
                                                                  if (val ==
                                                                      true) {
                                                                    subjectId =
                                                                        listOfSubjects![index]
                                                                            .id
                                                                            .toString();
                                                                    setState(
                                                                        () {
                                                                      listOfSubjects![index].isSelected =
                                                                          true;
                                                                      selectedSubjects
                                                                          .add(listOfSubjects![index]);
                                                                    });
                                                                  } else {
                                                                    listOfSubjects![index]
                                                                            .isSelected =
                                                                        false;
                                                                    removeSelected(
                                                                        listOfSubjects![index]
                                                                            .id);
                                                                  }
                                                                });
                                                              }
                                                            },
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              )
                                                ],
                                              ),
                                              onTap: () {},
                                            );
                                          }),
                                    ),
                                  ),
                                  Visibility(
                                    visible: fromBasicProfileFLow,
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            color: HexColor(AppColors.appColorWhite),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: appProgressButton(
                                                    key: progressButtonKey,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .redAccent)),
                                                    onPressed: () async {
                                                      for (var item
                                                          in selectedSubjects) {
                                                        teachingSubjects.add(
                                                            item.id.toString());
                                                      }

                                                      if (teachingSubjects
                                                          .isNotEmpty) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                SelectLanguageProficiencyDialogue(
                                                                    personId: prefs
                                                                        .getInt(
                                                                            "userId"),
                                                                    type:
                                                                        "add_subject",
                                                                    title2: AppLocalizations.of(context)!
                                                                        .translate(
                                                                            "what_want_to_be"),
                                                                    title: AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "my_proficiency"),
                                                                    subtitle: AppLocalizations
                                                                            .of(
                                                                                context)!
                                                                        .translate(
                                                                            "rate_experties"),
                                                                    categoryType:
                                                                        "Subject",
                                                                    id1:
                                                                        subjectId,
                                                                    ids:
                                                                        teachingSubjects,
                                                                    instId: instituteId
                                                                        .toString(),
                                                                    callbackPicker:
                                                                        () {
                                                                      if (fromBasicProfileFLow) {
                                                                        callbackPicker!();
                                                                        Navigator.of(context)
                                                                            .pop({
                                                                          'result':
                                                                              "success"
                                                                        });
                                                                      } else
                                                                        Navigator.of(context)
                                                                            .pop({
                                                                          'result':
                                                                              "success"
                                                                        });
                                                                    }));
                                                      } else {
                                                        callbackPicker!();
                                                        Navigator.of(context)
                                                            .pop({
                                                          'result': "success"
                                                        });
                                                      }
                                                    },
                                                    color: HexColor(AppColors.appColorWhite),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              'save_exit')
                                                          .toUpperCase(),
                                                      style: styleElements
                                                          .subtitle2ThemeScalable(
                                                              context)
                                                          .copyWith(
                                                              color: Colors
                                                                  .redAccent),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: appProgressButton(
                                                    key: progressButtonKeyNext,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .redAccent)),
                                                    onPressed: () async {
                                                      for (var item
                                                          in selectedSubjects) {
                                                        teachingSubjects.add(
                                                            item.id.toString());
                                                      }

                                                      if (teachingSubjects
                                                          .isNotEmpty) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                SelectLanguageProficiencyDialogue(
                                                                    personId: prefs
                                                                        .getInt(
                                                                            "userId"),
                                                                    type:
                                                                        "add_subject",
                                                                    title2: AppLocalizations.of(context)!
                                                                        .translate(
                                                                            "what_want_to_be"),
                                                                    title: AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "my_proficiency"),
                                                                    subtitle: AppLocalizations
                                                                            .of(
                                                                                context)!
                                                                        .translate(
                                                                            "rate_experties"),
                                                                    categoryType:
                                                                        "Subject",
                                                                    id1:
                                                                        subjectId,
                                                                    ids:
                                                                        teachingSubjects,
                                                                    instId: instituteId
                                                                        .toString(),
                                                                    callbackPicker:
                                                                        () {
                                                                      handleCallBack();
                                                                    }));
                                                      } else {
                                                        var result =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ExpertiseSelectClass(
                                                                      prefs.getInt(
                                                                          Strings
                                                                              .instituteId),
                                                                      null,
                                                                      true,
                                                                      0,
                                                                      callbackPicker,
                                                                 fromBasicProfileFLow,),
                                                                ));

                                                        if (result != null &&
                                                            result['result'] ==
                                                                "success") {
                                                          callbackPicker!();
                                                          Navigator.of(context)
                                                              .pop({
                                                            'result': "success"
                                                          });
                                                        }
                                                      }
                                                    },
                                                    color: HexColor(AppColors.appColorWhite),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate('next')
                                                          .toUpperCase(),
                                                      style: styleElements
                                                          .subtitle2ThemeScalable(
                                                              context)
                                                          .copyWith(
                                                              color: Colors
                                                                  .redAccent),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  ),
                                  Visibility(
                                      visible: !fromBasicProfileFLow,
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              color: HexColor(AppColors.appColorWhite),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 16),
                                                      height: 60,
                                                      color: HexColor(AppColors.appColorWhite),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "",
                                                          style: styleElements
                                                              .subtitle2ThemeScalable(
                                                                  context)
                                                              .copyWith(
                                                                  color: Colors
                                                                      .redAccent),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    child:
                                                        appProgressButton(
                                                      key:
                                                          progressButtonKeyNext,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .redAccent)),
                                                      onPressed: () async {
                                                        for (var item
                                                            in selectedSubjects) {
                                                          teachingSubjects.add(
                                                              item.id
                                                                  .toString());
                                                        }

                                                        if (teachingSubjects
                                                            .isNotEmpty) {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  SelectLanguageProficiencyDialogue(
                                                                      personId: prefs.getInt(
                                                                          "userId"),
                                                                      type:
                                                                          "add_subject",
                                                                      title2: AppLocalizations.of(context)!
                                                                          .translate(
                                                                              "what_want_to_be"),
                                                                      title: AppLocalizations.of(
                                                                              context)!
                                                                          .translate(
                                                                              "my_proficiency"),
                                                                      subtitle: AppLocalizations.of(
                                                                              context)!
                                                                          .translate(
                                                                              "rate_experties"),
                                                                      categoryType:
                                                                          "Subject",
                                                                      id1:
                                                                          subjectId,
                                                                      ids:
                                                                          teachingSubjects,
                                                                      instId: instituteId
                                                                          .toString(),
                                                                      callbackPicker:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop({
                                                                          'result':
                                                                              "success"
                                                                        });
                                                                      }));
                                                        } else {
                                                          ToastBuilder().showToast(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      "subjects_required"),
                                                              context,
                                                              HexColor(AppColors
                                                                  .information));
                                                        }
                                                      },
                                                      color: HexColor(AppColors.appColorWhite),

                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate('next')
                                                            .toUpperCase(),
                                                        style: styleElements
                                                            .subtitle2ThemeScalable(
                                                                context)
                                                            .copyWith(
                                                                color: Colors
                                                                    .redAccent),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )))),
                                ],
                              ))),
              ))),
    ));
  }

  handleCallBack() async {
    if (fromBasicProfileFLow) {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpertiseSelectClass(
                prefs.getInt(Strings.instituteId),
                null,
                true,
                0,
                callbackPicker,
         true,),
          ));

      if (result != null && result['result'] == "success") {
        callbackPicker!();
        Navigator.of(context).pop({'result': "success"});
      }
    } else
      Navigator.of(context).pop({'result': "success"});
  }

  removeSelected(int? id) {
    for (var i = 0; i < selectedSubjects.length; i++) {
      if (id == selectedSubjects[i].id) {
        selectedSubjects.removeAt(i);
        break;
      }
    }
  }

  bool fromBasicProfileFLow;
  Null Function()? callbackPicker;

  _SelectSubject(
      this.instituteId, this.fromBasicProfileFLow, this.callbackPicker);
}
