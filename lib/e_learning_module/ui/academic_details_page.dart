import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/models/e_learning/academic_details_selection_model.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'academic_details_selection_pages.dart';


// ignore: must_be_immutable
class AcademicDetailspage extends StatefulWidget {
final PostCreatePayload? createLessonData;

  const AcademicDetailspage({Key? key, this.createLessonData}) : super(key: key);
  _AcademicDetailspage createState() => _AcademicDetailspage();


}

class _AcademicDetailspage extends State<AcademicDetailspage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  List<AcademicDetailSelectionItem> affiliatedList = [];
  List<AcademicDetailSelectionItem> programmesList = [];
  List<AcademicDetailSelectionItem> classesList = [];
  List<AcademicDetailSelectionItem> subjectsList = [];
  List<AcademicDetailSelectionItem> disciplineList = [];

  @override
  void initState() {
    super.initState();

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
              Padding(
                padding: const EdgeInsets.only(top:16.0,left: 16.0,right: 16.0),
                child: InkWell(
                  onTap: (){
                    if(widget.createLessonData!.affiliatedList!=null &&widget.createLessonData!.programmesList!=null&& widget.createLessonData!.disciplineList!=null&&
                    widget.createLessonData!.classesList!=null && widget.createLessonData!.subjectsList!=null)
                    {
                      { Navigator.pop(context, widget.createLessonData);}
                    }
                    else
                    {
                      ToastBuilder().showToast(
                          AppLocalizations.of(context)!
                              .translate("topic_group"),
                          context,
                          HexColor(AppColors.information));
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('next'),
                    style: styleElements
                        .subtitle2ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ),
            ],
            appBarTitle:
            " Academic details",
            onBackButtonPress: () {
              Navigator.pop(context, widget.createLessonData);
            },
          ),
          body: Stack(

            children: [
              Container(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 20, bottom: 20),
                    child: ListView(
                      children: [
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Affiliated board",
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select the affiliated board of your lesson",
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: affiliatedList.length>0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AcademicDetailsSelectionPages(
                                      selectedList: affiliatedList,
                                      type: AcademicDetailType.affiliated,
                                    ),
                                  )).then((value){
                                    setState(() {
                                      if(value!=null){
                                        affiliatedList = value;
                                        widget.createLessonData!.affiliatedList=value;
                                      }
                                    });
                              });
                            },
                          ),
                        ),
                        Opacity(
                          opacity:1.0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                     "Porgramme",
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select or create the programme of the students for your lessons",
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: programmesList.length>0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AcademicDetailsSelectionPages(
                                      selectedList: programmesList,
                                      type: AcademicDetailType.programme,
                                    ),
                                  )).then((value){
                                setState(() {
                                  if(value!=null){
                                    programmesList = value;
                                    widget.createLessonData!.programmesList=value;
                                  }
                                });
                              });
                            },
                          ),
                        ),
                        Opacity(
                          opacity:1.0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Discipline",
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select the discipline of the students for your lessons",
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: disciplineList.length>0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AcademicDetailsSelectionPages(
                                      selectedList: disciplineList,
                                      type: AcademicDetailType.discipline,
                                    ),
                                  )).then((value){
                                setState(() {
                                  if(value!=null){
                                    disciplineList = value;
                                    widget.createLessonData!.disciplineList=value;
                                  }
                                });
                              });
                            },
                          ),
                        ),
                        Opacity(
                          opacity: 1.0,
                          child: Visibility(

                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: appCard(

                                child: ListTile(
                                    tileColor: HexColor(AppColors.listBg),
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Class or year",
                                        style: styleElements
                                            .subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                       "Select the class or year of the students for your lessons",
                                        style: styleElements
                                            .bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    trailing: Visibility(
                                      visible: classesList.length>0,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: HexColor(AppColors.appColorGreen),
                                        size: 20,
                                      ),
                                    )),
                              ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AcademicDetailsSelectionPages(
                                        selectedList: classesList,
                                        type: AcademicDetailType.classes,
                                      ),
                                    )).then((value){
                                  setState(() {
                                    if(value!=null){
                                      classesList = value;
                                      widget.createLessonData!.classesList=value;
                                    }
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(

                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                  tileColor: HexColor(AppColors.listBg),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Subjects",
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select the subject of the students for your lessons",
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: subjectsList.length>0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: HexColor(AppColors.appColorGreen),
                                      size: 20,
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AcademicDetailsSelectionPages(
                                      selectedList: subjectsList,
                                      type: AcademicDetailType.subjects,
                                    ),
                                  )).then((value){
                                setState(() {
                                  if(value!=null){
                                    subjectsList = value;
                                    widget.createLessonData!.subjectsList=value;
                                  }
                                });
                              });
                            },
                          ),
                        ),

                      ],
                    ))),
            ],

          )),
    );
  }


  _AcademicDetailspage();
}
