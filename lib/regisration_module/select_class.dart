import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accedemic_selection_page.dart';

// ignore: must_be_immutable
class SelectClass extends StatefulWidget {
  RegisterUserAs registerUserAs;
  int instituteId;
  int personType;
  bool isVerified;
  bool isAddClass;

  SelectClass(this.instituteId, this.registerUserAs, this.isAddClass,
      this.personType, this.isVerified);

  _SelectClasses createState() => _SelectClasses(
      instituteId, registerUserAs, personType, isAddClass, isVerified);
}

class _SelectClasses extends State<SelectClass>
    with SingleTickerProviderStateMixin {

  late SharedPreferences prefs;
  RegisterUserAs registerUserAs;
  int? personType;
  String? classId;
  String? accedamicId;
  bool isVerified;
  bool isAddClass;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int? userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int? instituteId;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<InstituteClass>? listClasses = [];
  List<InstituteClass> selectedClasses = [];
  List<PersonClasses> teachingClasses = [];
  var isSearching = false;
  bool _enabled = true;
  String? nextYear;
  String? currentYear;
  String? acedemicYear;
  final _debouncer = Debouncer(500);
  String type = "";
  late TextStyleElements styleElements;

  Future<bool> _onBackPressed() {
    if (isVerified) {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title:
              new Text(AppLocalizations.of(context)!.translate('are_you_sure')),
          content:
              new Text(AppLocalizations.of(context)!.translate('exit_app')),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, bottom: 16, top: 16),
                child: Text(
                    AppLocalizations.of(context)!.translate('no').toUpperCase()),
              ),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, bottom: 16, top: 16),
                child: Text(AppLocalizations.of(context)!
                    .translate('yes')
                    .toUpperCase()),
              ),
            ),
          ],
        ),
      );
    } else
      Navigator.of(context).pop(true);

    return new Future(() => false);
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    setSharedPreferences();
    if (registerUserAs != null) {
      acedemicYear = registerUserAs.academicYear;
      instituteId = registerUserAs.institutionId;
      personType = registerUserAs.personTypeList![0];
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) => getRoles(null));
    super.initState();
  }

  bool contains(int? id) {
    for (var item in selectedClasses) {
      if (item.id == id) return true;
    }
    return false;
  }

  void getRoles(String? searchValue) async {

    final body = jsonEncode({
      "institution_id": instituteId,
      "search_val": searchValue,
    });

    Calls().call(body, context, Config.CLASSES_LIST).then((value) async {


      if (value != null) {
        var data = InstitutionClasses.fromJson(value);
        setState(() {
          _enabled = false;
          if (data.rows!.length > 0) {
            if (listClasses!.length > 0) {
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
            listClasses = data.rows;
          }

          isSearching = false;
        });
      } else {
        _enabled = false;
      }
    }).catchError((onError) {
      ToastBuilder().showSnackBar(
          onError.toString(), sctx, HexColor(AppColors.information));

      _enabled = false;
    });
  }
late BuildContext sctx;
  Widget build(BuildContext context) {
    ScreenUtil.init;

    pageTitle = AppLocalizations.of(context)!.translate("classes");
    styleElements = TextStyleElements(context);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(AppColors.appColorBackground),
      appBar: appAppBar().getCustomAppBar(context, appBarTitle: pageTitle,
          onBackButtonPress: () {
        _onBackPressed();
      }),
      body:
      new Builder(builder: (BuildContext context) {
        this.sctx = context;
        return DefaultTabController(
          length: 3,
          child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: SearchBox(
                      onvalueChanged: (String value) {
                        _debouncer.run(() {
                          setState(() {
                            isSearching = true;
                            getRoles(value);
                          });
                        });
                      },
                      progressIndicator: isSearching,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SelectAcademic(instituteId),
                                ));

                            if (result != null) {
                              setState(() {
                                acedemicYear = result['result'];
                                accedamicId = result['result'];
                                if (acedemicYear != null &&
                                    registerUserAs != null)
                                  registerUserAs.academicYear =
                                      acedemicYear;
                              });
                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 0,
                                bottom: 4,
                              ),
                              child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Visibility(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Align(
                                                    alignment:
                                                    Alignment.center,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Visibility(
                                                          visible:
                                                          acedemicYear !=
                                                              null,
                                                          child: Align(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            child: Text(
                                                              acedemicYear ??
                                                                  "",
                                                              style: styleElements
                                                                  .subtitle1ThemeScalable(
                                                                  context),
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          child: Text(AppLocalizations.of(context)!.translate('selected_academic_year'),
                                                            style: styleElements
                                                                .subtitle2ThemeScalable(
                                                                context),
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .all(16),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: SizedBox(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          child: Icon(
                                                              Icons
                                                                  .date_range,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ))
                                    ],
                                  )))))
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
                    margin: const EdgeInsets.only(bottom: 65),
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 8, top: 8),
                        itemCount: listClasses!.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                    visible: index == 0,
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 4),
                                      decoration: BoxDecoration(
                                          color: HexColor(AppColors.appMainColor33),
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
                                          personType == 3
                                              ? AppLocalizations.of(
                                              context)!
                                              .translate(
                                              "select_class_student")
                                              : personType == 4
                                              ? AppLocalizations
                                              .of(context)!
                                              .translate(
                                              "parent_child_select_class")
                                              : personType == 5
                                              ? AppLocalizations.of(
                                              context)!
                                              .translate(
                                              "alumni_select_class")
                                              : AppLocalizations.of(
                                              context)!
                                              .translate(
                                              "teacher_classes_info"),
                                          textAlign: TextAlign.center,
                                          style: styleElements
                                              .captionThemeScalable(
                                              context)
                                              .copyWith(
                                              color:
                                              HexColor(AppColors.appColorBlack85)),
                                        ),
                                      ),
                                    )),
                                ListTile(
                                    tileColor: HexColor(AppColors.listBg),
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        listClasses![index].className!,
                                        style: styleElements
                                            .subtitle1ThemeScalable(
                                            context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    trailing: Checkbox(
                                      activeColor:
                                      HexColor(AppColors.appMainColor),
                                      value: listClasses![index]
                                          .isSelected,
                                      onChanged: (val) {
                                        if (this.mounted) {
                                          setState(() {
                                            if (val == true) {
                                              classId =
                                                  listClasses![index]
                                                      .id
                                                      .toString();

                                              if (personType == 2 &&
                                                  !isAddClass) {
                                                // if role type is teacher
                                                // let teachers select multiple classes
                                                setState(() {
                                                  listClasses![index]
                                                      .isSelected =
                                                  true;
                                                  selectedClasses.add(
                                                      listClasses![
                                                      index]);
                                                });
                                              } else {
                                                setState(() {
                                                  // other roles can only select one class
                                                  for (int i = 0;
                                                  i <
                                                      listClasses!
                                                          .length;
                                                  i++) {
                                                    if (i == index) {
                                                      listClasses![i]
                                                          .isSelected =
                                                      true;
                                                      selectedClasses.add(
                                                          listClasses![
                                                          index]);
                                                    } else {
                                                      listClasses![i]
                                                          .isSelected =
                                                      false;
                                                      removeSelected(
                                                          listClasses![
                                                          i]
                                                              .id);
                                                    }
                                                  }
                                                });
                                              }
                                            } else {
                                              classId = "";

                                              listClasses![index]
                                                  .isSelected = false;
                                              removeSelected(
                                                  listClasses![index]
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
                              child: appElevatedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: HexColor(AppColors.appMainColor))),
                                onPressed: () {
                                  teachingClasses = [];
                                  for (var item in selectedClasses) {
                                    if (item.isSelected!) {
                                      PersonClasses proClass =
                                      PersonClasses();
                                      proClass.classId = item.id;
                                      proClass.className =
                                          item.className;
                                      teachingClasses.add(proClass);
                                    }
                                  }
                                  if (registerUserAs != null)
                                    registerUserAs.personClasses =
                                        teachingClasses;
                                  if (teachingClasses.isNotEmpty) {
                                    if (isAddClass) {
                                      if (classId != null &&
                                          classId!.isNotEmpty) {
                                        if (accedamicId != null &&
                                            accedamicId!.isNotEmpty) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext
                                              context) =>
                                                  SelectLanguageProficiencyDialogue(
                                                      personId:
                                                      prefs
                                                          .getInt(
                                                          "userId"),
                                                      type:
                                                      "add_class",
                                                      title:
                                                      "My Relation In this Class",
                                                      subtitle:
                                                      "Rate yourself in this class",
                                                      categoryType:
                                                      "Class",
                                                      id1: classId,
                                                      id2:
                                                      accedamicId,
                                                      instId: instituteId
                                                          .toString(),
                                                      callbackPicker:
                                                          () {
                                                        Navigator.of(
                                                            context)
                                                            .pop({
                                                          'result':
                                                          "success"
                                                        });
                                                      }));
                                        } else {
                                          ToastBuilder().showSnackBar(
                                              "Please Select academic year",
                                              sctx,
                                              HexColor(AppColors
                                                  .information));
                                        }
                                      } else {
                                        ToastBuilder().showSnackBar(
                                            "Please select class",
                                            sctx,
                                            HexColor(AppColors
                                                .information));
                                      }
                                    } else {
                                      Navigator.of(context).pop({
                                        'registerUserAs': registerUserAs
                                      });
                                    }
                                  } else {
                                    ToastBuilder().showSnackBar(
                                        "Please select class",
                                        sctx,
                                        HexColor(
                                            AppColors.information));
                                  }
                                },
                                color: HexColor(AppColors.appColorWhite),
                                child: Text(AppLocalizations.of(context)!.translate('next'),
                                  style: styleElements
                                      .subtitle2ThemeScalable(context)
                                      .copyWith(
                                      color: HexColor(AppColors.appMainColor)),
                                ),
                              ),
                            )),
                      ))
                ],
              )),
        );
      })



     ,
    ));
  }

  removeSelected(int? id) {
    for (var i = 0; i < selectedClasses.length; i++) {
      if (id == selectedClasses[i].id) {
        selectedClasses.removeAt(i);
        break;
      }
    }
  }

  void register(int userId) async {

    registerUserAs.personId = userId;

    registerUserAs.personClasses = teachingClasses;
    final body = jsonEncode(registerUserAs);

    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {

        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                      type: type,
                      isVerified: data.rows!.isVerified,
                      title: AppLocalizations.of(context)!.translate('you_are_added_as') + "Alumni ",
                      subtitle: (data.rows!.institutionName != null
                          ? " of " + data.rows!.institutionName!
                          : ""))),
              (Route<dynamic> route) => false);
        } else
          ToastBuilder().showSnackBar(
              data.message!, sctx, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showSnackBar(
          onError.toString(), sctx, HexColor(AppColors.information));

    });
  }

  _SelectClasses(this.instituteId, this.registerUserAs, this.personType,
      this.isAddClass, this.isVerified);
}
