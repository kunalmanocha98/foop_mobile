import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhiteLargeButton extends StatefulWidget {
  WhiteLargeButton({Key? key, this.name, this.offsetX, this.offsetY,required this.callback,this.color,this.textColor})
      : super(key: key);
  final name;
  final double? offsetX;
  final double? offsetY;
  final Function callback;
  final  String? color;
  final  String? textColor;

  @override
  _WhiteLargeButtonState createState() => _WhiteLargeButtonState(callback:callback,color:color,textColor:textColor);
}

class _WhiteLargeButtonState extends State<WhiteLargeButton> {
  Function callback;
    String? color;
  String? textColor;
  _WhiteLargeButtonState({required this.callback,this.color,this.textColor});
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812), );
    styleElements = TextStyleElements(context);
    return Stack(
      children: <Widget>[
        Container(
          width: 260.w,
          height: 52.h,
          child: TricycleElevatedButton(
            onPressed: callback,
            color: HexColor(color??AppColors.appColorWhite),
            child: Center(
              child: Text(
                this.widget.name,
                style: styleElements.subtitle2ThemeScalable(context)
                    .copyWith(color: HexColor(textColor??AppColors.appColorBlack), fontSize: 14.sp),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(24.0),
          //   color: HexColor(AppColors.appMainColor),
          //   boxShadow: [CommonComponents().getShadowforBox()],
          // ),
        ),
        // Transform.translate(
        //   offset: Offset(this.widget.offsetX, this.widget.offsetY),
        //   child: Text(
        //     this.widget.name,
        //     style:styleElements.subtitle2ThemeScalable(context).copyWith(color:  HexColor(AppColors.appColorWhite), fontSize: 14.sp),
        //     textAlign: TextAlign.left,
        //   ),
        // ),
      ],
    );
  }
}
