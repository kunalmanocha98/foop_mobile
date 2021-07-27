import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchKeywordDialog extends StatelessWidget {
  var value;
  final Function(String?)? okCallback;
  SearchKeywordDialog({this.okCallback});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Search keyword",
              style: styleElements.headline6ThemeScalable(context),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              onChanged: (value){
                this.value = value;
              },
              onSubmitted: (value){
                this.value = value;
                okCallback!(value);
                Navigator.pop(context);
              },
              style: styleElements.subtitle1ThemeScalable(context),
              decoration: InputDecoration(
                  hintText: 'Search Keyword',
                  hintStyle: styleElements
                      .bodyText1ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appColorBlack35))),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Spacer(),
                appTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: StadiumBorder(),
                    child:
                    Text(AppLocalizations.of(context)!.translate('cancel'),
                      style: styleElements.captionThemeScalable(context).copyWith(
                          color: HexColor(AppColors.appMainColor)
                      ),)),
                appTextButton(
                    onPressed: () {
                      okCallback!(value);
                      Navigator.pop(context);
                    },
                    shape: StadiumBorder(),
                    child:
                    Text(AppLocalizations.of(context)!.translate('ok'),
                      style: styleElements.captionThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor)
                      ),)),

              ],
            )
          ],
        ),
      ),
    );
  }
}
