import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/customcard.dart';

import 'package:oho_works_app/e_learning_module/model/create_lesson_data.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'academic_details_page.dart';
import 'chapters_page.dart';
import 'create_topic_page.dart';

// ignore: must_be_immutable
class CreateChapterLessonMainPage extends StatefulWidget {
  _CreateChapterLessonMainPage createState() => _CreateChapterLessonMainPage();
}

class _CreateChapterLessonMainPage extends State<CreateChapterLessonMainPage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  PostCreatePayload? createLessonData = PostCreatePayload();
  LessonTopic lessonTopic=LessonTopic();
  bool isTopicDone = false;
  bool isAcademicDone = false;
  bool isChapterLessonDone = false;
  bool isTestDone = false;

  @override
  void initState() {
    super.initState();
    createLessonData!.lessonTopic=lessonTopic;
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
            appBarTitle:
                AppLocalizations.of(context)!.translate('create_lessons'),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(
            children: [
              Container(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 50, bottom: 20),
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
                                        AppLocalizations.of(context)!
                                            .translate("lesson_topic"),
                                        style: styleElements
                                            .subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("create_topic"),
                                        style: styleElements
                                            .bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    trailing: Visibility(
                                      visible: isTopicDone,
                                      child: Icon(
                                        Icons.check_circle,
                                        color:
                                            HexColor(AppColors.appColorGreen),
                                        size: 20,
                                      ),
                                    )),
                              ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateTopicPage(
                                          createLessonData: createLessonData),
                                    )).then((value) {
                                  createLessonData = value;
                                  isTopicDone = createLessonData!.lessonTopic!.title !=
                                          null &&
                                      createLessonData!.lessonTopic!.topic != null &&
                                      createLessonData!.learnerItem != null;
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                         Visibility(
                              visible:false,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: appCard(
                                  child: ListTile(
                                      tileColor: HexColor(AppColors.listBg),
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate("Academic_detail"),
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate("academic_subtitle"),
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      trailing: Visibility(
                                        visible: isAcademicDone,
                                        child: Icon(
                                          Icons.check_circle,
                                          color:
                                              HexColor(AppColors.appColorGreen),
                                          size: 20,
                                        ),
                                      )),
                                ),
                                onTap: () async {
                                  if(isTopicDone)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AcademicDetailspage(
                                                createLessonData: createLessonData
                                            ),
                                      )).then((value) {

                                        isAcademicDone=(createLessonData!.affiliatedList!=null &&createLessonData!.programmesList!=null&& createLessonData!.disciplineList!=null&&
                                            createLessonData!.classesList!=null &&createLessonData!.subjectsList!=null

                                        );
                                        setState(() {



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
                                          AppLocalizations.of(context)!
                                              .translate("chapters_lessons"),
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate("chapter_subtitle"),
                                          style: styleElements
                                              .bodyText2ThemeScalable(context),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      trailing: Visibility(
                                        visible: false,
                                        child: Icon(
                                          Icons.check_circle,
                                          color:
                                              HexColor(AppColors.appColorGreen),
                                          size: 20,
                                        ),
                                      )),
                                ),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateChapterPage(createLessonData:createLessonData),
                                      ));
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: appCard(
                                child: ListTile(
                                    tileColor: HexColor(AppColors.listBg),
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("tests"),
                                        style: styleElements
                                            .subtitle1ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("test_subtitle"),
                                        style: styleElements
                                            .bodyText2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    trailing: Visibility(
                                      visible: false,
                                      child: Icon(
                                        Icons.check_circle,
                                        color:
                                            HexColor(AppColors.appColorGreen),
                                        size: 20,
                                      ),
                                    )),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostCreatePage(
                                          type: 'learning',
                                          question: null,
                                          prefs: null,
                                        )));
                              },
                            ),
                          ),
                        ],
                      ))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: HexColor(AppColors.appColorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('save_draft')
                                  .toUpperCase(),
                              style: styleElements
                                  .subtitle2ThemeScalable(context)
                                  .copyWith(
                                      color: HexColor(AppColors.appMainColor)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: appProgressButton(
                              key: progressButtonKeyNext,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {},
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('publish')
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                        color:
                                            HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          ),
                        ],
                      )))
            ],
          )),
    );
  }

  _CreateChapterLessonMainPage();
}
