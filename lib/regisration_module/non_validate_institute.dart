import 'package:oho_works_app/components/white_button_large.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/confirm_details_institute.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class NonValidatedDialog extends StatelessWidget {

  late TextStyleElements styleElements;
int? instId;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Dialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child:
      Container(
        child: Card(
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Text(
                      AppLocalizations.of(context)!.translate("unvalidated"),
                      style: styleElements.headline5ThemeScalable(context),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate(
                      "non_validated_inst"),
                  textAlign: TextAlign.center,
                  style: styleElements
                      .captionThemeScalable(context)
                      .copyWith(
                      color: HexColor(AppColors.appColorBlack85)),
                ),
              ),


              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16),
                  child: WhiteLargeButton(
                    name: AppLocalizations.of(context)!
                        .translate("exit"),
                    offsetX: 70.66,
                    offsetY: 12.93,
                    textColor: AppColors.appColorWhite,
                    color:AppColors.appMainColor,
                    callback: () {
                      Navigator.pop(context);

                    },
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(16),
                child: Text(AppLocalizations.of(context)!.translate('or'),
                    textAlign: TextAlign.center,
                    style: styleElements.captionThemeScalable(context)),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 30),
                  child: WhiteLargeButton(
                    name: AppLocalizations.of(context)!
                        .translate("validate"),
                    offsetX: 70.66,
                    offsetY: 12.93,
                    callback: () {
                      Navigator.pop(context);

                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ConfirmDetails(
                          instId: instId,
                          fromPage: 'registration',
                          callbackPicker:(){}
                      ))).then((value){
                        if(value){

                        }
                      });
                      },
                  ),
                ),
              ),

            ],
          ),
        ),
      ),);
  }

  NonValidatedDialog(this.instId);
}
