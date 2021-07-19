import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/regisration_module/subjects_page_new.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes_section_page_new.dart';
import 'disicipline_page.dart';
import 'new_program_page.dart';

// ignore: must_be_immutable
class AcademicInformationPage extends StatefulWidget {
  bool isInstituteSelectedAlready;
  bool isEdit;
  int institutionIdtoDelete;
  Function (RegisterUserAs)callBack;
  RegisterUserAs registerUserAs;

  _AcademicInformationPage createState() => _AcademicInformationPage(isInstituteSelectedAlready);

  AcademicInformationPage(
      {this.isInstituteSelectedAlready,
        this.isEdit = false,
        this.callBack,
       this. registerUserAs,
        this.institutionIdtoDelete});
}

class _AcademicInformationPage extends State<AcademicInformationPage> {
  List<PersonItem> rows = [];
  ProgressDialog pr;
  SharedPreferences prefs;
  BuildContext context;
  String type = "";
  bool isInstituteSelected;
  TextStyleElements styleElements;
 
  int instituteId;
  bool isInstituteSelectedAlready = false;
  bool isRoleSelected = true;
  bool showLimited=false;
  bool isProgramSelected = false;
  bool isDepartmentSelected = false;
  bool isClassSelected = false;
  bool isSubjectSelected = false;
  bool isDepartment = false;
  bool isLoading = false;
  bool isSubjectVisible = false;
  bool isStepsCompleted = false;
  final db = DatabaseHelper.instance;
  List<int> institutionRolesList = [];

