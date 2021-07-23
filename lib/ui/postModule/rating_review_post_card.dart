import 'dart:convert';
import 'dart:ui';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/post/ratingcreatemodels.dart';
import 'package:oho_works_app/models/review_rating_comment/rating_summary.dart';
import 'package:oho_works_app/profile_module/pages/raters_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRatingCard extends StatefulWidget {
  final int? postId;
  final String? ownerType;
  final int? ownerId;
  PostRatingCard({Key? key, required this.postId, required this.ownerId ,required this.ownerType}) : super(key: key);
  @override
  PostRatingCardState createState() => PostRatingCardState(
      postId: postId,
  );
}
class PostRatingCardState extends State<PostRatingCard>{
  int? postId;
  late TextStyleElements styleElements;
  RatingSummaryItem data = RatingSummaryItem();
  SharedPreferences? prefs;
bool isLoading=true;
  PostRatingCardState({ required this.postId});


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getRatingsData();
    });
  }

  void getRatingsData() async{
    prefs ??= await SharedPreferences.getInstance();
    CreateRatingPayload payload = CreateRatingPayload();
    payload.ratingContextId = widget.ownerId;
    payload.ratingContextType = widget.ownerType;
    payload.ratingSubjectId = postId;
    payload.ratingSubjectType='post';

    Calls().call(jsonEncode(payload), context, Config.RATING_SUMMARY).then((value) {
      var res  = RatingSummaryResponse.fromJson(value);
      setState(() {
        isLoading=false;
      });
      if(res.statusCode== Strings.success_code) {
        if(res.rows!.length>0) {
          setState(() {
            data = res.rows![0];
          });
        }
      }
    });
  }

  void updateData() {
    Future.delayed(Duration(milliseconds: 1500),(){ getRatingsData();});
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Opacity(
      opacity:isLoading? 0.0:1.0,
      child: TricycleListCard(
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
                            "Ratings",
                            style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    flex: 3,
                  ),

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
                                  data.averageRating!=null?  double.parse(data.averageRating!).toStringAsFixed(1).toString():"0.0",
                                  style: TextStyle(
                                    fontFamily: 'Source Sans Pro',
                                    fontSize: ScreenUtil()
                                        .setSp(24),
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
                                  child: Text(data.totalRatedUsers!=null?"${data.totalRatedUsers} ratings":"0 ratings",
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
                                          percent: (data.rating05!=null && data.rating05!=0)?calculatePercentage(data.rating05!.toDouble()):0.1,
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
                                          percent: (data.rating04!=null && data.rating04!=0)?calculatePercentage(data.rating04!.toDouble()):0.1,
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
                                          percent: (data.rating03!=null && data.rating03!=0)?calculatePercentage(data.rating03!.toDouble()):0.1,
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
                                          percent: (data.rating02!=null && data.rating02!=0)?calculatePercentage(data.rating02!.toDouble()):0.1,
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
                                          percent: (data.rating01!=null && data.rating01!=0)?(calculatePercentage(data.rating01!.toDouble())):0.1,
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
                padding: const EdgeInsets.only(left:16.0,right: 16.0,bottom: 12,top:12),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RatersPage(
                            id: postId,
                            name:prefs!.getString(Strings.userName),
                            ratingId: 0,
                            imageUrl:"",
                            ratingType: 'post',
                            data: null,
                            ownerType: widget.ownerType,
                            ownerId: widget.ownerId,
                            callback:(){}
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

              // Visibility(
              //
              //     child: GestureDetector(
              //       behavior: HitTestBehavior.translucent,
              //       onTap: (){
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => AddReviewPage(id: userId,name:userName,imageUrl:imageUrl??"",ratingType: type,data: data,callback:callback)));
              //
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Container(
              //           margin: const EdgeInsets.only(top: 16,),
              //           child: Column(
              //             children: <Widget>[
              //               Align(
              //                 alignment: Alignment.center,
              //                 child: Text(
              //                   AppLocalizations.of(context).translate('rate'),
              //                   style: TextStyle(
              //                     fontFamily: 'Source Sans Pro',
              //                     fontSize: ScreenUtil()
              //                         .setSp(16, ),
              //                     color: HexColor(AppColors.appColorBlack85),
              //                     height: 1.4285714285714286,
              //                   ),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //               RatingBar.builder(
              //                 initialRating:data.givenRating.toDouble()??0.0,
              //                 minRating: 0,
              //                 ignoreGestures: true,
              //                 direction: Axis.horizontal,
              //                 allowHalfRating: false,
              //                 itemCount: 5,
              //                 itemSize: 36.0,
              //                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //                 itemBuilder: (context, _) => Icon(
              //                   Icons.star_border,
              //                   color: HexColor(AppColors.appMainColor),
              //                 ),
              //                 onRatingUpdate: (rating) {
              //
              //
              //                 },
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: <Widget>[
              //                   Container(
              //                     margin:
              //                     const EdgeInsets.only(left: 60, right: 20),
              //                     child: Text(
              //                       AppLocalizations.of(context).translate("poor"),
              //                       style:
              //                       styleElements.captionThemeScalable(context),
              //                     ),
              //                   ),
              //                   Container(
              //                     margin:
              //                     const EdgeInsets.only(left: 20, right: 60),
              //                     child: Text(
              //                       AppLocalizations.of(context)
              //                           .translate("excellent"),
              //                       style:
              //                       styleElements.captionThemeScalable(context),
              //                     ),
              //                   )
              //                 ],
              //               )
              //
              //             ],
              //           ),
              //         ),
              //       ),
              //     )),
            ],
          )),
    );
  }

  double calculatePercentage(double val) {
    return val/data.totalRatedUsers!.toDouble();
  }




}
