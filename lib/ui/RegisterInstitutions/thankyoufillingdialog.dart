import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogThankYouFillingDetails extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var styleElements= TextStyleElements(context);
    return Dialog(
      child: Padding(
        padding:  EdgeInsets.only(top:24.0,bottom: 40,left: 16,right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context).translate('thank_u'),style: styleElements.headline6ThemeScalable(context).copyWith(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 16,),
            Text(AppLocalizations.of(context).translate('thank_u_filling_details'),style: styleElements.subtitle2ThemeScalable(context).copyWith(
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ),
    );
  }

}