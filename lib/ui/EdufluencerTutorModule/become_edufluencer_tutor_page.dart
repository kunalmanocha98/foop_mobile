import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/edufluencer_tutor_create_models.dart';
import 'package:oho_works_app/models/expertise_list.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_followup.dart';
import 'package:oho_works_app/ui/dialogs/dialog_week_days.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

enum edufluencer_type{E,T}

extension edufluencerExt on edufluencer_type?{
  String get type{
    if(this == edufluencer_type.E){
      return 'E';
    }else{
      return 'T';
    }
  }
}

class BecomeEdufluencerTutorForm extends StatefulWidget {
  final edufluencer_type? type;
  BecomeEdufluencerTutorForm({this.type});
  @override
  BecomeEdufluencerTutorFormState createState() =>
      BecomeEdufluencerTutorFormState();
}

class BecomeEdufluencerTutorFormState extends State<BecomeEdufluencerTutorForm>
    with CommonMixins {
  late TextStyleElements styleElements;
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  TextEditingController typeAheadMediumofConversation = TextEditingController();
  String? title;
  String? jobDes;
  String? yearsofExperience;
  String? trialHours;
  String? fees;

  String? profileInfo;
  bool isFree = false;
  List<String?> medium_of_conversation = [];
  List<String> weekDaysList = [];

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(
      appBar: TricycleAppBar().getCustomAppBar(
        context,
        appBarTitle:
        AppLocalizations.of(context)!.translate(
          widget.type == edufluencer_type.E
            ?'become_edufluencer'
              :"become_tutor"
        ),
        actions: [
          TricycleProgressButton(
            key: progressButtonKey,
            shape: StadiumBorder(),
            color: HexColor(AppColors.appColorBackground),
            elevation: 0,
            onPressed: () {
              progressButtonKey.currentState!.show();
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                progressButtonKey.currentState!.hide();
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return BecomeEdufluencerFollowupPage(
                        payload: getPayload(),
                      );
                    })).then((value){
                      if(value!=null){
                        if(value){
                          Navigator.pop(context,true);
                        }
                      }
                });
              }else{
                progressButtonKey.currentState!.hide();
              }
            },
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('next'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
                Icon(Icons.keyboard_arrow_right,
                    color: HexColor(AppColors.appMainColor))
              ],
            ),
          ),
        ],
        onBackButtonPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getEdufluencerInfo(),
                getBriefIntro(),
                getMediumofConversation()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customCard(String heading, {Widget? child}) {
    return TricycleListCard(
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              heading,
              style: styleElements
                  .headline6ThemeScalable(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            child!
          ],
        ));
  }

  Widget getEdufluencerInfo() {
    return customCard(AppLocalizations.of(context)!.translate(widget.type == edufluencer_type.E
        ?'edufluencer'
        :"tutor"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: styleElements.subtitle1ThemeScalable(context),
              validator: validateTextField,
              onSaved: (value) {
                title = value;
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  hintText: AppLocalizations.of(context)!
                      .translate('hint_heading_describe_you'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))),
            ),
            TextFormField(
              style: styleElements.subtitle1ThemeScalable(context),
              validator: validateTextField,
              onSaved: (value) {
                jobDes = value;
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  hintText: AppLocalizations.of(context)!
                      .translate('hint_cuurent_job'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorBlack35)
                  )),
            ),
            Row(children: [
              Expanded(
                child: TextFormField(
                  style: styleElements.subtitle1ThemeScalable(context),
                  validator: validateTextField,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    yearsofExperience = value;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: AppLocalizations.of(context)!
                          .translate('hint_years_experience'),
                      hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorBlack35)
                      )),
                ),
              ),
              SizedBox(
                width: 24,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogWeekDays();
                        }).then((value) {
                      if (value != null) {
                        setState(() {
                          weekDaysList.addAll(value);
                        });
                      }
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 16, left: 4, bottom: 11, right: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: HexColor(AppColors.appColorGrey500),
                          ),
                        ), // set border width
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          getDaysofWeek(),
                          textAlign: TextAlign.left,
                          style:
                          weekDaysList.length>0?
                          styleElements.subtitle1ThemeScalable(context)
                          :styleElements.bodyText2ThemeScalable(context),
                        ),
                      )),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isFree,
                    onChanged: (value) {
                      setState(() {
                        isFree = !isFree;
                      });
                    },
                  ),
                  Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.translate('offering_free'),
                        style: styleElements.subtitle1ThemeScalable(context),
                      )),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: styleElements.subtitle1ThemeScalable(context),
                    validator: validateTextField,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      trialHours = value;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(4),
                        hintText: AppLocalizations.of(context)!
                            .translate('trial_hours'),
                        hintStyle:
                        styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))),
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: TextFormField(
                    style: styleElements.subtitle1ThemeScalable(context),
                    validator: validateTextField,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      fees = value;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(4),
                        hintText: AppLocalizations.of(context)!
                            .translate('fees_hours'),
                        hintStyle:
                        styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget getBriefIntro() {
    return customCard(AppLocalizations.of(context)!.translate('brief_intro'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 4,
            ),
            Text(
              AppLocalizations.of(context)!
                  .translate('write_something_about_edufluencer'),
              style: styleElements.subtitle1ThemeScalable(context),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              style: styleElements.subtitle1ThemeScalable(context),
              validator: validateTextField,
              onSaved: (value) {
                profileInfo = value;
              },
              maxLength: 1000,
              maxLines: 8,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  hintText: AppLocalizations.of(context)!
                      .translate('write_your_intro'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
          ],
        ));
  }

  CreateEdufluencerTutorRequest getPayload() {
    CreateEdufluencerTutorRequest payload = CreateEdufluencerTutorRequest();
    payload.edufluencerType = widget.type.type;
    payload.edufluencerTitle = title;
    payload.edufluencerCurrentPosition = jobDes;
    payload.totalExperienceYears = double.parse(yearsofExperience!);
    payload.isFreeService = isFree;
    payload.trialHours = double.parse(trialHours!);
    payload.feesCurrency = "INR";
    payload.feesPerHour = int.parse(fees!);
    payload.edufluencerBio = profileInfo;
    payload.mediumOfCommunication = medium_of_conversation;
    payload.working_days = weekDaysList;
    return payload;
  }

  Widget getMediumofConversation() {
    return customCard(
      AppLocalizations.of(context)!.translate('medium_conversation'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeAheadField(
            suggestionsCallback: (String pattern) async {
              if (pattern.isNotEmpty) {
                var data = {
                  "search_val": pattern,
                  "expertise_category_code": "Languages",
                  "page_number": 1,
                  "page_size": 5,
                  "person_id": 1128,
                };
                var res = await Calls()
                    .call(jsonEncode(data), context, Config.EXPERTISE_API);
                if (ExpertiseList.fromJson(res).rows!.length > 0) {
                  return ExpertiseList.fromJson(res).rows!;
                } else {
                  return [];
                }
              } else {
                return [];
              }
            },
            itemBuilder: ( context,  itemData) {

              itemData as LanguageItem;
              return ListTile(
                title: Text(
                  itemData.expertiseTypeDescription??"",
                  style: styleElements.subtitle1ThemeScalable(context),
                ),
              );
            },
            onSuggestionSelected: ( suggestion) {
              suggestion as LanguageItem;
              setState(() {
                typeAheadMediumofConversation.text = "";
                medium_of_conversation.add(suggestion.expertiseTypeDescription);
              });
            },
            direction: AxisDirection.up,
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: typeAheadMediumofConversation,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16, left: 8, right: 16),
                  hintText: AppLocalizations.of(context)!
                      .translate('enter_languages_talk'),
                  hintStyle: styleElements.bodyText2ThemeScalable(context)),
            ),
          ),
          Visibility(
            visible: medium_of_conversation.length > 0,
            child: Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: medium_of_conversation.length,
                itemBuilder: (BuildContext context, int index) {
                  return Chip(
                    label: Text(medium_of_conversation[index]!),
                    padding: EdgeInsets.all(8),
                    onDeleted: () {
                      setState(() {
                        medium_of_conversation.removeAt(index);
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

  String getDaysofWeek() {
    if (weekDaysList.length > 0) {
      String s="";
      if(weekDaysList.any((element) => "Monday" == element)){
        s = 'M';
      }
      if(weekDaysList.any((element) => "Tuesday" == element)){
        s = s+'-T';
      }
      if(weekDaysList.any((element) => "Wednesday" == element)){
        s = s+'-W';
      }
      if(weekDaysList.any((element) => "Thursday" == element)){
        s = s+'-T';
      }
      if(weekDaysList.any((element) => "Friday" == element)){
        s = s+'-F';
      }
      if(weekDaysList.any((element) => "Saturday" == element)){
        s = s+'-S';
      }
      if(weekDaysList.any((element) => "Sunday" == element)){
        s = s+'-S';
      }
      return s;
    } else {
      return "Days of week";
    }
  }
}
