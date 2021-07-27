import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogWaitEvent extends StatelessWidget{
  final String? date;
  DialogWaitEvent({this.date});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:  EdgeInsets.only(top:24.0,bottom: 16,left: 24,right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.translate('wait_to_start'),style:
            styleElements.headline6ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack85),
              fontWeight: FontWeight.bold,
              fontSize: 18
            )),
            SizedBox(height: 10,),
            Image.asset('assets/appimages/wait_event.png',width: 56,height: 56,),
            SizedBox(height: 16,),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: AppLocalizations.of(context)!.translate('start_time'),
                        style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                        text: " : ",
                        style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                        text: date,
                        style: styleElements.subtitle2ThemeScalable(context)
                    )
                  ]
              ),
            ),
            SizedBox(height: 16,),
            Text(AppLocalizations.of(context)!.translate('wait_to_start_des'),
              textAlign: TextAlign.center,
              style:
              styleElements.subtitle1ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack85),
                  fontSize: 16
              ),),
            SizedBox(height: 10,),
            Row(
              children: [
                Spacer(),
                appTextButton(
                  shape: RoundedRectangleBorder(),
                    onPressed: (){Navigator.pop(context);},
                    child: Text(AppLocalizations.of(context)!.translate('ok'),style: styleElements.captionThemeScalable(context).copyWith(
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