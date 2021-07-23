import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CalenderItem extends StatelessWidget {
  SubRow data;
  TextStyleElements? styleElements;
  CalenderItem({Key? key, required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8.h),
          child: Container(
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            data.textOne ?? "",
                            style:styleElements!.captionThemeScalable(context),
                          ),
                        ),
                      ),
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            data.textTwo!,
                            style: styleElements!.subtitle1ThemeScalable(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            data.textThree!,
                            style: styleElements!.subtitle1ThemeScalable(context),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(4.h),
                            child: Text(
                              data.textFour!,
                              style: styleElements!.captionThemeScalable(context),
                            ),
                          )),
                    ],
                  ),
                  flex: 5,
                ),
                Flexible(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 16.h,
                        height: 16.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: HexColor(AppColors.appColorBlue)),
                      )),
                  flex: 1,
                ),
              ],
            ),
          ),
        ));
  }
}
