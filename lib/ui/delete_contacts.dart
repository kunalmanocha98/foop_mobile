import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/country_code_response.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable

class DeleteContacts extends StatefulWidget {
  final Null Function()? callBack;
  final Null Function()? callBackCancel;
  final bool? isEmail;
  final int? id;
  final String? contactDetail;
  const DeleteContacts(
      {Key? key, this.callBack, this.callBackCancel, this.isEmail,this.id,this.contactDetail})
      : super(key: key);

  @override
  _DeleteContacts createState() =>
      new _DeleteContacts(callBack, callBackCancel, isEmail,id,contactDetail);
}

class _DeleteContacts extends State<DeleteContacts> {
  Null Function()? callBack;
  Null Function()? callBackCancel;
 late  BuildContext context;
  late TextStyleElements tsE;
  bool? isEmail;
  String? contactDetail;
  int? id;
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordTextController = TextEditingController();
  List<dynamic>? countryCodeList = [];
  String? cCode;

  _DeleteContacts(this.callBack, this.callBackCancel, this.isEmail,this.id,this.contactDetail);

  @override
  // ignore: must_call_super
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    tsE = TextStyleElements(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding:
                EdgeInsets.only(top: 16, bottom: 30, left: 16, right: 16),
                child: Text(
                  isEmail!
                      ? AppLocalizations.of(context)!.translate('remove_email')
                      : AppLocalizations.of(context)!.translate('remove_mobile'),
                  style: tsE.headline6ThemeScalable(context),
                )),
          ),
          Padding(
              padding:
              EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 16),
              child: Text(
                AppLocalizations.of(context)!.translate('delete_sure'),
                style: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
              )),
          Padding(
              padding:
              EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 16),
              child: Text(
                contactDetail??"",
                style: tsE.subtitle2ThemeScalable(context),
              )),
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
                TricycleTextButton(
                  onPressed: () {
                    deleteContact();
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    AppLocalizations.of(context)!.translate('submit'),
                    style: tsE
                        .bodyText2ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void deleteContact() async {
    final body = jsonEncode({"id":id});
    Calls()
        .call(body, context, Config.DELETE_CONTACT)
        .then((value) async {

      Navigator.pop(context);
      callBack!();
    })
        .catchError((onError) {
      Navigator.pop(context);
      callBack!();
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
