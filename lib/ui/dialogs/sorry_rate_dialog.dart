import 'dart:ui';

import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class SorryRateDialog extends StatelessWidget{
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
          children: [
            Text(AppLocalizations.of(context).translate('sorry'),
            style: styleElements.headline6ThemeScalable(context).copyWith(
              color: HexColor(AppColors.appColorBlack85),
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 24,),
            Text(AppLocalizations.of(context).translate('sorry_rate',arguments: {"minute":"3"}),
            textAlign: TextAlign.center,
            style: styleElements.subtitle1ThemeScalable(context),),
            SizedBox(height: 12,),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  shape: StadiumBorder(),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                    child: Text(AppLocalizations.of(context).translate('ok').toUpperCase(),style:
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