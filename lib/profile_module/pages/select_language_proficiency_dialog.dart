import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/add_class_new.dart';
import 'package:oho_works_app/models/add_skills_language-payload.dart';
import 'package:oho_works_app/models/basic_res.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/edit_subject.dart';
import 'package:oho_works_app/models/global_category.dart';
import 'package:oho_works_app/models/goals_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloading_dilog.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SelectLanguageProficiencyDialogue extends StatefulWidget {
  String title;
  String? title2;
  String subtitle;
  String? type;
  String? categoryType;
  String? id1;
  String? id2;
  String? instId;
  int? personId;
  int? starRatingsId;
  double? starRatings;
  int? itemId;
  String? rattingType;
  List<String>? abilites;
  List<String>? goals;
  List<String>? ids;
  Null Function()? callbackPicker;
  String? id3;
  int? sectionId;

  SelectLanguageProficiencyDialogue({Key? key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.categoryType,
    this.instId,
    this.title2,
    this.id3,
    this.ids,
    this.personId,
    this.callbackPicker,
    this.itemId,
    this.starRatings,
    this.goals,
    this.id1,
    this.abilites,
    this.starRatingsId,
    this.sectionId,
    this.id2})
      : super(key: key);

  _SelectLanguageProficiency createState() =>
      _SelectLanguageProficiency(
        title: title,
        title2: title2,
        subtitle: subtitle,
        type: type,
        sectionId: sectionId,
        categoryType: categoryType,
        id1: id1,
        id2: id2,
        ids: ids,
        id3:id3,
        personId: personId,
        callbackPicker: callbackPicker,
        itemId: itemId,
        goals: goals,
        abilites: abilites,
        starRatingsId: starRatingsId,
        starRatings: starRatings,
        instId: instId,
      );
}

