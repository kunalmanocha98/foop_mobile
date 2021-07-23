import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'intro_widget.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  double screenWidth = 0.0;
  double screenheight = 0.0;

  int currentPageValue = 0;
  int previousPageValue = 0;
  PageController? controller;
  double _moveBar = 0.0;
  late TextStyleElements styleElements;

  @override
  void initState() {
   
    super.initState();

    controller = PageController(initialPage: currentPageValue);
  }

  void getChangedPageAndMoveBar(int page) {
    print('page is $page');

    if (previousPageValue == 0) {
      previousPageValue = page;
      _moveBar = _moveBar + 0.14;
    } else {
      if (previousPageValue < page) {
        previousPageValue = page;
        _moveBar = _moveBar + 0.14;
      } else {
        previousPageValue = page;
        _moveBar = _moveBar - 0.14;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;

    final List<Widget> introWidgetsList = <Widget>[
      IntroWidget(
        screenWidth: screenWidth,
        screenheight: screenheight,
        image: 'assets/appimages/Teacher-pana.png',
        type: AppLocalizations.of(context)!.translate("teacher_intro_title"),
        subText:
            AppLocalizations.of(context)!.translate("teacher_intro_subtitle"),
        desc: AppLocalizations.of(context)!.translate("teacher_intro_desc"),
      ),
      IntroWidget(
        screenWidth: screenWidth,
        screenheight: screenheight,
        image: 'assets/appimages/students1-pana.png',
        type: AppLocalizations.of(context)!.translate("student_intro_title"),
        subText:
            AppLocalizations.of(context)!.translate("student_intro_subtitle"),
        desc: AppLocalizations.of(context)!.translate("student_intro_desc"),
      ),
      IntroWidget(
        screenWidth: screenWidth,
        screenheight: screenheight,
        image: 'assets/appimages/Teacher-pana.png',
        type: AppLocalizations.of(context)!.translate("parent_intro_title"),
        subText:
            AppLocalizations.of(context)!.translate("parent_intro_subtitle"),
        desc: AppLocalizations.of(context)!.translate("parent_intro_desc"),
      )
    ];

    return
      SafeArea(child:
      Scaffold(
        resizeToAvoidBottomInset: false,
        body:
        Container(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: introWidgetsList.length,
                onPageChanged: (int page) {
                  setState(() {
                    currentPageValue = page;
                  });
                },
                controller: controller,
                itemBuilder: (context, index) {
                  return introWidgetsList[index];
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin:  EdgeInsets.only(left: 8.w),
                    child: TricycleElevatedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0.w),
                          side: BorderSide(color: HexColor(AppColors.appColorWhite))),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false);
                      },
                      color: HexColor(AppColors.appColorWhite),
                      child: Text(AppLocalizations.of(context)!.translate("skip"),
                          style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < introWidgetsList.length; i++)
                          if (i == currentPageValue) ...[circleBar(true)] else
                            circleBar(false),
                      ],
                    ),
                  ),
                  Container(
                      margin:  EdgeInsets.only(right: 8.w),
                      child: TricycleElevatedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0.w),
                            side: BorderSide(color: HexColor(AppColors.appColorWhite))),
                        onPressed: () {
                          setState(() {
                            if (currentPageValue == 2) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => Home()),
                                      (Route<dynamic> route) => false);
                            } else {
                              currentPageValue = currentPageValue + 1;
                              controller!.jumpToPage(currentPageValue);
                            }
                          });
                        },
                        color: HexColor(AppColors.appColorWhite),
                        child: Text(
                            AppLocalizations.of(context)!.translate("next"),
                            style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))),
                      ))
                ],
              )
            ],
          ),
        ),
      ));
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      height: isActive ? 12.w : 8.w,
      width: isActive ? 12.w : 8.w,
      decoration: BoxDecoration(
          color: isActive ? HexColor(AppColors.appMainColor) : HexColor(AppColors.appColorGrey500),
          borderRadius: BorderRadius.all(Radius.circular(12.w))),
    );
  }

  Container movingBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9.w),
      height: 12.h,
      width: 0.1.sw,
      decoration: BoxDecoration(
        color: HexColor(AppColors.appMainColor),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget slidingBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9.w),
      height: 8.h,
      width: 0.1.sw,
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorGrey500),
        shape: BoxShape.circle,
      ),
    );
  }
}
