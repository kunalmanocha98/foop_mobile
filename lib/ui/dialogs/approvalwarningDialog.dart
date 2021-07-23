import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovalWarningDialog extends StatelessWidget{
  final Function? onButtonCallback;
  ApprovalWarningDialog({this.onButtonCallback});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      child:Padding(
        padding: EdgeInsets.only(top: 16,bottom: 16,left: 52,right: 52),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32,),
            Icon(Icons.warning_amber_rounded,
            color: HexColor(AppColors.appMainColor),
            size: 64,),
            SizedBox(height: 20,),
            Text(AppLocalizations.of(context)!.translate('not_knowing_user'),
            textAlign: TextAlign.center,
            style: styleElements.subtitle1ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 16,),
            Text(AppLocalizations.of(context)!.translate('not_approve_user'),
              textAlign: TextAlign.center,
              style: styleElements.subtitle2ThemeScalable(context).copyWith(
              ),),
            SizedBox(height: 24,),
            Row(
              children: [
                Spacer(),
                TricycleTextButton(onPressed: (){
                  Navigator.pop(context);
                  onButtonCallback!();
                }, child: Text(AppLocalizations.of(context)!.translate('ok'),style: styleElements.buttonThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appMainColor)
                ),)),
              ],
            ),
            SizedBox(height: 16,),
          ],
        ),
      )
    );
  }

}