/*
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/add_new_skill.dart';
import 'package:oho_works_app/models/add_new_skill_response.dart';

import 'package:oho_works_app/regisration_module/department_page.dart';
import 'package:oho_works_app/regisration_module/select_class.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accedemic_selection_page.dart';

// ignore: must_be_immutable
class SelectProgram extends StatefulWidget {
  RegisterUserAs registerUserAs;
  int instituteId;
  int personType;
  bool isVerified;
  bool isAddClass;

  SelectProgram(this.instituteId, this.registerUserAs, this.isAddClass,
      this.personType, this.isVerified);

  _SelectProgram createState() => _SelectProgram(
      instituteId, registerUserAs, personType, isAddClass, isVerified);
}

class _SelectProgram extends State<SelectProgram>
    with AutomaticKeepAliveClientMixin<SelectProgram> {
  GlobalKey<TricycleProgressButtonState> progressButtonKeyNext = GlobalKey();
  SharedPreferences prefs;
  RegisterUserAs registerUserAs;
  int personType;
  String classId;
  String accedamicId;
  bool isVerified;
  bool isAddClass;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int userId;
  var color2 = HexColor(AppColors.appColorWhite);
  int instituteId;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<Programs> listPrograms = [];
  List<Programs> listSelectedPrograms = [];
  BuildContext sctx;
  var isSearching = false;

  // bool _enabled = true;
  String nextYear;
  String currentYear;
  String acedemicYear;

  // final _debouncer = Debouncer(500);
  String type = "";
  TextStyleElements styleElements;
  bool isLoading = false;
  int pageNumber = 1;
  int pageSize = 30;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  String searchVal = "";

  void _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
    if (registerUserAs != null) {
      acedemicYear = registerUserAs.academicYear;
      instituteId = registerUserAs.institutionId;
      personType = registerUserAs.personTypeList[0];
    }
    setSharedPreferences();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    listPrograms.clear();
    refresh();
  }

  refresh() {
    paginatorKey.currentState.changeState(resetState: true);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    pageTitle = AppLocalizations.of(context).translate('select_program_title');
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: pageTitle, onBackButtonPress: () {
                _onBackPressed();
              }),
          body: new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new Stack(
              children: [
                Container(
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: SearchBox(
                              onvalueChanged: onsearchValueChanged,
                              hintText:
                              AppLocalizations.of(context).translate('search'),
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
                                          child: Visibility(
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Align(
                                                          alignment: Alignment.center,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Visibility(
                                                                visible:
                                                                acedemicYear != null,
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.center,
                                                                  child: Text(
                                                                    acedemicYear ?? "",
                                                                    style: styleElements
                                                                        .subtitle1ThemeScalable(
                                                                        context),
                                                                    textAlign:
                                                                    TextAlign.left,
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment.center,
                                                                child: Text(
                                                                  acedemicYear != null
                                                                      ? AppLocalizations.of(
                                                                      context)
                                                                      .translate(
                                                                      'selected_financial_year')
                                                                      : AppLocalizations.of(
                                                                      context)
                                                                      .translate(
                                                                      'select_financial_year'),
                                                                  style: styleElements
                                                                      .subtitle2ThemeScalable(
                                                                      context),
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Container(
                                                          margin: const EdgeInsets.all(16),
                                                          child: Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child: SizedBox(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              child: Icon(Icons.date_range,
                                                                  color: Colors.black87),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )))))),
                          SliverToBoxAdapter(
                            child: Card(
                              child: Visibility(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: HexColor(AppColors.appMainColor33),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(4.0),
                                            topLeft: Radius.circular(4.0))),
                                    child: Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Text(
                                        personType == 3
                                            ? AppLocalizations.of(context)
                                            .translate("program_quote")
                                            : personType == 4
                                            ? AppLocalizations.of(context)
                                            .translate("program_quote_parent")
                                            : personType == 5
                                            ? AppLocalizations.of(context)
                                            .translate(
                                            "program_quote_alumni")
                                            : AppLocalizations.of(context)
                                            .translate(
                                            "program_quote_teacher"),
                                        textAlign: TextAlign.center,
                                        style: styleElements
                                            .captionThemeScalable(context)
                                            .copyWith(color: Colors.black87),
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        ];
                      },
                      body: Paginator.listView(
                          key: paginatorKey,
                          padding: EdgeInsets.only(top: 8, bottom: 50),
                          scrollPhysics: BouncingScrollPhysics(),
                          pageLoadFuture: getDepartment,
                          pageItemsGetter: listItemsGetter,
                          listItemBuilder: listItemBuilder,
                          loadingWidgetBuilder:
                          CustomPaginator(context).loadingWidgetMaker,
                          errorWidgetBuilder:
                          CustomPaginator(context).errorWidgetMaker,
                          emptyListWidgetBuilder:
                          CustomPaginator(context).emptyListWidgetMaker,
                          totalItemsGetter:
                          CustomPaginator(context).totalPagesGetter,
                          pageErrorChecker:
                          CustomPaginator(context).pageErrorChecker),
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: HexColor(AppColors.appColorWhite),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 8, bottom: 8, right: 16.0),
                      child: Container(
                        child: Row(
                          children: [
                            Spacer(),
                            TricycleProgressButton(
                              key: progressButtonKeyNext,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {
                                if (acedemicYear != null) {
                                  if (listSelectedPrograms.length > 0) {

                                    registerUserAs.isDepartment= await isHigherSecondary();
                                    registerUserAs.personPrograms =
                                        getProgramsId();
                                    print(jsonEncode(registerUserAs));
                                    Navigator.of(context).pop({
                                      'registerUserAs': registerUserAs
                                    });
                                  } else {
                                    ToastBuilder().showSnackBar(
                                        AppLocalizations.of(context)
                                            .translate("select_program"),
                                        sctx,
                                        HexColor(AppColors.information));
                                  }
                                } else {
                                  ToastBuilder().showSnackBar(
                                      AppLocalizations.of(context)
                                          .translate("select_department"),
                                      sctx,
                                      HexColor(AppColors.information));
                                }
                              },
                              color: HexColor(AppColors.appColorWhite),
                              textColor: HexColor(AppColors.appMainColor),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('next')
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color:
                                    HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }

  List<int> getProgramsId() {
    List<int> ids = [];
    for (var i = 0; i < listSelectedPrograms.length; i++) {
      ids.add(listSelectedPrograms[i].id);
    }
    return ids;
  }

  bool isHigherSecondary() {
    for (var i = 0; i < listSelectedPrograms.length; i++) {
      if (listSelectedPrograms[i].programCode != "K12" &&
          listSelectedPrograms[i].programCode !=
              "Primary school (1st to 5th)" &&
          listSelectedPrograms[i].programCode != "Middle School (6th to 8th)" &&
          listSelectedPrograms[i].programCode != "High School (9th & 10th)" &&
          listSelectedPrograms[i].programCode != "Play School" &&
          listSelectedPrograms[i].programCode !=
              "Pre-School (Nursery, Kintergarden)") {
        return true;
      }
    }
    return false;
  }

  void addNewLangSkill(String searchValue) async {
    AddNewSkillLangEntity addNewSkillLangEntity = AddNewSkillLangEntity();
    addNewSkillLangEntity.categoryType = "program";
    addNewSkillLangEntity.valueCode = searchValue;
    addNewSkillLangEntity.valueName = searchValue;
    addNewSkillLangEntity.instituteId = instituteId;
    addNewSkillLangEntity.valueDescription = searchValue;
    progressButtonKeyNext.currentState.show();
    Calls()
        .call(
        jsonEncode(addNewSkillLangEntity), context, Config.COMMON_NEW_ENTRY)
        .then((value) {
      progressButtonKeyNext.currentState.hide();
      var res = AddNewSkillLangResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        refresh();
      } else {}
    }).catchError((onError) {
      print(onError);
      progressButtonKeyNext.currentState.hide();
    });
  }

  Future<ProgramsData> getDepartment(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "institution_id": registerUserAs.institutionId,
      "search_val": searchVal,
      "page_number": page,
      "page_size": pageSize
    });
    var res = await Calls().call(body, context, Config.PROGRAM_LIST);
    return ProgramsData.fromJson(res);
  }

  bool isAlreadySelected(int id) {
    for (var item in listSelectedPrograms) {
      if (item.id == id) return true;
    }
    return false;
  }

  List<Programs> listItemsGetter(ProgramsData response) {
    for (int i = 0; i < response.rows.length; i++) {
      if (listSelectedPrograms != null && listSelectedPrograms.length > 0) {
        if (isAlreadySelected(response.rows[i].id))
          response.rows[i].isSelected = 1;
        else
          response.rows[i].isSelected = 0;
      } else
        response.rows[i].isSelected = 0;
    }
    listPrograms.addAll(response.rows);
    return response.rows;
  }

  Widget listItemBuilder(value, int index) {
    Programs item = value;

    return ListTile(
        tileColor: HexColor(AppColors.listBg),
        contentPadding: EdgeInsets.only(left: 16, right: 16),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.programName,
            style: styleElements.subtitle1ThemeScalable(context),
            textAlign: TextAlign.left,
          ),
        ),
        trailing: Checkbox(
          activeColor: HexColor(AppColors.appMainColor),
          value: item.isSelected ?? false,
          onChanged: (val) {
            if (this.mounted) {
              setState(() {
                if (val == true) {
                  classId = item.id.toString();
                  if (personType == 2) {
                    // if role type is teacher
                    // let teachers select multiple classes
                    setState(() {
                      item.isSelected = 1;
                      listSelectedPrograms.add(item);
                    });
                  } else {
                    setState(() {
                      // other roles can only select one program
                      for (int i = 0; i < listPrograms.length; i++) {
                        if (i == index) {
                          listPrograms[i].isSelected = 0;
                          listSelectedPrograms.add(listPrograms[i]);
                        } else {
                          listPrograms[i].isSelected = 0;
                          removeSelected(listPrograms[i].id);
                        }
                      }
                    });
                  }
                } else {
                  classId = "";
                  item.isSelected = 0;
                  removeSelected(item.id);
                }
              });
            }
          },
        ));
  }

  removeSelected(int id) {
    for (var i = 0; i < listSelectedPrograms.length; i++) {
      if (id == listSelectedPrograms[i].id) {
        listSelectedPrograms.removeAt(i);
        break;
      }
    }
  }

  _SelectProgram(this.instituteId, this.registerUserAs, this.personType,
      this.isAddClass, this.isVerified);
}
*/
