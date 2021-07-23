
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteMessageDialog extends StatefulWidget {

  Null Function(bool isSubmit)? callbackPicker;


  DeleteMessageDialog({Key? key,
   
    this.callbackPicker,
  })
      : super(key: key);

  _DeleteMessageDialog createState() =>
      _DeleteMessageDialog(
      
        callbackPicker: callbackPicker,
      
      );
}

class _DeleteMessageDialog
    extends State<DeleteMessageDialog> {

  Null Function(bool isSubmit)? callbackPicker;
 

  @override
  void initState() {
    super.initState();
  }



  _DeleteMessageDialog({
    this.callbackPicker,
  });

  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
  
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(left:16,bottom: 16, top: 20,right: 16),
                  child: Text(
                    AppLocalizations.of(context)!.translate("delete"),
                    style: styleElements.subtitle1ThemeScalable(context),
                    textAlign: TextAlign.center,
                  ),
                )),
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left:16,bottom: 16, top: 20,right: 16),
                  child: Text(
                    AppLocalizations.of(context)!.translate("confirm_delete"),
                    style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                    textAlign: TextAlign.center,
                  ),
                )),

            Divider(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    callbackPicker!(false);
                    Navigator.pop(context, null);
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.only(right: 30, top: 16, bottom: 16),
                    child: Text(
                      AppLocalizations.of(context)!.translate('cancel'),
                      style: styleElements
                          .bodyText1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    child: VerticalDivider(
                      color: HexColor(AppColors.appColorGrey500),
                      width: 2,
                    )),
                GestureDetector(
                    onTap: () {
                      callbackPicker!(true);
                      Navigator.pop(context, null);

                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 30, top: 16, bottom: 16),
                      child: Text(
                        AppLocalizations.of(context)!.translate('submit'),
                        style: styleElements
                            .bodyText1ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.w600,color: HexColor(AppColors.appMainColor)),
                      ),
                    ))
              ],
            )
          ],
        )
        );
  }

 
}
