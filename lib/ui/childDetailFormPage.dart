import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/Registration%20/childParentDetail.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboardhomepage.dart';
import 'dialog_page.dart';

// ignore: must_be_immutable
class ChildDetailFormPage extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  @override
  ChildDetailFormPageState createState() => ChildDetailFormPageState(registerUserAs);

  ChildDetailFormPage(this.registerUserAs);
}

class ChildDetailFormPageState extends State<ChildDetailFormPage> {
  late TextStyleElements styleElements;
  RegisterUserAs? registerUserAs;
  TextEditingController? nameController;
  TextEditingController? enrollmentNumberController;
  TextEditingController? emailController;
  TextEditingController? mobileController;
  int? selectedEpoch;
  late SharedPreferences prefs;
  String selectedDate = 'Date of Birth';
  String gender = "Gender";
  String selectedGender = "Gender";
  var items = ['Male', 'Female', 'Transgender'];
  String? email;
  String? childName;
  String? admissionNumber;
  String? mobileNumber;
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();

  }
  @override
  void initState() {
    _setPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final dob = GestureDetector(
      onTap: () {
        _showModalBottomSheet(context, "dob");
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
    final genderField = Stack(
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
                          child: Text(selectedGender,
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
    final name = TextFormField(
      controller: nameController,
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

      validator: CommonMixins().validateTextField,
      onSaved: (value) {
        childName = value;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('name_child'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final enrollmentNumber = TextFormField(
        controller: enrollmentNumberController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            enrollmentNumberController!.text = text.toUpperCase();
            enrollmentNumberController!.selection = TextSelection.fromPosition(
                TextPosition(offset: enrollmentNumberController!.text.length));
          }
        },
        validator: CommonMixins().validateTextField,
        onSaved: (value) {
          admissionNumber = value;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText:
          AppLocalizations.of(context)!.translate("enter_student_number"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
        ));
    final emailField = TextFormField(
      controller: emailController,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('email_id_child'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
      onSaved: (String? value) {
        email = value;
      },
    );
    final mob = TextFormField(
        controller: mobileController,
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            mobileController!.text = text.toUpperCase();
            mobileController!.selection = TextSelection.fromPosition(
                TextPosition(offset: mobileController!.text.length));
          }
        },

        onSaved: (value) {
          mobileNumber = value;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate("child_mobile"),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
        ));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: TricycleAppBar().getCustomAppBar(
          context,
          appBarTitle: AppLocalizations.of(context)!.translate('child_detail'),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
        ),
        body: Form(
          key: formKey,
          child: Container(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TricycleCard(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.translate('enter_details_child'),
                                style: styleElements
                                    .headline6ThemeScalable(context),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: name,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                        child: dob,
                                      )),
                                  Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                        child: genderField,
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: enrollmentNumber,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.translate("want_to_invite_child"),
                                  style: styleElements
                                      .bodyText2ThemeScalable(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: emailField,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: mob,
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Instructions\n\n',
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                '1. You will be having restricted access till the time You are verified. \n',
                                style:
                                styleElements.bodyText2ThemeScalable(context),
                              ),
                              TextSpan(
                                text:
                                '2. You may cancel the registration in case you do not have a child in this school and you created an account by mistake.',
                                style:
                                styleElements.bodyText2ThemeScalable(context),
                              )
                            ])),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    height: 56,
                    color: HexColor(AppColors.appColorWhite),
                    child: Row(
                      children: [
                        TricycleTextButton(
                          shape: RoundedRectangleBorder(),
                          onPressed: () {
                            if (prefs.getString("token") != null) {
                              if (prefs.getBool("isProfileCreated") != null && prefs.getBool("isProfileCreated")!)
                              {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (ctx) => DashboardPage()),
                                        (Route<dynamic> route) => false);

                              }
                              else
                              {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (ctx) => WelComeScreen()),
                                        (Route<dynamic> route) => false);
                              }


                            }
                          },
                          child: Text(AppLocalizations.of(context)!.translate('cancel_registration'),
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(color: HexColor(AppColors.appMainColor)),
                          ),
                        ),
                        Spacer(),
                        TricycleProgressButton(
                            key: progressButtonKey,
                            onPressed: () {
                              validate();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.translate('next'),
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(AppColors.appColorWhite)),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if(selectedEpoch!=null){
        if(selectedGender!=null){
          apiCall();
        }else{
          ToastBuilder().showToast(AppLocalizations.of(context)!.translate('gender_required'), context, HexColor(AppColors.information));
        }
      }else{
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('dob_required'), context, HexColor(AppColors.information));
      }
    }
  }

  void apiCall() async{
    progressButtonKey.currentState!.show();
    ChildDetailRequest payload = ChildDetailRequest();
    payload.email= email;
    payload.mobileNumber = mobileNumber;
    payload.admissionNo = admissionNumber;
    payload.childFullName = childName;
    payload.dateOfBirth = selectedDate;
    payload.gender = selectedGender;
    payload.phoneNumber = null; //send null
    // todo fill the following details if necessary ask shailender whats mandatory fields
    payload.allInstitutionId=registerUserAs!.institutionId;
    payload.institutionClassId=registerUserAs!.personClasses![0].classId.toString();
    payload.institutionSectionId=registerUserAs!.personClasses![0].sections![0].toString();
    payload.invitationId;
    payload.parentAllPersonsId=prefs.getInt(Strings.userId);
    Calls().call(jsonEncode(payload), context, Config.CHILD_DETAIL_CREATE).then((value) {
      progressButtonKey.currentState!.hide();
      var res = ChildDetailResponse.fromJson(value);
      if(res.statusCode==Strings.success_code){
        register(prefs.getInt(Strings.userId));
      }
    }).catchError((onError){
      progressButtonKey.currentState!.hide();
    });

  }

  // ignore: missing_return
  Widget ?_showModalBottomSheet(context, type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: _showCuperTinoDatePicker(type),
          );
        });
  }

  Widget _showCuperTinoDatePicker(String type) {
    DateTime today = new DateTime.now();
    var newDate;
    if (type == "dob")
      newDate = new DateTime(today.year - 4, today.month, today.day);
    else
      newDate = new DateTime.now();
    return CupertinoDatePicker(
      initialDateTime: newDate,
      maximumDate: newDate,
      onDateTimeChanged: (DateTime newdate) {
        setState(() {
          if (type == "dob") {
            selectedEpoch = newdate.millisecondsSinceEpoch;
            selectedDate = DateFormat('yyyy-MM-dd').format(newdate);
          } else {
            selectedEpoch = newdate.millisecondsSinceEpoch;
          }
        });
      },
      mode: CupertinoDatePickerMode.date,
    );
  }
  void register(int? userId) async {
    prefs = await SharedPreferences.getInstance();
    registerUserAs!.dateOfBirth = null;
    registerUserAs!.personId = userId;

    final body = jsonEncode(registerUserAs);
    progressButtonKey.currentState!.show();
    Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
      if (value != null) {
        progressButtonKey.currentState!.hide();
        var data = RegisterUserAsResponse.fromJson(value);
        print(data.toString());
        if (data.statusCode == "S10001") {
          prefs.setBool("isProfileCreated", true);


          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DilaogPage(
                    type: "parent",
                    isVerified: data.rows!.isVerified,
                    title: AppLocalizations.of(context)!.translate('you_are_added_as') + "parent",
                    subtitle: data.rows!.institutionName != null
                        ? " at " + data.rows!.institutionName!
                        : "",
                  )),
                  (Route<dynamic> route) => false);
        } else
          ToastBuilder().showToast(
              data.message!, context, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
      progressButtonKey.currentState!.hide();
    });
  }
  ChildDetailFormPageState(this.registerUserAs);
}
