import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Component51 extends StatefulWidget {
  Component51({
    Key? key,
    this.name,
    required this.callback,
    double? offsetX,
    double? offsetY,
  }) : super(key: key);
  final String? name;
  Function callback;

  @override
  _Component51State createState() => _Component51State(callback:callback);
}

class _Component51State extends State<Component51> {
  Function callback;
  _Component51State({required this.callback});
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812));
    return Stack(
      children: <Widget>[
        Container(
          width: 260.w,
          height: 52.h,
          child: TricycleElevatedButton(
            onPressed: callback,
            color: HexColor(AppColors.appColorWhite),
            child: Center(
              child: Text(
                this.widget.name!,
                style:
                styleElements.subtitle2ThemeScalable(context)
                    .copyWith(color: HexColor(AppColors.appMainColor), fontSize: 14.sp),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
