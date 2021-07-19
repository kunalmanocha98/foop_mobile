import 'dart:ui';

import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/create_goal.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'overlaped_circular_images.dart';

// ignore: must_be_immutable
class GoalsAndObjectiveCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  TextStyleElements styleElements;
  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context).translate('add_goal')),
          ),
        ],
        onSelected: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateGoal(),
              ));
        },
        icon: Icon(
          Icons.more_horiz,
          size: 30,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );
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

  GoalsAndObjectiveCard({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    return Container(
        margin:  EdgeInsets.only(left: 8.0.h,right: 8.0.h, top: 4.0.h, bottom: 4.0.h),
      child: Card(
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
                          data.title ?? "",
                          style: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appColorBlack85)),
                          textAlign: TextAlign.left,
                        ),
                      )),
                  flex: 3,
                ),
                Flexible(
                  child: Align(
                      alignment: Alignment.topRight, child: _simplePopup()),
                  flex: 1,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 8.0),
              child: Text(
                data.textOne ??= "",
                style: styleElements.subtitle2ThemeScalable(context),
                textAlign: TextAlign.left,
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8.0),
                                child: Text(
                                  data.textTwo ??= "",
                                  style: styleElements.subtitle2ThemeScalable(context),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      data.textThree ??= "",
                                      style: styleElements.subtitle2ThemeScalable(context),
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
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              width: 100.0,
                              height: 10.0,
                              child: TricycleElevatedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: HexColor(AppColors.appColorLightGreen))),
                                onPressed: () {},
                                color: HexColor(AppColors.appColorLightGreen),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  OverlappedImages(null),
                                  Text(
                                    data.textFour ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, top: 8.0),
                                  child: Text(
                                    data.textFive ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TricycleAvatar(
                                  imageUrl: data.urlOne,
                                  isFullUrl: true,
                                  size: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, top: 8.0),
                                  child: Text(
                                    data.textSix ??= "",
                                    style: styleElements.subtitle2ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: data.isBlur,
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
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileCards(
                          type: "goals",

                          currentPosition: 0, userId: null, userType: null,
                        ),
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
                  child: Visibility(
                    visible: data.isShowMore ??= false,
                    child: Align
                      (
                      alignment:  Alignment.bottomRight,
                      child: Text(AppLocalizations.of(context).translate('see_more'),
                        style: styleElements.subtitle2ThemeScalable(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
