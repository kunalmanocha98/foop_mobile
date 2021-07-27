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
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'verificationOtp.dart';

class RecoverPasswords extends StatefulWidget {
  @override
  _RecoverPasswords createState() => new _RecoverPasswords();
}

// ignore: must_be_immutable
class _RecoverPasswords extends State<RecoverPasswords> {
  final emailController = TextEditingController();

  late BuildContext context;
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  bool isCalling = false;

  void recoverPassword() async {
    if (emailController.text.trim().isNotEmpty &&
        EditProfileMixins().validateEmail(emailController.text) == null) {
      setState(() {
        isCalling = true;
      });
      RegisterUserPayload loginPayLoad = RegisterUserPayload();
      loginPayLoad.email = emailController.text;

      RecoverPasswordApis()
          .recoverPassword(jsonEncode(loginPayLoad.toJson()), context)
          .then((value) async {
        setState(() {
          isCalling = false;
        });
        if (value != null) {
          var data = CommonBasicResponse.fromJson(value);
          if (data.statusCode == Strings.success_code) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Verification(
                    email: emailController.text.toString(),
                    isRecoverPassword: true,
                    mobileNo: "",
                  ),
                ));
          } else {
            if (data.message != null)
              ToastBuilder().showToast(
                  data.message!, context, HexColor(AppColors.information));
            else
              ToastBuilder().showToast(
                  AppLocalizations.of(context)!.translate("try_again"),
                  context,
                  HexColor(AppColors.information));
          }
        }
      }).catchError((onError) async {
        setState(() {
          isCalling = false;
        });
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("try_again"),
            context,
            HexColor(AppColors.information));
      });
    } else
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("email_required"),
          context,
          HexColor(AppColors.information));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    final emailField = Form(
      child: TextFormField(
        style: styleElements.subtitle1ThemeScalable(context).copyWith(
            color: HexColor(AppColors.appColorBlack65)
        ),
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
        ],
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
            hintText: AppLocalizations.of(context)!.translate('email'),
            hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
            prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(Icons.email, color: HexColor(AppColors.appColorGrey500))),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.0,
              ),
            )),
        validator: EditProfileMixins().validateEmail,
        onSaved: (String? value) {},
      ),
    );
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            // resizeToAvoidBottomInset: false,

            appBar: appAppBar().getCustomAppBar(
              context,
              onBackButtonPress: () {
                Navigator.pop(context);
              },
              appBarTitle: "",
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: HexColor(AppColors.appColorBackground),
            body: Stack(children: <Widget>[
              Container(
                  alignment: Alignment(0, -0.6),
                  child: Image.asset("assets/appimages/logo.png",
                      height: 72, width: 72)),
              Container(
                alignment: Alignment(0, -0.4),
                child: Text(
                  AppLocalizations.of(context)!.translate("recover_password"),
                  style: styleElements.headline5ThemeScalable(context),
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
            !isCalling?  Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment(0, 0.4),
                  child: LargeButton(
                    name: AppLocalizations.of(context)!.translate("submit"),
                    offsetX: 109.66,
                    offsetY: 12.93,
                    callback: () {
                      recoverPassword();
                    },
                  ),
                ),
              ): Align(
              alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment(0, 0.4),
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),
            ),
              ),
            ])));
  }
}
