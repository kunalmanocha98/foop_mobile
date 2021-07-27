import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class RatingCard extends StatelessWidget {
  CommonCardData data;
  TextStyleElements? styleElements;
  RatingCard({Key? key, required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appListCard(

        child:Container(
          decoration: new BoxDecoration(
     borderRadius: BorderRadius.circular(6),
     gradient: new LinearGradient(
         colors: [
           HexColor(AppColors.appMainColor),
           HexColor(AppColors.appColorRed50),
         ],
         begin: const FractionalOffset(0.0, 0.0),
         end: const FractionalOffset(1.0, 0.0),
         stops: [0.0, 1.0],
         tileMode: TileMode.clamp),
          ),
          child: Center(
     child:Padding(
     padding: EdgeInsets.only(top: 24.h,bottom: 24.h,left: 16.w,right: 16.w),
       child: Column(
         children: [
           Container(
           margin:  EdgeInsets.all(16.w),
           child: Text(AppLocalizations.of(context)!.translate('leave_your_review'),
           style: styleElements!.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
         ),
           Container(
           margin:  EdgeInsets.only(top:8.h,bottom: 8.h,left: 16.w,right: 16.w),
           child: RatingBar(
             initialRating: data.ratingValue??1.0,
             minRating: 1,
             direction: Axis.horizontal,
             allowHalfRating: false,
             itemCount: 5,
             itemSize: 36.0,
             unratedColor: HexColor(AppColors.appColorBlack35),
             itemPadding: EdgeInsets.symmetric(horizontal: 4.0.h),
             ratingWidget: RatingWidget(
               empty:Icon(
                 Icons.star_border,
                 color: HexColor(AppColors.appColorWhite),
               ) ,
               half:Icon(
                 Icons.star_half,
                 color: HexColor(AppColors.appColorWhite),
               )  ,
               full: Icon(
                 Icons.star,
                 color: HexColor(AppColors.appColorWhite),
               )
             ),
             onRatingUpdate: (rating) {
               print(rating);
             },
           ),
         ),
       ],
     ),
          ),
        ),
        ),
      );
  }
}
