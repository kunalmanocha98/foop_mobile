import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/currencyFormat.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/settingsUpdate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyFormatSelection extends StatefulWidget {
  @override
  _CurrencyFormatSelection createState() => _CurrencyFormatSelection();
}

class _CurrencyFormatSelection extends State<CurrencyFormatSelection> {
  List<CurrencyFormatItem>? currencyList = [];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getDateFormats());
  }

  getDateFormats() async {

    final body = jsonEncode({});
    Calls().call(body, context, Config.CURRENCYFORMATLIST).then((value) async {

      if (value != null) {

        var data = CurrencyFormat.fromJson(value);
        if (this.mounted) {
          setState(() {
            currencyList = data.rows;
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));

    });
  }
  late TextStyleElements styleElements;
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context)!.translate("choose_currency"),
              onBackButtonPress:(){
                Navigator.pop(context);
              }),
          body: Stack(
            children: [
              ListView.builder(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  itemCount: currencyList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          updateCurrencyFormat(currencyList![index]);
                        },
                        child: ListTile(
                          title: Text(
                            currencyList!.length > 0
                                ? currencyList![index].code!
                                : "",
                            style: styleElements.subtitle1ThemeScalable(context),
                          ),
                          subtitle: Text(
                            currencyList!.length > 0
                                ? currencyList![index].name!
                                : "",
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          )),
    );
  }

  void updateCurrencyFormat(CurrencyFormatItem currencyList) async {

    prefs = await SharedPreferences.getInstance();

    AccountSettingUpdateRequest model = AccountSettingUpdateRequest();
    model.personId = prefs.getInt("userId");
    model.id = 7;
    model.currencyId = currencyList.id;
    var body = jsonEncode(model);
    Calls().call(body, context, Config.UPDATEACCOUNTSETTING).then((value) async {

      if (value != null) {

        var data = DynamicResponse.fromJson(value);
        if (data != null && data.rows != null && data.statusCode == 'S10001') {
          ToastBuilder().showToast("Successfully Updated", context,HexColor(AppColors.success));
          Navigator.pop(context);
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.failure));

    });
  }
}
