import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/components/white_button_large.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/code_verification.dart';
import 'package:oho_works_app/models/institute_list.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/empty_widget.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/regisration_detail_page.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/datasave.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/camera_module/photo_preview_screen.dart';
import 'accedemic_information_page.dart';
import 'non_validate_institute.dart';

// ignore: must_be_immutable
class SelectInstitute extends StatefulWidget {
  String type;
  int id;
  String studentType;
  String from;
  bool? isInstituteSelectedAlready;
  RegisterUserAs? registerUserAs;

  SelectInstitute(
      {Key? key,
      required this.type,
      required this.id,
      required this.from,
        this.registerUserAs,
      this.isInstituteSelectedAlready,
      required this.studentType})
      : super(key: key);

  _SelectInstitute createState() =>
      _SelectInstitute(type, id, studentType, from, isInstituteSelectedAlready);
}

class _SelectInstitute extends State<SelectInstitute>
    with SingleTickerProviderStateMixin {
  bool? isInstituteSelectedAlready;
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
  final _debouncer = Debouncer(100);
  CupertinoDatePicker? cupertinoDatePicker;
  var color1 = HexColor(AppColors.appMainColor);
  bool _enabled = false;
  bool _enabledInstitute = true;
  bool ifNoInstituteFound = false;
  var color2 = HexColor(AppColors.appColorWhite);
  int? id;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  TabController? _tabController;
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

  _SelectInstitute(String type, int id, String studentType, String from,
      bool? isInstituteSelectedAlready) {
    this.type = type;
    this.id = id;
    this.studentType = studentType;
    this.from = from;
    this.isInstituteSelectedAlready = isInstituteSelectedAlready;
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
    }

    if(widget.registerUserAs!=null && widget.registerUserAs!.institutionId!=null)
      {
        getAdditionDetails();

      }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    if (from != "created institute") getListOfInstitutes(" ");
    getPersonProfile();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setSharedPreferences());
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  final controllerSearch = TextEditingController();
  int selectedEpoch = 0;
  bool isLoading = false;

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    setState(() async {
      if (from == "created institute") {
        Navigator.of(context).pop(true);
      } else {
        if (_currentPosition == 0) {
          Navigator.of(context).pop(true);
        }
        if (_currentPosition == 1) {
          setState(() {
            _currentPosition = 0;
          });
        }
      }
    });
    return new Future(() => false);
  }

  late BuildContext sctx;

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init;


    list = [];
    list.add(TabMaker(
      tabName: AppLocalizations.of(context)!.translate('select_entity'),
      statelessWidget: Container(
        margin: const EdgeInsets.only(bottom: 65),
        child: NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (ScrollNotification? scrollInfo) {
              if (!isLoading &&
                  scrollInfo!.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                setState(() {
                  isLoading = true;
                  if (!_enabledInstitute && SearchVal.length == 0) {
                    var load = InstituteItem();
                    load.isLoading = true;
                    load.name = "";
                    load.description = "";
                    load.isSelected = false;
                    listInstitute!.add(load);
                  }
                });
                if (!isSearching) getListOfInstitutes(" ");
              }
              return true;
            } ,
            child: Stack(
              children: <Widget>[
                Visibility(
                  visible: _enabledInstitute,
                  child: PreloadingView(url: "assets/appimages/dice.png"),
                ),
                Visibility(
                    visible: ifNoInstituteFound, child: NoInstitutePage()),
                Visibility(
                    visible: !ifNoInstituteFound,
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 80, top: 8),
                        itemCount: listInstitute!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                    visible: index == 0,
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                          color: HexColor(
                                              AppColors.appMainColor10),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4.0),
                                              topLeft: Radius.circular(4.0))),
                                      child: Container(
                                        margin: const EdgeInsets.all(16),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                                  "select_right_entity"),
                                          textAlign: TextAlign.center,
                                          style: styleElements
                                              .captionThemeScalable(context)
                                              .copyWith(
                                                  color: HexColor(AppColors
                                                      .appColorBlack85)),
                                        ),
                                      ),
                                    )),
                                Visibility(
                                    visible: listInstitute![index].isLoading,
                                    child: Container(
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            child: Column(children: [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ]),
                                          )),
                                    )),
                                Visibility(
                                    visible: !listInstitute![index].isLoading,
                                    child: Container(
                                      margin: const EdgeInsets.only(),
                                      child: ListTile(
                                          tileColor: HexColor(AppColors.listBg),
                                          leading: SizedBox(
                                              width: 52,
                                              height: 52,
                                              child: TricycleAvatar(
                                                key: UniqueKey(),
                                                imageUrl: listInstitute![index]
                                                    .profileImage,
                                                service_type:
                                                    SERVICE_TYPE.INSTITUTION,
                                                resolution_type:
                                                    RESOLUTION_TYPE.R64,
                                                size: 52,
                                              )),
                                          title: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              listInstitute![index].name ?? "",
                                              style: styleElements
                                                  .subtitle1ThemeScalable(
                                                      context),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          subtitle: new RichText(
                                            text: new TextSpan(
                                              style: new TextStyle(
                                                fontSize: 10.0,
                                                color: HexColor(
                                                    AppColors.appColorBlack),
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text: listInstitute![index]
                                                                .institutionAddress !=
                                                            null
                                                        ? listInstitute![index]
                                                                .institutionAddress!
                                                                .streetAddress ??
                                                            ""
                                                        : "",
                                                    style: styleElements
                                                        .captionThemeScalable(
                                                            context)),
                                                new TextSpan(
                                                    text: (listInstitute![index]
                                                                    .isRegistered !=
                                                                null &&
                                                            listInstitute![index]
                                                                .isRegistered! &&
                                                            listInstitute![index]
                                                                    .isValidated !=
                                                                null &&
                                                            listInstitute![index]
                                                                .isValidated!)
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                "registered")
                                                        : "",
                                                    style: styleElements
                                                        .overlineThemeScalable(
                                                            context)
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: HexColor(
                                                                AppColors
                                                                    .appColorGreen))),
                                              ],
                                            ),
                                          )

                                          /*Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(

                                          listInstitute[index]
                                                      .institutionAddress !=
                                                  null
                                              ? listInstitute[index]
                                                      .institutionAddress
                                                      .streetAddress ??
                                                  ""
                                              : "",
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,

                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Visibility(
                                        visible:listInstitute[index].isRegistered ,
                                        child: Flexible(
                                          child: Text(
                                           AppLocalizations.of(context).translate("registered"),
                                            style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorGreen),fontSize: 10,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  )*/
                                          ,
                                          trailing: Column(
                                            children: [
                                              Checkbox(
                                                activeColor:
                                                    HexColor(AppColors.appMainColor),
                                                value: listInstitute![index]
                                                    .isSelected,
                                                onChanged: (val) {
                                                  if (this.mounted) {
                                                    setState(() {
                                                      if (val == true) {
                                                        if (listInstitute![index]
                                                            .isValidated!) {
                                                          for (int i = 0;
                                                              i <
                                                                  listInstitute!
                                                                      .length;
                                                              i++) {
                                                            if (i == index) {
                                                              instituteId =
                                                                  listInstitute![
                                                                          i]
                                                                      .id;
                                                              isInstituteSelected =
                                                                  true;
                                                              listInstitute![i]
                                                                      .isSelected =
                                                                  true;
                                                              getRoles(null,
                                                                  instituteId);
                                                              selectSchoolUrl = Config
                                                                          .BASE_URL +
                                                                      (listInstitute![i].profileImage !=
                                                                              null
                                                                          ? listInstitute![i]
                                                                              .profileImage!
                                                                          : "");
                                                              selectedSchool =
                                                                  listInstitute![
                                                                              i]
                                                                          .name ??
                                                                      "";
                                                              listInstitute![i]
                                                                      .name ??
                                                                  "";
                                                              selectedSchoolDec = listInstitute![
                                                                              i]
                                                                          .institutionAddress !=
                                                                      null
                                                                  ? listInstitute![
                                                                              i]
                                                                          .institutionAddress!
                                                                          .streetAddress ??
                                                                      ""
                                                                  : "";
                                                            } else
                                                              listInstitute![i]
                                                                      .isSelected =
                                                                  false;
                                                          }
                                                        } else {
                                                          prefs!.setString(
                                                              Strings
                                                                  .registeredInstituteName,
                                                              listInstitute![
                                                                          index]
                                                                      .name ??
                                                                  "");
                                                          prefs!.setString(
                                                              Strings
                                                                  .registeredInstituteImage,
                                                              listInstitute![
                                                                          index]
                                                                      .profileImage ??
                                                                  "");
                                                          prefs!.setInt(
                                                              "createdSchoolId",
                                                              listInstitute![
                                                                      index]
                                                                  .id!);
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  NonValidatedDialog(
                                                                      listInstitute![
                                                                              index]
                                                                          .id));
                                                        }
                                                      } else {
                                                        instituteId = null;
                                                        isInstituteSelected =
                                                            false;
                                                        listInstitute![index]
                                                            .isSelected = false;
                                                        selectedSchool = null;
                                                        selectedSchoolDec =
                                                            null;
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          )),
                                    ))
                              ],
                            ),
                            onTap: () {},
                          );
                        })),
              ],
            )),
      ),
    ));

    list.add(TabMaker(
      tabName: AppLocalizations.of(context)!.translate('select_role_p'),
      statelessWidget: Container(
        margin: const EdgeInsets.only(bottom: 65),
        child: NotificationListener<ScrollNotification>(
            child: Stack(
          children: <Widget>[
            Visibility(
              visible: _enabled,
              child: PreloadingView(url: "assets/appimages/dice.png"),
            ),
            Visibility(
                child: ListView.builder(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.only(left: 8, right: 8, bottom: 80, top: 8),
                    itemCount: listRoles!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Visibility(
                                visible: index == 0,
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
                                      AppLocalizations.of(context)!
                                          .translate("primary_role"),
                                      textAlign: TextAlign.center,
                                      style: styleElements
                                          .captionThemeScalable(context)
                                          .copyWith(
                                              color: HexColor(
                                                  AppColors.appColorBlack85)),
                                    ),
                                  ),
                                )),
                            Visibility(
                                visible: index == 0,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      tileColor: HexColor(AppColors.listBg),
                                      leading: SizedBox(
                                        height: 52,
                                        width: 52,
                                        child: TricycleAvatar(
                                          size: 52,
                                          imageUrl: selectSchoolUrl ?? "",
                                          isFullUrl: true,
                                          key: UniqueKey(),
                                        ),
                                      ),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          selectedSchool ?? "",
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          selectedSchoolDec ?? "",
                                          maxLines: 2,
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ))),
                            if (from == "created institute")
                              Visibility(
//                                    visible: !listInstitute[index].isLoading,
                                  child: (listRoles![index].personTypeId == 2 ||
                                          listRoles![index].personTypeId == 3)
                                      ? ListTile(
                                          tileColor: HexColor(AppColors.listBg),
                                          title: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              listRoles![index].personTypeName ??
                                                  "",
                                              style: styleElements
                                                  .subtitle1ThemeScalable(
                                                      context),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          subtitle: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              listRoles![index]
                                                      .personTypeDescription ??
                                                  "",
                                              style: styleElements
                                                  .bodyText2ThemeScalable(
                                                      context),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          trailing: Checkbox(
                                            activeColor: HexColor(
                                                AppColors.appMainColor),
                                            value: listRoles![index].isSelected,
                                            onChanged: (val) {
                                              if (this.mounted) {
                                                setState(() {
                                                  if (val == true) {
                                                    for (int i = 0;
                                                        i < listRoles!.length;
                                                        i++) {
                                                      if (i == index) {
                                                        isRoleSelected = true;
                                                        listRoles![i]
                                                            .isSelected = true;
                                                        type = listRoles![i]
                                                            .personTypeName;
                                                        id = listRoles![i]
                                                            .personTypeId;
                                                      } else
                                                        listRoles![i]
                                                            .isSelected = false;
                                                    }
                                                  } else {
                                                    isRoleSelected = false;
                                                    listRoles![index]
                                                        .isSelected = false;
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
                                      tileColor: HexColor(AppColors.listBg),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          listRoles![index].personTypeName ?? "",
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          listRoles![index]
                                                  .personTypeDescription ??
                                              "",
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      trailing: Checkbox(
                                        activeColor:
                                            HexColor(AppColors.appMainColor),
                                        value: listRoles![index].isSelected,
                                        onChanged: (val) {
                                          if (this.mounted) {
                                            setState(() {
                                              if (val == true) {
                                                for (int i = 0;
                                                    i < listRoles!.length;
                                                    i++) {
                                                  if (i == index) {
                                                    isRoleSelected = true;
                                                    listRoles![i].isSelected =
                                                        true;
                                                    type = listRoles![i]
                                                        .personTypeName;
                                                    id = listRoles![i]
                                                        .personTypeId;
                                                  } else
                                                    listRoles![i].isSelected =
                                                        false;
                                                }
                                              } else {
                                                isRoleSelected = false;
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
                    })),
          ],
        )),
      ),
    ));

    pageTitle = AppLocalizations.of(context)!.translate('select_entity');

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: pageTitle, onBackButtonPress: () {
            _onBackPressed();
          }),
          body: new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new Container(
                child: Scaffold(
                    backgroundColor: HexColor(AppColors.appColorBackground),
                    body: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor:
                              HexColor(AppColors.appColorBackground),
                          body: NestedScrollView(
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverToBoxAdapter(
                                    child: Visibility(
                                        visible: list.length > 0 ? true : false,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 0, bottom: 8),
                                          alignment: Alignment.center,
                                          child: Visibility(
                                            visible: false,
                                            child: TabBar(
                                              labelColor: HexColor(
                                                  AppColors.appColorWhite),
                                              indicatorColor:
                                                  HexColor(AppColors.appColorTransparent),
                                              controller: _tabController,
                                              isScrollable: true,
                                              tabs: List<Widget>.generate(
                                                  list.length, (int index) {
                                                return new Tab(
                                                  child: ButtonTheme(
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        if (from !=
                                                            "created institute") {
                                                          setState(() async {
                                                            controllerSearch
                                                                .clear();
                                                            if (index == 0) {
                                                              setState(() {
                                                                pageTitle = AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        "institute");
                                                                _currentPosition =
                                                                    0;
                                                              });
                                                            } else if (index ==
                                                                1) {
                                                              if (isInstituteSelected) {
                                                                setState(() {
                                                                  _scrollToTop();
                                                                  pageTitle =
                                                                      "Select Role";
                                                                  _currentPosition =
                                                                      index;
                                                                });
                                                              } else {
                                                                ToastBuilder().showSnackBar(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "select_entity"),
                                                                    sctx,
                                                                    HexColor(
                                                                        AppColors
                                                                            .information));
                                                              }
                                                            }
                                                          });
                                                        }
                                                      },
                                                      elevation: 2.0,
                                                      child: Center(
                                                        widthFactor: 1.0,
                                                        heightFactor: 1.0,
                                                        child: Text(
                                                          list[index].tabName ==
                                                                  "Select Institute"
                                                              ? "1"
                                                              : list[index]
                                                                          .tabName ==
                                                                      "Select Role"
                                                                  ? "2"
                                                                  : "3",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: styleElements
                                                              .subtitle1ThemeScalable(
                                                                  context)
                                                              .copyWith(
                                                                  color: index ==
                                                                          _currentPosition
                                                                      ? Colors
                                                                          .white
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                        ),
                                                      ),
                                                      fillColor:
                                                          index ==
                                                              _currentPosition
                                                              ? Theme
                                                              .of(context)
                                                              .primaryColor
                                                              : HexColor(AppColors.appColorWhite),
                                                          padding: EdgeInsets.all(
                                                              4.0),
                                                          shape: CircleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .redAccent,
                                                              )),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            )),
                                      ),
                                      SliverToBoxAdapter(
                                          child: Visibility(
                                              visible: _currentPosition == 0,
                                              child: SearchBox(
                                                onvalueChanged: (String text) {
                                                  setState(() {
                                                    SearchVal=text;
                                                    _debouncer.run(() {
                                                      if (text.length >= 2) {

                                                        instPageNumber = 1;
                                                        isSearching = true;
                                                        isCallComplete = false;
                                                        if (_currentPosition ==
                                                            0)
                                                          getListOfInstitutes(
                                                              text);
                                                        else
                                                          getRoles(text,
                                                              instituteId);
                                                      } else {
                                                        isSearching = false;
                                                        isCallComplete = true;
                                                        if (_currentPosition ==
                                                            0) {
                                                          instPageNumber = 1;
                                                          listInstitute =
                                                              [];
                                                          getListOfInstitutes(
                                                              " ");
                                                        }
                                                      }
                                                    });
                                                  });
                                                },
                                                hintText: AppLocalizations.of(context)!.translate('search'),
                                                progressIndicator:
                                                isSearching && !isCallComplete,
                                            isFilterVisible: false,
                                            onFilterClick: () {},
                                          ))),
                                ];
                              },
                              body: Visibility(
                                visible: list.length > 0 ? true : false,
                                child: Stack(
                                  children: <Widget>[
                                    TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _tabController,
                                      children: List<Widget>.generate(
                                          list.length, (int index) {
                                        return new Center(
                                            child: list[_currentPosition]
                                                .statelessWidget);
                                      }),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GestureDetector(
                                          child: Container(
                                            height: 60,
                                            color: HexColor(
                                                AppColors.appColorWhite),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Visibility(
                                                        visible: false,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'skip_this_now'),
                                                            style: styleElements
                                                                .bodyText2ThemeScalable(
                                                                    context),
                                                          ),
                                                        )),
                                                    Visibility(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                                left: 16.0,
                                                                right: 16.0),
                                                            child: TricycleElevatedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .redAccent)),
                                                          onPressed: () async {
                                                            if (_currentPosition ==
                                                                0) {
                                                              if (isInstituteSelected) {
                                                                widget.registerUserAs!.institutionId = instituteId;
                                                                getAdditionDetails();

                                                              } else {
                                                                ToastBuilder().showSnackBar(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "select_entity"),
                                                                    sctx,
                                                                    HexColor(
                                                                        AppColors
                                                                            .information));
                                                              }
                                                            } else if (_currentPosition ==
                                                                1) {
                                                              if (isRoleSelected) {
                                                                _scrollToTop();
                                                                {
                                                                  proceed(
                                                                      false,false);
                                                                }
                                                              } else {
                                                                ToastBuilder().showSnackBar(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "select_role"),
                                                                    sctx,
                                                                    HexColor(
                                                                        AppColors
                                                                            .information));
                                                              }
                                                            }
                                                          },
                                                          color: HexColor(AppColors.appColorWhite),
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      "next"),
                                                              style: styleElements
                                                                  .buttonThemeScalable(
                                                                      context)
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .redAccent)),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ))
                                  ],
                                ),
                              ))),
                    )));
          }),
        )));
  }


  void getAdditionDetails()
  {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height *
              0.75,
          child: Card(
            child: AcademicInformationPage(
              registerUserAs: widget.registerUserAs,
              callBack: (RegisterUserAs? registerUserdata  ){
                registerUserdata!.isDefaultInstitution=false;
                Navigator.of(
                    ctx)
                    .pop({
                  'registerUserdata': registerUserdata,

                });

              },
            ),
          ),
        );
      },
    );
  }

  Future<void> proceed(bool isVerified,bool isDefaultInstitution) async {
    var payload = RegisterUserAs();

    personTypeList = [];
    institutionRolesList = [];
    payload.institutionId = instituteId;
    payload.personId = userId;
    personTypeList.add(id);
    payload.isDefaultInstitution = isDefaultInstitution;
    payload.personTypeList = personTypeList;
    for (var item in listRoles!) {
      if (item.isSelected!) {
        institutionRolesList.add(item.personTypeId);
      }
    }
    payload.personTypeList = institutionRolesList;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PhotoPreviewScreen(registerUserAs: payload, from: from),
        ));

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
          _enabledInstitute = false;
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
                showModalBottomSheet<void>(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                  ),
                  builder: (context) {
                    return noInstituteFound( context);
                  },
                );
                /* showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => CallBackDialog(

                    ));*/
              }
            } else {
              if (listInstitute != null && listInstitute!.length > 0)
                listInstitute!.removeAt(listInstitute!.length - 1);
              if (listInstitute!.length == 0) {
                ifNoInstituteFound = true;
                showModalBottomSheet<void>(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                  ),
                  builder: (context) {
                    return SizedBox(
                      child: Card(
                        child: noInstituteFound(context),
                      ),
                    );
                  },
                );
                /*      showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => CallBackDialog(

                      ));*/
              } else
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

  Widget noInstituteFound(BuildContext ctx) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.start,
              //Center Row contents vertically,

              children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_backspace_outlined,
                              color: HexColor(AppColors.appColorBlack85),
                            ),
                            Text(
                                AppLocalizations.of(context)!
                                    .translate("search_again"),
                                style: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(
                                        color:
                                            HexColor((AppColors.appMainColor))))
                          ],
                        ),
                      ),
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left:60.0),
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context)!.translate("sorry"),
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Container()
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.translate("if_no_inst_found"),
              textAlign: TextAlign.center,
              style: styleElements
                  .captionThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16,top: 20),
              child: WhiteLargeButton(
                name: AppLocalizations.of(context)!
                    .translate("register__entity"),
                offsetX: 70.66,
                offsetY: 12.93,
                textColor: AppColors.appColorWhite,
                color: AppColors.appMainColor,
                callback: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RegisInstruction()));
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(AppLocalizations.of(context)!.translate('or'),
                textAlign: TextAlign.center,
                style: styleElements.captionThemeScalable(context)),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 60),
              child: WhiteLargeButton(
                name: AppLocalizations.of(context)!
                    .translate("join_app_workplace"),
                offsetX: 70.66,
                offsetY: 12.93,
                callback: () {
                 var registerUserdata=RegisterUserAs();
                 registerUserdata.isDefaultInstitution=true;
                  Navigator.of(context).pop();
                  Navigator.of(
                      ctx)
                      .pop({
                    'registerUserdata': registerUserdata,

                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
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
              if (from == "welcome" && isInstituteSelectedAlready!)
                prefs!.setBool("isProfileCreated", false);
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
            proceed(true,false);
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
  TextStyleElements? styleElements;

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
                child: Center(
                    child: EmptyWidget(
                        AppLocalizations.of(context)!.translate("no_data")))),
          )),
    );
  }

  void signUp() {}
}

class TabMaker {
  String? tabName;
  Widget? statelessWidget;

  TabMaker({this.tabName, this.statelessWidget});
}
