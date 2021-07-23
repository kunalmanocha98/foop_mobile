import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contact_detail_institute_page.dart';
import 'models/basic_response.dart';

// ignore: must_be_immutable
class DomainPage extends StatefulWidget {
  int? instId;
  @override
  _DomainPage createState() =>
      new _DomainPage(instId);

  DomainPage(this.instId);
}

class _DomainPage extends State<DomainPage>
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
              appBar: TricycleAppBar().getCustomAppBar(context,
                  appBarTitle: AppLocalizations.of(context)!.translate('register_institute'),
                  isIconVisible:false,
                  actions: [

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){


                          if(domainController.text.trim()!=null  && domainController.text.trim()!="")
                          {submit();}
                          else
                          {
                            prefs.setString("create_institute", "Contact");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        ContactsDetailsPageInstitute(instId)));
                          }

                        },
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.translate('next'), style:styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
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
                        child: TricycleCard(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: Text(AppLocalizations.of(context)!.translate('default_domain'),
                                      style: styleElements
                                          .headline6ThemeScalable(context)
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate("domain"),
                                        style: styleElements
                                        .bodyText2ThemeScalable(context)
                                        .copyWith(color: HexColor(AppColors.appColorBlack85)),

                                    ),
                                  )),
                             
                            
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.h),
                                    child: donamin,
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
                                        child: TricycleElevatedButton(
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
    return new Future(() => false);
  }

  void submit() async {

setState(() {
  isLoading=true;
});
    final body = jsonEncode({
      "institution_id": instId,
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
                      ContactsDetailsPageInstitute(instId)));
        }
      }
    }).catchError((onError) async {
      setState(() {
        isLoading=false;
      });

    });
  }

  _DomainPage(this.instId);
}
