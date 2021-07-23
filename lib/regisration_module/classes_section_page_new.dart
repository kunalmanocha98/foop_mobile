import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/classes_sections.dart';
import 'package:oho_works_app/models/custom_tab_maker.dart';
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
import 'classes_section_provider.dart';

// ignore: library_prefixes

// ignore: must_be_immutable
class selectClassesAndSections extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  int instituteId;
  int? personType;
  bool isVerified;
  bool isAddClass;

  selectClassesAndSections(this.instituteId, this.registerUserAs,
      this.isAddClass, this.personType, this.isVerified);

  _SelectDisicipline createState() => _SelectDisicipline(
      instituteId, registerUserAs, personType, isAddClass, isVerified);
}

class _SelectDisicipline extends State<selectClassesAndSections>
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
  ClassesAndSectionsProvider? chatNotifier;
  BuildContext? ctx;
  bool isAlreadySent = false;
  String? acedemicYear;
  List<PersonClasses> listSelectedClasses = [];

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ownerId = prefs.getInt(Strings.userId);
      instituteId = registerUserAs!.institutionId;
    });
    ClassesAndSectionsProvider notifier =
        Provider.of<ClassesAndSectionsProvider>(context, listen: false);
    if (searchVal != null && searchVal!.isNotEmpty)
      notifier.search(searchVal, instituteId, context, listSelectedClasses);
    else
      notifier.reload(searchVal, instituteId, context, listSelectedClasses);
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
      searchVal = text;
    });
    if (text.isNotEmpty)
      chatNotifier!.search(text, instituteId, context, listSelectedClasses);
    else
      chatNotifier!.reload(text, instituteId, context, listSelectedClasses);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    chatNotifier = Provider.of<ClassesAndSectionsProvider>(context);
    this.ctx = context;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        Navigator.pop(context);
        return new Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: TricycleAppBar().getCustomAppBar(
              context,
              appBarTitle: AppLocalizations.of(context)!.translate('classes'),
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
                              personType == 3
                                  ? AppLocalizations.of(context)!
                                      .translate("select_class_student")
                                  : personType == 4
                                      ? AppLocalizations.of(context)!.translate(
                                          "parent_child_select_class")
                                      : personType == 5
                                          ? AppLocalizations.of(context)!
                                              .translate("alumni_select_class")
                                          : AppLocalizations.of(context)!
                                              .translate(
                                                  "teacher_classes_info"),
                              textAlign: TextAlign.center,
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(
                                      color:
                                          HexColor(AppColors.appColorBlack85)),
                            ),
                          ),
                        )),
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [
                    chatNotifier != null &&
                            chatNotifier!.getConversationList() != null &&
                            chatNotifier!.getConversationList()!.isNotEmpty
                        ? NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo is ScrollEndNotification &&
                                  scrollInfo.metrics.extentAfter == 0) {
                                chatNotifier!.getMore(searchVal, instituteId,
                                    context, listSelectedClasses);
                                return true;
                              }
                              return false;
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.only(left:0.0,right: 0.0,top:0.0,bottom: 70),
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    chatNotifier!.getConversationList()!.length,
                                itemBuilder: (context, index) {
                                  return listItemBuilder(

                                      chatNotifier!
                                          .getConversationList()![index]
                                          .sections!,
                                      chatNotifier!
                                          .getConversationList()![index]
                                          .className!,
                                      chatNotifier!
                                          .getConversationList()![index]
                                          .id,
                                    chatNotifier!
                                        .getConversationList()![index]
                                        .className,

                                    chatNotifier!
                                        .getConversationList()![index]
                                        .classCode,

                                  );
                                }),

                            /*GroupedListView<dynamic, String>(
                              elements: chatNotifier.getConversationList(),
                              groupBy: (element) => element.className,
                              groupComparator: (value1, value2) =>
                                  value2.compareTo(value1),
                              itemComparator: (item1, item2) =>
                                  item1.className.compareTo(item2.className),
                              order: GroupedListOrder.ASC,
                              useStickyGroupSeparators: true,
                              groupSeparatorBuilder: (String value) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 30,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: styleElements
                                            .subtitle2ThemeScalable(context),
                                      ),
                                    ),
                                  )),
                              itemBuilder: (c, element) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  child: listItemBuilder(element.sections,
                                      element.className, element.id),
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
                                child: TricycleEmptyWidget(
                                  message: AppLocalizations.of(context)!
                                      .translate('no_data'),
                                ),
                              )
                                  // EmptyWidget(AppLocalizations.of(context)
                                  //     .translate('no_data'),
                                  );
                            }),
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
                                TricycleProgressButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: HexColor(
                                              AppColors.appMainColor))),
                                  onPressed: () async {
                                    if (acedemicYear != null) {
                                      if (listSelectedClasses.isNotEmpty) {
                                        registerUserAs!.personClasses =
                                            listSelectedClasses;
                                        Navigator.of(context).pop(
                                            {'registerUser': registerUserAs});
                                      } else {
                                        ToastBuilder().showToast(
                                            AppLocalizations.of(context)!
                                                .translate("classes_subjects"),
                                            context,
                                            HexColor(AppColors.information));
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

  generate_tags(List<Sections> programs, String degreeType, int? id,String? className,String? classCode) {
    return programs
        .map((programs) => get_chip(programs, degreeType, id,className,classCode))
        .toList();
  }

  get_chip(Sections programs, String degreeType, int? id,String? className,String? classCode) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(programs.sectionName=="More")
          {
            if(programs.isSelected!)
            chatNotifier!.updateItemMoreLess(className, false);
            else
              chatNotifier!.updateItemMoreLess(className, true);
          }
        else if(programs.sectionName=="Less")
        {
          if(programs.isSelected!)
            chatNotifier!.updateItemMoreLess(classCode, false);
          else
            chatNotifier!.updateItemMoreLess(classCode, true);
        }
       else if (programs.isSelected!) {
          chatNotifier!.updateItem(programs, degreeType, false, personType == 2 ? true : false);
          removeSelected(programs.id, degreeType, id);
        } else {
          if (personType != 2) listSelectedClasses.clear();
          chatNotifier!.updateItem(programs, degreeType, true, personType == 2 ? true : false);
          addSection(programs.id, degreeType, id);
        }
      },
      child: Chip(
          elevation: 2.0,
          backgroundColor: programs.isSelected!
              ? HexColor(AppColors.appMainColor)
              : HexColor(AppColors.appColorWhite),
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(programs.sectionName ?? "",
                style: styleElements.subtitle2ThemeScalable(context).copyWith(
                    color: programs.isSelected!
                        ? HexColor(AppColors.appColorWhite)
                        : HexColor(AppColors.appColorBlack65))),
          )),
    );
  }

  addSection(int? id, String name, int? classId) {
    if (listSelectedClasses.isEmpty) {
      List<int?> sections = [];
      PersonClasses personClasses = PersonClasses();
      personClasses.classId = classId;
      personClasses.className = name;
      sections.add(id);
      personClasses.sections = sections;
      listSelectedClasses.add(personClasses);
    } else {
      if (isClassAlreadyAdded(id, name, classId)) {
      } else {
        List<int?> sections = [];
        PersonClasses personClasses = PersonClasses();
        personClasses.classId = classId;
        personClasses.className = name;
        sections.add(id);
        personClasses.sections = sections;
        listSelectedClasses.add(personClasses);
      }
    }
  }

  bool isClassAlreadyAdded(int? id, String name, int? classId) {
    for (int i = 0; i < listSelectedClasses.length; i++) {
      if (listSelectedClasses[i].classId == classId) {
        listSelectedClasses[i].sections!.add(id);
        return true;
      }
    }
    return false;
  }

  Widget listItemBuilder(List<Sections> programs, String degreeType, int? id,String? className,String? classCode) {
    late List<Sections> sectionsWithMore;
   if(programs!=null && programs.length>4)
    sectionsWithMore=programs.sublist(0,4);



    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              degreeType,
              style: styleElements.subtitle2ThemeScalable(context),
            ),
          ),


          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            // children: <Widget>[...generate_tags(programs[3].isSelected?programs :sectionsWithMore, degreeType, id,className,classCode)],

            children: <Widget>[...generate_tags(programs.length<5?programs:programs[3].isSelected!?programs :sectionsWithMore, degreeType, id,className,classCode)],

          ),
        ],
      ),
    );
  }

  removeSelected(int? id, String name, int? classId) {
    for (var i = 0; i < listSelectedClasses.length; i++) {
      if (classId == listSelectedClasses[i].classId) {
        if(listSelectedClasses[i].sections!.length==1)
          listSelectedClasses.removeAt(i);
        else
        listSelectedClasses[i].sections!.remove(id);
        break;
      }
    }
  }

  _SelectDisicipline(this.instituteId, this.registerUserAs, this.personType,
      this.isAddClass, this.isVerified);
}
