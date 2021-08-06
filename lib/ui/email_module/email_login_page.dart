import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/button_filled.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/login_signup_module/verificationOtp.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/email_module/email_login.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'email_home_page.dart';

class EmailLoginPage extends StatefulWidget {
  final bool onlyLogin;

  EmailLoginPage({this.onlyLogin = false});

  @override
  _EmailLoginPage createState() => _EmailLoginPage();
}

class _EmailLoginPage extends State<EmailLoginPage> with CommonMixins {
  TextStyleElements? styleElements;
  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> formKeyRecover = GlobalKey();
  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<appProgressButtonState> progressKey = GlobalKey();
  bool isRecoverPassword = false;
  bool isResetPassword = false;
  bool isCalling = false;
  bool _validate2 = false;
  bool _validate = false;
  String? recoverEmail;
  String? resetPassword;
  String? confirmResetPassword;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
      onWillPop: onpopPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: appAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context)!
                  .translate('email_login'), onBackButtonPress: () {
                if (isRecoverPassword || isResetPassword) {
                  setState(() {
                    isRecoverPassword = false;
                    isResetPassword = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              }),
          body: isRecoverPassword
              ? getRecoverPasswordUi():
              isResetPassword?
                  getResetPasswordUi()
              : Container(
            child: appListCard(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Image.asset(
                        'assets/appimages/email.png',
                        width: 240,
                        height: 240,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: HexColor(
                                    AppColors.appColorBackground),
                              ),
                              child: Row(
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 4),
                                        child: Icon(
                                          Icons.email_outlined,
                                          size: 30,
                                          color: HexColor(
                                              AppColors.appColorBlack65),
                                        )),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: validateTextField,
                                      onSaved: (value) {
                                        email = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Email id",
                                          contentPadding: EdgeInsets.only(
                                              left: 12,
                                              top: 16,
                                              bottom: 8),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          labelText:
                                          "Enter the email ID"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: HexColor(
                                    AppColors.appColorBackground),
                              ),
                              child: Row(
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 4),
                                        child: Icon(
                                          Icons.lock_outline_rounded,
                                          size: 30,
                                          color: HexColor(
                                              AppColors.appColorBlack65),
                                        )),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: validateTextField,
                                      obscureText: true,
                                      onSaved: (value) {
                                        password = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "password",
                                          contentPadding: EdgeInsets.only(
                                              left: 12,
                                              top: 16,
                                              bottom: 8),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          labelText: "Enter password"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRecoverPassword = true;
                                });
                              },
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 16, right: 32),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("forgot_pass"),
                                    style: styleElements!
                                        .subtitle2ThemeScalable(context)
                                        .copyWith(
                                        color: HexColor(
                                            AppColors.appMainColor)),
                                  ))),
                          SizedBox(
                            height: 80,
                          ),
                          appProgressButton(
                            key: progressKey,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                login();
                              }
                            },
                            padding: EdgeInsets.only(
                                left: 36, right: 36, top: 12, bottom: 12),
                            child: Text(
                              "Access Email",
                              style: styleElements!
                                  .subtitle1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(
                                      AppColors.appColorWhite),
                                  fontWeight: FontWeight.w500),
                            ),
                            color: HexColor(AppColors.appMainColor),
                            shape: StadiumBorder(),
                            splashColor: HexColor(AppColors.appMainColor),
                            progressColor:
                            HexColor(AppColors.appColorWhite),
                          ),
                          SizedBox(
                            height: 56,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    progressKey.currentState!.show();
    EmailLoginRequest payload = EmailLoginRequest();
    payload.username = email!;
    payload.password = password!;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_LOGIN)
        .then((value) {
      progressKey.currentState!.hide();
      var res = EmailLoginResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        prefs.setString(Strings.mailUsername, email!);
        prefs.setString(Strings.mailToken, res.rows!);
        if (widget.onlyLogin) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, true);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return EmailHomePage();
              }));
        }
      }else {
        ToastBuilder().showToast(
            res.message!,
            context,
            HexColor(AppColors.information));
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate('some_error_occurred'),
          context,
          HexColor(AppColors.information));
      progressKey.currentState!.hide();
      print(onError.toString());
    });
  }

  Widget getRecoverPasswordUi() {
    final emailField = Form(
      key: formKey,
      child: TextFormField(
        style: styleElements!
            .subtitle1ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack65)),
        keyboardType: TextInputType.emailAddress,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
        ],
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
            hintText: AppLocalizations.of(context)!.translate('email'),
            hintStyle: styleElements!
                .bodyText2ThemeScalable(context)
                .copyWith(color: HexColor(AppColors.appColorBlack35)),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(Icons.email,
                    color: HexColor(AppColors.appColorGrey500))),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String? value) {
          recoverEmail = value;
        },
      ),
    );
    return appListCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: <Widget>[
        Container(
          margin: EdgeInsets.only(top:24,bottom: 24),
            child: Image.asset("assets/appimages/email.png",
                height: 120, width: 120)),
        Container(
          margin: EdgeInsets.only(left:24,right: 24),
          child: Text(
            AppLocalizations.of(context)!.translate("recover_password"),
            textAlign: TextAlign.center,
            style: styleElements!.headline5ThemeScalable(context),
          ),
        ),
            Container(
              margin: EdgeInsets.only(left:24,right: 24,top:16),
              child: Text(
                AppLocalizations.of(context)!.translate("email_recover_password"),
                textAlign: TextAlign.center,
                style: styleElements!.bodyText2ThemeScalable(context),
              ),
            ),
        Container(
          margin: EdgeInsets.only(top:24,bottom: 24,left: 16,right: 16),
          // margin: EdgeInsets.fromWindowPadding(padding, 50%),
          child: emailField,
        ),
        !isCalling
            ? Container(
          margin: EdgeInsets.only(top:24,bottom: 24),
              child: LargeButton(
                name: AppLocalizations.of(context)!.translate("submit"),
                offsetX: 109.66,
                offsetY: 12.93,
                callback: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    recoverPassword();
                  }
                },
              ),
            )
            : Container(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator()),
            ),
      ]),
    );
  }

  void recoverPassword() async {
    var data = jsonEncode({"email_id": recoverEmail});
    Calls().call(data, context, Config.EMAIL_FORGOT_PASSWORD).then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return Verification(
                isRecoverPassword: true,
                email: recoverEmail!,
                isEmailRecovery: true,
                mobileNo: '',
              );
            })).then((value) {
              if(value!=null && value){
                setState(() {
                  isRecoverPassword = false;
                  isResetPassword = true;
                });
              }
        });
      }else{
        ToastBuilder().showToast(
            res.message!,
            context,
            HexColor(AppColors.information));
      }
    });
  }

  Future<bool> onpopPressed() async {
    if (isRecoverPassword || isResetPassword) {
      setState(() {
        isRecoverPassword = false;
        isResetPassword = false;
      });
      return false;
    } else {
      return true;
    }
  }

  Widget getResetPasswordUi(){
    final emailField = TextFormField(
      obscureText: true,
      style: styleElements!.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      validator: EditProfileMixins().validatePassword,
      onSaved: (String? value) {
        resetPassword = value;
      },
      onChanged: (v){

        setState(() {
          v.trim().length<8?_validate=false:_validate=true; return null;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('enter_new_pass'),
          errorText:!_validate?AppLocalizations.of(context)!.translate("min_character"):null,
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500),size: 20)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final confirmPassword = TextFormField(
      obscureText: true,
      style: styleElements!.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      validator: EditProfileMixins().validatePassword,
      onSaved: (String? value) {
        confirmResetPassword = value;
      },
      onChanged: (v){
        setState(() {
          v.trim().length<8?_validate2=false:_validate2=true; return null;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('password'),
          errorText:!_validate2?AppLocalizations.of(context)!.translate("min_character"):null,
          hintStyle: styleElements!.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.lock_outline, color: HexColor(AppColors.appColorGrey500),size: 20)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    return Builder(builder: (BuildContext context) {
      return Form(
        key: formKey,
        child:  Stack(children: <Widget>[

          Container(
              alignment: Alignment(0, -0.6),
              child: Image.asset("assets/appimages/email.png",
                  height: 72, width: 72)),
          Container(
            alignment: Alignment(0, -0.4),
            child: Text(
              AppLocalizations.of(context)!.translate("reset_password"),
              style:styleElements!.headline5ThemeScalable(context),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.1),
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
              // margin: EdgeInsets.fromWindowPadding(padding, 50%),
              child: emailField,
            ),
          ),
          Align(
            alignment: Alignment(0, 0.1),
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width / 7),
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
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    if (resetPassword == confirmResetPassword) {
                      newPasswordSet();
                    }else{
                      ToastBuilder().showSnackBar(
                          AppLocalizations.of(context)!.translate("password_not_matching"),
                          context,HexColor(AppColors.information));
                    }
                  }
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
        ]),
      );
    });

  }

  void newPasswordSet() async{
    var data = jsonEncode(
        {"username":recoverEmail, "password": resetPassword});
    Calls().call(data, context, Config.EMAIL_PASSWORD_UPDATE,isMailToken: true).then((value) {
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("updated_successfully"),
            context,
            HexColor(AppColors.information));
        setState(() {
          isResetPassword = false;
          isRecoverPassword = false;
        });
      }
    }).catchError((onError){
      print(onError);
    });
  }
}
