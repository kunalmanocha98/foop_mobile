import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/basic_res.dart';
import 'package:oho_works_app/models/delete_class_subject.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable


/*enums use
for

sending action_type
[15:16, 11/4/2020] Shaelendar: MEDIA_SUB_CONTEXT_TYPE = \
{"SUBJECT":"subject","CLASS":"class", "CLUB":"club", "SPORTS":"sports", "CAMPUS":"campus", "REWARDS":"rewards","LANGUAGE":"language","SKILL":"skill"}*/
// ignore: must_be_immutable
class DeleteClass extends StatefulWidget {
  String? title;
  String? subtitle;
  String? type;
  String categoryType;
  String? id;
  String? id2;
  String? instId;
  int? personType;
  Null Function()? callbackPicker;

  DeleteClass({Key? key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.categoryType,
    this.instId,
    this.personType,
    this.callbackPicker,
    this.id,
    this.id2})
      : super(key: key);

  _SelectLanguageProficiency createState() =>
      _SelectLanguageProficiency(
          title: title,
          subtitle: subtitle,
          type: type,
          categoryType: categoryType,
          id: id,
          id2: id2,
          callbackPicker: callbackPicker,
          instId: instId,
          personType: personType);
}

class _SelectLanguageProficiency extends State<DeleteClass> {
  String? title;
  String? subtitle;
  String categoryType;
  String? id;
  String? id2;
  Null Function()? callbackPicker;
  int? personType;
  String? instId;
  late SharedPreferences prefs;
  Map<String, bool> catList = Map();
  late BuildContext context;
  String? type;
bool isLoading=false;

  @override
  void initState() {
    setSharedPreferences();
    super.initState();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    //  getCategories(context);
  }

  _SelectLanguageProficiency({required this.type,
    required this.title,
    required this.subtitle,
    this.id,
    this.id2,
    this.instId,
    this.callbackPicker,
    this.personType,
    required this.categoryType});

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: GestureDetector(
          onTap: () {
            if(!isLoading)
            deleteClass(context);
          },
          child: SizedBox(
            height: 54,
            child:isLoading?SizedBox(
              height: 20,
                width: 20,
                child: CircularProgressIndicator()): Center(
              child: Text("Delete This " + categoryType,
                style: styleElements.subtitle1ThemeScalable(context),
              ),
            ),
          ),
        ));
  }

  void deleteClass(BuildContext context) async {
    DeleteClassSubjectPayload addClassNew = new DeleteClassSubjectPayload();
    addClassNew.institutionId = instId;
    addClassNew.id = id;
    addClassNew.personId = prefs.getInt("userId").toString();
    addClassNew.actionType = categoryType; //id2;

  setState(() {
    isLoading=true;
  });
    Calls()
        .call(json.encode(addClassNew), context, Config.DELETE_CLASS_SUBJECT)
        .then((value) async {
      if (value != null) {
        setState(() {
          isLoading=false;
        });
        var data = BasicRes.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast(data.message ?? "", context,HexColor(AppColors.information));
          Navigator.of(context).pop(true);
          callbackPicker!();
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading=false;
      });
      Navigator.pop(context, null);
    });
  }
}
