/*
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BannerCard extends StatelessWidget {
  TextStyleElements styleElements;


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
      height: 375.h,
      padding: EdgeInsets.only(bottom:16.h,left: 16.w,right: 16.w),
      width: double.infinity,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 265.h,
                padding:
                    EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w, bottom: 8.h),
                color: HexColor(AppColors.appColorBlack85),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context).translate('see_more')"Hi!\nKunal Manocha",
                        style:
                           styleElements.headline4ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context).translate('see_more')"Have a nice day!",
                        style:
                            styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                      ),
                    )
                  ],
                ),
              )), // ,
          Align(
            alignment: Alignment.bottomCenter,
            child: SearchBox(
              onvalueChanged: (value){
              },
              hintText: "Search",
              isFilterVisible: false ,
            )
          ),
        ],
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: CachedNetworkImageProvider(
            "https://image.freepik.com/free-vector/abstract-gradient-yellow-squares-wave-background_78474-284.jpg"),
        fit: BoxFit.fill,
      )),
    );
  }
}
*/
