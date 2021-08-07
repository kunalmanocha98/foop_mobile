import 'dart:convert';

import 'package:oho_works_app/api_calls/recover_password.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'new_password.dart';

// ignore: must_be_immutable
class OTPRecoverPasswords extends StatelessWidget {
  final userNameTextController = TextEditingController();

  BuildContext? context;

  final String email;
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  OTPRecoverPasswords({Key? key, required this.email}) : super(key: key);

  void recoverPassword() async {
    if (userNameTextController.text.trim().isNotEmpty) {
      progressButtonKey.currentState!.show();
      RegisterUserPayload loginPayLoad = RegisterUserPayload();
      loginPayLoad.email = email;
      loginPayLoad.token = int.parse(userNameTextController.text);

      RecoverPasswordApis()
          .recoverPasswordOtp(context, jsonEncode(loginPayLoad.toJson()))
          .then((value) async {
        progressButtonKey.currentState!.hide();
        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code &&
              data.message == Strings.success) {
            Navigator.push(
                context!,
                MaterialPageRoute(
                  builder: (context) => NewPassword(
                    email: email,
                  ),
                ));
          } else {
            if (data.message != null)
              ToastBuilder().showToast(data.message!, context,HexColor(AppColors.information));
            else
              ToastBuilder().showToast(
                  AppLocalizations.of(context!)!.translate("try_again"), context,HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        progressButtonKey.currentState!.hide();
        ToastBuilder().showToast(
            AppLocalizations.of(context!)!.translate("try_again"), context,HexColor(AppColors.information));
      });
    } else
      ToastBuilder().showToast(
          AppLocalizations.of(context!)!.translate("enter_otp"), context,HexColor(AppColors.information));
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    final emailField = TextField(
      obscureText: false,
      controller: userNameTextController,
      keyboardType: TextInputType.number,
      scrollPadding: const EdgeInsets.all(20.0),
      style:styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('enter_otp'),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorWhite),
          body: Stack(children: <Widget>[
            GestureDetector(
              onTap: () {
                print("Clicked on");
                Navigator.pushNamed(context, '/otp_recover_password');
              },
              child: Container(
                  alignment: Alignment(-0.9, -0.9),
                  child: Icon(Icons.arrow_back_ios)),
            ),
            Container(
                alignment: Alignment(0, -0.6),
                child: Image.asset("assets/appimages/logo.png",
                    height: 72, width: 72)),
            Container(
              alignment: Alignment(0, -0.4),
              child: Text(
                AppLocalizations.of(context)!.translate("enter_otp"),
                style: styleElements.headline4ThemeScalable(context),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: new EdgeInsets.symmetric(horizontal: screenWidth / 7),
                // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                child: emailField,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment(0, 0.4),
                child: appProgressButton(
                  key: progressButtonKey,
                child: Text(
                    AppLocalizations.of(context)!.translate("submit"),
                  style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorWhite)
                  ),
                ),
                onPressed: (){
                  recoverPassword();
                },),
              ),
            ),
          ])),
    );
  }
}
