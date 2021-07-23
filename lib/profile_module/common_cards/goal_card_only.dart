import 'dart:ui';

import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/goal_detail_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class GoalsCardOnly extends StatelessWidget {
  final CommonCardData data;

  double _sigmaX = 5.01; // from 0-10
  double _sigmaY = 5.01; // from 0-10
  double _opacity = 0.0; // from 0-1.0

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
  late TextStyleElements styleElements;
  GoalsCardOnly({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalsDetailPage(),
                ));
          },
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin:  EdgeInsets.only(
                              left: 16.w, right: 8.w, top: 24.0.h),
                          child: Text(
                            data.textTwo ??= "",
                            style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 8, top: 6.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                data.textThree ??= "",
                                style: styleElements.bodyText1ThemeScalable(context),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            RatingBar(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 15.0,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
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
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 12, right: 8, top: 6.0),
                        child: LinearPercentIndicator(
                          width: 100,
                          animation: true,
                          lineHeight: 5.0,
                          animationDuration: 2000,
                          percent: 0.8,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: HexColor(AppColors.appColorGreen),
                          backgroundColor: HexColor(AppColors.appColorTransparent),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 8, top: 6.0, bottom: 16),
                        child: Row(
                          children: <Widget>[
                            OverlappedImages(null),
                            Text(
                              data.textFour ??= "",
                              style: styleElements.bodyText1ThemeScalable(context),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 16, top: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              data.textFive ??= "",
                              style: styleElements.bodyText1ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(data.urlOne ??= ""),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              data.textSix ??= "",
                              style:styleElements.bodyText1ThemeScalable(context),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: data.isBlur!,
                child: ClipRect(
                  child: Container(
                    width: displayWidth(context),
                    height: 150,
                    decoration: BoxDecoration(
                      color: HexColor(AppColors.appColorTransparent),
                      /*    image: DecorationImage(
                  image: CachedNetworkImageProvider(data.urlOne),
                  fit: BoxFit.cover,
                ),*/
                    ),
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        color: HexColor(AppColors.appColorWhite).withOpacity(_opacity),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
