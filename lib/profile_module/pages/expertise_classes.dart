import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/classes_exp.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
import 'package:oho_works_app/regisration_module/section_expertise.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/dialogue_for_successfull_addition.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../regisration_module/accedemic_selection_page.dart';
import 'edit_education.dart';

// ignore: must_be_immutable
class ExpertiseSelectClass extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int? instituteId;
  int? personType;
  bool isAddClass;
  bool fromBasicProfileFLow;
  Null Function()? callbackPicker;
  ExpertiseSelectClass(
      this.instituteId, this.registerUserAs, this.isAddClass, this.personType,this.callbackPicker,this.fromBasicProfileFLow);
  _SelectClasses createState() => _SelectClasses(instituteId, registerUserAs, personType, isAddClass,callbackPicker);
}

class _SelectClasses extends State<ExpertiseSelectClass>
    with SingleTickerProviderStateMixin {

  late SharedPreferences prefs;
  RegisterUserAs? registerUserAs;
  int? personType;
  String? classId;
  String? className;
  String? accedamicId;

  bool isAddClass;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int? userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int? instituteId;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<ClassesItemsExpert>? listClasses = [];
  List<ClassesItemsExpert> selectedClasses = [];
  List<PersonClasses> teachingClasses = [];
  var isSearching = false;
  bool _enabled = true;
  late String nextYear;
  late String currentYear;
  String? acedemicYear;
  final _debouncer = Debouncer(500);
  String type = "";
  late TextStyleElements styleElements;

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {

    final DateFormat formatter = DateFormat('yyyy');
    setSharedPreferences();
    final DateTime now = DateTime.now();

    if (registerUserAs != null && registerUserAs!.personTypeList![0] != 5) {
      currentYear = formatter.format(now);
      nextYear = (int.parse(currentYear) + 1).toString();
      acedemicYear = currentYear + "-" + nextYear;
      registerUserAs!.academicYear = acedemicYear;
      personType = registerUserAs!.personTypeList![0];
    }

    if (registerUserAs != null) {
      instituteId = registerUserAs!.institutionId;
      personType = registerUserAs!.personTypeList![0];
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

    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode(

        {"search_val":searchValue,
          "person_id":prefs.getInt("userId").toString(),
          "business_id":instituteId,
          "page_number":1,"page_size":100}


    );

    Calls().call(body, context, Config.CLASSES_EXPERTISE).then((value) async {


      if (value != null) {
        var data = ClassesExpertises.fromJson(value);
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
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));

      _enabled = false;
    });
  }

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
          body: Container(
              child: Scaffold(
                  backgroundColor: HexColor(AppColors.appColorBackground),
                  body: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                        backgroundColor: HexColor(AppColors.appColorBackground),
                        body: NestedScrollView(
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
                                                registerUserAs!.academicYear =
                                                    acedemicYear;
                                            });
                                          }
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 16,
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
                                                                        child: Text(AppLocalizations.of(context)!.translate('selected_financial_year'),
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
                                  child: appListCard(
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
                                                          bottom: 0),
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
                                                        const EdgeInsets.only(left:16,right:16,top:4,bottom: 4),
                                                        child: Text(
                                                          personType == 3
                                                              ? AppLocalizations.of(
                                                              context)!
                                                              .translate(
                                                              "student_subj_inf")
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
                                                              context),
                                                        ),
                                                      ),
                                                    )),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 16,
                                                    bottom: 4,
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
                                                                listClasses![index]
                                                                    .className!,
                                                                style: styleElements
                                                                    .subtitle1ThemeScalable(
                                                                    context),
                                                                textAlign:
                                                                TextAlign.left,
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                        const EdgeInsets.all(4),
                                                        child: Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child: Checkbox(
                                                              activeColor:
                                                              HexColor(AppColors.appMainColor),
                                                              value:
                                                              listClasses![index]
                                                                  .isSelected,
                                                              onChanged: (val) {
                                                                if (this.mounted) {
                                                                  setState(() {
                                                                    if (val == true) {
                                                                      classId = listClasses![index]
                                                                          .classId
                                                                          .toString();
                                                                      className=listClasses![
                                                                      index].className;
                                                                      if (personType ==
                                                                          2 &&
                                                                          !isAddClass) {
                                                                        // if role type is teacher
                                                                        // let teachers select multiple classes
                                                                        setState(() {
                                                                          listClasses![
                                                                          index]
                                                                              .isSelected = true;
                                                                          selectedClasses.add(
                                                                              listClasses![
                                                                              index]);
                                                                        });
                                                                      } else {
                                                                        setState(() {
                                                                          // other roles can only select one class
                                                                          for (int i =
                                                                          0;
                                                                          i < listClasses!.length;
                                                                          i++) {
                                                                            if (i ==
                                                                                index) {
                                                                              listClasses![i].isSelected =
                                                                              true;
                                                                              selectedClasses
                                                                                  .add(listClasses![index]);
                                                                            } else {
                                                                              listClasses![i].isSelected =
                                                                              false;
                                                                              removeSelected(
                                                                                  listClasses![i].classId);
                                                                            }
                                                                          }
                                                                        });
                                                                      }
                                                                    } else {
                                                                      classId = "";

                                                                      listClasses![index]
                                                                          .isSelected =
                                                                      false;
                                                                      removeSelected(
                                                                          listClasses![
                                                                          index]
                                                                              .classId);
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

                                    child:
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
                                                  onPressed: () async {
                                                    if(classId!=null)
                                                    {
                                                      teachingClasses = [];
                                                      registerUserAs=RegisterUserAs();
                                                      PersonClasses proClass =
                                                      PersonClasses();
                                                      proClass.classId = int.parse(classId!);
                                                      proClass.className = className;
                                                      teachingClasses.add(proClass);
                                                      registerUserAs!.personClasses=teachingClasses;
                                                      registerUserAs!.academicYear=accedamicId;
                                                      registerUserAs!.institutionId=instituteId;
                                                      if (teachingClasses.isNotEmpty) {
                                                        if (isAddClass) {
                                                          if (classId != null &&
                                                              classId!.isNotEmpty) {
                                                            if (accedamicId != null &&
                                                                accedamicId!.isNotEmpty) {
                                                              var result=await   Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        SelectSectionExpertise(
                                                                            0,
                                                                            registerUserAs,
                                                                            false,
                                                                            null,
                                                                            false),
                                                                  ));
                                                              int? r=result['result'];
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                  context) =>
                                                                      SelectLanguageProficiencyDialogue(
                                                                          personId: prefs.getInt("userId"),
                                                                          type: "add_class",
                                                                          title:
                                                                          "My Relation In this Class",
                                                                          subtitle:
                                                                          "Rate yourself in this class",
                                                                          categoryType:
                                                                          "Class",
                                                                          id1: classId,
                                                                          id2: accedamicId,
                                                                          sectionId:r,

                                                                          instId: instituteId.toString(),
                                                                          callbackPicker: () {
                                                                            handleCallBack();
                                                                          }
                                                                      ));


                                                            } else {
                                                              ToastBuilder().showToast(
                                                                  "Please select academic year",
                                                                  context,HexColor(AppColors.information));
                                                            }
                                                          } else {
                                                            ToastBuilder().showToast(
                                                                "Please select class",
                                                                context,HexColor(AppColors.information));
                                                          }
                                                        }


                                                      }
                                                    }

                                                    else
                                                    {
                                                      handleCallBack();
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
                                        )))
                              ],
                            ))),
                  ))),
        ));
  }
  handleCallBack() async {

    if(widget.fromBasicProfileFLow)
    {
      var result =await   Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditEducation(null, false,widget.fromBasicProfileFLow,callbackPicker)));



      if (result != null && result['result'] == "success") {
        callbackPicker!();
        Navigator.of(context).pop({'result': "success"});
      }
    }
    else
      Navigator.of(context).pop({'result': "success"});


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
    registerUserAs!.personId = userId;
    print(teachingClasses.toString() +
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    registerUserAs!.personClasses = teachingClasses;
    final body = jsonEncode(registerUserAs);

    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {

        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => CustomDialogue(
                  type: type,
                  isVerified:data.rows!.isVerified,
                  title:AppLocalizations.of(context)!.translate('you_are_added_as')+ "Alumni ",
                  subtitle: (data.rows!.institutionName != null
                      ? " of " + data.rows!.institutionName!
                      : "")));
        } else
          ToastBuilder().showToast(data.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));

    });
  }
  Null Function()? callbackPicker;
  _SelectClasses(
      this.instituteId, this.registerUserAs, this.personType, this.isAddClass,this.callbackPicker);
}
