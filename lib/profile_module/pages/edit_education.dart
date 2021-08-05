import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/edit_add_education_work_entity.dart';
import 'package:oho_works_app/models/institute_list.dart';
import 'package:oho_works_app/models/institution_classes.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_language-page.dart';

// ignore: must_be_immutable
class EditEducation extends StatefulWidget {
  final CommonCardData? commonCardData;
  bool isEducation;
  bool fromBasicProfileFLow;

  _EditEducation createState() => _EditEducation(
      commonCardData, isEducation, fromBasicProfileFLow, call);
 final Null Function()? call;

  EditEducation(this.commonCardData, this.isEducation,
      this.fromBasicProfileFLow, this.call, );
}

class _EditEducation extends State<EditEducation>
    with SingleTickerProviderStateMixin {
  GlobalKey<appProgressButtonState> progressButtonKeyBasic = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  List names =  [];
  String? selectedEmpType;
  String? selectedIndType;
  List filteredNames =  [];
  var items = <String?>[];
  var itemsIndustry = <String?>[];

 late CommonCardData? commonCardData;
  late SharedPreferences prefs;
  String classId = "";
  late BuildContext ctx;
  int? institutionId;
  final classesCon = TextEditingController();

  final cgpaCon = TextEditingController();
  final locationCon = TextEditingController();
  FocusNode textFocus = new FocusNode();
  FocusNode decFocus = new FocusNode();
  FocusNode textFocusEmp = new FocusNode();
  final studiesFieldController = TextEditingController();
  final descriptionController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final schoolController = TextEditingController();
  final genderController = TextEditingController();
  bool? checkedValue = false;
  late TextStyleElements styleElements;

  // bool _isChecked = false;
 late BuildContext context;
  final _debouncer = Debouncer(500);
  String startDate = 'Start Date';
  String endDate = 'End Date';
  String startDateBackEnd = 'Start Date';
  String endDateBackEnd = 'End Date';
  String industry = "Industry";
  String hint = "University/School/Institution*";
  int? selectedEpoch, selectedEpoch2;

  List<InstituteItem>? rows = [];
  List<InstituteClass>? classesList = [];

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance!.addPostFrameCallback((_) =>    setSharedPreferences());



  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    getEmpType();
    getIndustryType();
    if (commonCardData != null) setOldData(commonCardData!);
  }

  final body = jsonEncode({
    "conversationOwnerId": '151601607502972',
    "conversationOwnerType": 'personal',
    "businessId": '1452745716',
    "registeredUserId": '1452745716',
    "pageNo": 0,
    "pageNumber": 1,
    "pageSize": 5
  });

  Widget build(BuildContext context) {


    this.context = context;
    List<DropdownMenuItem> _genderValues = [];
    _getGenderValues() {
      for (int i = 0; i < items.length; i++) {
        _genderValues.add(DropdownMenuItem(
          child: Text(
            items[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: items[i],
        ));
      }
      return _genderValues;
    }

    List<DropdownMenuItem> _genderValuesIndus = [];

    _getGenderValuesIndus() {
      for (int i = 0; i < itemsIndustry.length; i++) {
        _genderValuesIndus.add(DropdownMenuItem(
          child: Text(
            itemsIndustry[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: itemsIndustry[i],
        ));
      }
      return _genderValuesIndus;
    }

    ScreenUtil.init;
    this.ctx = context;
    styleElements = TextStyleElements(context);

    final location = TextField(
      obscureText: false,
      controller: locationCon,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          locationCon.text = text.toUpperCase();
          locationCon.selection = TextSelection.fromPosition(
              TextPosition(offset: locationCon.text.length));
        }
      },
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: AppLocalizations.of(context)!.translate("location"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );

    final empType = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectedEmpType ??
              AppLocalizations.of(context)!.translate("employment_type"),
          style: styleElements.bodyText2ThemeScalable(context),
        ),
      ),
      items: _getGenderValues(),
      onChanged: (value) {
        value as DropdownMenuItem;
        if (this.mounted)
       {
         setState(() {
           selectedEmpType = (value) as String?;
         });
       }
      },
    );
    final indType = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectedIndType ?? AppLocalizations.of(context)!.translate("industry"),
          style: styleElements.bodyText2ThemeScalable(context),
        ),
      ),
      items: _getGenderValuesIndus(),
      onChanged: (value) {
        value as DropdownMenuItem;
        if (this.mounted){
        setState(() {
          selectedIndType = (value) as String?;
        });}
      },
    );


    final cgpa = TextField(
      obscureText: false,
      controller: cgpaCon,
      focusNode: decFocus,

      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          cgpaCon.text = text.toUpperCase();
          cgpaCon.selection = TextSelection.fromPosition(
              TextPosition(offset: cgpaCon.text.length));
        }
      },
      textCapitalization: TextCapitalization.words,
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
          hintText: isEducation
              ? AppLocalizations.of(context)!.translate("cgpa")
              : AppLocalizations.of(context)!.translate("industry"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final classes = TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        controller: classesCon,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            classesCon.text = text.toUpperCase();
            classesCon.selection = TextSelection.fromPosition(
                TextPosition(offset: classesCon.text.length));
          }
        },
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
            hintText: isEducation
                ? AppLocalizations.of(context)!.translate("class_degree")
                : AppLocalizations.of(context)!.translate("designation"),
            hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0,
              ),
            )),
      ),
      suggestionsCallback: (pattern)  {
        if (pattern != "") {
          _debouncer.run(() {
            if (institutionId != null && isEducation) getClasses(pattern);
          });
          if (classesList!.length > 0) return classesList!;
        }

return [];
      },
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(

          title: Text(suggestion.className),
        );
      },
      onSuggestionSelected: (dynamic suggestion) {
        if (this.mounted){
        setState(() {
          classesList = [];
          classId = suggestion.id.toString();
          print(" suggestion.id" +
              suggestion.id.toString() +
              "+++++++++++++++++++++++++");
          classesCon.text = suggestion.className;
        });}
      },
    );

    void backPressed() {

      if(fromBasicProfileFLow)
        Navigator.of(ctx).pop({'result': "back"});
      else
        Navigator.of(context).pop(true);
    }

    final description = TextField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 20.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          hintText: isEducation?'Describe about your education':'Describe about your work'),
    );
    final dateStart = GestureDetector(
      onTap: () {
        _selectDate(context, "startDate");
      },
      child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                //
                color: HexColor(AppColors.appColorGrey500),
                width: 1.0,
              ),
            ), // set border width
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$startDate",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: styleElements.bodyText2ThemeScalable(context),
            ),
          )),
    );
    final dateEnd = GestureDetector(
      onTap: () {
        if (startDate != "Start Date") {
          if (!checkedValue!)
            _selectDate(context, endDate);
          else {
            if (isEducation)
              ToastBuilder().showToast(
                  AppLocalizations.of(context)!.translate("un_select_e"),
                  context,HexColor(AppColors.information));
            else
              ToastBuilder().showToast(
                  AppLocalizations.of(context)!.translate("un_select_"),
                  context,HexColor(AppColors.information));
          }
        } else {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate("select_start_date"),
              context,HexColor(AppColors.information));
        }
      },
      child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                //
                color: HexColor(AppColors.appColorGrey500),
                width: 1.0,
              ),
            ), // set border width
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$endDate",
              textAlign: TextAlign.left,
              style: styleElements.bodyText2ThemeScalable(context),
            ),
          )),
    );

    final universitySchools = TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        controller: schoolController,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            schoolController.text = text.toUpperCase();
            schoolController.selection = TextSelection.fromPosition(
                TextPosition(offset: schoolController.text.length));
          }
        },
        textCapitalization: TextCapitalization.words,
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 8.0),
            hintText: isEducation
                ? hint
                : AppLocalizations.of(context)!
                    .translate("work_company_name_hint"),
            hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0,
              ),
            )),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern != "" && pattern != null) {
          _debouncer.run(() {
            if (this.mounted){
            setState(() {
              getListOfInstitutes(pattern);
            });}
          });
          if (rows!.length > 0) return rows!;
        }
