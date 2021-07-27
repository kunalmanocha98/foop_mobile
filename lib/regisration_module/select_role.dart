import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_earn_card.dart';
import 'package:oho_works_app/components/white_button_large.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/login_signup_module/call_back_page.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/code_verification.dart';
import 'package:oho_works_app/models/institute_list.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/regisration_module/years_entity.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'from_to_date_picker.dart';

// ignore: must_be_immutable
class SelectRole extends StatefulWidget {
  String type;
  int id;
  String studentType;
  String from;
  int? instituteId;
  Function(List<int?>?, String?)? callBack;

  SelectRole(
      {Key? key,
      required this.type,
      required this.id,
      required this.from,
      this.callBack,
      this.instituteId,
      required this.studentType})
      : super(key: key);

  _SelectRole createState() =>
      _SelectRole(type, id, studentType, from, instituteId);
}

class _SelectRole extends State<SelectRole>
    with SingleTickerProviderStateMixin {
  late int currentYear;
  List<YearsData> startYears = [];
  List<YearsData> passOutYear = [];
  String? studentType;
  String? from;
  bool isUploadImageActive = false;
  SharedPreferences? prefs;
  int? userId;
  String? selectSchoolUrl;
  bool isHaveCode = false;
  Color disabledColor = HexColor(AppColors.appColorGrey500);
  ScrollController? _scrollController;
  String? selectedSchool;
  String? selectedSchoolDec;
  String pageTitle = "";
  String? imageUrl;
  int instPageNumber = 1;
  String SearchVal = "";
  CupertinoDatePicker? cupertinoDatePicker;
  var color1 = HexColor(AppColors.appMainColor);
  bool _enabled = false;
  bool ifNoInstituteFound = false;
  var color2 = HexColor(AppColors.appColorWhite);
  int? id;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  late TabController _tabController;
  Map<String, bool> mapRules = Map();
  List<PersonItem>? listRoles = [];
  List<InstituteItem>? listInstitute = [];
  String? type;
  var isClassesSelected = HexColor(AppColors.appColorWhite);
  var isSubjectSelected = HexColor(AppColors.appColorWhite);
  var isRoleSelected = false;

  var isSearching = false;
  var isCallComplete = false;
  var isInstituteSelected = false;
  List<Subjects> listOfSubjects = [];
  List<InstituteClass> listOfClasses = [];
  List<int?> personTypeList = [];
  List<int?> institutionRolesList = [];
  List<int> teachingClasses = [];
  List<int> teachingSubjects = [];
  late TextStyleElements styleElements;

  _SelectRole(
      String type, int id, String studentType, String from, int? instituteId) {
    this.type = type;
    this.id = id;
    this.studentType = studentType;
    this.from = from;
    this.instituteId = instituteId;
  }

  List<TabMaker> list = [];
  int? instituteId;

  int _currentPosition = 0;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (from == "created institute") {
      _currentPosition == 1;
      selectedSchool = prefs!.getString(Strings.registeredInstituteName);
      selectSchoolUrl = prefs!.getString(Strings.registeredInstituteImage);
      instituteId = prefs!.getInt("createdSchoolId");
      isInstituteSelected = true;
      getRoles(null, instituteId);
    } else {
      getRoles(null, instituteId);
    }
  }

  @override
  void initState() {
    super.initState();
    getYears();
    getYearsdd();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  final controllerSearch = TextEditingController();
  int selectedEpoch = 0;
  bool isLoading = false;

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    setState(() async {
      Navigator.of(context).pop(true);
    });
    return new Future(() => false);
  }

  late BuildContext sctx;

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init;

    pageTitle = AppLocalizations.of(context)!.translate('role');

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: HexColor(AppColors.appColorWhite),
          body: new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new Container(
                child: Scaffold(
              backgroundColor: HexColor(AppColors.appColorWhite),
              body: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: HexColor(AppColors.appColorWhite),
                  body: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("                        "),
                              Text(pageTitle,
                                  style: styleElements
                                      .headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 16.0),
                                child: appElevatedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side:
                                          BorderSide(color: HexColor(AppColors.appMainColor))),
                                  onPressed: () {
                                    if (isRoleSelected) {
                                      _scrollToTop();
                                      {
                                        proceed(false);
                                      }
                                    } else {
                                      ToastBuilder().showSnackBar(
                                          AppLocalizations.of(context)!
                                              .translate("select_role"),
                                          sctx,
                                          HexColor(AppColors.information));
                                    }
                                  },
                                  color: HexColor(AppColors.appColorWhite),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("proceed"),
                                      style: styleElements
                                          .buttonThemeScalable(context)
                                          .copyWith(color: HexColor(AppColors.appMainColor))),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 65),
                              child: NotificationListener<ScrollNotification>(
                                  child: Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _enabled,
                                    child: PreloadingView(
                                        url: "assets/appimages/dice.png"),
                                  ),
                                  Visibility(
                                      child: Column(
                                    children: [
                                      /*  Visibility(

                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                    color: HexColor(AppColors.appMainColor10),
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight: Radius.circular(4.0),
                                                                        topLeft: Radius.circular(4.0))),
                                                                child: Container(
                                                                  margin: const EdgeInsets.all(16),
                                                                  child: Text(
                                                                    AppLocalizations.of(context)
                                                                        .translate("primary_role"),
                                                                    textAlign: TextAlign.center,
                                                                    style: styleElements
                                                                        .captionThemeScalable(context)
                                                                        .copyWith(color: HexColor(AppColors.appColorBlack85)),
                                                                  ),
                                                                ),
                                                              ),
                                                            )),*/
                                      Expanded(
                                        child: ListView.builder(
                                            controller: _scrollController,
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: 80,
                                                top: 8),
                                            itemCount: listRoles!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                child: Column(
                                                  children: <Widget>[
                                                    if (from ==
                                                        "created institute")
                                                      Visibility(
//                                    visible: !listInstitute[index].isLoading,
                                                          child: (listRoles![index]
                                                                          .personTypeId ==
                                                                      2 ||
                                                                  listRoles![index]
                                                                          .personTypeId ==
                                                                      3)
                                                              ? ListTile(
                                                                  tileColor: HexColor(
                                                                      AppColors
                                                                          .listBg),
                                                                  leading:
                                                                  CachedNetworkImage(
                                                                    height: 20,
                                                                    width: 20,
                                                                    imageUrl: Utility().getUrlForImage(listRoles![index].imageUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.PERSON) ,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  title: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      listRoles![index]
                                                                              .personTypeName ??
                                                                          "",
                                                                      style: styleElements
                                                                          .subtitle1ThemeScalable(
                                                                              context),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    ),
                                                                  ),
                                                                  subtitle:
                                                                      Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      listRoles![index]
                                                                              .personTypeDescription ??
                                                                          "",
                                                                      style: styleElements
                                                                          .bodyText2ThemeScalable(
                                                                              context),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                      Checkbox(
                                                                    activeColor:
                                                                        HexColor(
                                                                            AppColors.appMainColor),
                                                                    value: listRoles![
                                                                            index]
                                                                        .isSelected,
                                                                    onChanged:
                                                                        (val) {
                                                                      if (this
                                                                          .mounted) {
                                                                        setState(
                                                                            () {
                                                                          if (val ==
                                                                              true) {
                                                                            for (int i = 0;
                                                                                i < listRoles!.length;
                                                                                i++) {
                                                                              if (i == index) {
                                                                                isRoleSelected = true;
                                                                                listRoles![i].isSelected = true;
                                                                                type = listRoles![i].personTypeName;
                                                                                id = listRoles![i].personTypeId;
                                                                              } else
                                                                                listRoles![i].isSelected = false;
                                                                            }
                                                                          } else {
                                                                            isRoleSelected =
                                                                                false;
                                                                            listRoles![index].isSelected =
                                                                                false;
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                  ))
                                                              : Container())
                                                    else
                                                      Visibility(
//                                    visible: !listInstitute[index].isLoading,
                                                          child: ListTile(
                                                              tileColor: HexColor(
                                                                  AppColors
                                                                      .listBg),

                                                              leading:
                                                              CachedNetworkImage(
                                                                height: 20,
                                                                width: 20,
                                                                imageUrl: Utility().getUrlForImage(listRoles![index].imageUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.PERSON) ,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              title:


                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  listRoles![index]
                                                                          .personTypeName ??
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
                                                                  listRoles![index]
                                                                          .personTypeDescription ??
                                                                      "",
                                                                  style: styleElements
                                                                      .bodyText2ThemeScalable(
                                                                          context),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              trailing:
                                                                  Checkbox(
                                                                activeColor:
                                                                    HexColor(
                                                                        AppColors
                                                                            .appMainColor),
                                                                value: listRoles![
                                                                        index]
                                                                    .isSelected,
                                                                onChanged:
                                                                    (val) {
                                                                  if (this
                                                                      .mounted) {
                                                                    setState(
                                                                        () {
                                                                      if (val ==
                                                                          true) {
                                                                        for (int i =
                                                                                0;
                                                                            i < listRoles!.length;
                                                                            i++) {
                                                                          if (i ==
                                                                              index) {
                                                                            isRoleSelected =
                                                                                true;
                                                                            listRoles![i].isSelected =
                                                                                true;
                                                                            type =
                                                                                listRoles![i].personTypeName;
                                                                            id =
                                                                                listRoles![i].personTypeId;
                                                                          } else
                                                                            listRoles![i].isSelected =
                                                                                false;
                                                                        }
                                                                      } else {
                                                                        isRoleSelected =
                                                                            false;
                                                                        listRoles![index].isSelected =
                                                                            false;
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                              )))
                                                  ],
                                                ),
                                                onTap: () {},
                                              );
                                            }),
                                      ),
                                    ],
                                  )),
                                ],
                              )),
                            ),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            child: Container(
                              height: 60,
                              color: HexColor(AppColors.appColorWhite),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Visibility(
                                          visible: false,
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('skip_this_now'),
                                              style: styleElements
                                                  .bodyText2ThemeScalable(
                                                      context),
                                            ),
                                          )),
                                      Visibility(
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
                                              if (isRoleSelected) {
                                                _scrollToTop();
                                                {
                                                  proceed(false);
                                                }
                                              } else {
                                                ToastBuilder().showSnackBar(
                                                    AppLocalizations.of(context)!
                                                        .translate(
                                                            "select_role"),
                                                    sctx,
                                                    HexColor(
                                                        AppColors.information));
                                              }
                                            },
                                            color:HexColor(AppColors.appColorWhite),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate("next"),
                                                style: styleElements
                                                    .buttonThemeScalable(
                                                        context)
                                                    .copyWith(
                                                        color:
                                                        HexColor(AppColors.appMainColor))),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ))
                    ],
                  )),
            ));
          }),
        )));
  }

  Future<void> proceed(bool isVerified) async {
    var payload = RegisterUserAs();

    personTypeList = [];
    institutionRolesList = [];
    payload.institutionId = instituteId;
    payload.personId = userId;
    personTypeList.add(id);
    payload.personTypeList = personTypeList;
    for (var item in listRoles!) {
      if (item.isSelected!) {
        institutionRolesList.add(item.personTypeId);
      }
    }
    payload.personTypeList = institutionRolesList;

    if (institutionRolesList[0] == 5) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) => DatePickerFromTo(
                ctx: context,
                startYears: startYears,
                passOutYear: passOutYear,
                selectDateCallBack: (String? academicYears) {
                  if (academicYears != null && academicYears != "") {
                    print(academicYears);
                    exit(institutionRolesList, academicYears);
                  } else
                    ToastBuilder().showSnackBar(
                        AppLocalizations.of(context)!
                            .translate("financial_years"),
                        sctx,
                        HexColor(AppColors.information));
                },
              ));
    } else {
      exit(institutionRolesList, "");
    }
  }

  void exit(List<int?> list, String academicYears) {
    Navigator.of(context).pop({
      'institutionRolesList': institutionRolesList,
      "academicYears": academicYears
    });
    widget.callBack!(institutionRolesList, academicYears);
  }

  Future<void> getYears() async {
    currentYear = DateTime.now().year;

    for (int i = 0; i < 150; i++) {
      YearsData yearsData = YearsData();
      yearsData.isSelected = false;
      yearsData.yearName = (currentYear - i).toString();
      passOutYear.add(yearsData);
    }

    setState(() {});
  }

  Future<void> getYearsdd() async {
    currentYear = DateTime.now().year;
    for (int i = 0; i < 150; i++) {
      YearsData yearsData = YearsData();
      yearsData.isSelected = false;
      yearsData.yearName = (currentYear - i).toString();
      startYears.add(yearsData);
    }

    setState(() {});
  }

  void getRoles(String? searchValue, int? instituteId) async {
    _enabled = true;
    final body = jsonEncode({
      "institution_id": instituteId,
      "searchVal": searchValue,
    });
    Calls().call(body, context, Config.PERSON_LIST).then((value) async {
      if (value != null) {
        var data = PersonTypeList.fromJson(value);
        setState(() {
          _enabled = false;
          listRoles = data.rows;
          for (int i = 0; i < listRoles!.length; i++) {
            listRoles![i].isSelected = false;
          }

          if (from == "created institute") {
            setState(() {
              _scrollToTop();
              pageTitle = "Select role";
              _currentPosition = _currentPosition + 1;
            });
          }
        });
      }
    }).catchError((onError) async {});
  }

  _scrollToTop() {
    _scrollController!.animateTo(_scrollController!.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
  }

  void getListOfInstitutes(String searchValue) async {
    final body = jsonEncode({
      "searchVal": searchValue,
      "page_number": instPageNumber,
      "page_size": 30
    });
    Calls().call(body, context, Config.INSTITUTE_LIST).then((value) async {
      if (value != null) {
        isCallComplete = true;
        var data = InstituteList.fromJson(value);
        if (data != null && data.statusCode == Strings.success_code) {
          isLoading = false;
          if (data.rows != null && data.rows!.isNotEmpty) {
            for (int i = 0; i < data.rows!.length; i++) {
              // already selected institute mark red
              if (instituteId != null) {
                if (data.rows![i].id == instituteId)
                  data.rows![i].isSelected = true;
                else
                  data.rows![i].isSelected = false;
              } else {
                data.rows![i].isSelected = false;
              }
            }
            if (isSearching) {
              listInstitute = data.rows;
            } else {
              if (listInstitute!.length > 0)
                listInstitute!.removeAt(listInstitute!.length - 1);
              instPageNumber = instPageNumber + 1;
              listInstitute = listInstitute! + data.rows!;
            }
            setState(() {
              ifNoInstituteFound = false;
            });
          } else {
            if (isSearching) {
              //if searching and no data found show no institute layout
              if (searchValue != "" && searchValue != null) {
                ifNoInstituteFound = true;
              }
            } else {
              if (listInstitute != null && listInstitute!.length > 0)
                listInstitute!.removeAt(listInstitute!.length - 1);
              if (listInstitute!.length == 0)
                ifNoInstituteFound = true;
              else
                ifNoInstituteFound = false;
            }

            setState(() {});
          }
        } else {
          if (listInstitute!.length > 0)
            listInstitute!.removeAt(listInstitute!.length - 1);
          setState(() {});
        }
      } else {
        isCallComplete = true;
      }
    }).catchError((onError) {
      isCallComplete = true;
    });
  }

  void getPersonProfile() async {
    prefs = await SharedPreferences.getInstance();

    final body = jsonEncode({"person_id": null});

    Calls().call(body, context, Config.PERSONAL_PROFILE).then((value) async {
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var data = PersonalProfile.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {
              Persondata? persondata = data.rows;
              DataSaveUtils().saveUserData(prefs, persondata);
              if (from == "welcome") prefs!.setBool("isProfileCreated", false);
            }
          });
        }
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void verifyCode(BuildContext ctx, String value) async {
    final body =
        jsonEncode({"invitation_code": value, "institution_id": instituteId});
    Calls().call(body, context, Config.CODE_VERIFICATION).then((value) async {
      if (value != null) {
        var data = CodeVerification.fromJson(value);
        if (data != null && data.statusCode == "S10001") {
          if (data.rows!.isValid!) {
            proceed(true);
          } else {
            ToastBuilder().showSnackBar(
                AppLocalizations.of(context)!.translate("codeV"),
                sctx,
                HexColor(AppColors.information));
          }
        }
      }
    }).catchError((onError) {});
  }
}

// ignore: must_be_immutable
class NoInstitutePage extends StatelessWidget {
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: HexColor(AppColors.appColorBackground)),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          color: HexColor(AppColors.appMainColor10),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.0),
                              topLeft: Radius.circular(4.0))),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("if_no_inst_found"),
                          textAlign: TextAlign.center,
                          style: styleElements
                              .captionThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appColorBlack85)),
                        ),
                      ),
                    ),
                    appEarnCard(
                      title: AppLocalizations.of(context)!.translate('register'),
                      imageUrl: "",
                      coinsValue: "100",
                      moneyVal: "1000",
                      quote: '',
                      isClickable: true,
                      type: "register__entity",
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(AppLocalizations.of(context)!.translate('or'),
                          textAlign: TextAlign.center,
                          style: styleElements.captionThemeScalable(context)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 55),
                        child: WhiteLargeButton(
                          name: AppLocalizations.of(context)!
                              .translate("request_callback"),
                          offsetX: 70.66,
                          offsetY: 12.93,
                          callback: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallBackPage(),
                                ));
                          },
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  void signUp() {}
}

class TabMaker {
  String? tabName;
  Widget? statelessWidget;

  TabMaker({this.tabName, this.statelessWidget});
}
