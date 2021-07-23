import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class IntroWidget extends StatelessWidget {
   IntroWidget(
      {Key? key,
      required this.screenWidth,
      required this.screenheight,
      this.image,
      this.type,
      this.startGradientColor,
      this.endGradientColor,
      this.subText,
      this.desc})
      : super(key: key);

  final double screenWidth;
  final double screenheight;
  final String? image;
  final type;
  final Color? startGradientColor;
  final Color? endGradientColor;
  final String? subText;
  final String? desc;
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
        margin: EdgeInsets.only(bottom: 60.h),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(color: HexColor(AppColors.appColorBackground),),
        child: ListView(
          children: <Widget>[
            Container(
                margin:  EdgeInsets.only(
                    left: 16.w, bottom: 12.h, top: 50.h, right: 16.w),
                alignment: Alignment.topLeft,
                child: Text(type,
                    style: styleElements.subtitle1ThemeScalable(context))),
            Container(
                margin:  EdgeInsets.only(
                    left: 16.w, bottom: 12.h, top: 12.h, right: 16.w),
                alignment: Alignment.topLeft,
                child: Text(subText!,
                    style: styleElements.headline5ThemeScalable(context))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin:  EdgeInsets.only(top: 100.h),
                    alignment: Alignment.center,
                    height: 200.h,
                    width: 200.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image!),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: null /* add child content here */,
                  ),
                  Container(
                    margin:  EdgeInsets.only(
                        left: 16.w, bottom: 12.h, top: 12.h, right: 16.w),
                    alignment: Alignment(0, -0.76),
                    child: Text(
                      desc!,
                      textAlign: TextAlign.center,
                      style: styleElements.subtitle1ThemeScalable(context)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
