import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'commonComponents.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class Facebookbutton extends StatelessWidget {
  Facebookbutton({
    Key? key,
    this.name,
    this.offsetX,
    this.offsetY,
  }) : super(key: key);
  final name;
  final double? offsetX;
  final double? offsetY;
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),designSize: Size(375,812));
    return Stack(
      children: <Widget>[
        Container(
          width: 260.w,
          height: 40.0.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0.w),
            color:  HexColor(AppColors.appColorWhite),
            boxShadow: [CommonComponents().getShadowforBox()],
          ),
        ),
        Transform.translate(
          offset: Offset(80.29, 11.44),
          child: Text(
            this.name,
            style: styleElements.subtitle2ThemeScalable(context).copyWith(fontSize: 14.sp),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(31.52, 13.77),
          child:
              // Adobe XD layer: 'facebook' (group)
              Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0.0, 0.0),
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(name == "Sign in with Facebook" ||
                                name == "Sign up with Facebook"
                            ? 'assets/appimages/facebook.png'
                            : 'assets/appimages/ui.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(5.34, 3.07),
                // child: SvgPicture.string(
                //   _svg_oukk0x,
                //   allowDrawingOutsideViewBox: true,
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
