import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class ReportConfirmDialog extends StatelessWidget {
  final Function callBack;
  ReportConfirmDialog(this.callBack);
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: EdgeInsets.only(top: 24),
        height: 600,
        child: Column(
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/appimages/report_content_icon.png'),
                  )
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("report_abuse_title"),
                    style: styleElements.headline5ThemeScalable(context),
                  ),
                )),
            Expanded(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context).translate("report_abuse_des"),
                      style:styleElements.subtitle2ThemeScalable(context),
                    ),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.all(8),
                //   child: TricycleElevatedButton(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(25.0),
                //         side: BorderSide(color: HexColor(AppColors.appMainColor))),
                //     onPressed: () {
                //       Navigator.pop(context);
                //       callBack();
                //     },
                //     textColor: HexColor(AppColors.appMainColor),
                //     color: HexColor(AppColors.appColorWhite),
                //     child: Text(AppLocalizations.of(context).translate('cancel'),
                //       style: styleElements.captionThemeScalable(context).
                //       copyWith(color:HexColor(AppColors.appMainColor)),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TricycleElevatedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: HexColor(AppColors.appMainColor))),
                    onPressed: () {
                      Navigator.pop(context);
                      callBack();
                    },
                    color: HexColor(AppColors.appMainColor),
                    child: Text(AppLocalizations.of(context).translate('ok'),
                      style:styleElements.captionThemeScalable(context).
                        copyWith(color:HexColor(AppColors.appColorWhite))
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
