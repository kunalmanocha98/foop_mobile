import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/appemptywidget.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/program_data.dart';
import 'package:oho_works_app/regisration_module/programnotifier.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accedemic_selection_page.dart';

// ignore: library_prefixes

// ignore: must_be_immutable
class SelectProgramNew extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int instituteId;
  int? personType;
  bool isVerified;
  bool isAddClass;

  SelectProgramNew(this.instituteId, this.registerUserAs, this.isAddClass,
      this.personType, this.isVerified);

  _SelectProgramNew createState() => _SelectProgramNew(
      instituteId, registerUserAs, personType, isAddClass, isVerified);
}

class _SelectProgramNew extends State<SelectProgramNew>
    with SingleTickerProviderStateMixin {
  String? searchVal;
  String? personName;
  String? type;
  int? id;
  String? ownerType;
  int? ownerId;
  int? instituteId;
  RegisterUserAs? registerUserAs;
  int? personType;
  bool isVerified;
  bool isAddClass;
  String? accedamicId;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<PaginatorState> paginatorKeyChat = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  List<CustomTabMaker> list = [];

  String? pageTitle;
  ProgramNotifier? chatNotifier;
  BuildContext? ctx;
  bool isAlreadySent = false;
  String? acedemicYear;
  List<ProgramDataItem> listSelectedPrograms = [];
  List<Programs> _listSelectedPrograms = [];

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ownerId = prefs.getInt(Strings.userId);
      instituteId = registerUserAs!.institutionId;
    });
    ProgramNotifier notifier =
        Provider.of<ProgramNotifier>(context, listen: false);
    if (searchVal != null && searchVal!.isNotEmpty)
      notifier.search(searchVal, instituteId, context, _listSelectedPrograms);
    else
      notifier.reload(searchVal, instituteId, context,  _listSelectedPrograms);
  }

  @override
  void initState() {
    super.initState();
    if (registerUserAs != null) {
      acedemicYear = registerUserAs!.academicYear;
      instituteId = registerUserAs!.institutionId;
      if(registerUserAs!.personTypeList!=null && registerUserAs!.personTypeList!.isNotEmpty)
      personType = registerUserAs!.personTypeList![0];
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => _setPref());
  }

  void onsearchValueChanged(String text) {
    setState(() {
      searchVal = text;
    });
    if (text.isNotEmpty)
      chatNotifier!.search(
          text, instituteId, context,  _listSelectedPrograms);
    else
      chatNotifier!.reload(
          text, instituteId, context, _listSelectedPrograms);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    chatNotifier = Provider.of<ProgramNotifier>(context);
    this.ctx = context;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: ()  {
        Navigator.pop(context);
        return new Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: appAppBar().getCustomAppBar(
              context,
              appBarTitle: AppLocalizations.of(context)!
                  .translate('select_programme'),
              onBackButtonPress: () async {
                Navigator.pop(context);
              },
            ),
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: SearchBox(
                        onvalueChanged: onsearchValueChanged,
                        hintText:
                            AppLocalizations.of(context)!.translate('search'),
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
                                    registerUserAs!.academicYear = acedemicYear;
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: <Widget>[
                                                Visibility(
                                                  visible: acedemicYear != null,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      acedemicYear ?? "",
                                                      style: styleElements
                                                          .subtitle1ThemeScalable(
                                                              context),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    acedemicYear != null
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'selected_financial_year')
                                                        : AppLocalizations.of(
                                                                context)!
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
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                width: 20.0,
                                                height: 20.0,
                                                child: Icon(Icons.date_range,
                                                    color: HexColor(AppColors.appColorBlack85)),
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
                              color: HexColor(AppColors.appMainColor10),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  topLeft: Radius.circular(4.0))),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            child: Text(
                              personType == 3
                                  ? AppLocalizations.of(context)!
                                      .translate("program_quote")
                                  : personType == 4
                                      ? AppLocalizations.of(context)!
                                          .translate("program_quote_parent")
                                      : personType == 5
                                          ? AppLocalizations.of(context)!
                                              .translate("program_quote_alumni")
                                          : AppLocalizations.of(context)!
                                              .translate(
                                                  "program_quote_teacher"),
                              textAlign: TextAlign.center,
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
                            ),
                          ),
                        )),
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 62),
                      child: chatNotifier != null &&
                              chatNotifier!.getConversationList() != null &&
                              chatNotifier!.getConversationList()!.isNotEmpty
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo is ScrollEndNotification &&
                                    scrollInfo.metrics.extentAfter == 0) {
                                  chatNotifier!.getMore(searchVal, instituteId,
                                      context, _listSelectedPrograms);
                                  return true;
                                }
                                return false;
                              },
                              child:
                              ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: chatNotifier!.getConversationList()!.length,
                                  itemBuilder: (context, index) {
                                    return listItemBuilder(chatNotifier!.getConversationList()![index].programs!,
                                        chatNotifier!.getConversationList()![index].degreeType!);
                                  }),


                        /*GroupedListView<dynamic, String>(
                                elements: chatNotifier.getConversationList(),
                                groupBy: (element) => element.degreeType,
                                groupComparator: (value1, value2) =>
                                    value2.compareTo(value1),
                                itemComparator: (item1, item2) => item1
                                    .degreeType
                                    .compareTo(item2.degreeType),
                                order: GroupedListOrder.ASC,
                                useStickyGroupSeparators: true,
                                groupSeparatorBuilder: (String value) =>
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 30,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: styleElements
                                                  .subtitle2ThemeScalable(
                                                      context),
                                            ),
                                          ),
                                        )),
                                itemBuilder: (c, element) {
                                  return Container(
                                    margin: const EdgeInsets.all(4),
                                    child: listItemBuilder(
                                        element.programs, element.degreeType),
                                  );
                                },
                              )*/
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: appEmptyWidget(
                                    message: AppLocalizations.of(context)!
                                        .translate('no_conversation'),
                                  ),
                                )
                                    // EmptyWidget(AppLocalizations.of(context)
                                    //     .translate('no_data'),
                                    );
                              }),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        color: HexColor(AppColors.appColorWhite),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 16.0),
                          child: Container(
                            child: Row(
                              children: [
                                Spacer(),
                                appProgressButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: HexColor(
                                              AppColors.appMainColor))),
                                  onPressed: () async {
                                    try {
                                      if (acedemicYear != null) {
                                                                            List<int?> ids = getIds();

                                                                            if (ids.length > 0) {
                                                                              registerUserAs!.isDepartment =
                                                                                  await isHigherSecondary();
                                                                              registerUserAs!.personPrograms = ids;
                                                                              Navigator.of(context).pop({'registerUserAs': registerUserAs});
                                                                            } else {
                                                                              ToastBuilder().showToast(
                                                                                  AppLocalizations.of(context)!
                                                                                      .translate("select_program"),
                                                                                  context,
                                                                                  HexColor(AppColors.information));
                                                                            }
                                                                          } else {
                                                                            ToastBuilder().showToast(
                                                                                AppLocalizations.of(context)!
                                                                                    .translate("select_department"),
                                                                                context,
                                                                                HexColor(AppColors.information));
                                                                          }
                                    } catch (e) {
                                      print(e);
                                      ToastBuilder().showToast(
                                          e.toString(),
                                          context,
                                          HexColor(AppColors.information));
                                    }
                                  },
                                  color: HexColor(AppColors.appColorWhite),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('next')
                                        ,
                                    style: styleElements
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(
                                            color: HexColor(
                                                AppColors.appMainColor)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  generate_tags(List<Programs> programs, String degreeType) {
    return programs.map((programs) => get_chip(programs, degreeType)).toList();
  }

  get_chip(Programs programs, String degreeType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (programs.isSelected!) {
          chatNotifier!.updateItem(
              programs, degreeType, false, personType == 2 ? true : false);
          removeSelected(programs.id);
        } else {
          if (personType != 2) _listSelectedPrograms.clear();
          chatNotifier!.updateItem(programs, degreeType, true, personType == 2 ? true : false);
          _listSelectedPrograms.add(programs);
          setState(() {

          });
        }
      },
      child: Chip(
          elevation: 2.0,
          backgroundColor: programs.isSelected!
              ? HexColor(AppColors.appMainColor)
              : HexColor(AppColors.appColorWhite),
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(programs.programName ?? "",
                style: styleElements.subtitle2ThemeScalable(context).copyWith(
                    color: programs.isSelected!
                        ? HexColor(AppColors.appColorWhite)
                        : HexColor(AppColors.appColorBlack65))),
          )),
    );
  }

  Widget listItemBuilder(List<Programs> programs, String degreeType) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(degreeType,
              style: styleElements.subtitle2ThemeScalable(context),),
          ),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[...generate_tags(programs, degreeType)],
          ),
        ],
      ),
    );
  }

  removeSelected(int? id) {
    for (var i = 0; i < _listSelectedPrograms.length; i++) {
      if (id == _listSelectedPrograms[i].id) {
        _listSelectedPrograms.removeAt(i);
        break;
      }
    }
  }

  getIds() {
    List<int?> list = [];
    for (var i = 0; i < _listSelectedPrograms.length; i++) {
      list.add(_listSelectedPrograms[i].id);
    }
    return list;
  }

  Future<bool> isHigherSecondary() async {
    for (var i = 0; i < _listSelectedPrograms.length; i++) {
      if (_listSelectedPrograms[i].programCode != "K12" &&
          _listSelectedPrograms[i].programCode !=
              "Primary school (1st to 5th)" &&
          _listSelectedPrograms[i].programCode !=
              "Middle School (6th to 8th)" &&
          _listSelectedPrograms[i].programCode != "High School (9th & 10th)" &&
          _listSelectedPrograms[i].programCode != "Play School" &&
          _listSelectedPrograms[i].programCode !=
              "Pre-School (Nursery, Kintergarden)") {
        return true;
      }
    }
    return false;
  }

  _SelectProgramNew(this.instituteId, this.registerUserAs, this.personType,
      this.isAddClass, this.isVerified);
}
