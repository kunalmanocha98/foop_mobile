import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycleemptywidget.dart';
import 'package:oho_works_app/models/add_new_skill.dart';
import 'package:oho_works_app/models/add_new_skill_response.dart';
import 'package:oho_works_app/models/expertise_list.dart';
import 'package:oho_works_app/profile_module/pages/select_language_proficiency_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/add_subject_select_screen.dart';

//************************************************************

// common class for language and skill list with search

//***********************************************************

// ignore: must_be_immutable
class EditLanguage extends StatefulWidget {
  String type;
  String? instId;
  bool fromBasicProfileFLow;

  _EditLanguage createState() => _EditLanguage(
      this.type, this.instId, this.fromBasicProfileFLow, this.callbackPicker);
  Null Function()? callbackPicker;

  EditLanguage(
      this.type, this.instId, this.fromBasicProfileFLow, this.callbackPicker);
}

class _EditLanguage extends State<EditLanguage> {
 bool isLoading=false;
  late SharedPreferences prefs;
  String type;
  String? instId;
  String? searchVal;
  bool fromBasicProfileFLow;
  bool isSearching = false;
  late TextStyleElements styleElements;
  Map<LanguageItem, bool?> language = new Map();
  int? selectedLangId = -1;
 GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
 GlobalKey<TricycleProgressButtonState> progressButtonKeyNext = GlobalKey();
  @override
  void initState() {
    super.initState();
    getList("");
  }

  final _debouncer = Debouncer(500);

