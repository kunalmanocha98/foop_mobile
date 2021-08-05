import 'dart:convert';

import 'package:oho_works_app/api_calls/recover_password.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/common_response.dart';
import 'package:oho_works_app/models/register_user_payload.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: must_be_immutable

class NewPassword extends StatefulWidget {
  final String email;
  NewPassword({Key? key, required this.email}) : super(key: key);
  @override
  _NewPassword createState() => new _NewPassword(email);
}

class _NewPassword extends State<NewPassword> {
  final userNameTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();
 late BuildContext context;
  bool isCalling = false;
  bool _validate = false;
  bool _validate2 = false;
  SharedPreferences? prefs;
  late String  email;
  late TextStyleElements styleElements;

  _NewPassword( this.email) ;

  void recoverPassword() async {
    if (userNameTextController.text.isNotEmpty && userNameTextController.text.length>7) {
      if (confirmPasswordController.text.isNotEmpty  && confirmPasswordController.text.length>7) {
        if (confirmPasswordController.text == userNameTextController.text) {
          setState(() {
            isCalling = true;
          });
          RegisterUserPayload loginPayLoad = RegisterUserPayload();
          loginPayLoad.email = email;
          loginPayLoad.password = userNameTextController.text;

          RecoverPasswordApis()
              .resetPassword(jsonEncode(loginPayLoad.toJson()), context)
              .then((value) async {
            setState(() {
              isCalling = false;
            });
            if (value != null) {
              var data = CommonBasicResponse.fromJson(value);
              if (data.statusCode == Strings.success_code) {
                ToastBuilder().showSnackBar(data.message!, sctx,HexColor(AppColors.success));
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (r) => false);
              } else {
                if (data.message != null)
                  ToastBuilder().showSnackBar(data.message!, sctx,HexColor(AppColors.information));
                else
                  ToastBuilder().showSnackBar(
                      AppLocalizations.of(context)!.translate("try_again"),
                      sctx,HexColor(AppColors.failure));
              }
            }
          }).catchError((onError) async {
            setState(() {
              isCalling = false;
            });
            ToastBuilder().showSnackBar(
                AppLocalizations.of(context)!.translate("try_again"), sctx,HexColor(AppColors.information));
          });
        } else
          ToastBuilder().showSnackBar(
              AppLocalizations.of(context)!.translate("password_not_matching"),
              sctx,HexColor(AppColors.information));
      } else
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("confirm_password"),
            sctx,HexColor(AppColors.information));
    } else
      {
        print (userNameTextController.text);
        ToastBuilder().showSnackBar(
            AppLocalizations.of(context)!.translate("enter_password"), sctx,HexColor(AppColors.information));
      }

  }
late BuildContext sctx;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    final emailField =
    Form(
        child: TextFormField(
          obscureText: true,
          style: styleElements.subtitle1ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack65)
          ),
          validator: EditProfileMixins().validatePassword,
          onSaved: (String? value) {},
          controller: userNameTextController,
          onChanged: (v){

            setState(() {
              v.trim().length<8?_validate=false:_validate=true; return null;
            });
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
              hintText: AppLocalizations.of(context)!.translate('enter_new_pass'),
              errorText:!_validate?AppLocalizations.of(context)!.translate("min_character"):null,
              hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0.h),
                  child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500),size: 20.h)),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.0.h,
                ),
              )),
        ));



    final confirmPassword =

    TextFormField(
      obscureText: true,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      validator: EditProfileMixins().validatePassword,
      onSaved: (String? value) {},
      onChanged: (v){

        setState(() {
          v.trim().length<8?_validate2=false:_validate2=true; return null;
        });
      },
      controller: confirmPasswordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('password'),
          errorText:!_validate2?AppLocalizations.of(context)!.translate("min_character"):null,
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0.h),
              child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500),size: 20.h)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );

    var screenWidth = MediaQuery.of(context).size.width;
    return
      SafeArea(child: Scaffold(
        // resizeToAvoidBottomInset: false,
          resizeToAvoidBottomInset: false,

          appBar: OhoAppBar().getCustomAppBar(context,
            onBackButtonPress: (){
              Navigator.pop(context);
            },
            appBarTitle: "",
          ),

          backgroundColor: HexColor(AppColors.appColorWhite),
          body:
          new Builder(builder: (BuildContext context) {
            this.sctx = context;
            return new Stack(children: <Widget>[

              Container(
                  alignment: Alignment(0, -0.6),
                  child: Image.asset("assets/appimages/logo.png",
                      height: 72, width: 72)),
              Container(
                alignment: Alignment(0, -0.4),
                child: Text(
                  AppLocalizations.of(context)!.translate("reset_password"),
                  style:styleElements.headline5ThemeScalable(context),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.1),
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal: screenWidth / 7),
                  // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                  child: emailField,
                ),
              ),
              Align(
                alignment: Alignment(0, 0.1),
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal: screenWidth / 7),
                  // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                  child: confirmPassword,
                ),
              ),
             !isCalling? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment(0, 0.4),
                  child: LargeButton(
                    name: AppLocalizations.of(context)!.translate("submit"),
                    offsetX: 109.66,
                    offsetY: 12.93,
                    callback: (){
                      recoverPassword();
                    },),
                ),
              ):Align(
            alignment: Alignment.bottomCenter,
            child: Container(
            alignment: Alignment(0, 0.4),
            child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator()),
            ),
            ),
            ]);
          })


          ));
  }
}
