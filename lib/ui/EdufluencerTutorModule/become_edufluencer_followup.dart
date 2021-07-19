import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/suggestion_field_models.dart';
import 'package:oho_works_app/models/edufluencer_tutor_create_models.dart';
import 'package:oho_works_app/models/expertise_list.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BecomeEdufluencerFollowupPage extends StatefulWidget {
  final CreateEdufluencerTutorRequest payload;
  final edufluencer_type type;
  BecomeEdufluencerFollowupPage({this.payload,this.type});
  @override
  BecomeEdufluencerFollowupPageState createState() =>
      BecomeEdufluencerFollowupPageState(payload: payload);
}

class BecomeEdufluencerFollowupPageState
    extends State<BecomeEdufluencerFollowupPage>
    with CommonMixins{
  CreateEdufluencerTutorRequest payload;
  BecomeEdufluencerFollowupPageState({this.payload});
  TextStyleElements styleElements;
  List<SkillsList> skillsList = [];
  List<SubjectsList> subjectsList = [];
  List<ClassesList> classesList = [];
  TextEditingController specialistController = TextEditingController();
  TextEditingController subjectsController = TextEditingController();
  TextEditingController classesController = TextEditingController();
  SharedPreferences prefs = locator<SharedPreferences>();


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(
      appBar: TricycleAppBar().getCustomAppBar(
        context,
        appBarTitle:
        AppLocalizations.of(context).translate(widget.type == edufluencer_type.E?'become_edufluencer':"become_tutor"),
        actions: [
          TricycleTextButton(
            onPressed: () {
              create();
            },
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('create'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ],
            ),
            shape: CircleBorder(),
          ),
        ],
        onBackButtonPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: payload.edufluencerType == edufluencer_type.E.type,
                  child:getSpecialities()),
              Visibility(
                visible: payload.edufluencerType == edufluencer_type.T.type,
                  child: getSubjects()),
              Visibility(
                visible: payload.edufluencerType == edufluencer_type.T.type,
                  child: getClasses()),
              // EdufluemcerProfileCard(),
              // EdufluencerSpecialistSubjectCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget customCard(String heading, {Widget child}) {
    return TricycleListCard(
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(heading,
              style: styleElements.headline6ThemeScalable(context).copyWith(
                  fontWeight: FontWeight.bold
              ),),
            child
          ],
        )
    );
  }

  Widget getSpecialities() {
    return customCard('Skills & specialities',
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            suggestionsCallback: (String pattern) async {
              if (pattern.isNotEmpty) {
                var data = {
                  "search_val": pattern,
                  "expertise_category_code": "Skill",
                  "page_number": 1,
                  "page_size": 5,
                  "person_id": prefs.getInt(Strings.userId),
                };
                var res = await Calls()
                    .call(jsonEncode(data), context, Config.EXPERTISE_API);
                if (ExpertiseList.fromJson(res).rows.length > 0) {
                  return ExpertiseList.fromJson(res).rows;
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
            itemBuilder: (BuildContext context, LanguageItem itemData) {
              return ListTile(
                title: Text(
                  itemData.expertiseTypeDescription,
                  style: styleElements.subtitle1ThemeScalable(context),
                ),
              );
            },
            onSuggestionSelected: (LanguageItem suggestion) {
              setState(() {
                specialistController.text = "";
                skillsList.add(SkillsList(
                  skillName: suggestion.expertiseTypeDescription,
                  skillCode: suggestion.expertiseTypeCode,
                  skillId: suggestion.standardExpertiseCategoryId
                ));
              });
            },
            direction: AxisDirection.up,
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: specialistController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16, left: 8, right: 16),
                  hintText: AppLocalizations.of(context)
                      .translate('enter_special_skills'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))),
            ),
          ),
          Visibility(
            visible: skillsList.length>0,
            child: Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: skillsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Chip(
                    label: Text(skillsList[index].skillName),
                    padding: EdgeInsets.all(8),
                    onDeleted: (){
                      setState(() {
                        skillsList.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget getSubjects() {
    return customCard('Subjects tutoring',
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            suggestionsCallback: (String pattern) async {
              if (pattern.isNotEmpty) {
                var data =  {"searchVal":pattern,"page_number":1,"page_size":5};
                var res = await Calls()
                    .call(jsonEncode(data), context, Config.SUBJECT_MASTERLIST);
                if (SubjectListResponse.fromJson(res).rows.length > 0) {
                  return SubjectListResponse.fromJson(res).rows;
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
            itemBuilder: (BuildContext context, SubjectListItem itemData) {
              return ListTile(
                title: Text(
                  itemData.subjectName,
                  style: styleElements.subtitle1ThemeScalable(context),
                ),
              );
            },
            onSuggestionSelected: (SubjectListItem suggestion) {
              setState(() {
                subjectsController.text = "";
                subjectsList.add(SubjectsList(
                  subjectId: suggestion.subjectId,
                  subjectCode: suggestion.subjectCode,
                  subjectName: suggestion.subjectName
                ));
              });
            },
            direction: AxisDirection.down,
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: subjectsController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16, left: 8, right: 16),
                  hintText: AppLocalizations.of(context)
                      .translate('enter_subjects_coach'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context)),
            ),
          ),
          Visibility(
            visible: subjectsList.length>0,
            child: Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: subjectsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Chip(
                    label: Text(subjectsList[index].subjectName),
                    padding: EdgeInsets.all(8),
                    onDeleted: (){
                      setState(() {
                        subjectsList.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget getClasses() {
    return customCard('Classes & Discipline',
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            suggestionsCallback: (String pattern) async {
              if (pattern.isNotEmpty) {
                var data = {
                  "search_val": pattern,
                  "expertise_category_code": "Skill",
                  "page_number": 1,
                  "page_size": 5,
                  "person_id": 1128,
                };
                var res = await Calls()
                    .call(jsonEncode(data), context, Config.CLASS_MASTERLIST);
                if (ClassListResponse.fromJson(res).rows.length > 0) {
                  return ClassListResponse.fromJson(res).rows;
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
            itemBuilder: (BuildContext context, ClassListItem itemData) {
              return ListTile(
                title: Text(
                  itemData.className,
                  style: styleElements.subtitle1ThemeScalable(context),
                ),
              );
            },
            onSuggestionSelected: (ClassListItem suggestion) {
              setState(() {
                classesController.text = "";
                classesList.add(ClassesList(
                  classId: suggestion.classId,
                  classCode: suggestion.classCode,
                  className:suggestion.className
                ));
              });
            },
            direction: AxisDirection.up,
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: classesController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16, left: 8, right: 16),
                  hintText: AppLocalizations.of(context)
                      .translate('enter_class_coach'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))),
            ),
          ),
          Visibility(
            visible: classesList.length>0,
            child: Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: classesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Chip(
                    label: Text(classesList[index].className),
                    padding: EdgeInsets.all(8),
                    onDeleted: (){
                      setState(() {
                        classesList.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void create() {
    payload.skillsList = skillsList;
    payload.subjectsList = subjectsList;
    payload.classesList = classesList;
    Calls().call(jsonEncode(payload), context, Config.EDUFLUENCER_REGISTER).then((value){
      var response = CreateEdufluencerResponse.fromJson(value);
      if(response.statusCode == Strings.success_code){
        ToastBuilder().showToast(AppLocalizations.of(context).translate('registered_successfully'), context, HexColor(AppColors.information));
        Navigator.pop(context,true);
      }
    }).catchError((onError){
      print(onError.toString());
    });
  }
}
