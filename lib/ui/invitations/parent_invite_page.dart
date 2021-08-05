import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/invite_module/InviteModels.dart';
import 'package:oho_works_app/models/menu/menulistmodels.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InviteParent extends StatefulWidget {
  SharedPreferences? prefs;

  InviteParent({this.prefs});

  @override
  _InviteParent createState() => _InviteParent(prefs: prefs);
}

class _InviteParent extends State<InviteParent> with CommonMixins{
  late TextStyleElements styleElements;
  ProgressDialog? pr;
  Persondata? rows;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  bool cb1 = false, cb2 = false;
  List<MenuListItem> menuList = [];
  int? selectedRadio;
  SharedPreferences? prefs;
  GlobalKey<appProgressButtonState> progressButtonKey= GlobalKey();


  String? fatherFirstName,motherFirstName;
  String? fatherLastName,motherLastName;
  String? fatherEmail, motherEmail;
  String? fatherMobile, motherMobile;
  GlobalKey<FormState> formKey = GlobalKey();


  _InviteParent({this.prefs});

  @override
  void initState() {
    super.initState();

  }
    final mobileControllerFather = TextEditingController();
    final mobileControllerMother = TextEditingController();
    final firstNameControllerFather = TextEditingController();
  final lastNameControllerFather = TextEditingController();
  final firstNameControllerMother = TextEditingController();
  final lastNameControllerMother = TextEditingController();
  // final genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    final emailFieldFather = TextFormField(
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
        validator: validateEmail,
        onSaved: (String? value) {
          fatherEmail = value;
        },
      );
    final mobileFather = TextField(
      obscureText: false,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: mobileControllerFather,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('mobile_number'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.call_outlined, color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );
    final firstNameFather = TextFormField(
      validator: validateTextField,
      onSaved: (value){
        fatherFirstName = value;
      },
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
          firstNameControllerFather.text = text.toUpperCase();
          firstNameControllerFather.selection = TextSelection.fromPosition(
              TextPosition(offset: firstNameControllerFather.text.length));
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('first_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context),
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
    final lastNameFather = TextFormField(
      validator: validateTextField,
      onSaved: (value){
        fatherLastName = value;
      },
      controller: lastNameControllerFather,
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
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
            lastNameControllerFather.text = text.toUpperCase();
            lastNameControllerFather.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameControllerFather.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('last_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp),
        ));
    final emailFieldMother = TextFormField(
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
        validator: validateEmail,
        onSaved: (String? value) {
          motherEmail = value;
        },
      );
    final mobileMother = TextField(
      obscureText: false,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      controller: mobileControllerMother,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[,\.]')),
      ],
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('mobile_number'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.call_outlined, color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );
    final firstNameMother = TextFormField(
      validator: validateTextField,
      onSaved: (value){
        motherFirstName = value;
      },
      controller: firstNameControllerMother,
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
          firstNameControllerMother.text = text.toUpperCase();
          firstNameControllerMother.selection = TextSelection.fromPosition(
              TextPosition(offset: firstNameControllerMother.text.length));
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
    final lastNameMother = TextFormField(
      validator: validateTextField,
      onSaved: (value){
        motherLastName = value;
      },
      controller: lastNameControllerMother,
        style: styleElements
            .subtitle1ThemeScalable(context).copyWith(
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
            lastNameControllerMother.text = text.toUpperCase();
            lastNameControllerMother.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameControllerMother.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('last_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(fontSize: 14.sp),
        ));

    return SafeArea(
      child: Scaffold(

        appBar: OhoAppBar().getCustomAppBar(context,
            appBarTitle: 'Invite Parents', onBackButtonPress: () {
          Navigator.pop(context);
        }),
        body:

        Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Container(
                              child: Image(
                                  image: AssetImage(
                                      'assets/appimages/Teacher-pana.png')),
                            ),
                          ),
                          Container(
                              child: Text(
                                AppLocalizations.of(context)!.translate("invite_parent"),
                                style: styleElements.headline6ThemeScalable(context),
                              )),
                          Container(
                              child: Text(
                                AppLocalizations.of(context)!.translate("earn_coins"),
                                style: styleElements
                                    .headline6ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Form(
                key: formKey,
                child:
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: appCard(
                          padding: EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Padding(
                                    padding: const EdgeInsets.all(16),
                                    child:Text(AppLocalizations.of(context)!.translate("father_detail"),   style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w700),)),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: firstNameFather,
                                      )),
                                      Flexible(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: lastNameFather,
                                      ),)  ,
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, top: 12.h, bottom: 8.h),
                                      child: emailFieldFather,
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, top: 12.h, bottom: 8.h),
                                      child: mobileFather,
                                    )),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: appCard(
                          padding: EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(16),
                                    child:Text(AppLocalizations.of(context)!.translate("mother_detail"),style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w700))),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: firstNameMother,
                                      )),
                                      Flexible(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: lastNameMother,
                                      ),)  ,
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, top: 12.h, bottom: 8.h),
                                      child: emailFieldMother,
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, top: 12.h, bottom: 8.h),
                                      child: mobileMother,
                                    )),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
            )
            ,
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: HexColor(AppColors.appColorWhite),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: appProgressButton(
                          key: progressButtonKey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: HexColor(AppColors.appMainColor))),
                          onPressed: () {
                            sendInvites();
                          },
                          color: HexColor(AppColors.appColorWhite),
                          child: Text(
                              AppLocalizations.of(context)!.translate("invite"),
                              style: styleElements.buttonThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
                        ),
                      )),
                ))],
        ),
      ),
    );
  }

  void sendInvites() async{
   progressButtonKey.currentState!.show();
    prefs??=await SharedPreferences.getInstance();
    formKey.currentState!.save();
    if((mobileControllerFather.text!=null && mobileControllerFather.text.isNotEmpty&& fatherEmail!=null && fatherEmail!.isNotEmpty)||(mobileControllerMother.text!=null && mobileControllerMother.text.isNotEmpty&& motherEmail!=null && motherEmail!.isNotEmpty)){

      InviteCreatePayload payload = InviteCreatePayload();
      payload.inviteContextType = 'TR';
      payload.inviteContextTypeId = prefs!.getInt(Strings.userId);
      payload.invitedByType = 'person';
      payload.invitedById = prefs!.getInt(Strings.userId);
      payload.invitationRecipientList = getInvitationRecipientList();
      Calls().call(jsonEncode(payload), context, Config.INVITATION_CREATE).then((value) async {
        var response  = InviteCreateResponse.fromJson(value);
        progressButtonKey.currentState!.hide();
        if(response.statusCode == Strings.success_code){
          ToastBuilder().showToast(response.message!, context, HexColor(AppColors.success));
          Navigator.pop(context);
        }else{
          ToastBuilder().showToast(response.message!, context, HexColor(AppColors.warning));
        }
      }).catchError((onError) async {
        progressButtonKey.currentState!.hide();
        ToastBuilder().showToast('Some Failure', context, HexColor(AppColors.warning));
      });
    }
    else
      {
        progressButtonKey.currentState!.hide();
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate("email_mobile_required"), context, HexColor(AppColors.information));
      }
  }

  List<InvitationRecipientList> getInvitationRecipientList() {
    List<InvitationRecipientList> list = [];

    list.add(InvitationRecipientList(
      category: "Parent",
      emailId: fatherEmail,
      name: fatherFirstName!+" "+fatherLastName!,
      mobileNumber: mobileControllerFather.text
    ));
    list.add(InvitationRecipientList(
        category: "Parent",
        emailId: motherEmail,
        name: motherFirstName!+" "+motherLastName!,
        mobileNumber: mobileControllerMother.text
    ));
    return list;
  }
}