class _SelectLanguageProficiency
    extends State<SelectLanguageProficiencyDialogue> {
  String title;
  String subtitle;
  String? title2;
  int? personId;
  String? id3;
  int? sectionId;
  int? starRatingsId;
  int? itemId;
  Null Function()? callbackPicker;
  List<String>? goals;
  double? starRatings;
  List<String>? ids;
  List<String>? abilites;
  String? categoryType;
  String? id1;
  String? id2;
  String? personType;
  String? instId;
  bool isCategory = true;
  late SharedPreferences prefs;
  Map<String?, bool?> catList = Map();
  Map<String?, bool?> goalsList = Map();
 late BuildContext context;
  String? type;
  String? ratingType;
bool isLoading=false;
  int? ownerId;
  String? ownerType;

  @override
  void initState() {
    setSharedPreferences();
    super.initState();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    ownerId = prefs.getInt("userId");
    ownerType = prefs.getString("ownerType");
    personType=prefs.getString(Strings.personType);
    getCategories(context);
    if ((categoryType == "Subject" ||
        categoryType == "Languages" ||
        categoryType == "Skill") &&
        ownerId == personId) getGoals(context);

    ratingType = categoryType == "Subject"
        ? "subject"
        : categoryType == "Languages"
        ? "language"
        : categoryType == "Skill"
        ? "skill"
        : categoryType == "Class" ? "class" : "";
  }

  _SelectLanguageProficiency({required this.type,
    required this.title,
    required this.subtitle,
    this.id1,
    this.id2,
    this.title2,
    this.instId,
    this.goals,
    this.personId,
    this.itemId,
    this.id3,
    this.starRatingsId,
    this.callbackPicker,
    this.starRatings,
    this.ids,
    this.sectionId,
    this.abilites,
    required this.categoryType});

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child:  isLoading? PreloadingViewDilog(
            url: "assets/appimages/classroom.png"): Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(left:16,bottom: 16, top: 20,right: 16),
                    child: Text(
                      isCategory ? title : title2 ?? "",
                      style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Visibility(
                  visible: isCategory,
                  child: Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8.0),
                      children: catList.keys
                          .map((String? key) =>
                          CheckboxListTile(
                            title: Text(
                              key ?? "",
                              style: styleElements
                                  .subtitle1ThemeScalable(context),
                            ),
                            value: catList[key],
                            onChanged: (val) {
                              if (categoryType == "Languages")
                                handleCategoryForLanguage(val, key);
                              else
                                handleCategoryForClassesAndSubjects(
                                    val, key);
                            },
                          ))
                          .toList(),
                    ),
                  )),
              Visibility(
                  visible: !isCategory,
                  child: Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8.0),
                      children: goalsList.keys
                          .map((String? key) =>
                          CheckboxListTile(
                            title: Text(
                              key!,
                              style: styleElements
                                  .subtitle1ThemeScalable(context),
                            ),
                            value: goalsList[key],
                            onChanged: (val) {
                              setState(() {
                                goalsList[key] = val;
                              });
                            },
                          ))
                          .toList(),
                    ),
                  )),
              Visibility(
                visible: isCategory,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: Text(
                        subtitle,
                        style: styleElements.headline6ThemeScalable(context),
                      ),
                    )),
              ),
              Visibility(
                  visible: isCategory,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Column(
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating:
                          starRatings != null ? starRatings! : 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 36.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_border,
                            color: HexColor(AppColors.appMainColor),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                            starRatings=rating;
                          },
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin:
                              const EdgeInsets.only(left: 60, right: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("poor"),
                                style:
                                styleElements.captionThemeScalable(context),
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 20, right: 60),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("excellent"),
                                style:
                                styleElements.captionThemeScalable(context),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              Divider(
                height: 2,
              ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Container(
                      margin:
                      const EdgeInsets.only(right: 30, top: 16, bottom: 16),
                      child: Text(
                        AppLocalizations.of(context)!.translate('cancel'),
                        style: styleElements
                            .bodyText1ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      child: VerticalDivider(
                        color: HexColor(AppColors.appColorGrey500),
                        width: 2,
                      )),
                  GestureDetector(
                      onTap: () {
                        if (ownerId == personId) {
                          if (categoryType == "Subject" ||
                              categoryType == "Languages" ||
                              categoryType == "Skill") {
                            if (isCategory) {
                              setState(() {
                                isCategory = false;
                                if (goalsList.isEmpty)
                                  getGoals(context);
                              });
                            }
                            else {
                              if (categoryType == "Subject") {
                                if (type == "add_subject")
                                  addSubject(context);
                                else
                                  editSubject(context);
                              } else if (categoryType == "Skill" ||
                                  categoryType == "Languages") {
                                addLang(context);
                              }
                            }
                          } else {
                            if (type == "add_class")
                              addClass(context);
                            else
                              editClass(context);
                          }
                        }
                        else {
                          if (categoryType == "Subject") {
                            if (type == "add_subject")
                              addSubject(context);
                            else
                              editSubject(context);
                          } else if (categoryType == "Skill" ||
                              categoryType == "Languages") {
                            addLang(context);
                          }
                          else {
                            if (type == "add_class")
                              addClass(context);
                            else
                              editClass(context);
                          }
                        }

                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 30, top: 16, bottom: 16),
                        child: Text(
                          AppLocalizations.of(context)!.translate('submit'),
                          style: styleElements
                              .bodyText1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }

  void addLang(BuildContext context) async {
    AddLanguageSkills addClassNew = new AddLanguageSkills();
    addClassNew.institutionId = int.parse(instId!);
    addClassNew.personId = personId;
    addClassNew.isSelected = "Y";
    addClassNew.selfRating = "0";
    addClassNew.averageRating = "0";
    addClassNew.numberOfRatings = "0";
    addClassNew.id = itemId;
    addClassNew.givenById = ownerId;
    addClassNew.personType = personType;
    addClassNew.standardExpertiseCategoryTypes = int.parse(id1!); //id2;
    addClassNew.standardExpertiseCategory = int.parse(id2!);
    var listAbilities = <String?>[];
    catList.forEach((key, value) {
      if (value!) listAbilities.add(key);
    });
    addClassNew.abilities = listAbilities;
    var listGoals = <String?>[];
    goalsList.forEach((key, value) {
      if (value!) listGoals.add(key);
    });
    addClassNew.goals = listGoals;
    setState(() {
      isLoading=true;
    });
    Calls()
        .call(json.encode(addClassNew), context, Config.ADD_LANGUAGE_SKILLS)
        .then((value) async {
      if (value != null) {
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          if (starRatingsId != null)
            apiUpdateRatings(context);
          else
            apiCreateRatings(context);
          /*             Navigator.pop(context, null);*/
        }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
    });
  }

  void addSubject(BuildContext context) async {
    if(ids==null)
    {
      ids=[];
      ids!.add(id3??"");

    }

    AddClassNew addClassNew = new AddClassNew();
    addClassNew.personType =personType;
    addClassNew.institutionId = instId;
    addClassNew.personId = personId;
    addClassNew.institutionAcademicYearId = "1"; //id2;
    addClassNew.institutionSubject = ids ?? [];
    addClassNew.standardExpertiseCategoryId = "6";
    addClassNew.givenById = ownerId;

    var listAbilities = <String?>[];

    catList.forEach((key, value) {
      if (value!) listAbilities.add(key);
    });
    addClassNew.abilities = listAbilities;

    var listGoals = <String?>[];
    goalsList.forEach((key, value) {
      if (value!) listGoals.add(key);
    });
    addClassNew.goals = listGoals;
    setState(() {
      isLoading=true;
    });
    Calls()
        .call(json.encode(addClassNew), context, Config.ADD_SUBJECT)
        .then((value) async {
      if (value != null) {
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          apiCreateRatings(context);

          /*             Navigator.pop(context, null);*/
        }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
    });
  }

  void addClass(BuildContext context) async {

    AddClassNew addClassNew = new AddClassNew();
    addClassNew.personType = personType;
    addClassNew.institutionId = instId;
    addClassNew.personId = personId;
    addClassNew.sectionId=sectionId;
    addClassNew.institutionAcademicYearId = id2;
    addClassNew.institutionClassId = id1;
    addClassNew.givenById =ownerId;
    addClassNew.standardExpertiseCategoryId = "5";
    var listAbilities = <String?>[];
    catList.forEach((key, value) {
      if (value!) listAbilities.add(key);
    });
    addClassNew.abilities = listAbilities;
    setState(() {
      isLoading=true;
    });
    Calls()
        .call(json.encode(addClassNew), context, Config.ADD_CLASS)
        .then((value) async {
      if (value != null) {
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          apiCreateRatings(context);

        }
        else
          {
            ToastBuilder().showToast(data.message ?? "Please Try Again", context,HexColor(AppColors.information));
            Navigator.pop(context, null);

          }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
      setState(() {
        isLoading=false;
      });
    });
  }

  void editClass(BuildContext context) async {
    AddClassNew addClassNew = new AddClassNew();
    addClassNew.personType = personType;
    addClassNew.institutionId = instId;

    addClassNew.id = itemId.toString();
    addClassNew.personId = personId;
    addClassNew.givenById = ownerId;
    addClassNew.institutionAcademicYearId = id2; //id2;
    addClassNew.institutionClassId = id1;
    addClassNew.standardExpertiseCategoryId = "5";
    var listAbilities = <String?>[];
    catList.forEach((key, value) {
      if (value!) listAbilities.add(key);
    });
    addClassNew.abilities = listAbilities;
    setState(() {
      isLoading=true;
    });
    Calls()
        .call(json.encode(addClassNew), context, Config.EDIT_CLASS)
        .then((value) async {
      if (value != null) {
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          if (starRatingsId != null)
            apiUpdateRatings(context);
          else
            apiCreateRatings(context);

          /*             Navigator.pop(context, null);*/
        }
        else
          {
            ToastBuilder().showToast(data.message ?? "Please Try Again", context,HexColor(AppColors.information));
            Navigator.pop(context, null);
          }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
    });
  }

  void editSubject(BuildContext context) async {
    EditSubject addClassNew = new EditSubject();
    addClassNew.personType = personType;
    addClassNew.institutionSubject = id1;
    addClassNew.institutionId = instId;
    addClassNew.givenById = ownerId;
    addClassNew.institutionAcademicYearId = "1"; //id2;
    addClassNew.standardExpertiseCategoryId = "6";
    addClassNew.id = itemId.toString();
    addClassNew.personId = personId.toString();
    var listAbilities = <String?>[];
    catList.forEach((key, value) {
      if (value!) listAbilities.add(key);
    });
    addClassNew.abilities = listAbilities;
    setState(() {
      isLoading=true;
    });
    Calls()
        .call(json.encode(addClassNew), context, Config.EDIT_SUBJECT)
        .then((value) async {
      if (value != null) {
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          if (starRatingsId != null)
            apiUpdateRatings(context);
          else
            apiCreateRatings(context);

          /*             Navigator.pop(context, null);*/
        } else
        {
          ToastBuilder().showToast(data.message ?? "Please Try Again", context,HexColor(AppColors.information));
          Navigator.pop(context, null);
        }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
    });
  }

/*
Enums for standard category list-
{"Sports":"1","Languages":"2","Literature":"3","Skill":"4","Class":"5","Subject":"6"}
*/
  void getCategories(BuildContext context) async {
    final body = jsonEncode({
      "standard_expertise_category_types_id": categoryType,
      "standard_expertise_category_pid_val":
      categoryType == "Class" || categoryType == "Subject" ? null : id1,
      "page_number": 1,
      "page_size": 50,
      "person_id":personId,
      "endorse_content_id": id3,
      "given_by_id": ownerId,
      "id": itemId
      //  this id fo get previously selected items , its id of subject class or lang from see more page
    });
   setState(() {
     isLoading=true;
   });
    Calls()
        .call(body, context, Config.GLOBAL_CATEGORY_LIST)
        .then((value) async {
      if (value != null) {
        setState(() {
          isLoading=false;
        });
        if (this.mounted) {
          setState(() {
            var data = GlobalCategoryList.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                for (var item in data.rows!) {
                  if (item.isSelected == "Yes")
                    catList[item.expertiseAbilityCode] = true;
                  else
                    catList[item.expertiseAbilityCode] = false;
                }
                setState(() {});
              }
            } else
            {
              ToastBuilder().showToast(data.message ?? "Please Try Again", context,HexColor(AppColors.information));
              Navigator.pop(context, null);
            }
          });
        }
      }
    }).catchError((onError) {
      Navigator.pop(context, null);
      setState(() {
        isLoading=false;
      });
    });
  }

  void getGoals(BuildContext context) async {
    final body = jsonEncode({
      "standard_expertise_category_name": categoryType,
      "page_number": 1,
      "page_size": 50,
      "standard_expertise_category_types_id":
      (categoryType == "Languages" || categoryType == "Skill") ? id1 : null,
      "standard_expertise_category_id": categoryType == "Subject" ? "6" : null,
      "subject_class_id": categoryType == "Subject" ? id1 : null,
      "id": itemId
      //  this id fo get previously selected items , its id of subject class or lang from see more page
    });

    setState(() {
      isLoading=true;
    });
    Calls().call(body, context, Config.GLOBAL_GOAL_LIST).then((value) async {
      setState(() {
        isLoading=false;
      });
      if (value != null) {
        if (this.mounted) {
          setState(() {
            var data = GoalsList.fromJson(value);
            if (data != null && data.statusCode == 'S10001') {

              if (data.rows != null) {
                for (var item in data.rows!) {
                  if (item.isSelected == "Yes")
                    goalsList[item.expertiseGoalCode] = true;
                  else
                    goalsList[item.expertiseGoalCode] = false;
                }
                setState(() {});
              }
            } else
            {
              ToastBuilder().showToast(data.message ?? "Please Try Again", context,HexColor(AppColors.information));
              Navigator.pop(context, null);
            }
          });
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading=false;
      });
      Navigator.pop(context, null);
    });
  }

  handleCategoryForLanguage(bool? val, String? key) {
    setState(() {
      catList[key] = val;
    });
  }

  handleCategoryForClassesAndSubjects(bool? val, String? key) {
    catList[key] = val;

    if (isCategory) {
      catList.forEach((k, v) {
        if (key == k) {
          catList[key] = val;
        } else
          catList[k] = false;
        setState(() {});
      });
    }
  }

  //id1 id class id in Case of Classes

  String getBodyRating(double ratingValue, String type, String id) {
    return jsonEncode({
      "rating_note_id": null,
      "rating_subject_type": type,
      "rating_subject_id": int.parse(id),
      "rating_context_type": "person",
      "rating_context_id": null,
      "rating_given_by_id": ownerId,
      "rating_given": ratingValue.toInt().toString()
    });
  }

  void apiUpdateRatings(BuildContext ctx) async {

    setState(() {
      isLoading=true;
    });

    var body = jsonEncode({
      "id": starRatingsId,
      "rating_note_id": null,
      "rating_subject_type": ratingType,
      "rating_subject_id": int.parse(id1!),
      "rating_context_type": "person",
      "rating_context_id": personId,
      "rating_given_by_id": ownerId,
      "rating_given": starRatings != null ? starRatings!.toInt().toString() : "0"
    });
    Calls().call(body, ctx, Config.UPDATE_RATINGS).then((value) async {
      if (value != null) {
        setState(() {
          isLoading=false;
        });
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          Navigator.of(ctx).pop(true);
          callbackPicker!();
        } else {
          setState(() {
            isLoading=false;
          });
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,HexColor(AppColors.information));
        }
      } else {
        setState(() {
          isLoading=false;
        });
        ToastBuilder().showToast("Please Try Again", ctx,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      setState(() {
        isLoading=false;
      });
      ToastBuilder().showToast(onError.toString(), ctx,HexColor(AppColors.information));
      print(onError.toString());
    });
  }

  void apiCreateRatings(BuildContext ctx) async {
    var body = jsonEncode({
      "rating_note_id": null,
      "rating_subject_type": ratingType,
      "rating_subject_id": int.parse(id1!),
      "rating_context_type": "person",
      "rating_context_id": personId,
      "rating_given_by_id": ownerId,
      "rating_given": starRatings != null ? starRatings!.toInt().toString() : "0"
    });
    setState(() {
      isLoading=true;
    });
    Calls().call(body, ctx, Config.CREATE_RATINGS).then((value) async {
      if (value != null) {
        setState(() {
          isLoading=false;
        });
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast(data.message ?? "", ctx,HexColor(AppColors.success));
          Navigator.of(ctx).pop(true);
          callbackPicker!();
        } else {
          setState(() {
            isLoading=false;
          });
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,HexColor(AppColors.information));
        }
      } else {
        setState(() {
          isLoading=false;
        });
        ToastBuilder().showToast("Please Try Again", ctx,HexColor(AppColors.information));
      }
    }).catchError((onError) {
      setState(() {
        isLoading=false;
      });
      ToastBuilder().showToast(onError.toString(), ctx,HexColor(AppColors.information));
      print(onError.toString());
    });
  }
}
