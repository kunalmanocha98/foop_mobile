import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/CommonListingModels/commonListingrequest.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/regisration_module/verify_child.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



// ignore: must_be_immutable
class StudentsPage extends StatefulWidget {
  RegisterUserAs registerUserAs;

  StudentsPage(this.registerUserAs);

  _StudentsPage createState() => _StudentsPage(registerUserAs);
}

class _StudentsPage extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  RegisterUserAs registerUserAs;
  int? idStudent;
  String? searchValue;

  String? studentType;
  bool isUploadImageActive = false;
  late SharedPreferences prefs;
  int? userId;
  int? personType;
  ScrollController? _scrollController;
  String? selectedSchool;
  String? selectedSchoolDec;
  String pageTitle = "";
  String? imageUrl;
  int instPageNumber = 1;
  final _debouncer = Debouncer(500);
  CupertinoDatePicker? cupertinoDatePicker;
  var color1 = HexColor(AppColors.appMainColor);
  bool _enabledInstitute = false;
  bool ifNoInstituteFound = false;
  var color2 = HexColor(AppColors.appColorWhite);
  int? id;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  TabController? _tabController;
  Map<String, bool> mapRules = Map();
  List<PersonItem> listRoles = [];
  List<String> personList = [];
  List<CommonListResponseItem>? listInstitute = [];
  String type = "parent";
  var isClassesSelected = HexColor(AppColors.appColorWhite);
  var isSubjectSelected = HexColor(AppColors.appColorWhite);
  var isRoleSelected = false;

  var isSearching = false;
  var isCallComplete = false;
  var isInstituteSelected = false;
  List<Subjects> listOfSubjects = [];
  List<InstituteClass> listOfClasses = [];
  List<int> personTypeList = [];
  List<int> institutionRolesList = [];
  List<int> teachingClasses = [];
  List<int> teachingSubjects = [];
  late TextStyleElements styleElements;
  bool? fromBasicProfileFLow;
  Null Function()? callbackPicker;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  _StudentsPage(this.registerUserAs);

  List<TabMaker> list = [];
  int? instituteId;

  int _currentPosition = 0;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");
  }

  @override
  void initState() {
    super.initState();
    personList.add("S");

    setSharedPreferences();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 1);
    cupertinoDatePicker = CupertinoDatePicker(
      initialDateTime: DateTime.now(),
      maximumDate: DateTime.now(),
      onDateTimeChanged: (DateTime newdate) {
        setState(() {
          selectedEpoch = newdate.millisecondsSinceEpoch;
          selectedDate = DateFormat('dd-MM-yyyy').format(newdate);
        });
        print('2. onDateTimeChanged : $selectedDate');
      },
      mode: CupertinoDatePickerMode.date,
    );
    //  getListOfInstitutes(null);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  final controllerSearch = TextEditingController();
  int selectedEpoch = 0;
  String selectedDate = 'DOB';
  bool isLoading = false;

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    setState(() async {
      if (_currentPosition == 0) {
        Navigator.of(context).pop(true);
      }
    });
    return new Future(() => false);
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init;

    list = [];
    list.add(TabMaker(
      tabName: AppLocalizations.of(context)!.translate('select_child'),
      statelessWidget: Container(
        margin: const EdgeInsets.only(bottom: 65),
        child: NotificationListener<ScrollNotification>(
          // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                setState(() {
                  isLoading = true;
                  if (!_enabledInstitute) {
                    var load = CommonListResponseItem();
                    load.isLoading = true;
                    load.title = "";
                    load.isSelected = false;
                    listInstitute!.add(load);
                  }
                });
                if (!isSearching) getListOfInstitutes(null);
              }
            } as bool Function(ScrollNotification)?,
            child: Stack(
              children: <Widget>[
                Visibility(
                    visible: listInstitute!.isEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        color: HexColor(AppColors.appColorWhite),
                        child: Card(
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
                                      .translate("selectChildInstruction"),
                                  textAlign: TextAlign.center,
                                  style: styleElements
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(color: HexColor(AppColors.appColorBlack85)),
                                ),
                              ),
                            )),
                      ),
                    )),
                Visibility(

                    child: listInstitute != null && listInstitute!.length > 0
                        ? ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 80, top: 8),
                        itemCount: listInstitute!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Visibility(
                                        visible: listInstitute![index].isLoading!,
                                        child: Container(
                                          width: double.infinity,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                margin:
                                                const EdgeInsets.all(16),
                                                child: Column(children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ]),
                                              )),
                                        )),
                                    Visibility(
                                        visible:
                                        !listInstitute![index].isLoading!,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: ListTile(
                                              leading: SizedBox(
                                                height: 52,
                                                width: 52,
                                                child: appAvatar(
                                                  size: 52,
                                                  key:UniqueKey(),
                                                  imageUrl:  listInstitute![index].avatar,
                                                  service_type: SERVICE_TYPE.PERSON,
                                                  resolution_type: RESOLUTION_TYPE.R64,
                                                ),
                                              ),
                                              title: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  listInstitute![index].title ??
                                                      "",
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              trailing: Checkbox(
                                                activeColor:
                                                HexColor(AppColors.appMainColor),
                                                value: listInstitute![index]
                                                    .isSelected,
                                                onChanged: (val) {
                                                  if (this.mounted) {
                                                    setState(() {
                                                      if (val == true) {
                                                        for (int i = 0;
                                                        i <
                                                            listInstitute!
                                                                .length;
                                                        i++) {
                                                          if (i == index) {
                                                            idStudent =
                                                                listInstitute![i]
                                                                    .id;

                                                            listInstitute![i]
                                                                .isSelected =
                                                            true;
                                                          } else
                                                            listInstitute![i]
                                                                .isSelected =
                                                            false;
                                                        }
                                                      } else {
                                                        listInstitute![index]
                                                            .isSelected = false;
                                                      }
                                                    });
                                                  }
                                                },
                                              )),
                                        ))
                                  ],
                                )),
                            onTap: () {},
                          );
                        })
                        :  Center(
                      child: Visibility(
                        visible: searchValue != null &&
                            searchValue!.isNotEmpty,
                        child: appEmptyWidget(
                          message: "No data found!!",
                        ),
                      ),
                    )),
              ],
            )),
      ),
    ));

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
              appBar: OhoAppBar().getCustomAppBar(context,
                  appBarTitle: pageTitle, onBackButtonPress: () {
                    _onBackPressed();
                  }),
              backgroundColor: HexColor(AppColors.appColorBackground),
              resizeToAvoidBottomInset: false,
              body: Container(
                  child: Scaffold(
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
                                        child: Visibility(
                                          visible: _currentPosition == 0,
                                          child: Container(
                                            height: 48.h,
                                            margin: EdgeInsets.only(
                                                left: 16.w,
                                                right: 16.w,
                                                top: 2.h,
                                                bottom: 12.h),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  HexColor(AppColors.appColorWhite),
                                                  HexColor(AppColors.appColorWhite),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0.w)),
                                              boxShadow: [
                                                CommonComponents()
                                                    .getShadowforBox_01_3()
                                              ],
                                            ),
                                            child: Center(
                                              child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextField(
                                                          onChanged: (text) {
                                                            setState(() {
                                                              _debouncer.run(() {
                                                                if (text.length >= 2) {
                                                                  instPageNumber = 1;
                                                                  if (_currentPosition == 0)
                                                                    isSearching = true;
                                                                  getListOfInstitutes(text);
                                                                  searchValue = text;
                                                                } else {
                                                                  if (_currentPosition ==
                                                                      0) {
                                                                    setState(() {
                                                                      isSearching = false;
                                                                      instPageNumber = 1;
                                                                      listInstitute =
                                                                          [];
                                                                    });
                                                                  }
                                                                }
                                                              });
                                                            });
                                                          },
                                                          style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                                              color: HexColor(AppColors.appColorBlack65)
                                                          ),
                                                          decoration: InputDecoration(
                                                            hintText: AppLocalizations.of(context)!.translate('search'),
                                                            border: InputBorder.none,
                                                            hintStyle: styleElements
                                                                .bodyText2ThemeScalable(
                                                                context).copyWith(
                                                              color: HexColor(AppColors.appColorBlack35)
                                                            ),
                                                            prefixIcon: Padding(
                                                                padding:
                                                                EdgeInsets.all(0.0.w),
                                                                child: Icon(Icons.search,
                                                                    color: HexColor(AppColors.appColorGrey500))),
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                          visible: false,
                                                          child: Container(
                                                            margin: EdgeInsets.all(16.w),
                                                            child: new SizedBox(
                                                              height: 20.0.h,
                                                              width: 20.0.h,
                                                              child:
                                                              new CircularProgressIndicator(
                                                                value: null,
                                                                strokeWidth: 2.0,
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        )),
                                  ];
                                },
                                body: Visibility(
                                  visible: list.length > 0 ? true : false,
                                  child: Stack(
                                    children: <Widget>[
                                      TabBarView(
                                        physics: NeverScrollableScrollPhysics(),
                                        controller: _tabController,
                                        children: List<Widget>.generate(list.length,
                                                (int index) {
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
                                              color: HexColor(AppColors.appColorWhite),
                                              child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Visibility(
                                                          visible: true,
                                                          child: GestureDetector(
                                                            behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                            onTap: () {
                                                              register(userId);
                                                            },
                                                            child: Container(
                                                              margin:
                                                              const EdgeInsets
                                                                  .all(16),
                                                              child: Text(AppLocalizations.of(context)!.translate('skip_this_now'),
                                                                style: styleElements
                                                                    .bodyText2ThemeScalable(
                                                                    context)
                                                                    .copyWith(
                                                                    color: Colors
                                                                        .redAccent),
                                                              ),
                                                            ),
                                                          )),
                                                      Visibility(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                              height: 60,
                                                              color: HexColor(AppColors.appColorWhite),
                                                              child: Align(
                                                                  alignment: Alignment
                                                                      .centerRight,
                                                                  child: Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 16.0,
                                                                        right:
                                                                        16.0),
                                                                    child:
                                                                    appProgressButton(
                                                                      key: progressButtonKey,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                          side: BorderSide(
                                                                              color:
                                                                              HexColor(AppColors.appMainColor))),
                                                                      onPressed:
                                                                          () {
                                                                        var ids =
                                                                        isItemSelected();
                                                                        if (ids !=
                                                                            null) {
                                                                          registerUserAs
                                                                              .childId =
                                                                              ids;
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    VerifyChild(0, registerUserAs),
                                                                              ));
                                                                        } else {
                                                                          register(
                                                                              userId);
                                                                        }
                                                                      },
                                                                      color: Colors
                                                                          .white,

                                                                      child: Text(
                                                                        AppLocalizations.of(context)!.translate('next'),
                                                                        style: styleElements
                                                                            .subtitle2ThemeScalable(
                                                                            context)
                                                                            .copyWith(
                                                                            color:
                                                                            HexColor(AppColors.appMainColor)),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            )),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ))
                                    ],
                                  ),
                                ))),
                      ))),
            )));
  }

  int? isItemSelected() {
    for (var item in listInstitute!) {
      if (item.isSelected!) {
        return item.id;
      }
    }
    return null;
  }

  void register(int? userId) async {
    registerUserAs.dateOfBirth = null;
    registerUserAs.personId = userId;
    print(teachingClasses.toString() +
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

    final body = jsonEncode(registerUserAs);
    // pr = ToastBuilder().setProgressDialog(context);

    progressButtonKey.currentState!.show();
    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                    type: type,
                    isVerified: data.rows!.isVerified,
                    title: AppLocalizations.of(context)!.translate('you_are_added_as') + type,
                    subtitle: "",
                  )),
                  (Route<dynamic> route) => false);
        } else
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }

  void getListOfInstitutes(String? searchValue) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "page_number": instPageNumber,
      "page_size": 20,
      "requested_by_type": "institution",
      "list_type": null,
      "institution_id": registerUserAs.institutionId,
      "searchVal": searchValue,
      "person_type": ["S"],
      "person_id": prefs.getInt("userId").toString(),
       "class_id": registerUserAs.personClasses![0].classId,
      "section_id": registerUserAs.personClasses![0]!=null && registerUserAs.personClasses![0].sections!=null &&
          registerUserAs.personClasses![0].sections!.isNotEmpty?registerUserAs.personClasses![0].sections![0]:null
    });
    Calls().call(body, context, Config.USER_LIST).then((value) async {
      if (value != null) {
        isCallComplete = true;
        setState(() {
          isSearching = true;
        });
        var data = CommonListResponse.fromJson(value);
        if (data != null) {
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
              setState(() {
                isSearching = false;
              });
            } else {
              if (listInstitute!.length > 0)
                listInstitute!.removeAt(listInstitute!.length - 1);
              instPageNumber = instPageNumber + 1;
              listInstitute = listInstitute! + data.rows!;
            }
          }
        } else {
          setState(() {});
        }
      } else {
        isCallComplete = true;
      }
    }).catchError((onError) {
      isCallComplete = true;
      ToastBuilder()
          .showToast(onError.toString(), context, HexColor(AppColors.failure));
    });
  }
}

class TabMaker {
  String? tabName;
  Widget? statelessWidget;

  TabMaker({this.tabName, this.statelessWidget});
}