  //"expertise_category_code":"2" is for language
  void getList(String? searchVal) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading=true;
    });
    final body = jsonEncode({
      "search_val": searchVal,
      "expertise_category_code": type,
      "page_number": 1,
      "page_size": 100,
      "person_id": prefs.getInt("userId")
    });
    Calls().call(body, context, Config.EXPERTISE_API).then((value) async {
      setState(() {
        isLoading=false;
      });
      isSearching = false;
      if (value != null) {

        var data = ExpertiseList.fromJson(value);

        if (this.mounted && data.statusCode == "S10001") {
          language = new Map();
          setState(() {
            if (data.rows != null) {
              var list = data.rows!;
              for (var item in list) {
                if (item.id == selectedLangId)
                  language[item] = true;
                else
                  language[item] = false;
              }
            }
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
      setState(() {
        isLoading=false;
      });
    });
  }

  Widget build(BuildContext context) {
    ScreenUtil.init;
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBar(
          context,
          appBarTitle: type == "Languages" ? ' Add Language' : 'Add Skill',
          onBackButtonPress: () {
            _onBackPressed();
          },
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SearchBox(
                  onvalueChanged: (text) {
                    _debouncer.run(() {
                      isSearching = true;
                      searchVal=text;
                      getList(text);
                    });
                  },
                  hintText:
                      type == "Languages" ? ' Search Language' : 'Search Skill',
                  progressIndicator: false,
                ),

                isLoading?  PreloadingView(
                    url: "assets/appimages/settings.png"):  Expanded(
                  child: language.isNotEmpty
                      ? TricycleListCard(
                        child: ListView(
                            children: language.keys
                                .map((LanguageItem key) => Container(
                                    color: HexColor(AppColors.appColorWhite),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:0,bottom: 2),
                                      child: CheckboxListTile(
                                        title: Text(
                                          key.expertiseTypeDescription!,
                                          style: styleElements
                                              .subtitle1ThemeScalable(context),
                                        ),
                                        value: language[key],
                                        onChanged: (val) {
                                          setState(() {
                                            for (LanguageItem s in language.keys) {
                                              if (s.id == key.id) {
                                                selectedLangId = key.id;
                                                language[s] = val;
                                              } else
                                                language[s] = false;
                                            }
                                          });
                                        },
                                      ),
                                    )))
                                .toList(),
                          ),
                      )
                      : TricycleEmptyWidget(message: 'No data Found !! Click Next to add $type'),
                )
              ],
            ),

            Visibility(
              visible: fromBasicProfileFLow,
              child:  Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: HexColor(AppColors.appColorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:16.0),
                            child: TricycleProgressButton(
                              key: progressButtonKey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {
                                bool isSelected = false;
                                language.forEach((key, value) {
                                  if (value!) {
                                    isSelected = true;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SelectLanguageProficiencyDialogue(
                                              personId: prefs.getInt("userId"),
                                              title2: AppLocalizations.of(
                                                  context)!
                                                  .translate("what_want_to_be"),
                                              title: AppLocalizations.of(
                                                  context)!
                                                  .translate("my_proficiency"),
                                              subtitle: AppLocalizations
                                                  .of(context)!
                                                  .translate("rate_experties"),
                                              categoryType: type,
                                              id1: key.id.toString(),
                                              id3: key
                                                  .standardExpertiseCategoryTypeId,
                                              id2: key
                                                  .standardExpertiseCategoryId
                                                  .toString(),
                                              instId: instId,
                                              callbackPicker: () {
                                                callbackPicker!();
                                                Navigator.of(context).pop({'result': "success"});
                                              }, type: null,));
                                  }
                                });
                                if (!isSelected) {
                                  callbackPicker!();
                                  Navigator.of(context).pop({'result': "success"});
                                } },
                              color: HexColor(AppColors.appColorWhite),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('save_exit')
                                    .toUpperCase(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          )
                          ,  Padding(
                            padding: const EdgeInsets.only(right:16.0),
                            child: TricycleProgressButton(
                              key: progressButtonKeyNext,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: HexColor(AppColors.appMainColor))),
                              onPressed: () async {

                                if(language!=null&& language.isEmpty && searchVal!=null && searchVal!.isNotEmpty)
                                {
                                  addNewLangSkill(searchVal);
                                }
                                else
                                {
                                  LanguageItem? item;
                                  language.forEach((key, value) {
                                    if (value!) {
                                      item = key;
                                    }
                                  });
                                  if (item != null) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SelectLanguageProficiencyDialogue(
                                              personId: prefs.getInt(
                                                  "userId"),
                                              title2: AppLocalizations
                                                  .of(context)!
                                                  .translate(
                                                  "what_want_to_be"),
                                              title: AppLocalizations
                                                  .of(context)!
                                                  .translate(
                                                  "my_proficiency"),
                                              subtitle: AppLocalizations.of(
                                                  context)!
                                                  .translate(
                                                  "rate_experties"),
                                              categoryType: type,
                                              id1: item!.id.toString(),
                                              id3: item!
                                                  .standardExpertiseCategoryTypeId,
                                              id2: item!
                                                  .standardExpertiseCategoryId
                                                  .toString(),
                                              instId: instId,

                                              callbackPicker: () {
                                                handleCallBack();
                                              }, type: null,));
                                  } else {
                                    handleCallBack();
                                  }
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
                                    color: HexColor(AppColors.appMainColor)),
                              ),
                            ),
                          ),

                        ],
                      ))),),
            Visibility(
                visible: !fromBasicProfileFLow,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color: HexColor(AppColors.appColorWhite),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () { },
                              child: Container(
                                margin: const EdgeInsets.only(left: 16),
                                height: 60,
                                color: HexColor(AppColors.appColorWhite),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "",
                                    style: styleElements
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(color: HexColor(AppColors.appMainColor)),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right:16.0),
                              child: TricycleProgressButton(
                                key: progressButtonKeyNext,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: HexColor(AppColors.appMainColor))),
                                onPressed: () async {
                                  if(language!=null&& language.isEmpty && searchVal!=null && searchVal!.isNotEmpty)
                                    {
                                      addNewLangSkill(searchVal);
                                    }
                                  else
                                    {
                                      language.forEach((key, value) {
                                        if (value!) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SelectLanguageProficiencyDialogue(
                                                    personId: prefs.getInt(
                                                        "userId"),
                                                    title2: AppLocalizations.of(
                                                        context)!
                                                        .translate(
                                                        "what_want_to_be"),
                                                    title: AppLocalizations.of(
                                                        context)!
                                                        .translate(
                                                        "my_proficiency"),
                                                    subtitle: AppLocalizations
                                                        .of(context)!
                                                        .translate(
                                                        "rate_experties"),
                                                    categoryType: type,
                                                    id1: key.id.toString(),
                                                    id3: key
                                                        .standardExpertiseCategoryTypeId,
                                                    id2: key
                                                        .standardExpertiseCategoryId
                                                        .toString(),
                                                    instId: instId,
                                                    callbackPicker: () {
                                                      Navigator.of(context).pop(
                                                          {'result': "success"});
                                                    }, type: null,));
                                        }
                                      });
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
                                      color: HexColor(AppColors.appMainColor)),
                                ),
                              ),
                            )

                            ,

                          ],
                        )))),

          ],
        ),
      ),
    );
  }

  handleCallBack() async {
    if (type == "Languages") {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditLanguage(
                  "Skill",
                  prefs.getInt("instituteId").toString(),
                  fromBasicProfileFLow,
                  callbackPicker)));
      if (result != null && result['result'] == "success") {
        callbackPicker!();
        Navigator.of(context).pop({'result': "success"});
      }
    } else {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddSelectSubject(
                  int.parse(instId!), fromBasicProfileFLow, callbackPicker)));
      if (result != null && result['result'] == "success") {
        callbackPicker!();
        Navigator.of(context).pop({'result': "success"});
      }

    }
  }
 void addNewLangSkill(String? searchValue) async {

    AddNewSkillLangEntity addNewSkillLangEntity = AddNewSkillLangEntity();
   addNewSkillLangEntity.categoryType =type=="Languages"?"language":"skill";
   addNewSkillLangEntity.valueCode = searchValue;
   addNewSkillLangEntity.valueName = searchValue;
   addNewSkillLangEntity.valueDescription = searchValue;
    progressButtonKeyNext.currentState!.show();

   Calls()
       .call(jsonEncode(addNewSkillLangEntity), context,
       Config.COMMON_NEW_ENTRY)
       .then((value) {
     progressButtonKeyNext.currentState!.hide();
     var res = AddNewSkillLangResponse.fromJson(value);
     if (res.statusCode == Strings.success_code) {
       isSearching = true;
       searchVal=searchValue;
       getList(searchValue);
     } else {}
   }).catchError((onError) {
     print(onError);
     progressButtonKeyNext.currentState!.hide();
   });
 }
  // ignore: missing_return
  Future<bool>? _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  Null Function()? callbackPicker;

  _EditLanguage(
      this.type, this.instId, this.fromBasicProfileFLow, this.callbackPicker);
}
