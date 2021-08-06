import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/models/profileEditRequest.dart';
import 'package:oho_works_app/profile_module/pages/edit_education.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class BasicInfo extends StatefulWidget {
  Persondata? personData;
  final Null Function()? callbackPicker;

  _BasicInfo createState() => _BasicInfo(personData, callbackPicker);

  BasicInfo(this.personData,this.callbackPicker);
}

class _BasicInfo extends State<BasicInfo>
    with EditProfileMixins, SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  SharedPreferences? prefs;
  Null Function()? callback;
  late TextStyleElements styleElements;
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final bioController = TextEditingController();
  final mobileController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  // final quotesController = TextEditingController();
  final secondCon = TextEditingController();
  String bioCharacterLength = "0";
  String quotesCharacterLength = "0";
  String? email, biog, quotes;
 late BuildContext context;
  String selectedDoA = 'Date of Anniversary';
  String selectedDate = 'Date of Birth';
  String selectedGender = "Gender*";
  String selectedBGroup = "Blood Group";
  int? selectedEpoch;
  var items = ['Male', 'Female', 'Transgender'];
  var itemsBG = ['A+', 'A-', 'B+', ' B-', ' O+', 'O-', 'AB+', ' AB-'];
  Map<String, String> mpGroup = {
    'A+': 'APOSITIVE',
    'A-': 'ANEGATIVE',
    'B+': 'BPOSITIVE',
    ' B-': 'BNEGATIVE',
    ' O+': 'OPOSITIVE',
    'O-': 'ONEGATIVE',
    'AB+': 'ABPOSITIVE',
    ' AB-': 'ABNEGATIVE'
  };

  Map<String, String> mpGroupRev = {
    'APOSITIVE': 'A+',
    'ANEGATIVE': 'A-',
    'BPOSITIVE': 'B+',
    'BNEGATIVE': ' B-',
    'OPOSITIVE': ' O+',
    'ONEGATIVE': 'O-',
    'ABPOSITIVE': 'AB+',
    'ABNEGATIVE': ' AB-'
  };

  @override
  void initState() {
    super.initState();

    setData();
  }

  Widget build(BuildContext context) {


    ScreenUtil.init;
    styleElements = TextStyleElements(context);
    this.context = context;
    final bio = TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: validateBioName,
      onSaved: (String? value) {
        biog = value;
      },
      onChanged: (text) {
        setState(() {
          bioCharacterLength = text.length.toString();
        });
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(100),
      ],
      controller: bioController,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );
    // final quote = TextFormField(
    //     style: styleElements.bodyText2ThemeScalable(context),
    //     keyboardType: TextInputType.multiline,
    //     maxLines: null,
    //     validator: validateQuote,
    //     onSaved: (String value) {
    //       quotes = value;
    //     },
    //     onChanged: (text) {
    //       setState(() {
    //         quotesCharacterLength = text.length.toString();
    //       });
    //     },
    //     inputFormatters: [
    //       new LengthLimitingTextInputFormatter(100),
    //     ],
    //     controller: quotesController,
    //     scrollPadding:
    //         EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    //     decoration: InputDecoration(
    //       border: InputBorder.none,
    //       focusedBorder: InputBorder.none,
    //       enabledBorder: InputBorder.none,
    //       errorBorder: InputBorder.none,
    //       disabledBorder: InputBorder.none,
    //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    //       hintStyle: styleElements.subtitle2ThemeScalable(context),
    //     ));
    final dob = GestureDetector(
      onTap: () {
        _selectDate(context, "dob");

      },
      child: Container(
          padding: EdgeInsets.all(16),
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
              selectedDate != "Date of Birth"
                  ? DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(selectedDate))
                  : selectedDate,
              textAlign: TextAlign.left,
              style: styleElements.subtitle2ThemeScalable(context),
            ),
          )),
    );
    final doa = GestureDetector(
      onTap: () {
        _selectDate(context, "doa");

      },
      child: Container(
          padding: EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 4),
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
              selectedDoA != "Date of Anniversary"
                  ? DateFormat('dd-MM-yyyy').format(DateTime.parse(selectedDoA))
                  : selectedDoA,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styleElements.subtitle2ThemeScalable(context),
            ),
          )),
    );
    final gender = Stack(
      children: <Widget>[
        Column(
          children: [
            Row(
              children: <Widget>[
                new Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 8, top: 16, bottom: 16, right: 4),
                        alignment: Alignment.centerLeft,
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
                            "$selectedGender",
                            textAlign: TextAlign.left,
                            style:
                                styleElements.subtitle2ThemeScalable(context),
                          ),
                        ))),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: new PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              setState(() {
                selectedGender = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return items.map<PopupMenuItem<String>>((String value) {
                return new PopupMenuItem(child: new Text(value), value: value);
              }).toList();
            },
          ),
        )
      ],
    );
    final secondName = TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: secondCon,
      keyboardType: TextInputType.text,
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp(
          "[a-z,A-Z,]",
        )),
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('second_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final firstName = TextField(
      controller: firstNameController,
      keyboardType: TextInputType.text,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('first_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final lastName = TextField(
        controller: lastNameController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('last_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
        ));
    final userName = TextField(
        controller: userNameController,
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
          hintText: AppLocalizations.of(context)!.translate('user_name'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
        ));
    final bGroup = Stack(
      children: <Widget>[
        Column(
          children: [
            Row(
              children: <Widget>[
                new Expanded(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
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
                            "$selectedBGroup",
                            textAlign: TextAlign.left,
                            style:
                                styleElements.subtitle2ThemeScalable(context),
                          ),
                        ))),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: new PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              setState(() {
                selectedBGroup = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return itemsBG.map<PopupMenuItem<String>>((String value) {
                return new PopupMenuItem(child: new Text(value), value: value);
              }).toList();
            },
          ),
        )
      ],
    );
    Widget _body() {
      return Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 80),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("basic"),
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              flex: 3,
                            ),
                          ],
                        ),
                        Container(
                            child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: firstName,
                              )),
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: secondName,
                              )),
                            ],
                          ),
                        )),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: lastName,
                            )),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin:
                              const EdgeInsets.only(left: 16, right: 16),
                              child: userName,
                            )),
                        Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: gender,
                              )),
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: dob,
                              )),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: doa,
                              )),
                              new Flexible(
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: bGroup,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Card(
                        child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("bio"),
                                      style: styleElements
                                          .subtitle1ThemeScalable(context),
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
                            margin: const EdgeInsets.only(
                                left: 16, right: 8, top: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("write_about_you"),
                              style:
                                  styleElements.captionThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
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
                            child: bio),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8.0),
                            child: Text(
                              bioCharacterLength + "/100",
                              style:
                                  styleElements.captionThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ))),
                // Container(
                //     margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                //     child: Card(
                //         child: Column(
                //       children: <Widget>[
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: <Widget>[
                //             Flexible(
                //               child: Align(
                //                   alignment: Alignment.topLeft,
                //                   child: Container(
                //                     margin: const EdgeInsets.only(
                //                         left: 16, top: 16),
                //                     child: Text(
                //                       AppLocalizations.of(context)
                //                           .translate("quote"),
                //                       style: styleElements
                //                           .subtitle1ThemeScalable(context),
                //                       textAlign: TextAlign.left,
                //                     ),
                //                   )),
                //               flex: 3,
                //             ),
                //           ],
                //         ),
                //         Align(
                //           alignment: Alignment.topLeft,
                //           child: Container(
                //             margin: const EdgeInsets.only(
                //                 left: 16, right: 8, top: 8.0),
                //             child: Text(
                //               AppLocalizations.of(context)
                //                   .translate("write_quote_you"),
                //               style:
                //                   styleElements.captionThemeScalable(context),
                //               textAlign: TextAlign.left,
                //             ),
                //           ),
                //         ),
                //         Container(
                //             height: 100,
                //             margin: const EdgeInsets.all(16),
                //             decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: HexColor(AppColors.appColorGrey500),
                //                 ),
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(8))),
                //             child: quote),
                //         Align(
                //           alignment: Alignment.bottomRight,
                //           child: Container(
                //             margin: const EdgeInsets.only(
                //                 left: 16, right: 16, bottom: 8.0),
                //             child: Text(
                //               quotesCharacterLength + "/100",
                //               style:
                //                   styleElements.captionThemeScalable(context),
                //               textAlign: TextAlign.left,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ))),
              ],
            ),
          ),
          Align(
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
                            if (firstNameController.text != null &&
                                firstNameController.text != "")
                              {
                                if (selectedDate != null &&
                                    selectedDate != "Gender*")
                                  _profileUpdate("save");
                                else
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate("gender_required"),
                                      context,HexColor(AppColors.information));
                              }

                            else
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate("first_name_required"),
                                  context,HexColor(AppColors.information));

                          },
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
                            if (firstNameController.text != null &&
                                firstNameController.text != "")
                              _profileUpdate("next");
                            else
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate("first_name_required"),
                                  context,HexColor(AppColors.information)); },
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
                  )))
        ],
      );
    }

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: HexColor(AppColors.appColorBackground),
            appBar: appAppBar().getCustomAppBar(
              context,
              appBarTitle: 'Profile',
              onBackButtonPress: () {

                Navigator.of(context).pop(true);
              },
            ),
            body: Form(
              key: formKey,
              child: _body(),
            )));
  }

  setData() {
    if (personData != null) {
      if (personData!.firstName != null)
        firstNameController.text = personData!.firstName ?? "";
      if (personData!.lastName != null)
        lastNameController.text = personData!.lastName ?? "";
      if (personData!.email != null)
        emailController.text = personData!.email ?? "";
      if (personData!.userName != null)
        userNameController.text = personData!.userName ?? "";

      if (personData!.dateOfBirth != null)
        selectedDate = personData!.dateOfBirth ?? "";
      if (personData!.dateOfAnniversary != null)
        selectedDoA = personData!.dateOfAnniversary ?? "";
      if (personData!.gender != null)
        selectedGender = personData!.gender == 1
            ? 'Male'
            : personData!.gender == 2
                ? 'Female'
                : personData!.gender == 3 ? 'Transgender' : "Gender*";
      if (personData!.fullBio != null) {
        bioController.text = personData!.fullBio ?? "";
        bioCharacterLength = personData!.fullBio!.length.toString();
      }

      // if (personData.message != null) {
      //   quotesController.text = personData.message ?? "";
      //   quotesCharacterLength = personData.message.length.toString();
      // }

      if (personData!.middleName != null)
        secondCon.text = personData!.middleName ?? "";
      if (personData!.bloodGroup != null)
        selectedBGroup = mpGroupRev[personData!.bloodGroup!] ?? "";
    }
  }


  // ignore: missing_return

  Future<void> _profileUpdate(String action) async {
    ProfileEditPayload payload = ProfileEditPayload();
    payload.userName =
    (userNameController.text != null && userNameController.text != "")
        ? userNameController.text
        : personData!.userName;

    payload.firstName =
        (firstNameController.text != null && firstNameController.text != "")
            ? firstNameController.text
            : personData!.firstName;
    payload.secondName =
        (secondCon.text != null) ? secondCon.text : personData!.middleName;
    payload.lastName = (lastNameController.text != null)
        ? lastNameController.text
        : personData!.lastName;
    if (selectedGender == 'Male') {
      payload.gender = 1;
    } else if (selectedGender == 'Female') {
      payload.gender = 2;
    } else if (selectedGender == 'Transgender') {
      payload.gender = 3;
    } else {
      payload.gender = personData!.gender;
    }
    payload.dateOfBirth =
        (selectedDate != null && selectedDate != "Date of Anniversary")
            ? selectedDate
            : personData!.dateOfBirth;
    payload.dateOfAnniversary =
        (selectedDoA != null && selectedDoA != "Date of Anniversary")
            ? selectedDoA
            : personData!.dateOfAnniversary;
    payload.bloodGroup = mpGroup[selectedBGroup] != null
        ? mpGroup[selectedBGroup]
        : personData!.bloodGroup;
    payload.bio =
        (bioController.text != null) ? bioController.text : personData!.fullBio;
    payload.slug = personData!.slug;
    // payload.quote = (quotesController.text != null)
    //     ? quotesController.text
    //     : personData.message;
    var data = jsonEncode(payload);
    if(action=="save")
    progressButtonKey.currentState!.show();
    else
    progressButtonKeyNext.currentState!.show();
    Calls().call(data, context, Config.PROFILEEDIT).then((value) async {
      DynamicResponse resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();
        if (action == "save") {
          print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
          callbackPicker!();
          Navigator.pop(context);
        }
        else {
        var result  =await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditEducation(null, true, true, callbackPicker)));
        if(result!=null && result['result']=="success")
        {
          callbackPicker!();
          Navigator.pop(context);
        }
        }
      } else {
        if(action=="save")
          progressButtonKey.currentState!.hide();
        else
          progressButtonKeyNext.currentState!.hide();
        ToastBuilder().showToast(resposne.message!, context,HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      if(action=="save")
        progressButtonKey.currentState!.hide();
      else
        progressButtonKeyNext.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }

  Persondata? personData;
  Null Function()? callbackPicker;

  _BasicInfo(this.personData, this.callbackPicker);

  Future<void> _selectDate(BuildContext context,String type) async {
    var newDate;
    if (type == "dob")
      newDate = new DateTime(DateTime.now().year - 4, DateTime.now().month, DateTime.now().day);
    else
      newDate = new DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HexColor(AppColors.appColorBlack),
              accentColor: HexColor(AppColors.appColorBlack),
              colorScheme: ColorScheme.dark(
                primary: HexColor(AppColors.appColorBlack),
                onPrimary: HexColor(AppColors.appColorWhite),
                surface: HexColor(AppColors.appColorWhite),
                onSurface: HexColor(AppColors.appColorBlack),
              ),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!,
          );
        },
        firstDate: DateTime(1900),
        lastDate: newDate);


    if (picked != null)
      setState(() {
        print (DateFormat('yyyy-MM-dd').format(picked)+"ppppppppppppppppppppppppppppp");
        if (type == "dob") {
          selectedEpoch = picked.millisecondsSinceEpoch;
          selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          selectedEpoch = picked.millisecondsSinceEpoch;
          selectedDoA = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
  }

}
