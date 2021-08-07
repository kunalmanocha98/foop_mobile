import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/coupons/couponheader.dart';
import 'package:oho_works_app/models/coupons/couponlisting.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CouponsModule/couponsPage.dart';

class MenuUserBalanceCard extends StatefulWidget{
  @override
  MenuUserBalanceCardState createState() => MenuUserBalanceCardState();
}

class MenuUserBalanceCardState extends State<MenuUserBalanceCard>{
  late SharedPreferences prefs;
  String? currentBalance="0";
  String? currentBalanceCash="0";
  late TextStyleElements styleElements;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchData());
  }

  void fetchData() async{
    fetchDataCash();
    fetchDataCoins();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CouponsPage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/appimages/coins.png',width: 20,height: 20,),
                    Text(Utility().getCompatNumber(double.parse(currentBalance!)),style: styleElements.subtitle1ThemeScalable(context),),
                  ],
                ),
                Text(AppLocalizations.of(context)!.translate('app_coins'))
              ],
            ),
          ),
          Container(width: 0.5,
          height: 30,
          color: HexColor(AppColors.appColorBlack35),),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CouponsPage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.translate('ruppe_symbol')+Utility().getCompatNumber(double.parse(currentBalanceCash!)),style: styleElements.subtitle1ThemeScalable(context),),
                Text(AppLocalizations.of(context)!.translate('cash_rewards'))
              ],
            ),
          )
        ],
      ),
    );
  }



  fetchDataCoins() async {
    prefs = await SharedPreferences.getInstance();
    CouponListRequest payload = CouponListRequest();
    payload.personId = prefs.getInt(Strings.userId).toString();
    payload.ledgerType="coins";

    var data = jsonEncode(payload);
    Calls().call(data, context, Config.COUPONBALANCE).then((value) {
      var res = CouponHeaderResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        Future((){
          setState(() {
            currentBalance = res.rows!.currentBalance;
          });
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }
  fetchDataCash() async {
    prefs = await SharedPreferences.getInstance();
    CouponListRequest payload = CouponListRequest();
    payload.personId = prefs.getInt(Strings.userId).toString();
    payload.ledgerType="cash";
    var data = jsonEncode(payload);
    Calls().call(data, context, Config.COUPONBALANCE).then((value) {
      var res = CouponHeaderResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        Future((){
          setState(() {
            currentBalanceCash = res.rows!.currentBalance;
          });
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

}