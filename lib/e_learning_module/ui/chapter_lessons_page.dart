

import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/e_learning_module/ui/academic_details_selection_pages.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/e_learning/academic_details_selection_model.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateChapterLessonsPage extends StatefulWidget {
 final List<PostCreatePayload?>? list;
  final PostReceiverListItem?  selectedReceiverData;
final Function? callBack;
final PostCreatePayload? createLessonData;
  const CreateChapterLessonsPage({Key? key, this.list, this.selectedReceiverData,this.callBack,this.createLessonData}) : super(key: key);
  _CreateChapterLessonsPage createState() => _CreateChapterLessonsPage(createLessonData: createLessonData);


}

class _CreateChapterLessonsPage extends State<CreateChapterLessonsPage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  List<PostCreatePayload>? list;
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<TricycleProgressButtonState> progressButtonKeyNext = GlobalKey();
  PostReceiverListItem? selectedReceiverData;
  PostCreatePayload? createLessonData;
  _CreateChapterLessonsPage({this.list,this.selectedReceiverData,this.createLessonData});
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
          appBar: TricycleAppBar().getCustomAppBar(
            context,
            appBarTitle:
            AppLocalizations.of(context)!.translate('institution_type'),
            actions: [
            ],
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(

            children: [

              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8,left: 16,right: 16,bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all( Radius.circular(12)),
                        color: HexColor(AppColors.appColorRed50)
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.translate("lesson_desc"),
                          style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),

                        )
                      // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                      //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, top: 20, bottom: 16),
                          child: ListView(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left :16.0,bottom: 8.0),
                              //   child: Text(
                              //     widget.list[0]!=null &&widget.list[0].lessonTopic!=null&& widget.list[0].lessonTopic.title!=null ?widget.list[0].lessonTopic.title:  AppLocalizations.of(context).translate('Topic_type'),
                              //     style: styleElements
                              //         .headline6ThemeScalable(context)
                              //         .copyWith(fontWeight: FontWeight.bold),
                              //   ),
                              // ),

                              Visibility(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: TricycleCard(

                                    child: ListTile(
                                        tileColor: HexColor(AppColors.listBg),
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("k12"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("lessons_schools"),
                                            style: styleElements
                                                .bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                     ),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AcademicDetailsSelectionPages(
                                            selectedList: getSelectedList(AcademicDetailType.classes),
                                            callBack:(){Navigator.of(context).pop();
                                            if(widget.callBack!=null)
                                            widget.callBack!();
                                            },
                                            createLessonData:createLessonData,
                                            list: widget.list,
                                            selectedReceiverData: widget.selectedReceiverData,
                                            type: AcademicDetailType.classes,

                                            category_type: 'school',

                                          ),
                                        ));
                                  },
                                ),
                              ),

                              Opacity(
                                opacity:1.0,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: TricycleCard(

                                    child: ListTile(
                                        tileColor: HexColor(AppColors.listBg),
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("collage_lesson"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("lessons_collage"),
                                            style: styleElements
                                                .bodyText2ThemeScalable(context),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AcademicDetailsSelectionPages(
                                            selectedList: getSelectedList(AcademicDetailType.programme),
                                              callBack:(){Navigator.of(context).pop();
                                              if(widget.callBack!=null)
                                                widget.callBack!();
                                              },
                                              createLessonData:createLessonData,
                                            type: AcademicDetailType.programme,
                                              list: widget.list,
                                              selectedReceiverData:selectedReceiverData
                                          ),
                                        ));
                                  },
                                ),
                              ),


                            ],
                          ))),
                  ),
                ],
              ), ],

          )),
    );
  }

  List<AcademicDetailSelectionItem> getSelectedList(AcademicDetailType type) {
    if(type == AcademicDetailType.programme) {
      if (createLessonData != null && createLessonData!.programmesList != null &&
          createLessonData!.programmesList!.length > 0) {
        return List<AcademicDetailSelectionItem>.generate(
            createLessonData!.programmesList!.length, (index) {
          return AcademicDetailSelectionItem(
            programName: createLessonData!.programmesList![index].programName,
            programCode: createLessonData!.programmesList![index].programCode,
            programId: createLessonData!.programmesList![index].id,
          );
        });
      } else {
        return [];
      }
    }else{
      if (createLessonData != null && createLessonData!.classesList != null &&
          createLessonData!.classesList!.length > 0) {
        return List<AcademicDetailSelectionItem>.generate(
            createLessonData!.classesList!.length, (index) {
          return AcademicDetailSelectionItem(
            className: createLessonData!.classesList![index].className,
            classCode: createLessonData!.classesList![index].classCode,
            classId: createLessonData!.classesList![index].id,
          );
        });
      } else {
        return [];
      }
    }
  }
}

class CommentSheet extends StatefulWidget {



  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    final name = TextField(
        controller: lastNameController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),

        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            lastNameController.text = text.toUpperCase();
            lastNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameController.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('give_topic_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate(''),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Text(
                AppLocalizations.of(context)!.translate('topic_name'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0,left: 16.0,right: 16.0),
              child: Text(
                AppLocalizations.of(context)!.translate('next'),
                style: styleElements
                    .subtitle2ThemeScalable(context)
                    .copyWith(color: HexColor(AppColors.appMainColor)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 30),
          child: name,
        ),
        Padding(
          padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 20,bottom: 60),
          child: Text(
            AppLocalizations.of(context)!.translate('topic_detail_dec'),
            style: styleElements
                .bodyText1ThemeScalable(context)
            ,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }


}