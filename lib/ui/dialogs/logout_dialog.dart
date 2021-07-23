import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';

class LogoutDialog extends StatelessWidget{
  final Function logoutCallback;
  LogoutDialog(this.logoutCallback);
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
              child: Text(AppLocalizations.of(context)!.translate('are_you_sure_logout'),style: styleElements.subtitle2ThemeScalable(context),)),
          Padding(
            padding: const EdgeInsets.only(bottom:8.0,right: 8.0),
            child: Row(
              children: [
                Spacer(),
                TricycleTextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('cancel'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appMainColor)
                  ),),
                ),
                TricycleTextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    logoutCallback();
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('ok'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
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