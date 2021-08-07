import 'dart:ui';

import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';


class CancelOrderDilog extends StatefulWidget{
  String ?title;
  String ?subTile;
  String ?description;
  Function(bool)?  callBack;
  CancelOrderDilog({this.title, this.subTile, this.description, this.callBack});
  @override
  CancelOrderDilogState createState() =>CancelOrderDilogState();
}


class CancelOrderDilogState extends State<CancelOrderDilog> {


  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      child: Container(
        padding: EdgeInsets.only(top: 16,bottom: 16,left: 36,right: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(widget.title!,
                textAlign: TextAlign.center,
                style: styleElements.headline6ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorBlack85),
                    fontWeight: FontWeight.bold
                ),),
            ),
            SizedBox(height: 24,),
            Text(widget.subTile!,
              textAlign: TextAlign.start,
              style: styleElements.subtitle1ThemeScalable(context),),
            SizedBox(height: 2,),
            Text(widget.description!,
              textAlign: TextAlign.center,
              style: styleElements.subtitle1ThemeScalable(context),),
            SizedBox(height: 12,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                appTextButton(
                    shape: StadiumBorder(),
                    onPressed: (){
                      Navigator.pop(context);
                      widget.callBack!(false);
                    },
                    child: Text("No",style:
                    styleElements.captionThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor)
                    ),)
                ),

                appTextButton(
                    shape: StadiumBorder(),
                    onPressed: (){
                      Navigator.pop(context);
                     widget. callBack!(true);
                    },
                    child: Text("Yes".toUpperCase(),style:
                    styleElements.captionThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor)
                    ),)
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}

