import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CouponHistoryItemCard extends StatelessWidget {
  String title;
  String dayOfMonth;
  String month;
  String rewardPoints;
  bool isDeduct;
  TextStyleElements styleElements;
String currencyCode;
  CouponHistoryItemCard(
      {Key key,
      this.title,
      this.dayOfMonth,
      this.month,
        this.currencyCode,
      this.rewardPoints,
      this.isDeduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                Align(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      dayOfMonth,
                      style: styleElements.bodyText2ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      month,
                      style: styleElements.captionThemeScalable(context),
                    ),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      title,
                      style:styleElements.bodyText2ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            flex: 6,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [


                    currencyCode!=null && currencyCode=="TCC" ? SizedBox(
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
                    ):    currencyCode!=null && currencyCode=="INR"? Text(
                      "₹",
                      style: styleElements.bodyText2ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDeduct ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorGreen)),
                    ):Text(
                      "",
                      style: styleElements.bodyText2ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDeduct ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorGreen)),
                    ),
                    Expanded(
                      child: Text(
                        rewardPoints,
                        style: styleElements.bodyText2ThemeScalable(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDeduct ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorGreen)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
