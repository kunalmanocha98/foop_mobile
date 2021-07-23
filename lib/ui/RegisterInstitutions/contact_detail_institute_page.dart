import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/conversationPage/base_response.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'institute_location_page.dart';
import 'models/instituteContacts.dart';

// ignore: must_be_immutable
class ContactsDetailsPageInstitute extends StatefulWidget {
  int? instId;

  ContactsDetailsPageInstitute(this.instId);

  @override
  _ContactsDetailsPageInstitute createState() =>
      new _ContactsDetailsPageInstitute(instId);
}

class _ContactsDetailsPageInstitute extends State<ContactsDetailsPageInstitute>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl;
  int? instId;
  var range = <String>[];
  var rangeStudent = <String>[];

  var instituteTypelist = <String>[];
  var relationship = <String>[];
  bool isTermAndConditionAccepted = false;
  String? email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final emailController = TextEditingController();
  final instituteNameC = TextEditingController();
  final username = TextEditingController();
  final websiteCon = TextEditingController();
  final mobileController = TextEditingController();
  final phoneCon = TextEditingController();
  final firstNameController = TextEditingController();
  final usernameCont = TextEditingController();
  final genderController = TextEditingController();
  final descriptionController = TextEditingController();

 late BuildContext context;
  late TextStyleElements styleElements;


  String? selectInstCategory;

  String? selectInstType;

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

    final website = Form(
        child: TextFormField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      onSaved: (String? value) {},
      controller: websiteCon,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('website'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    ));
    final emailField = Form(
      child: TextFormField(
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
            contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
            hintText: AppLocalizations.of(context)!.translate('email'),
            hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
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
    final mobile = TextField(
      enableInteractiveSelection: false,
      obscureText: false,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
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
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );
    final phone = TextField(
      enableInteractiveSelection: false,
      obscureText: false,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: phoneCon,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('phone'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );

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

                          submit(context);

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
                  Visibility(
                      visible: !isGoogleOrFacebookDataReceived,
                      child: TricycleCard(
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: Text(AppLocalizations.of(context)!.translate('contact_details'),
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
                                  child: mobile,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: phone,
                                )),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: emailField),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: website,
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Card(

                                  color:HexColor(AppColors.appColorWhite65),
                                  margin: EdgeInsets.only(
                                      left: 8.w, right: 8.w, bottom: 8.h),
                                  child: Container(child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)!.translate('tricycle_web_auto')),
                                      ))),
                                )),

                          ],
                        ),
                      )),

                ],
              ))),
    );
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {

    return new Future(() => false);
  }

  void submit(BuildContext ctx) async {
    setState(() {
      isLoading=true;
    });
    InstituteContactDetail instituteContactDetail =
    InstituteContactDetail();
    instituteContactDetail.institutionId = instId;
    instituteContactDetail.phone = int.parse(phoneCon.text.trim()!=""?phoneCon.text:"0");
    instituteContactDetail.mobile = int.parse(mobileController.text.trim()!=""?mobileController.text:"0");
    instituteContactDetail.email = emailController.text;
    instituteContactDetail.website = websiteCon.text;
    print(jsonEncode(instituteContactDetail));

    Calls()
        .call(jsonEncode(instituteContactDetail), context,
        Config.INSTITUTE_CONTACT)
        .then((value) async {

      if (value != null) {
        setState(() {
          isLoading=false;
        });

        var data = BaseResponse.fromJson(value);
        if(data.statusCode==Strings.success_code)
        {
          prefs.setString("create_institute", "Address");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext
                  context) =>
                      InstituteLocationAddressPage(instId)));
        }


      }

    }).catchError((onError) async {
      setState(() {
        isLoading=false;
      });
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));

    });
  }

  _ContactsDetailsPageInstitute(this.instId);
}
