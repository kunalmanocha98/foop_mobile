import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/conversationPage/base_response.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/country_code_response.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
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
// ignore: must_be_immutable

class AddEmailDilog extends StatefulWidget {
  final Null Function()? callBack;
  final Null Function()? callBackCancel;
  final bool? isEmail;

  const AddEmailDilog(
      {Key? key, this.callBack, this.callBackCancel, this.isEmail})
      : super(key: key);

  @override
  _AddEmzailDilog createState() =>
      new _AddEmzailDilog(callBack, callBackCancel, isEmail);
}

class _AddEmzailDilog extends State<AddEmailDilog> {
  Null Function()? callBack;
  Null Function()? callBackCancel;
 late BuildContext context;
  late TextStyleElements tsE;
  bool? isEmail;
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordTextController = TextEditingController();
  List<dynamic>? countryCodeList = [];
  String? cCode;

  bool isLoading=false;
  _AddEmzailDilog(this.callBack, this.callBackCancel, this.isEmail);

  @override
  // ignore: must_call_super
  void initState() {
    if (!isEmail!) getCounrtyCode();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
            hintText: AppLocalizations.of(context)!.translate('enter_email'),
            hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(
              color: HexColor(AppColors.appColorBlack35)
            ),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0.h),
                child: Icon(
                  Icons.email,
                  color: HexColor(AppColors.appColorGrey500),
                  size: 20.w,
                )),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0.w,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String? value) {},
      ),
    );
    final passwordField = Form(
        child: TextFormField(
      obscureText: true,
      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      onChanged: (v) {},
      onSaved: (String? value) {},
      controller: passwordTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('password'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.lock_outline,
                  color: HexColor(AppColors.appColorGrey500), size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    ));
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
        hintText: AppLocalizations.of(context)!.translate('enter_mobile'),
        hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(color: HexColor(AppColors.appColorBlack35)),
        border: InputBorder.none,
      ),
    );
    List<DropdownMenuItem> countryCodes = [];
    _getCountryCodes() {
      for (int i = 0; i < countryCodeList!.length; i++) {
        countryCodes.add(DropdownMenuItem(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                countryCodeList![i].flagIconUrl ?? "",
                style: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Text(
                  countryCodeList![i].dialCode,
                  style: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                ),
              ),
            ],
          ),
          value: countryCodeList![i].dialCode,
        ));
      }
      return countryCodes;
    }

    final codes = DropdownButtonFormField<dynamic>(
      value: null,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(4.0.w, 15.0.h, 4.0.w, 15.0.h),
        border: InputBorder.none,
      ),
      hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            cCode ?? AppLocalizations.of(context)!.translate("code"),
            style: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          )),
      items: _getCountryCodes(),
      onChanged: (value) {

        value as DropdownMenuItem;
        setState(() {
          cCode = (value) as String?;
        });
      },
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 30, left: 16, right: 16),
              child: Text(
                isEmail!
                    ? AppLocalizations.of(context)!.translate('add_email')
                    : AppLocalizations.of(context)!.translate('add_mobile'),
                style: tsE.headline6ThemeScalable(context),
              )),
          Visibility(
            visible: !isEmail!,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        child: Icon(
                          Icons.call,
                          color: HexColor(AppColors.appColorGrey500),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: codes,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: mobile,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                  ),
                  child: SizedBox(
                    height: 1.0,
                    child: new Center(
                      child: new Container(
                        height: 1.0,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isEmail!,
            child: Padding(
              padding: EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 16),
              child: emailField,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 16),
            child: passwordField,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 30),
            child: Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    callBackCancel!();
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                    style: tsE
                        .bodyText2ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
                Row(
                  children: [
                    TricycleTextButton(
                      onPressed: () {
                        if (isEmail!
                            ? emailController.text.trim().isNotEmpty &&
                                EditProfileMixins()
                                        .validateEmail(emailController.text) ==
                                    null
                            : mobileController.text != null &&
                                mobileController.text.trim().length > 0) {
                          if(passwordTextController.text.trim().isNotEmpty)
                            {

                              if(!isLoading)
                              addContacts();

                            }
                          else
                            {
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!.translate("login_password_empty"),
                                  context,HexColor(AppColors.information));
                            }

                        } else {
                          ToastBuilder().showToast(
                              isEmail!
                                  ? AppLocalizations.of(context)!
                                      .translate("email_required")
                                  : AppLocalizations.of(context)!
                                      .translate("enter_mobile"),
                              context,
                              HexColor(AppColors.information));
                        }
                      },
                      shape: StadiumBorder(),
                      child: Text(
                        AppLocalizations.of(context)!.translate('submit'),
                        style: tsE
                            .bodyText2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                    ),
                    Visibility(
                      visible: isLoading,
                      child: Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: SizedBox(
                          height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addContacts() async {
    setState(() {
      isLoading=true;
    });
    final body = jsonEncode({
      "contact_type": isEmail! ? "email" : "mobile",
      "country_code": !isEmail! ? cCode : "",
      "contact_detail": isEmail!
          ? emailController.text.toString()
          : mobileController.text.toString(),
      "password": passwordTextController.text.toString()
    });
    Calls()
        .call(body, context, Config.ADD_NEW_CONTACTS)
        .then((value) async {
      var data = BaseResponse.fromJson(value);
 if(data.statusCode!=null && data.statusCode==Strings.success_code)
   {
     setState(() {
       isLoading=false;
     });
     Navigator.pop(context);
     callBack!();
   }
 else
   {
     setState(() {
       isLoading=false;
     });
     ToastBuilder().showToast(
         data.message??"", context, HexColor(AppColors.information));
   }

    })
        .catchError((onError) {
      Navigator.pop(context);
      callBack!();
      setState(() {
        isLoading=false;
      });
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getCounrtyCode() async {
    final body = jsonEncode({
      "country": "IN",
    });
    Calls()
        .calWithoutToken(body, context, Config.COUNTRY_CODES)
        .then((value) async {
      if (value != null) {
        var data = CountryCodeResponse.fromJson(value);
        countryCodeList = data.rows;
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
}
