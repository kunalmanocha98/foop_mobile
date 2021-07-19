import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AboutProfileCard extends StatelessWidget {
  final CommonCardData data;
  TextStyleElements styleElements;
  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  AboutProfileCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16,top:12,bottom:12),
                        child: Text(
                          data.title ?? "",
                          style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),

              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5,bottom: 20),
              child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 16, top: 20),
                                    child: Text(
                                      data.textOne ??= "",
                                      style: styleElements.subtitle2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 8, right: 16),
                                    child: Text(
                                      capitalize(data.textTwo??"---") ,
                                      style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child:
                          Container(
                              margin: const EdgeInsets.only(left: 30),
                              child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20, right: 20),
                                    child: Text(
                                      data.textThree ??= "",
                                      style: styleElements.subtitle2ThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 8, right: 20),
                                    child: Text(
                                      data.textFour ??= "",
                                      style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                            ],
                          )),
                        )
                      ],
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 16, top: 20),
                                      child: Text(
                                        data.textFive ??= "",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, top: 8, right: 16),
                                      child: Text(
                                        capitalize(data.textSix??"---") ,
                                        style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child:
                            Container(
                                margin: const EdgeInsets.only(left: 30),
                                child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 20, right: 20),
                                      child: Text(
                                        data.textSeven ??= "",
                                        style: styleElements.subtitle2ThemeScalable(context),
                                        textAlign: TextAlign.right,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 8, right: 20),
                                      child: Text(
                                        data.textEight ??= "",
                                        style: styleElements.bodyText1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            )),
                          )
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 16.h, right: 16.h, top: 20.0.h,bottom: 16.h),
                        child: Text(
                          data.textNine ??= "",
                          style: styleElements.subtitle2ThemeScalable(context),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],

                  )
             ,
            )
           ,

          ],
        ));
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
