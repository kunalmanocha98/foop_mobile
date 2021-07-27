import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/conversationPage/base_response.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/models/request_callback.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallBackPage extends StatefulWidget {
  @override
  _CallBackPage createState() => new _CallBackPage();
}

class _CallBackPage extends State<CallBackPage>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  var range = <String?>[];
  var rangeStudent = <String?>[];
  bool isCalling = false;
  var instituteTypelist = <String?>[];
  var relationship = <String?>[];
  bool isTermAndConditionAccepted = false;
  String? email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final emailController = TextEditingController();
  final instituteNameC = TextEditingController();
  final locationCon = TextEditingController();
  final passwordTextController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final descriptionController = TextEditingController();
  late BuildContext context;
  late TextStyleElements styleElements;

  late TextStyleElements tsE;
  String? selectRelation;

  String? selectInstType;

  String? selectStRange;

  String? selectTecRange;
  int? selectedEpoch;

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    getEmpType();
    getInstituteType();
    getRelationType();
  }

  String quotesCharacterLength = "0";

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    List<DropdownMenuItem> _genderValuesIndus = [];
    List<DropdownMenuItem> _geneRange = [];
    List<DropdownMenuItem> instituteType = [];
    List<DropdownMenuItem> relationType = [];
    _getGenderValuesIndus() {
      for (int i = 0; i < range.length; i++) {
        _genderValuesIndus.add(DropdownMenuItem(
          child: Text(
            range[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: range[i],
        ));
      }
      return _genderValuesIndus;
    }

    _getRangeValuesIndus() {
      for (int i = 0; i < rangeStudent.length; i++) {
        _geneRange.add(DropdownMenuItem(
          child: Text(
            rangeStudent[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: rangeStudent[i],
        ));
      }
      return _geneRange;
    }

    _getInstituteType() {
      for (int i = 0; i < instituteTypelist.length; i++) {
        instituteType.add(DropdownMenuItem(

          child: Text(
            instituteTypelist[i]!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styleElements.captionThemeScalable(context),
          ),
          value: instituteTypelist[i],
        ));
      }
      return instituteType;
    }

    _getRelationtype() {
      for (int i = 0; i < relationship.length; i++) {
        relationType.add(DropdownMenuItem(
          child: Text(
            relationship[i]!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styleElements.captionThemeScalable(context),
          ),
          value: relationship[i],
        ));
      }
      return relationType;
    }

    final description = TextField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (text) {
        setState(() {
          quotesCharacterLength = text.length.toString();
        });
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(100),
      ],
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
          hintText: AppLocalizations.of(context)!.translate('say_something_about_you')),
    );
    tsE = TextStyleElements(context);

    final emailField = Form(
      child: TextFormField(
        controller: emailController,
        style: tsE.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
            hintText: AppLocalizations.of(context)!.translate('email'),
            hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0.h),
                child: Icon(
                  Icons.email_outlined,
                  color: HexColor(AppColors.appColorGrey500),
                  size: 20.w,
                )),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0.w,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String? value) {
          email = value;
        },
      ),
    );
    final instituteName = TextField(
      obscureText: false,
      controller: instituteNameC,
      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      keyboardType: TextInputType.name,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('name_of_institute'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(color: HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.account_balance_outlined,
                  color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );
    final location = TextField(
      obscureText: false,
      controller: locationCon,
      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      keyboardType: TextInputType.name,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('location'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.location_on_outlined,
                  color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );

    final mobile = TextField(
      enableInteractiveSelection: false,
      obscureText: false,
      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: mobileController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('mobile_number'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.call_outlined, color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );
    final firstName = TextField(
      controller: firstNameController,
      keyboardType: TextInputType.text,
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp(
          "[a-z,A-Z,]",
        )),
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {
        if (text.length == 1 && text != text.toUpperCase()) {
          firstNameController.text = text.toUpperCase();
          firstNameController.selection = TextSelection.fromPosition(
              TextPosition(offset: firstNameController.text.length));
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('first_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(
                Icons.person_outline,
                color: HexColor(AppColors.appColorGrey500),
                size: 20.h,
              )),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.h,
            ),
          )),
    );
    final lastName = TextField(
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        controller: lastNameController,
        inputFormatters: [
          new FilteringTextInputFormatter.allow(RegExp(
            "[a-z,A-Z]",
          )),
          FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
        ],
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
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('second_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp, color: HexColor(AppColors.appColorBlack35)),
        ));
    final studentRange = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: RichText(
            text: TextSpan(
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.body1,
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.school_outlined,
                      color: HexColor(AppColors.appColorGrey500),
                    ),
                  ),
                ),
                TextSpan(
                  text: selectStRange ??
                      AppLocalizations.of(context)!.translate("student_range"),
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ],
            ),
          )),
      items: _getRangeValuesIndus(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectStRange = (value) as String?;
        });
      },
    );

    final institute = DropdownButtonFormField<dynamic>(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectInstType ??
              AppLocalizations.of(context)!.translate("inst_type"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getInstituteType(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectInstType = (value) as String?;
        });
      },
    );

    final relation = DropdownButtonFormField<dynamic>(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectRelation ??
              AppLocalizations.of(context)!.translate("Relationship"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getRelationtype(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectRelation = (value) as String?;
        });
      },
    );
    final teacherRange = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: RichText(
            text: TextSpan(
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.body1,
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.local_library_outlined,
                      color: HexColor(AppColors.appColorGrey500),
                    ),
                  ),
                ),
                TextSpan(
                  text: selectTecRange ??
                      AppLocalizations.of(context)!.translate("teacher_range"),
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ],
            ),
          )),
      items: _getGenderValuesIndus(),
      onChanged: (value) {
        value as DropdownMenuItem;
        setState(() {
          selectTecRange = (value) as String?;
        });
      },
    );
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
              // resizeToAvoidBottomInset: false,
              appBar: appAppBar().getCustomAppBar(
                context,
                appBarTitle: '',
                onBackButtonPress: () {
                  Navigator.pop(context);
                },
              ),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Visibility(
                        visible: !isGoogleOrFacebookDataReceived,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Container(
                                  // margin:  EdgeInsets.only(top: 16.h),
                                  child: Image(
                                image: AssetImage('assets/appimages/logo.png'),
                                fit: BoxFit.contain,
                                width: 72.w,
                                height: 72.h,
                              )),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("call_back"),
                                style: styleElements
                                    .headline5ThemeScalable(context)
                                    .copyWith(fontSize: 24.sp),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.all(8.h),
                                      width: 0.45.sw,
                                      child: firstName),
                                  Container(
                                    margin: EdgeInsets.all(8.h),
                                    width: 0.45.sw,
                                    child: lastName,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: emailField,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: mobile,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: instituteName,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 8.w, right: 8.w, bottom: 8.h),
                                          width: 0.5.sw,
                                          child:institute),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 8.w, right: 8.w, bottom: 8.h),
                                          width: 0.5.sw,
                                          child: relation),
                                    ),
                                  ],
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: location,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 8.w, right: 8.w, bottom: 8.h),
                                        width: 0.5.sw,
                                        child: teacherRange),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 8.w, right: 8.w, bottom: 8.h),
                                        width: 0.5.sw,
                                        child: studentRange),
                                  ],
                                )),
                            Container(
                                height: 80,
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: HexColor(AppColors.appColorGrey500),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: description),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 4.0),
                                child: Text(
                                  quotesCharacterLength + "/100",
                                  style: styleElements
                                      .captionThemeScalable(context),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          !isCalling?  Container(
                                margin: EdgeInsets.only(bottom: 4.h, top: 4.h),
                                alignment: Alignment(0.w, 0.3.w),
                                child: Container(
                                  margin: EdgeInsets.only(top: 36.h),
                                  alignment: Alignment(0, 0.4),
                                  child: LargeButton(
                                      name: "Submit",
                                      offsetX: 96.66.w,
                                      offsetY: 12.93.w,
                                      callback: () {
                                        submit(context);
                                      }),
                                )):Container(
                            alignment: Alignment(0.w, 0.3.w),
                            margin: EdgeInsets.only(top: 36.h),

                            child: Center(
                            child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                          ),
                                ),
                          ],
                        )),
                  ],
                ),
              ))),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
    return new Future(() => false);
  }

  void submit(BuildContext ctx) async {
    if (firstNameController.text.trim().isNotEmpty) {
      if (lastNameController.text.trim().isNotEmpty) {
        if (emailController.text.trim().isNotEmpty &&
            EditProfileMixins().validateEmail(emailController.text) == null) {
          {
            {
              {
                setState(() {
                  isCalling = true;
                });
                RequestCallBack registerUserPayload = RequestCallBack();
                registerUserPayload.emailId = emailController.text;
                try {
                  registerUserPayload.mobileNumber = mobileController.text;
                } catch (e) {
                  print(e);
                }
                registerUserPayload.firstName = firstNameController.text;
                registerUserPayload.lastName = lastNameController.text;
                registerUserPayload.institutionName = instituteNameC.text;
                InstitutionLocation loc = InstitutionLocation();
                loc.address1 = locationCon.text;
                registerUserPayload.enquiryType = "callback";
                registerUserPayload.institutionLocation = loc;
                registerUserPayload.enquiryReference = selectRelation;
                registerUserPayload.numberOfStudent = selectStRange;
                registerUserPayload.numberOfTeacher = selectTecRange;
                registerUserPayload.institutionType = selectInstType;
                registerUserPayload.relationShipType = selectRelation;
                registerUserPayload.description = descriptionController.text;

                print(jsonEncode(registerUserPayload));

                Calls()
                    .call(jsonEncode(registerUserPayload), context,
                        Config.CALL_BACK)
                    .then((value) async {
                  setState(() {
                    isCalling = false;
                  });
                  if (value != null) {
                    Navigator.pop(ctx);
                    var data = BaseResponse.fromJson(value);
                    ToastBuilder().showToast(
                        data.message!, context, HexColor(AppColors.information));

                  }
                }).catchError((onError) async {
                  ToastBuilder().showToast(onError.toString(), context,
                      HexColor(AppColors.information));
                  setState(() {
                    isCalling = false;
                  });
                });
              }
            }
          }
        } else {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate("email_required"),
              context,
              HexColor(AppColors.information));
        }
      } else
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("last_name_required"),
            context,
            HexColor(AppColors.information));
    } else
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("first_name_required"),
          context,
          HexColor(AppColors.warning));
  }

  void getEmpType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "RANGETYPE",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);

        for (var item in data.rows!) {
          range.add(item.description);
          rangeStudent.add(item.description);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getInstituteType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "inst_type",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);

        for (var item in data.rows!) {
          instituteTypelist.add(item.description);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getRelationType() async {
    final body = jsonEncode({
      "search_val": "",
      "dictonary_type_id": "RELATIONSHIPTYPE",
      "page_number": 1,
      "page_size": 115
    });
    Calls().call(body, context, Config.DROP_DOWN_GLOBAL).then((value) async {
      if (value != null) {
        var data = DropDownCommon.fromJson(value);

        for (var item in data.rows!) {
          relationship.add(item.description);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
}
