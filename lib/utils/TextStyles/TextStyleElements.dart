import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyleElements {
  Color color;
  double fontSize;
  BuildContext context;

  TextStyleElements(this.context){
   ScreenUtil.init(BoxConstraints(
       maxWidth: MediaQuery.of(context).size.width,
       maxHeight: MediaQuery.of(context).size.height),designSize: Size(375, 812));
  }

  TextStyle headline1ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline1.copyWith(fontSize: 96.sp);
  }

  TextStyle headline2ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline2.copyWith(fontSize: 60.sp);
  }

  TextStyle headline3ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline3.copyWith(fontSize: 48.sp);
  }

  TextStyle headline4ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline4.copyWith(fontSize: 34.sp);
  }

  TextStyle headline5ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline5.copyWith(fontSize: 24.sp);
  }

  TextStyle headlinecustomThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline6.copyWith(fontSize: 20.sp);
  }

  TextStyle headline6ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.headline6.copyWith(fontSize: 18.sp,fontWeight: FontWeight.w600);
  }

  TextStyle subtitle1ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16.sp);
  }
  TextStyle subtitle2ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 14.sp);
  }
  TextStyle bodyText1ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16.sp);
  }
  TextStyle bodyText2ThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14.sp);
  }
  TextStyle captionThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.caption.copyWith(fontSize: 12.sp);
  }
  TextStyle buttonThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.button.copyWith(fontSize: 14.sp);
  }
  TextStyle overlineThemeScalable(BuildContext context){
    return Theme.of(context).textTheme.overline.copyWith(fontSize: 10.sp);
  }


  TextStyle textStyleRegular() {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? null,
        fontFamily: 'Source sans pro',
        fontWeight: FontWeight.w400);
  }

  TextStyle textStyleMedium() {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? null,
        fontFamily: 'Source sans pro',
        fontWeight: FontWeight.w500);
  }

  TextStyle textStyleBold() {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? null,
        fontFamily: 'Source sans pro',
        fontWeight: FontWeight.w700);
  }

  TextStyle textStyleBold900() {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? null,
        fontFamily: 'Source sans pro',
        fontWeight: FontWeight.w900);
  }

  TextStyle textStyleLight() {
    return TextStyle(
        fontSize: fontSize,
        color: color ?? null,
        fontFamily: 'Source sans pro',
        fontWeight: FontWeight.w300);
  }

}
