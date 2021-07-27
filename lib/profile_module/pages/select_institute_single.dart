import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/SubjectList.dart';
import 'package:oho_works_app/models/institute_list.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_education.dart';
import 'expertise_classes.dart';

// ignore: must_be_immutable
class SelectInstituteSingle extends StatefulWidget {
  String? type;
  int? id;
  String? studentType;
  bool fromBasicProfileFLow;
  Null Function() callbackPicker;
  SelectInstituteSingle(
      this.fromBasicProfileFLow,
      this.callbackPicker);
  _SelectInstitute createState() => _SelectInstitute(type, id, studentType,fromBasicProfileFLow,callbackPicker);
}

class _SelectInstitute extends State<SelectInstituteSingle>
    with SingleTickerProviderStateMixin {

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
  bool _enabledInstitute = true;
  bool ifNoInstituteFound = false;
  bool empty=false;
  var color2 = HexColor(AppColors.appColorWhite);
  int? id;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  TabController? _tabController;
  Map<String, bool> mapRules = Map();
  List<PersonItem> listRoles = [];
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
  List<int> personTypeList = [];
  List<int> institutionRolesList = [];
  List<int> teachingClasses = [];
  List<int> teachingSubjects = [];
  late TextStyleElements styleElements;
  bool fromBasicProfileFLow;
  Null Function() callbackPicker;
  _SelectInstitute(String? type, int? id, String? studentType,this.fromBasicProfileFLow,this.callbackPicker) {
    this.type = type;
    this.id = id;
    this.studentType = studentType;
  }

  List<TabMaker> list = [];
  int? instituteId;

  int _currentPosition = 0;

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

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
    getListOfInstitutes(" ");
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
      tabName: AppLocalizations.of(context)!.translate('select_entity'),
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
            } as bool Function(ScrollNotification)?,
            child: Stack(
              children: <Widget>[
                Visibility(
                  visible: _enabledInstitute,
                  child: PreloadingView(url: "assets/appimages/dice.png"),
                ),
                Visibility(
                    visible: ifNoInstituteFound, child: NoInstitutePage()),

                Center(
                  child: Visibility(
                    visible: empty,
                    child:   TricycleEmptyWidget(
                      message: AppLocalizations.of(context)!
                          .translate('no_data'),
                    ),
                  ),
                ),
                Visibility(
                    visible: !ifNoInstituteFound,
                    child: ListView.builder(
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
                                        visible: index == 0,
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                              color: HexColor(AppColors.appMainColor35),
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
                                                  .captionThemeScalable(context),
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
                                          margin: const EdgeInsets.only(

                                          ),
                                          child: ListTile(
                                              leading: SizedBox(
                                                width: 52,
                                                height: 52,
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:  Config.BASE_URL+
                                                        (listInstitute![index]
                                                            .profileImage ??=
                                                        ""),
                                                    placeholder: (context, url) => Center(
                                                        child:  Image.asset(
                                                          'assets/appimages/image_place.png',

                                                        )),
                                                  ),
                                                ),
                                              ),
                                              title:   Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(
                                                  listInstitute![index].name ??
                                                      "",
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )  ,
                                              subtitle:  Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(
                                                  listInstitute![index]
                                                      .institutionAddress !=
                                                      null
                                                      ? listInstitute![index]
                                                      .institutionAddress!
                                                      .streetAddress ??
                                                      ""
                                                      : "",
                                                  style: styleElements
                                                      .bodyText2ThemeScalable(
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
                                                            instituteId =
                                                                listInstitute![
                                                                i]
                                                                    .id;
                                                            isInstituteSelected = true;
                                                            listInstitute![i].isSelected = true;

                                                            selectedSchool =
                                                                listInstitute![
                                                                i]
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
                                                        instituteId = null;
                                                        isInstituteSelected =
                                                        false;
                                                        listInstitute![index]
                                                            .isSelected =
                                                        false;
                                                        selectedSchool = null;
                                                        selectedSchoolDec =
                                                        null;
                                                      }
                                                    });
                                                  }
                                                },
                                              )

                                          ),
                                        ))
                                  ],
                                )),
                            onTap: () {},
                          );
                        })),
              ],
            )),
      ),
    ));

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
              appBar: TricycleAppBar().getCustomAppBar(context,
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

                                                                  if (_currentPosition ==
                                                                      0)
                                                                    getListOfInstitutes(
                                                                        text);
                                                                } else {
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
                                                          visible: isSearching,
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
                                          )

                                          /*SearchBox(

                                            onvalueChanged: (String text) {
                                              setState(() {
                                                isSearching = true;
                                                _debouncer.run(() {
                                                  if (text.length >=
                                                      2) {
                                                    instPageNumber = 1;
                                                    if (_currentPosition ==
                                                        0)
                                                      getListOfInstitutes(
                                                          text);

                                                  } else {

                                                    if (_currentPosition ==
                                                        0) {
                                                      instPageNumber =
                                                      1;
                                                      listInstitute =
                                                          [];
                                                      getListOfInstitutes(
                                                          " ");
                                                    }
                                                  }
                                                });
                                              });
                                            },
                                            hintText: 'Search',
                                            progressIndicator: isSearching ,
                                            isFilterVisible: false,
                                            onFilterClick: (){},

                                          )*/
                                          ,
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

                                                      GestureDetector(
                                                        onTap:(){   setState(() async {
                                                          {
                                                            {
                                                              if (isInstituteSelected) {
                                                                var result =
                                                                await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => ExpertiseSelectClass(
                                                                          instituteId,
                                                                          null,
                                                                          true,
                                                                          personType,
                                                                          callbackPicker,
                                                                         fromBasicProfileFLow,


                                                                      ),
                                                                    ));

                                                                if (result !=
                                                                    null &&
                                                                    result['result'] ==
                                                                        "success") {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop({
                                                                    'result':
                                                                    "success"
                                                                  });
                                                                }
                                                              } else {

                                                                if(fromBasicProfileFLow)
                                                                {
                                                                  callbackPicker();
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop({
                                                                    'result':
                                                                    "success"
                                                                  });

                                                                }

                                                              }
                                                            }
                                                          }
                                                        });},
                                                        child: Visibility(
                                                            visible: fromBasicProfileFLow,
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                  .all(16),
                                                              child: Text(
                                                                AppLocalizations.of(context)!
                                                                    .translate('save_exit')
                                                                    .toUpperCase(),
                                                                style: styleElements
                                                                    .captionThemeScalable(context)
                                                                    .copyWith(color: HexColor(AppColors.appMainColor)),
                                                              ),
                                                            )),
                                                      )
                                                      ,
                                                      Container(
                                                        margin:
                                                        const EdgeInsets.only(
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
                                                            if (isInstituteSelected) {
                                                              var result =
                                                                  await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => ExpertiseSelectClass(
                                                                        instituteId,
                                                                        null,
                                                                        true,
                                                                        personType,
                                                                        callbackPicker,
                                                                    fromBasicProfileFLow,


                                                                    ),
                                                                  ));

                                                              if (result !=
                                                                  null &&
                                                                  result['result'] ==
                                                                      "success") {
                                                                Navigator.of(
                                                                    context)
                                                                    .pop({
                                                                  'result':
                                                                  "success"
                                                                });
                                                              }
                                                              setState(() {

                                                              });
                                                            }
                                                            else {

                                                              if(fromBasicProfileFLow)
                                                              {
                                                                var result =await   Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => EditEducation(null, false,fromBasicProfileFLow,callbackPicker)));


                                                                if (result !=
                                                                    null &&
                                                                    result['result'] ==
                                                                        "success") {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop({
                                                                    'result':
                                                                    "success"
                                                                  });

                                                                  setState(() {

                                                                  });

                                                                }}
                                                              else
                                                              {
                                                                ToastBuilder().showToast(
                                                                    AppLocalizations.of(
                                                                        context)!
                                                                        .translate(
                                                                        "select_entity"),
                                                                    context,HexColor(AppColors.information));}
                                                            }
                                                          },
                                                          color: HexColor(AppColors.appColorWhite),

                                                          child: Text(
                                                              AppLocalizations.of(
                                                                  context)!
                                                                  .translate(
                                                                  "next"),
                                                              style: styleElements
                                                                  .captionThemeScalable(
                                                                  context)
                                                                  .copyWith(
                                                                  color:HexColor(AppColors.appMainColor))),
                                                        ),
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




  void getListOfInstitutes(String searchValue) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "searchVal": searchValue,
      "person_id": prefs.getInt("userId"),
      "page_number": instPageNumber,
      "page_size": 50
    });
    Calls().call(body, context, Config.INSTITUTE_LIST).then((value) async {
      if (value != null) {
        isCallComplete = true;
        setState(() {
          isSearching = true;
        });
        var data = InstituteList.fromJson(value);
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
              isSearching = false;
            } else {
              if (listInstitute!.length > 0)
                listInstitute!.removeAt(listInstitute!.length - 1);
              instPageNumber = instPageNumber + 1;
              listInstitute = listInstitute! + data.rows!;
            }

          }
          else{
            if(instPageNumber==1)
            empty=true;
          }

        } else {
          setState(() {});
        }
      } else {
        isCallComplete = true;
      }
    }).catchError((onError) {
      isCallComplete = true;
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
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
                decoration: BoxDecoration(color: HexColor(AppColors.appColorBackground)),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Card(
                        color: HexColor(AppColors.appMainColor35),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate("if_no_inst_found"),
                              textAlign: TextAlign.center,
                              style: styleElements.captionThemeScalable(context)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 100, left: 16, right: 16, bottom: 55),
                        child: LargeButton(
                          name: AppLocalizations.of(context)!
                              .translate("request_callback"),
                          offsetX: 70.66,
                          offsetY: 12.93,
                          callback: () {},
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