  @override
  void initState() {
    super.initState();
    
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (isInstituteSelectedAlready != null && isInstituteSelectedAlready) {
      instituteId = prefs.getInt("createdSchoolId");
      
     widget. registerUserAs.institutionId = instituteId;
      setState(() {
        isInstituteSelected = true;
        isRoleSelected = false;
        isProgramSelected = false;
        isDepartmentSelected = false;
        isDepartment = false;
        isClassSelected = false;
        isSubjectSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    isRoleSelected = true;
    isProgramSelected = false;
    isDepartmentSelected = false;
    isClassSelected = false;
    isSubjectSelected = false;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,

          body: Container(
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 30),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("                        "),
                          Text( AppLocalizations.of(context).translate('update'),
                              style: styleElements
                                  .headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                right: 16.0),
                            child: TricycleElevatedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side:
                                  BorderSide(color: Colors.redAccent)),
                              onPressed: () {
                                Navigator.of(context).pop();
                                widget.callBack(widget.registerUserAs);
                              },
                              color: Colors.white,
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("proceed"),
                                  style: styleElements
                                      .buttonThemeScalable(context)
                                      .copyWith(color: Colors.redAccent)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Opacity(
                              opacity: isRoleSelected ? 1.0 : 0.25,
                              child: Visibility(
                                visible: !showLimited,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: TricycleCard(
                                    child: ListTile(
                                        tileColor: HexColor(AppColors.listBg),
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("program_selection"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).translate(
                                                "select_institute_program"),
                                            style: styleElements
                                                .bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        trailing: Visibility(
                                          visible: widget.registerUserAs.personPrograms!=null && widget.registerUserAs.personPrograms.isNotEmpty,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: HexColor(AppColors.appColorGreen),
                                            size: 20,
                                          ),
                                        )),
                                  ),
                                  onTap: () async {
                                    if (isRoleSelected) {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectProgramNew(
                                              0,
                                              widget.registerUserAs,
                                              false,
                                              null,
                                              false,
                                            ),
                                          ));

                                      if (result != null &&
                                          result['registerUserAs'] != null) {


                                        widget.registerUserAs = result['registerUserAs'];
                                        isDepartment = widget.registerUserAs.isDepartment;
                                        isProgramSelected = true;
                                        isDepartmentSelected = false;
                                        isClassSelected = false;
                                        isSubjectSelected = false;
                                        if (!isDepartment)
                                          isDepartmentSelected = true;
                                        setState(() {
print(jsonEncode(widget.registerUserAs));
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isDepartment && type != "Other Staff",
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: TricycleCard(
                                  child: ListTile(
                                      tileColor: HexColor(AppColors.listBg),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("discipline"),
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context).translate(
                                              "select_institute_discipline"),
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      trailing: Visibility(
                                        visible: widget.registerUserAs.personDepartments!=null && widget.registerUserAs.personDepartments.isNotEmpty,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: HexColor(AppColors.appColorGreen),
                                          size: 20,
                                        ),
                                      )),
                                ),
                                onTap: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectDiscipline(
                                            0, widget.registerUserAs, false, null, false),
                                      ));

                                  if (result != null &&
                                      result['registerUser'] != null) {
                                    widget.registerUserAs = result['registerUser'];
                                    if (widget.registerUserAs.personDepartments != null) {
                                      print(
                                          jsonEncode(widget.registerUserAs.personDepartments));
                                      setState(() {
                                        isDepartmentSelected = true;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Opacity(
                              opacity:widget.registerUserAs.isDepartment!=null && widget.registerUserAs.isDepartment

                                  ||widget.registerUserAs.personPrograms!=null && widget.registerUserAs.personPrograms.isNotEmpty&&widget.registerUserAs.isDepartment!=null && !widget.registerUserAs.isDepartment

                                  ? 1.0 : 0.25,
                              child: Visibility(
                                visible: type != "Other Staff",
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: TricycleCard(
                                    child: ListTile(
                                        tileColor: HexColor(AppColors.listBg),
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("classes_subjects"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).translate(
                                                "select_institute_class_sec"),
                                            style: styleElements
                                                .bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        trailing: Visibility(
                                          visible: widget.registerUserAs.personClasses!=null && widget.registerUserAs.personClasses.isNotEmpty,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: HexColor(AppColors.appColorGreen),
                                            size: 20,
                                          ),
                                        )),
                                  ),
                                  onTap: () async {

                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                selectClassesAndSections(0,
                                                    widget.registerUserAs, false, null, false),
                                          ));

                                      if (result != null &&
                                          result['registerUser'] != null) {
                                        widget.registerUserAs = result['registerUser'];
                                        print(jsonEncode(widget.registerUserAs) +
                                            "--------------------------------------------------");
                                        if (widget.registerUserAs.personClasses != null) {
                                          isClassSelected = true;
                                          isStepsCompleted = true;
                                        }
                                        setState(() {});
                                      }

                                  },
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: isClassSelected ? 1.0 : 0.25,
                              child: Visibility(
                                visible: isSubjectVisible && type != "Other Staff",
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: TricycleCard(
                                    child: ListTile(
                                        tileColor: HexColor(AppColors.listBg),
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("subjects"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("select_institute_sub"),
                                            style: styleElements
                                                .bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        trailing: Visibility(
                                          visible: isSubjectSelected,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: HexColor(AppColors.appColorGreen),
                                            size: 20,
                                          ),
                                        )),
                                  ),
                                  onTap: () async {
                                    if (isClassSelected) {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SubjectsPageNew(
                                                0, widget.registerUserAs, false, null, false),
                                          ));

                                      if (result != null &&
                                          result['registerUser'] != null) {
                                        widget.registerUserAs = result['registerUser'];
                                        print(jsonEncode(widget.registerUserAs) +
                                            "--------------------------------------------------");
                                        if (widget.registerUserAs.personSubjects != null) {
                                          isSubjectSelected = true;
                                          isStepsCompleted = true;
                                        }

                                        setState(() {});
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child:   TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.callBack(widget.registerUserAs);
                          },
                          child: Text(AppLocalizations.of(context).translate("skip"), ),
                        ),
                      )

                    ],
                  )))),
    );
  }

  void register() async {
    widget.registerUserAs.personId = prefs.getInt("userId");
    widget.registerUserAs.personTypeList[0] == 2
        ? type = "teacher"
        : widget.registerUserAs.personTypeList[0] == 3
        ? type = "student"
        : widget.registerUserAs.personTypeList[0] == 4
        ? "parent"
        : "alumni";

    widget.registerUserAs.personSubjects ??= [];
    widget.registerUserAs.deleted_institution_user_id = widget.institutionIdtoDelete;
    final body = jsonEncode(widget.registerUserAs);
    setState(() {
      isLoading = true;
    });

    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        setState(() {
          isLoading = false;
        });
        if (data.statusCode == "S10001") {
          if (widget.isEdit) {
            Navigator.pop(context, true);
          } else {
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
          }
        } else
          ToastBuilder().showToast(
              data.message, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      setState(() {
        isLoading = false;
      });
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  _AcademicInformationPage(this.isInstituteSelectedAlready);
}
