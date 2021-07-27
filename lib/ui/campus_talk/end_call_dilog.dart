import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class EndCallDilog extends StatelessWidget{
final Null Function()? callBack;
final Null Function()? callBackCancel;
  EndCallDilog({this.callBack,this.callBackCancel});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16,left:16,right: 16),
              child: Text(AppLocalizations.of(context)!.translate('confirm_end'),style: styleElements.headline6ThemeScalable(context),)),
          Center(
            child: Image(
              width: 48,
              height: 48,
              image: AssetImage(
                  'assets/appimages/the-end.png'),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16,left:16,right: 16),
              child: Text(AppLocalizations.of(context)!.translate('end_text'),style: styleElements.subtitle1ThemeScalable(context),)),


          Padding(
            padding: const EdgeInsets.only(bottom:8.0,right: 8.0),
            child: Row(
              children: [
                Spacer(),
                appTextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    callBackCancel!();
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('cancel'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                  ),),
                ),
                appTextButton(
                  onPressed: (){

                    Navigator.pop(context);
                    callBack!();
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('end_now'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                  ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}