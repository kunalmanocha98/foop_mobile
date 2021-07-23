import 'dart:ui';

import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/raters_page.dart';
import 'package:oho_works_app/ui/addreviewPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class RatingAndReviewCard extends StatelessWidget {
  final CommonCardData data;
  Persondata? persondata;
  Null Function()? callback;
  BuildContext? context;
  late TextStyleElements styleElements;
  int? userId;
  int? ownerId;
  String? type;
  String? imageUrl;
  String? userName;
  bool showRating;


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

  RatingAndReviewCard({Key? key, required this.data, this.showRating = true,this.persondata, this.callback,this.type,this.ownerId,this.userId,this.userName,this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return TricycleListCard(
        child: Column(
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
                          data.title??"",
                          style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),
                /*  Flexible(
                     child: Align(
                       alignment: Alignment.topRight,
                       child: _simplePopup(),
                     ),
                     flex: 1,),*/
              ],
            ),

            Stack(
              children: <Widget>[
                Container(

                  margin: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              child: Text(
                                data.textOne!=null?  double.parse(data.textOne!).toStringAsFixed(1).toString():"",
                                style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  fontSize: ScreenUtil()
                                      .setSp(24, ),
                                  color: HexColor(AppColors.appColorBlack85),
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left:8,right: 8),
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 24),
                              child: RatingBar(
                                ignoreGestures: true,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 15.0,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                ratingWidget: RatingWidget(
                                  empty: Icon(
                                    Icons.star_outline,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                  half:  Icon(
                                    Icons.star_half_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                  full:  Icon(
                                    Icons.star_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                child: Text(
                                  data.textThree??"",
                                  style: TextStyle(
                                    fontFamily: 'Source Sans Pro',
                                    fontSize: ScreenUtil()
                                        .setSp(16, ),
                                    color: HexColor(AppColors.appColorBlack35),
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:  Column(
                            children: <Widget>[

                              Container(
                                margin: const EdgeInsets.only( right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(left: 8, top: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('number_5'),
                                          style: TextStyle(
                                            fontFamily: 'Source Sans Pro',
                                            fontSize: ScreenUtil()
                                                .setSp(12, ),
                                            color: HexColor(AppColors.appColorBlack65),
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 8.0),
                                      child:  LinearPercentIndicator(
                                        width: 200,
                                        animation: true,
                                        lineHeight:10.0,
                                        animationDuration: 2000,
                                        percent: data.ratingValueFiveStar!=0?(data.ratingValueFiveStar!.toDouble() /10):0.1,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: HexColor(AppColors.appColorGreen),
                                        backgroundColor: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only( right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(left: 8, top: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('number_4'),
                                          style: TextStyle(
                                            fontFamily: 'Source Sans Pro',
                                            fontSize: ScreenUtil()
                                                .setSp(12, ),
                                            color: HexColor(AppColors.appColorBlack65),
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 8.0),
                                      child:  LinearPercentIndicator(
                                        width: 200,
                                        animation: true,
                                        lineHeight: 10.0,
                                        animationDuration: 2000,
                                        percent: data.ratingValueFourStar!=0?(data.ratingValueFourStar!.toDouble() /10):0.1,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: HexColor(AppColors.appColorLightGreen),
                                        backgroundColor: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only( right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(left: 8, top: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('number_3'),
                                          style: TextStyle(
                                            fontFamily: 'Source Sans Pro',
                                            fontSize: ScreenUtil()
                                                .setSp(12, ),
                                            color: HexColor(AppColors.appColorBlack65),
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 8.0),
                                      child:  LinearPercentIndicator(
                                        width: 200,
                                        animation: true,
                                        lineHeight: 10.0,
                                        animationDuration: 2000,
                                        percent: data.ratingValueThreeStar!=0?(data.ratingValueThreeStar!.toDouble() /10):0.1,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: HexColor(AppColors.appColorYellow),
                                        backgroundColor: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only( right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(left: 8, top: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('number_2'),
                                          style: TextStyle(
                                            fontFamily: 'Source Sans Pro',
                                            fontSize: ScreenUtil()
                                                .setSp(12, ),
                                            color: HexColor(AppColors.appColorBlack65),
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 8.0),
                                      child:  LinearPercentIndicator(
                                        width: 200,
                                        animation: true,
                                        lineHeight: 10.0,
                                        animationDuration: 2000,
                                        percent: data.ratingValueTwoStar!=0?(data.ratingValueTwoStar!.toDouble() /10):0.1,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: HexColor(AppColors.appColorOrange),
                                        backgroundColor: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only( right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(left: 8, top: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('number_1'),
                                          style: TextStyle(
                                            fontFamily: 'Source Sans Pro',
                                            fontSize: ScreenUtil()
                                                .setSp(12, ),
                                            color: HexColor(AppColors.appColorBlack65),
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 8.0),
                                      child:  LinearPercentIndicator(
                                        width: 200,
                                        animation: true,
                                        lineHeight: 10.0,
                                        animationDuration: 2000,
                                        percent: data.ratingValueOneStar!=0?(data.ratingValueOneStar!.toDouble() /10):0.1,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: HexColor(AppColors.appMainColor),
                                        backgroundColor: HexColor(AppColors.appColorTransparent),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),

                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16.0,bottom: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RatersPage(
                          id: userId,
                          name:userName,
                          ratingId: 0,
                          imageUrl:imageUrl,
                          ratingType: type == "institution" ? "institution" : "person",
                          ownerType: type == "institution" ? "institution" : "person" ,
                          ownerId: userId,
                          data: data,callback:callback,
                      )));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    AppLocalizations.of(context)!.translate('see_people'),
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: ScreenUtil()
                          .setSp(12, ),
                      color: HexColor(AppColors.appMainColor),
                      height: 1.4285714285714286,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: showRating,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddReviewPage(id: userId,name:userName,imageUrl:imageUrl??"",ratingType: type,data: data,callback:callback)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0,),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.translate('rate'),
                              style: TextStyle(
                                fontFamily: 'Source Sans Pro',
                                fontSize: ScreenUtil()
                                    .setSp(16, ),
                                color: HexColor(AppColors.appColorBlack85),
                                height: 1.4285714285714286,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating:data.givenRating!.toDouble(),
                            minRating: 0,
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 36.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_border,
                              color: HexColor(AppColors.appMainColor),
                            ),
                            onRatingUpdate: (rating) {


                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin:
                                const EdgeInsets.only(left: 60, right: 20),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("poor"),
                                  style:
                                  styleElements.captionThemeScalable(context),
                                ),
                              ),
                              Container(
                                margin:
                                const EdgeInsets.only(left: 20, right: 60),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("excellent"),
                                  style: styleElements.captionThemeScalable(context),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
