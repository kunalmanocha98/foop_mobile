import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/regisration_module/select_institute_screen.dart';
import 'package:oho_works_app/regisration_module/select_role.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/ui/student_serach_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class WelComeScreen extends StatefulWidget {
  bool? isInstituteSelectedAlready;
  bool isEdit;
  int? institutionIdtoDelete;

  _WelComeScreen createState() => _WelComeScreen(isInstituteSelectedAlready);

  WelComeScreen(
      {this.isInstituteSelectedAlready,
      this.isEdit = false,
      this.institutionIdtoDelete});
}

class _WelComeScreen extends State<WelComeScreen> {
  List<PersonItem> rows = [];
  ProgressDialog? pr;
  late SharedPreferences prefs;
  late BuildContext context;
  String type = "";
  bool? isInstituteSelected;
  late TextStyleElements styleElements;
  RegisterUserAs? registerUser;
  int? instituteId;
  bool? isInstituteSelectedAlready = false;
  bool isRoleSelected = false;
  bool showLimited = false;
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => showRoles());
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    registerUser = RegisterUserAs();
    if (isInstituteSelectedAlready != null && isInstituteSelectedAlready!) {
      instituteId = prefs.getInt("createdSchoolId");

      registerUser!.institutionId = instituteId;
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

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBar(
            context,
            actions: [
              Visibility(
                visible: isStepsCompleted,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (registerUser!.personTypeList![0] == 4) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentsPageNew(registerUser),
                            ));
                      } else
                        register();
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('next'),
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appMainColor)),
                        ),
                        Visibility(
                          visible: isLoading,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
            appBarTitle:
                AppLocalizations.of(context)!.translate('update_profile'),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Container(
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 50, bottom: 20),
                  child: ListView(
                    children: [
                      Opacity(
                        opacity: 1.0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: appCard(
                            child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("select_role_p"),
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("select_entity_role"),
                                    style: styleElements
                                        .bodyText2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                trailing: Visibility(
                                  visible: isRoleSelected,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: HexColor(AppColors.appColorGreen),
                                    size: 20,
                                  ),
                                )),
                          ),
                          onTap: () async {
                            showRoles();
                          },
                        ),
                      ),
                      Visibility(
                        visible: registerUser != null &&
                            registerUser!.personTypeList != null &&
                            registerUser!.personTypeList!.isNotEmpty &&
                            (isInstituteSelectedAlready == null ||
                                !isInstituteSelectedAlready!),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: appCard(
                            child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("institute"),
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("select_entity_text"),
                                    style: styleElements
                                        .bodyText2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                trailing: Visibility(
                                  visible: isInstituteSelected != null &&
                                      isInstituteSelected!,
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
                                  builder: (context) => SelectInstitute(
                                      type: "",
                                      id: 0,
                                      registerUserAs: registerUser,
                                      isInstituteSelectedAlready:
                                          isInstituteSelectedAlready,
                                      studentType: "",
                                      from: "welcome"),
                                ));
                            if (result != null &&
                                result['registerUserdata'] != null) {
                              registerUser = result['registerUserdata'];
                              setState(() {
                                isInstituteSelected = true;
                              });
                            }
                          },
                        ),
                      ),

                      /*  Opacity(
                        opacity: isRoleSelected ? 1.0 : 0.25,
                        child: Visibility(
                          visible: !showLimited,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(
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
                                          "select_entity_program"),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: isProgramSelected,
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
                                        registerUser,
                                        false,
                                        null,
                                        false,
                                      ),
                                    ));

                                if (result != null &&
                                    result['registerUserAs'] != null) {
                                  registerUser = result['registerUserAs'];
                                  isDepartment = registerUser.isDepartment;
                                  setState(() {
                                    isProgramSelected = true;
                                    isDepartmentSelected = false;
                                    isClassSelected = false;
                                    isSubjectSelected = false;
                                    if (!isDepartment)
                                      isDepartmentSelected = true;
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
                          child: appCard(
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
                                        "select_entity_discipline"),
                                    style: styleElements
                                        .bodyText2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                trailing: Visibility(
                                  visible: isDepartmentSelected,
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
                                      0, registerUser, false, null, false),
                                ));

                            if (result != null &&
                                result['registerUser'] != null) {
                              registerUser = result['registerUser'];
                              if (registerUser.personDepartments != null) {
                                print(
                                    jsonEncode(registerUser.personDepartments));
                                setState(() {
                                  isDepartmentSelected = true;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      Opacity(
                        opacity: isDepartmentSelected ? 1.0 : 0.25,
                        child: Visibility(
                          visible: type != "Other Staff",
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(
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
                                          "select_entity_class_sec"),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: isClassSelected,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              if (isDepartmentSelected) {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          selectClassesAndSections(0,
                                              registerUser, false, null, false),
                                    ));

                                if (result != null &&
                                    result['registerUser'] != null) {
                                  registerUser = result['registerUser'];
                                  print(jsonEncode(registerUser) +
                                      "--------------------------------------------------");
                                  if (registerUser.personClasses != null) {
                                    isClassSelected = true;
                                    isStepsCompleted = true;
                                  }
                                  setState(() {});
                                }
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
                            child: appCard(
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
                                          .translate("select_entity_sub"),
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
                                          0, registerUser, false, null, false),
                                    ));

                                if (result != null &&
                                    result['registerUser'] != null) {
                                  registerUser = result['registerUser'];
                                  print(jsonEncode(registerUser) +
                                      "--------------------------------------------------");
                                  if (registerUser.personSubjects != null) {
                                    isSubjectSelected = true;
                                    isStepsCompleted = true;
                                  }

                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                      ),*/
                    ],
                  )))),
    );
  }

  void showRoles() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Card(
            child: SelectRole(
                type: "",
                id: 0,
                studentType: "",
                callBack: ( institutionRolesList,  academicYears)
                {
                  if (institutionRolesList != null &&
                      institutionRolesList.isNotEmpty) {
                    if (institutionRolesList[0] == 3)
                      type = AppLocalizations.of(context)!.translate("student");
                    if (institutionRolesList[0] == 2)
                      type = AppLocalizations.of(context)!.translate("teacher");
                    if (institutionRolesList[0] == 4)
                      type = AppLocalizations.of(context)!.translate("parent");
                    if (institutionRolesList[0] == 5) {
                      type = AppLocalizations.of(context)!.translate("alumni");
                      isStepsCompleted = true;
                      showLimited = true;

                      registerUser!.academicYear = academicYears;
                    }
                    if (institutionRolesList[0] == 10) {
                      isStepsCompleted = true;
                      showLimited = true;
                      type = AppLocalizations.of(context)!
                          .translate("other_staff");
                    }
                    registerUser!.personTypeList = institutionRolesList;
                  }
                  setState(() {
                    showLimited = true;
                    isRoleSelected = true;
                    isStepsCompleted = true;

                    handleEdit();
                  });
                },
                instituteId: instituteId,
                from: "welcome"),
          ),
        );
      },
    );
  }

  Future<void> handleEdit() async {
    if (widget.isEdit != null &&
        widget.isEdit &&
        widget.institutionIdtoDelete != null) {
      registerUser!.institutionId = widget.institutionIdtoDelete;
      setState(() {
        isInstituteSelected = true;
      });
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectInstitute(
                type: "",
                id: 0,
                registerUserAs: registerUser,
                isInstituteSelectedAlready: isInstituteSelectedAlready,
                studentType: "",
                from: "welcome"),
          ));
      if (result != null && result['registerUserdata'] != null) {
        registerUser = result['registerUserdata'];
        setState(() {
          isInstituteSelected = true;
        });
      }
    }
  }

  void register() async {
    registerUser!.personId = prefs.getInt("userId");
    registerUser!.personTypeList![0] == 2
        ? type = "teacher"
        : registerUser!.personTypeList![0] == 3
            ? type = "student"
            : registerUser!.personTypeList![0] == 4
                ? "parent"
                : "alumni";

    registerUser!.personSubjects ??= [];
    registerUser!.deleted_institution_user_id = widget.institutionIdtoDelete;
    final body = jsonEncode(registerUser);
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
                        isVerified: data.rows!.isVerified,
                        title: AppLocalizations.of(context)!
                                .translate('you_are_added_as') +
                            type,
                        subtitle: type == "parent"
                            ? ((data.rows!.studentName != null
                                    ? "of" + data.rows!.studentName!
                                    : "") +
                                (data.rows!.institutionName != null
                                    ? " of " + data.rows!.institutionName!
                                    : ""))
                            : (data.rows!.institutionName != null
                                ? " of " + data.rows!.institutionName!
                                : ""))),
                (Route<dynamic> route) => false);
          }
        } else
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      setState(() {
        isLoading = false;
      });
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  _WelComeScreen(this.isInstituteSelectedAlready);
}
