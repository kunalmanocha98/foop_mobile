import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/register_user_as_response.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/basic_institute_detail.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/contact_detail_institute_page.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/basic_response.dart';
import 'package:oho_works_app/ui/dialog_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class EmployeeCode extends StatefulWidget {
  RegisterUserAs? registerUserAs;
  @override
  _EmployeeCode createState() =>
      new _EmployeeCode();

  EmployeeCode(this.registerUserAs);
}

class _EmployeeCode extends State<EmployeeCode>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  late int? instId;
  var range = <String>[];
  var rangeStudent = <String>[];

  var instituteTypelist = <String>[];
  var relationship = <String>[];
  var mapCountry = HashMap<String, String>();
  bool isTermAndConditionAccepted = false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final domainController = TextEditingController();
  final instituteNameC = TextEditingController();
  final username = TextEditingController();
  final selectFromMap = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final addController = TextEditingController();
  final ohoUserName = TextEditingController();



  late BuildContext context;
  late TextStyleElements styleElements;


  String? selectState;

  String? selectCountry;

  String? selectStRange;

  String? selectTecRange;
  int? selectedEpoch;

  late SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    setSharedPreferences();

  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

  }
  String quotesCharacterLength = "0";
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    final ohoUserNameForm = Form(
        child: TextFormField(
          style: styleElements.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack65)
          ),
          onSaved: (String? value) {},
          controller: ohoUserName,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
              hintText: "Enter your admission code",
              hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.0.h,
                ),
              )),
        ));

    final donamin = Form(
        child: TextFormField(
          style: styleElements.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack65)
          ),
          onSaved: (String? value) {},
          controller: domainController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
              hintText: AppLocalizations.of(context)!.translate('default_email_domain'),
              hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.0.h,
                ),
              )),
        ));

    styleElements = TextStyleElements(context);


    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
              appBar: appAppBar().getCustomAppBar(context,
                  appBarTitle: "Enter admission code",
                  isIconVisible:true,
                  actions: [

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){


                          register();
                        },
                        child: Row(
                          children: [
                            InkWell(
                                onTap:(){


register();

                                },


                                child: Text(AppLocalizations.of(context)!.translate('next'), style:styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),)),
                            Visibility(
                              visible: isLoading,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],


                  onBackButtonPress: () {
                    _onBackPressed();
                  }



              ),

              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Visibility(
                        visible: !isGoogleOrFacebookDataReceived,
                        child: appCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: Text('Enter admission Code',
                                      style: styleElements
                                          .headline6ThemeScalable(context)
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  )),


                              Container(
                                margin: EdgeInsets.only(
                                    left: 8.w, right: 8.w, bottom: 8.h),
                                child: Text(
                                  "You must have received an invitation with an admission code (AC) from your employer. Please enter the same to validate your association with the company.",
                                  style: styleElements
                                      .bodyText2ThemeScalable(context)
                                      .copyWith(color: HexColor(AppColors.appColorBlack85)),

                                ),
                              ),

                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 20.h,top: 80),
                                    child: ohoUserNameForm,
                                  )),



                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h,top: 16),
                                      child: Text(
                                        "Instructions\n\n 1. An admission code is provided by your employer that. Please contact administrator’s name to get an invitation.\n 2. Admission code is unique, you should not share the admission code with anyone else.",style: styleElements
                                          .bodyText2ThemeScalable(context)
                                          .copyWith(color: HexColor(AppColors.appColorBlack85)),

                                      ),
                                    ),
                                  )),



                            ],
                          ),
                        )),
                  ),


                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: GestureDetector(
                        child: Container(
                          height: 60,
                          color: HexColor(AppColors.appColorWhite),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Visibility(
                                      visible: false,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: appElevatedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: HexColor(AppColors.appMainColor))),
                                          onPressed: () async {},
                                          color: HexColor(AppColors.appColorWhite),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate("next"),
                                              style: styleElements
                                                  .buttonThemeScalable(context)
                                                  .copyWith(
                                                  color: HexColor(AppColors.appMainColor))),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )),
                        ),
                      ))
                ],
              ))),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    return new Future(() => false);
  }

  void submit() async {

    setState(() {
      isLoading=true;
    });
    final body = jsonEncode({
      "business_id": instId,
      "domain_name": domainController.text
    });
    Calls()
        .call(body, context, Config.ADD_DOMAIN_INSTITUTE)
        .then((value) async {

      if (value != null) {
        setState(() {
          isLoading=false;
        });
        var resposne = BasicDataResponse.fromJson(value);
        if (resposne.statusCode == Strings.success_code) {

          prefs.setString("create_institute", "Contact");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext
                  context) =>
                      ContactsDetailsPageInstitute(instId:instId)));
        }
      }
    }).catchError((onError) async {
      setState(() {
        isLoading=false;
      });

    });
  }

  _EmployeeCode();

  void register() async {


    if(ohoUserName.text!=null && ohoUserName.text.isNotEmpty) {
      RegisterUserAs registerUserAs = widget.registerUserAs!;
      registerUserAs.invitation_code = ohoUserName.text.toString();
      registerUserAs.personId = prefs.getInt(Strings.userId);

      final body = jsonEncode(registerUserAs);

      Calls().call(body, context, Config.REGISTER_USER_AS).then((value) async {
        if (value != null) {
          var data = RegisterUserAsResponse.fromJson(value);
          print(data.toString());
          if (data.statusCode == "S10001") {
            prefs.setBool("isProfileCreated", true);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => DilaogPage(
                        type: "admin",
                        isVerified: true,
                        title: AppLocalizations.of(context)!
                                .translate('you_are_added_as') +
                            "Employee  of",
                        subtitle: (data.rows!.institutionName!))),
                (Route<dynamic> route) => false);
          } else
            ToastBuilder().showToast(
                data.message!, context, HexColor(AppColors.information));
        }
      }).catchError((onError) async {
        ToastBuilder().showToast(
            onError.toString(), context, HexColor(AppColors.information));
      });
    }
    else
      ToastBuilder().showToast(
         AppLocalizations.of(context)!.translate("code_req"), context, HexColor(AppColors.information));
  }
}
