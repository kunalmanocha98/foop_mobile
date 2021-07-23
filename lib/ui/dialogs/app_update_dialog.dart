import 'dart:ui';

import 'package:oho_works_app/components/tricycleHtmlViewer.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class AppUpdateDialog extends StatelessWidget{
  final Function? cancelButton;
  final Function? updateButton;
  final bool showCancelButton;
  final String? note;
  AppUpdateDialog({this.cancelButton,this.updateButton,this.showCancelButton= true,this.note});
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Update Application",style: styleElements.subtitle1ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 16,),
            (note != null && note!.isNotEmpty)?
            TricycleHtmlViewer(
              sourceString:note,
              isDetailPage: true,
            )
            :Text("Your current version is lower than the latest version which is available on the App store",
              textAlign: TextAlign.center,
              style: styleElements.subtitle2ThemeScalable(context),),
            SizedBox(height: 8,),
            Row(children: [
              Spacer(),
              Visibility(
                visible: showCancelButton,
                child: TricycleTextButton(onPressed: (){
                  Navigator.pop(context);
                  cancelButton!();
                  },
                    shape: StadiumBorder(),
                    child: Text(AppLocalizations.of(context)!.translate('cancel'),style:
                      styleElements.captionThemeScalable(context)
                          .copyWith(color:HexColor(AppColors.appMainColor)),)),
              ),
              TricycleTextButton(onPressed: (){
                updateButton!();
              },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('update'),style:
                  styleElements.captionThemeScalable(context)
                      .copyWith(color:HexColor(AppColors.appMainColor))))
            ],
            ),
          ],
        ),
      ),
    );
  }

}