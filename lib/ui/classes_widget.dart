
import 'package:oho_works_app/profile_module/pages/particular_subject_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: must_be_immutable
class IntroWidget extends StatelessWidget {

  TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Flexible(
      child: Visibility(

        child:  GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParticularSubject(
                    type:"",
                    currentPosition: 1,
                  ),
                ));
          },
          child: Container(
              height: 150,
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: new Border(
                            top: BorderSide(
                              color: HexColor(AppColors.appMainColor),
                              width: 3.0,
                            )
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(8.0),
                            topRight: const Radius.circular(8.0)),
                        color: HexColor(AppColors.appMainColor),
                      ),
                      height: 50,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.h,
                          child:  Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "5",
                                        style: styleElements
                                            .subtitle2ThemeScalable(
                                            context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child: RatingBar(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 12.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
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
                                    )
                                    ,
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.star_border_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                    size: 20.h,
                                  ),
                                  // tooltip: 'Profile',
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                          child:  Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "",
                                        style: styleElements
                                            .subtitle2ThemeScalable(
                                            context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child:   Container(
                                        child: Text(
                                          "",
                                          style: styleElements
                                              .subtitle2ThemeScalable(
                                              context),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                    ,
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.star_border_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                    size: 20.h,
                                  ),
                                  tooltip: '',
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child:   Container(
                            child: Text(
                              "",
                              style: styleElements
                                  .subtitle2ThemeScalable(
                                  context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0,
                                top: 16.0),
                            child:  Align(
                              alignment: Alignment.center,
                              child: RatingBar(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 12.0,
                                itemPadding: EdgeInsets.symmetric(
                                    horizontal: 4.0),
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
                            )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),),
      flex: 1,
    );
  }
}