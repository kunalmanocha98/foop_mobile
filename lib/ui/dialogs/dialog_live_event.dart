import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogLiveEvent extends StatelessWidget{
  final Function? okCallback;
  final String? date;
  DialogLiveEvent({this.date,this.okCallback});
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
            Text(AppLocalizations.of(context)!.translate('confirm'),style:
            styleElements.headline6ThemeScalable(context).copyWith(
                color: HexColor(AppColors.appColorBlack85),
                fontWeight: FontWeight.bold,
                fontSize: 18
            )),
            SizedBox(height: 10,),
            Image.asset('assets/appimages/live_event.png',width: 56,height: 56,),
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
            Text(AppLocalizations.of(context)!.translate('confirm_live_des'),
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
                TricycleTextButton(
                    shape: RoundedRectangleBorder(),
                    onPressed: (){Navigator.pop(context);},
                    child: Text(AppLocalizations.of(context)!.translate('cancel'),style: styleElements.captionThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor)
                    ),)
                ),
                TricycleTextButton(
                    shape: RoundedRectangleBorder(),
                    onPressed: (){Navigator.pop(context);okCallback!();},
                    child: Text(AppLocalizations.of(context)!.translate('start_now'),style: styleElements.captionThemeScalable(context).copyWith(
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