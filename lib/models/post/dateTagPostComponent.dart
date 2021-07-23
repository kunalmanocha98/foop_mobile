import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

class DateTagPostComponent extends StatelessWidget{
  final DateTime? date;
  final bool showTime;
  DateTagPostComponent({this.date,this.showTime =false});
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return Container(
      width: 60,
      decoration: BoxDecoration(
        boxShadow: [CommonComponents().getShadowforBox()],
        borderRadius: BorderRadius.circular(8),
        color: HexColor(AppColors.appColorWhite)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
              color:  HexColor(AppColors.appMainColor)
            ),
            height: 20,
            child:  Center(
              child: Text(Utility().getDateFormat('MMM', date!).toUpperCase(),
                style: styleElements.captionThemeScalable(context).copyWith(
                    fontWeight: FontWeight.bold,
                  color: HexColor(AppColors.appColorWhite)
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 2,bottom: 4,left: 2,right: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Utility().getDateFormat('dd', date!),
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    fontWeight: FontWeight.bold
                ),),
              Visibility(
                visible: showTime,
                child: Text(Utility().getDateFormat('h:mma', date!).toUpperCase(),
                  style: styleElements.captionThemeScalable(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),)
        ],
      ),
    );
  }
}
