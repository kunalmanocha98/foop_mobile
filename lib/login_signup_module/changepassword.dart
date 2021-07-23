import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => new _ChangePassword();
}

// ignore: must_be_immutable
class _ChangePassword extends  State<ChangePassword> {
  final passwordTextController = TextEditingController();
  final confirmpassController = TextEditingController();
  late BuildContext context;
  late TextStyleElements styleElements;
  bool _validate = false;
  bool _validate2 = false;
  GlobalKey<TricycleProgressButtonState> progressButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    this.context = context;

    styleElements = TextStyleElements(context);
    var screenWidth = MediaQuery.of(context).size.width;
    final passwordField = TextField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      obscureText: true,
      controller: passwordTextController,
      onChanged: (v){

        setState(() {
          v.trim().length<8?_validate=false:_validate=true; return null;
        });
      },
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('password'),
          errorText:!_validate?AppLocalizations.of(context)!.translate("min_character"):null,
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.lock_outline_rounded, color: HexColor(AppColors.appColorGrey500))),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );
    final confirmpasswordField = TextField(
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      obscureText: true,
      controller: confirmpassController,
      onChanged: (v){

        setState(() {
          v.trim().length<8?_validate2=false:_validate2=true; return null;
        });
      },
      scrollPadding: const EdgeInsets.all(20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context)!.translate('confirm_password'),
          errorText:!_validate2?AppLocalizations.of(context)!.translate("min_character"):null,
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
          prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(Icons.lock_outline_rounded, color: HexColor(AppColors.appColorGrey500))),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0,
            ),
          )),
    );

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppColors.appColorBackground),
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: ''
              // AppLocalizations.of(context).translate("change_password")
              ,
              onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 72),
                    alignment: Alignment.center,
                    child: Image.asset("assets/appimages/logo.png",
                        height: 72, width: 72)),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.translate("change_password"),
                    style: styleElements
                        .headline6ThemeScalable(context)
                        .copyWith(fontSize: 32),
                  ),
                ),
                Align(
                  child: Container(
                    alignment: Alignment.center,
                    margin: new EdgeInsets.only(
                        left: screenWidth / 7, right: screenWidth / 7, top: 72),
                    // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                    child: passwordField,
                  ),
                ),
                Align(
                  child: Container(
                    alignment: Alignment.center,
                    margin: new EdgeInsets.only(
                        left: screenWidth / 7, right: screenWidth / 7, top: 16),
                    // margin: EdgeInsets.fromWindowPadding(padding, 50%),
                    child: confirmpasswordField,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 36, bottom: 36),
                    child: TricycleProgressButton(
                      key: progressButtonKey,
                      progressColor: HexColor(AppColors.appColorWhite),
                      progressSize: 20,
                      child: Text(AppLocalizations.of(context)!.translate("submit"),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorWhite)
                      ),),
                      onPressed: () {
                        checkValidations();
                      },
                      padding: EdgeInsets.only(left: 56,right: 56,top: 16,bottom: 16),
                    ),
                  ),
                ),
              ]))),
    );
  }

  void checkValidations() {
    String pass = passwordTextController.text.toString();
    String confirmPass = confirmpassController.text.toString();
    if (pass.length >= 8) {
      if (pass == confirmPass) {
        changepassword(pass);
      } else {
        ToastBuilder().showToast("passwords don't match", context,HexColor(AppColors.information));
      }
    } else {
      ToastBuilder().showToast("password length is too short", context,HexColor(AppColors.information));
    }
  }

  void changepassword(String pass) async {
   progressButtonKey.currentState!.show();
    final body = jsonEncode({
      "password": pass,
    });
    Calls().call(body, context, Config.CHANGEPASSWORD).then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Updated Successfully", context,HexColor(AppColors.information));
          Navigator.pop(context);
        }
      }
    }).catchError((onError) async {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));
    });
  }
}