return rows!;
      },
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          leading: SizedBox(
            width: 28,
            height: 28,
            child: ClipOval(
              child: CachedNetworkImage(
                  imageUrl: Utility().getUrlForImage(suggestion.profileImage,
                      RESOLUTION_TYPE.R64, SERVICE_TYPE.INSTITUTION),),
            ),
          ),
          title: Text(suggestion.name),
        );
      },
      onSuggestionSelected: (dynamic suggestion) {
    if (this.mounted){  setState(() {
          rows = [];
          institutionId = suggestion.id;
          schoolController.text = suggestion.name;
        });}
      },
    );

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          backPressed();
          return new Future(() => false);
        } ,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: HexColor(AppColors.appColorBackground),
            appBar: OhoAppBar().getCustomAppBar(context,
                appBarTitle: isEducation ? 'Education' : "Work",
                onBackButtonPress: () {
             backPressed();
            }),
            body: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 80),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Card(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, top: 20),
                                          child: Text(
                                            isEducation
                                                ? AppLocalizations.of(context)!
                                                    .translate(
                                                        "add_edit_education")
                                                : AppLocalizations.of(context)!
                                                    .translate("add_edit_work"),
                                            style: styleElements
                                                .subtitle1ThemeScalable(context)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                    flex: 3,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(left: 20, top: 4),
                                    child: Text(
                                      isEducation
                                          ? AppLocalizations.of(context)!
                                              .translate("add_education_backg")
                                          : AppLocalizations.of(context)!
                                              .translate("add_work_backg"),
                                      style: styleElements
                                          .bodyText2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: universitySchools,
                                  )),
                              Container(
                                  child: Container(
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Flexible(
                                        child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: dateStart,
                                    )),
                                    new Flexible(
                                        child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: dateEnd,
                                    )),
                                    new Flexible(
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: Row(
                                            children: <Widget>[
                                              new Checkbox(
                                                activeColor: HexColor(AppColors.appMainColor),
                                                checkColor: HexColor(AppColors.appColorWhite65),
                                                value: checkedValue,
                                                onChanged: (bool? value) {
                                                  if (this.mounted){
                                                  setState(() {
                                                    checkedValue = value;
                                                    if (value!)
                                                      endDate = "End Date";
                                                  });}
                                                },
                                              ),
                                              Flexible(
                                                child: new Text(
                                                  isEducation
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              "still_studying")
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              "still_working"),
                                                  maxLines: 2,
                                                  style: styleElements
                                                      .captionThemeScalable(
                                                          context),
                                                ),
                                              )
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: classes,
                                  )),
                              Visibility(
                                visible: !isEducation,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: empType,
                                    )),
                              ),
                              Visibility(
                                visible: !isEducation,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: indType,
                                    )),
                              ),
                              Visibility(
                                  visible: isEducation,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 16),
                                        child: cgpa,
                                      ))),
                              Visibility(
                                visible: !isEducation,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: location,
                                    )),
                              ),
                              Container(
                                  height: 100,
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor(AppColors.appColorGrey500),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: description),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
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
                                  child: appProgressButton(
                                    key: progressButtonKey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: HexColor(AppColors.appMainColor))),
                                    onPressed: () async {
                                      if (schoolController.text.isNotEmpty &&
                                          schoolController.text != null) {
                                        if (commonCardData == null) {
                                          _addEducation("save");
                                        } else
                                          _editEducation("save");
                                      } else {
                                        Navigator.of(ctx).pop({'result': "success"});

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
                                  child: appProgressButton(
                                    key: progressButtonKeyNext,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: HexColor(AppColors.appMainColor))),
                                    onPressed: () async {
                                      if (schoolController
                                          .text.isNotEmpty &&
                                          schoolController.text != null) {
                                        if (commonCardData == null) {
                                          _addEducation("next");
                                        } else
                                          _editEducation("next");
                                      } else {
                                        if(isEducation)
                                        {

                                          var result  =await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditLanguage(
                                                          "Languages", prefs.getInt("instituteId").toString(), fromBasicProfileFLow,callbackPicker)));
                                          if(result!=null && result['result']=="success")
                                          {
                                            Navigator.of(ctx).pop({'result': "success"});
                                          }
                                        }
                                        else
                                        {
                                          callbackPicker!();
                                          Navigator.of(ctx).pop({'result': "success"});
                                        }

                                      }},
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
                                  onTap: () {},
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
                                  child: appProgressButton(
                                    key: progressButtonKeyBasic,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: HexColor(AppColors.appMainColor))),
                                    onPressed: () async {
                                      if (schoolController
                                          .text.isNotEmpty &&
                                          schoolController.text != null) {
                                        if (commonCardData == null) {
                                          _addEducation("save");
                                        } else
                                          _editEducation("save");
                                      } else {
                                        ToastBuilder().showToast(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                'work_company_name_mandatory'),
                                            context,HexColor(AppColors.information));
                                      } },
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
        ));
  }

  setOldData(CommonCardData data) {
    endDate = data.textSix != null && data.textSix != "None"
        ? DateFormat('MM-yyyy').format(DateTime.parse(data.textSix!))
        : "End Date";
    endDateBackEnd = data.textSix != null && data.textSix != "None"
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(data.textSix!))
        : "End Date";
    if (data.textFive != null && data.textFive != "None") {
      startDate = data.textFive != null && data.textFive != "None"
          ? DateFormat('MM-yyyy').format(DateTime.parse(data.textFive!))
          : "Start Date";
      selectedEpoch = DateTime.parse(data.textFive!).millisecondsSinceEpoch;
      startDateBackEnd = data.textFive != null && data.textFive != "None"
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(data.textFive!))
          : "Start Date";
    }

    if (isEducation) {
      classesCon.text = data.textOne ?? "";
      schoolController.text = data.textThree ?? "";
      descriptionController.text = data.textFour ?? "";
      checkedValue = data.isCurrent ?? false;
      cgpaCon.text = data.textEleven ?? "";
    } else {
      classesCon.text = data.textTwelve ?? "";
      schoolController.text = data.textThree ?? "";
      descriptionController.text = data.textFour ?? "";
      checkedValue = data.isCurrent ?? false;
      if (data.textNine != null) selectedIndType = data.textNine ?? "";
      if (data.textEight != null) selectedEmpType = data.textEight ?? "";
      locationCon.text = data.textTen ?? "";
    }
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    var newDate;
    late var selectedDate;

    newDate = new DateTime.now();
    if (selectedEpoch != null)
      selectedDate = new DateTime.fromMillisecondsSinceEpoch(selectedEpoch!);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: dateType == "End Date" ? selectedDate : DateTime(1800),
        lastDate: newDate);
    if (picked != null) {
      if (this.mounted){
      setState(() {
        setState(() {
          if (dateType == "startDate") {
            selectedEpoch = picked.millisecondsSinceEpoch;
            startDate = DateFormat('MM-yyyy').format(picked);
            startDateBackEnd = DateFormat('yyyy-MM-dd').format(picked);
            if (isEducation)
              decFocus.requestFocus();
            else
              textFocusEmp.requestFocus();
          } else {
            selectedEpoch2 = picked.millisecondsSinceEpoch;
            endDate = DateFormat('MM-yyyy').format(picked);
            endDateBackEnd = DateFormat('yyyy-MM-dd').format(picked);
            checkedValue = false;
            textFocusEmp.requestFocus();
            if (isEducation)
              decFocus.requestFocus();
            else
              textFocusEmp.requestFocus();
          }
        });
      });}
    } else {
      if (isEducation)
        decFocus.requestFocus();
      else
        textFocusEmp.requestFocus();
    }
  }

  Future<void> _editEducation(String action) async {
    EditEducationWork payload = EditEducationWork();

    payload.startDate = startDate != "Start Date" ? startDateBackEnd : null;
    payload.endDate = endDate != "End Date" ? endDateBackEnd : null;
    payload.id = int.parse(commonCardData!.id!);
    payload.institutionName = schoolController.text;
    payload.description = descriptionController.text;
    payload.personId = prefs.getInt("userId").toString();
    payload.iscurrent = checkedValue;
    if (isEducation) {
      payload.grade = cgpaCon.text;
      payload.className = classesCon.text;
      payload.classId = classId;
      payload.institutionId = institutionId;
      payload.classId = classId;
      payload.fieldOfStudy = studiesFieldController.text;
      payload.cardType = "education";
    } else {
      payload.location = locationCon.text;
      payload.industryType = selectedIndType;
      payload.designation = classesCon.text;
      payload.institutionId = institutionId;
      payload.employmentType = selectedEmpType;
      payload.cardType = "work";
    }
    var data = jsonEncode(payload);
    print(data.toString());
    if(!fromBasicProfileFLow)
      progressButtonKeyBasic.currentState!.show();
   else if(action=="save")
      progressButtonKey.currentState!.show();
    else
      progressButtonKeyNext.currentState!.show();
    Calls().call(data, context, Config.ADD_EDIT_EDUCATION_WORK).then((value) async {
      DynamicResponse resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        //callback();
        if(!fromBasicProfileFLow)
          progressButtonKeyBasic.currentState!.hide();
        else if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();

        Navigator.of(ctx).pop({'result': "success"});
      } else {
        if(!fromBasicProfileFLow)
          progressButtonKeyBasic.currentState!.hide();
        else if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();
        ToastBuilder().showToast(resposne.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      if(!fromBasicProfileFLow)
        progressButtonKeyBasic.currentState!.hide();
      else if(action=="save")
        progressButtonKey.currentState!.hide();
      else
        progressButtonKeyNext.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  Future<void> _addEducation(String action) async {
    EditEducationWork payload = EditEducationWork();
    payload.startDate = startDate != "Start Date"
        ? startDateBackEnd
        : commonCardData != null ? commonCardData!.textFive ?? "" : "";
    payload.endDate = endDate != "End Date"
        ? endDateBackEnd
        : commonCardData != null ? commonCardData!.textSix ?? "" : "";
    payload.institutionName = schoolController.text;
    payload.description = descriptionController.text;
    payload.personId = prefs.getInt("userId").toString();
    if (isEducation) {
      payload.grade = cgpaCon.text;
      payload.className = classesCon.text;
      payload.classId = classId;
      payload.institutionId = institutionId;
      payload.classId = classId;
      payload.fieldOfStudy = studiesFieldController.text;
      payload.cardType = "education";
    } else {
      payload.location = locationCon.text;
      payload.industryType = selectedIndType;
      payload.designation = classesCon.text;
      payload.institutionId = institutionId;
      payload.employmentType = selectedEmpType;
      payload.cardType = "work";
    }

    payload.iscurrent = checkedValue ?? false;
    var data = jsonEncode(payload);
    print(data.toString());
    if(!fromBasicProfileFLow)
      progressButtonKeyBasic.currentState!.show();
    else if(action=="save")
      progressButtonKey.currentState!.show();
    else
      progressButtonKeyNext.currentState!.show();
    Calls().call(data, context, Config.ADD_WORK_EDUCATION).then((value) async {
      DynamicResponse resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        schoolController.clear();
        if(!fromBasicProfileFLow)
          progressButtonKeyBasic.currentState!.hide();
        else if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();

        if (action == "save" && fromBasicProfileFLow)
         {
           Navigator.of(ctx).pop({'result': "success"});}
       else if (action == "save" && !fromBasicProfileFLow)
          Navigator.of(ctx).pop({'result': "success"});
        else {
          if(isEducation)
            {
              var result  =await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditLanguage(
                              "Languages", prefs.getInt("instituteId").toString(), fromBasicProfileFLow,callbackPicker)));
              if(result!=null && result['result']=="success")
              {
                if(callbackPicker!=null)
                callbackPicker!();
                Navigator.pop(context);
              }
            }
          else
            {
              if(callbackPicker!=null)
              callbackPicker!();
              Navigator.of(ctx).pop({'result': "success"});}

        }
      } else {
        if(!fromBasicProfileFLow)
          progressButtonKeyBasic.currentState!.hide();
        else if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();
        ToastBuilder().showToast(resposne.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      if(!fromBasicProfileFLow)
        progressButtonKeyBasic.currentState!.hide();
      else if(action=="save")
        progressButtonKey.currentState!.hide();
      else
        progressButtonKeyNext.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  void getClasses(String searchValue) async {
    final body = jsonEncode({
      "institution_id": institutionId,
      "searchVal": searchValue,
    });

    Calls().call(body, context, Config.CLASSES_LIST).then((value) async {


      if (value != null) {
        var data = InstitutionClasses.fromJson(value);
        if (this.mounted){
        setState(() {
          classesList = data.rows;
        });}
      }
    }).catchError((onError) {});
  }

  void getListOfInstitutes(String searchValue) async {
    final body = jsonEncode(
        {"searchVal": searchValue, "page_number": 1, "page_size": 5});
    Calls().call(body, context, Config.INSTITUTE_LIST).then((value) async {
      if (value != null) {
        var data = InstituteList.fromJson(value);
        if (this.mounted){
        setState(() {
          rows = data.rows;
        });}
      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  void getEmpType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "EMPLOYMENTTYPE",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);
if(data!=null&& data.statusCode==Strings.success_code)
  {
    for (var item in data.rows!) {
      items.add(item.description);
    }
    if (this.mounted){
      setState(() {
        print(
            "FFFFFFFFFFFFFFFFFFFFFFFFFFFF" + itemsIndustry.length.toString());
      });}
  }

      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  void getIndustryType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "INDUSTRYTYPE",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);
        if(data!=null&& data.statusCode==Strings.success_code){
        for (var item in data.rows!) {
          itemsIndustry.add(item.description);
        }
        if (this.mounted){
        setState(() {
          print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs" +
              itemsIndustry.length.toString());
        });}}
      }
    }).catchError((onError) {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  bool isEducation;
  bool fromBasicProfileFLow;
  Null Function()? callbackPicker;

  _EditEducation(this.commonCardData, this.isEducation,
      this.fromBasicProfileFLow, this.callbackPicker);
}
