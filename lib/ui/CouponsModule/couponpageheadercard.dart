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

class CouponPageHeaderCard extends StatefulWidget {
  CouponPageHeaderCard({Key? key}) : super(key: key);

  @override
  CouponPageHeaderCardState createState() => CouponPageHeaderCardState();
}

class CouponPageHeaderCardState extends State<CouponPageHeaderCard> {
  late SharedPreferences prefs;
  String? currentbalance = "0";
  String? lifetimeearned = "0";
  String? lifetimeburn = "0";

  String? currentbalanceCash = "0";
  String? lifetimeearnedCash = "0";
  String? lifetimeburnCash = "0";
  bool isCashSelected = false;
  late TextStyleElements styleElements;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchData());
  }

  fetchData() async {
    prefs = await SharedPreferences.getInstance();
    CouponListRequest payload = CouponListRequest();
    payload.personId = prefs.getInt(Strings.userId).toString();
    payload.ledgerType="coins";

    var data = jsonEncode(payload);
    Calls().call(data, context, Config.COUPONBALANCE).then((value) {
      var res = CouponHeaderResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          currentbalance = res.rows!.currentBalance;
          lifetimeburn = res.rows!.lifetimeBurn;
          lifetimeearned = res.rows!.lifetimeEarned;
        });
      }
      fetchDataCash();
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
        setState(() {
          currentbalanceCash = res.rows!.currentBalance;
          lifetimeburnCash = res.rows!.lifetimeBurn;
          lifetimeearnedCash = res.rows!.lifetimeEarned;
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isCashSelected = false;
                  });
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                  child: Text(AppLocalizations.of(context)!.translate('tricycle_coins'),
                    style: styleElements.captionThemeScalable(context).copyWith(
                        color: !isCashSelected
                            ? HexColor(AppColors.appMainColor)
                            : HexColor(AppColors.appColorBlack)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCashSelected = true;
                  });
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                  child: Text(AppLocalizations.of(context)!.translate('cash_rewards'),
                    style: styleElements.captionThemeScalable(context).copyWith(
                        color: isCashSelected
                            ? HexColor(AppColors.appMainColor)
                            : HexColor(AppColors.appColorBlack)),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('current_balance'),
                      style: styleElements.bodyText2ThemeScalable(context),
                    ),

                    RichText(
                      text: TextSpan(children: [
                        !isCashSelected? WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1.0),
                            child:  SizedBox(
                              height: 20,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Image(
                                    image: AssetImage('assets/appimages/coins.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ):  TextSpan(
                            text: "₹",
                            style: styleElements.subtitle1ThemeScalable(context)),
                        TextSpan(
                            text:      Utility().getCompatNumber(
                                double.parse(isCashSelected?currentbalanceCash??"0.0":currentbalance ??= "0.0")),
                            style: styleElements.subtitle1ThemeScalable(context)),
                      ]),
                    )

                  ],
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('lifetime_earned'),
                      style: styleElements.bodyText2ThemeScalable(context),
                    ),

                    RichText(
                      text: TextSpan(children: [
                        !isCashSelected? WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1.0),
                            child:  SizedBox(
                              height: 20,
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Image(
                                    image: AssetImage('assets/appimages/coins.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ):  TextSpan(
                            text: "₹",
                            style: styleElements.subtitle1ThemeScalable(context)),
                        TextSpan(
                            text:   Utility().getCompatNumber(
                                double.parse(isCashSelected?lifetimeearnedCash??"0.0":lifetimeearned ??= "0.0")) ,
                            style: styleElements.subtitle1ThemeScalable(context)),
                      ]),
                    )


                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('lifetime_burn'),
                      style: styleElements.bodyText2ThemeScalable(context),
                    ),

                    RichText(
                      text: TextSpan(children: [
                      !isCashSelected? WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.0),
                          child:  SizedBox(
                            height: 20,
                            width: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                child: Image(
                                  image: AssetImage('assets/appimages/coins.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ):  TextSpan(
                            text: "₹",
                            style: styleElements.subtitle1ThemeScalable(context)),
                        TextSpan(
                            text:    Utility().getCompatNumber(
                                double.parse(isCashSelected?lifetimeburnCash??"0.0":lifetimeburn ??= "0.0")),
                            style: styleElements.subtitle1ThemeScalable(context)),
                      ]),
                    )

                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
