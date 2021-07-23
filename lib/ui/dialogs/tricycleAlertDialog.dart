import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TricycleDialog extends StatelessWidget{
   String? message;
  TricycleDialog({this.message});

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return AlertDialog(
      content: Text(message ??=AppLocalizations.of(context)!.translate('you_cant_select'),
      style: styleElements.subtitle1ThemeScalable(context),),
      buttonPadding: EdgeInsets.all(0),
      actions: [
        TricycleTextButton(
          child: Text(AppLocalizations.of(context)!.translate('ok').toUpperCase()),
          onPressed: (){
            Navigator.pop(context);
          },
          shape: StadiumBorder(),
        )
      ],
    );
  }

}