import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/add_new_skill.dart';
import 'package:oho_works_app/models/add_new_skill_response.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
import 'package:oho_works_app/models/subject_response.dart';
import 'package:oho_works_app/regisration_module/subjectProvider.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accedemic_selection_page.dart';


// ignore: library_prefixes

// ignore: must_be_immutable
class SubjectsPageNew extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int instituteId;
  int? personType;
  bool isVerified;
  bool isAddClass;

  SubjectsPageNew(this.instituteId, this.registerUserAs, this.isAddClass,
      this.personType, this.isVerified);

  _SubjectsPageNew createState() => _SubjectsPageNew(
      instituteId, registerUserAs, personType, isAddClass, isVerified);
}

class _SubjectsPageNew extends State<SubjectsPageNew>
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

  List<Subjects> listSelectedSubjects = [];
  List<CustomTabMaker> list = [];

  String? pageTitle;
  SubjectsProvider? chatNotifier;
  BuildContext? ctx;
  bool isAlreadySent = false;
  String? acedemicYear;

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ownerId = prefs.getInt(Strings.userId);
      instituteId = registerUserAs!.institutionId;
    });
    SubjectsProvider notifier =
    Provider.of<SubjectsProvider>(context, listen: false);
    if(searchVal!=null && searchVal!.isNotEmpty)
      notifier.search(searchVal, instituteId, context);
    else
      notifier.reload(searchVal, instituteId, context);
  }

  @override
  void initState() {
    super.initState();
    if (registerUserAs != null) {
      acedemicYear = registerUserAs!.academicYear;
      instituteId = registerUserAs!.institutionId;
      personType = registerUserAs!.personTypeList![0];
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => _setPref());
  }

  void onsearchValueChanged(String text) {

    setState(() {
      searchVal=text;
    });
    if(text.isNotEmpty)
      chatNotifier!.search(text, instituteId, context);
    else
      chatNotifier!.reload(text, instituteId, context);
  }



  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    chatNotifier = Provider.of<SubjectsProvider>(context);
    this.ctx = context;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        Navigator.pop(context);
        return new Future(() => false);
      } ,
      child: SafeArea(
        child: Scaffold(
            appBar: TricycleAppBar().getCustomAppBar(
              context,
              appBarTitle:
              AppLocalizations.of(context)!.translate('subjects'),
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
                                                                'selected_academic_year')
                                                                : AppLocalizations.of(
                                                                context)!
                                                                .translate(
                                                                'select_academic_year'),
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
                                    registerUserAs!.personTypeList![0] ==
                                        2
                                        ? AppLocalizations.of(
                                        context)!
                                        .translate(
                                        "teacher_sub_info")
                                        : registerUserAs!.personTypeList![0] ==
                                        3
                                        ? AppLocalizations.of(context)!.translate(
                                        "student_subj_inf")
                                        : "",
                                    textAlign:
                                    TextAlign
                                        .center,
                                    style: styleElements
                                        .captionThemeScalable(
                                        context)),
                              ),
                            )),
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [Container(
                    margin: const EdgeInsets.only(bottom: 62),
                    child: chatNotifier != null &&
                        chatNotifier!.getConversationList() != null &&
                        chatNotifier!.getConversationList()!.isNotEmpty
                        ? NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollEndNotification &&
                            scrollInfo.metrics.extentAfter == 0) {
                          chatNotifier!.getMore(
                              searchVal, instituteId, context);
                          return true;
                        }
                        return false;
                      },
                      child:   ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          physics: BouncingScrollPhysics(),
                          itemCount: chatNotifier!.getConversationList()!.length,
                          itemBuilder: (context, index) {
                            return listItemBuilder(chatNotifier!.getConversationList()![index].subjects!,
                                chatNotifier!.getConversationList()![index].subjectCategoryName!);
                          }),
                    )
                        : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TricycleEmptyWidget(
                                  message: searchVal!=null && searchVal!.isNotEmpty?AppLocalizations.of(context)!
                                      .translate('add_new_subject_click'):AppLocalizations.of(context)!
                                      .translate('no_data'),
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
                          padding:
                          const EdgeInsets.only(top: 8, bottom: 8, right: 16.0),
                          child: Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left :16.0),
                                  child: TricycleProgressButton(

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: HexColor(AppColors.appMainColor))),
                                    onPressed: () async {
                                      Navigator.of(context).pop({
                                        'registerUser': registerUserAs
                                      });
                                    },
                                    color: HexColor(AppColors.appColorWhite),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('skip')
                                          .toUpperCase(),
                                      style: styleElements
                                          .subtitle2ThemeScalable(context)
                                          .copyWith(
                                          color:
                                          HexColor(AppColors.appMainColor)),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                TricycleProgressButton(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: HexColor(AppColors.appMainColor))),
                                  onPressed: () async {
                                    if (acedemicYear != null) {
                                      if (chatNotifier!.getConversationList() != null &&
                                          chatNotifier!.getConversationList()!.isEmpty &&
                                          searchVal != null && searchVal!.isNotEmpty) {
                                        addNewLangSkill(searchVal);
                                      }
                                      else
                                        {
                                          List<int> ids=getIds();;
                                          if (ids.length > 0) {
                                            registerUserAs!.personSubjects = ids;
                                            Navigator.of(context).pop({
                                              'registerUser': registerUserAs
                                            });
                                          } else {
                                            registerUserAs!.personSubjects=[];
                                            Navigator.of(context).pop({
                                              'registerUser': registerUserAs
                                            });
                                          }
                                        }


                                    } else {
                                      ToastBuilder().showToast(
                                          AppLocalizations.of(context)!
                                              .translate("select_academic"),
                                          context,
                                          HexColor(AppColors.information));
                                    }
                                  },
                                  color: HexColor(AppColors.appColorWhite),
                                  child: Text(
                                    AppLocalizations.of(context)!
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
                )
            )),
      ),
    );
  }
  getIds() {
    List<int?> list = [];
    for (var i = 0; i < listSelectedSubjects.length; i++) {
      list.add(listSelectedSubjects[i].id);
    }
    return list;
  }
  generate_tags(List<Subjects> subject, String degreeType) {
    return subject.map((subject) => get_chip(subject, degreeType)).toList();
  }

  get_chip(Subjects subject, String degreeType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (subject.isSelected!) {
          chatNotifier!.updateItem(
              subject, degreeType, false, true);
          removeSelected(subject.id);
        } else {
          chatNotifier!.updateItem(
              subject, degreeType, true, true);
          listSelectedSubjects.add(subject);
        }
      },
      child: Chip(
          elevation: 2.0,
          backgroundColor: subject.isSelected!
              ? HexColor(AppColors.appMainColor)
              : HexColor(AppColors.appColorWhite),
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(subject.subjectName ?? "",
                style: styleElements.subtitle2ThemeScalable(context).copyWith(
                    color: subject.isSelected!
                        ? HexColor(AppColors.appColorWhite)
                        : HexColor(AppColors.appColorBlack65))),
          )),
    );
  }
  void addNewLangSkill(String? searchValue) async {
    AddNewSkillLangEntity addNewSkillLangEntity = AddNewSkillLangEntity();
    addNewSkillLangEntity.categoryType = "subject";
    addNewSkillLangEntity.valueCode = searchValue;
    addNewSkillLangEntity.instituteId = instituteId;
    addNewSkillLangEntity.valueName = searchValue;
    addNewSkillLangEntity.valueDescription = searchValue;

    Calls()
        .call(
        jsonEncode(addNewSkillLangEntity), context, Config.COMMON_NEW_ENTRY)
        .then((value) {

      var res = AddNewSkillLangResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        chatNotifier!.search(searchVal, instituteId, context);
      } else {}
    }).catchError((onError) {
      print(onError);

    });
  }
  Widget listItemBuilder(List<Subjects> subject, String degreeType) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            children: <Widget>[...generate_tags(subject, degreeType)],
          ),
        ],
      )
    );
  }
  removeSelected(int? id) {
    for (var i = 0; i < listSelectedSubjects.length; i++) {
      if (id == listSelectedSubjects[i].id) {
        listSelectedSubjects.removeAt(i);
        break;
      }
    }
  }



  _SubjectsPageNew(this.instituteId, this.registerUserAs, this.personType,
      this.isAddClass, this.isVerified);
}
