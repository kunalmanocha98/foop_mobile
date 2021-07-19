import 'package:oho_works_app/models/language_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SportsExpertiseDialog extends StatefulWidget {
  @override
  _SportsExpertiseDialog createState() => _SportsExpertiseDialog();
}

class _SportsExpertiseDialog extends State<SportsExpertiseDialog> {
  List<LanguageItem> list = [];
  TextStyleElements styleElements;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => inflateData());
  }

  void inflateData() {
    list.add(LanguageItem(languageName: "I Play"));
    list.add(LanguageItem(languageName: "I Like"));
    list.add(LanguageItem(languageName: "I Coach"));
    setState(() {
      for (LanguageItem item in list) {
        item.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 470,
        child: Column(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Text(AppLocalizations.of(context).translate('sports_expertise'),
                    style: styleElements.headline5ThemeScalable(context),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Column(children: [
                CheckboxListTile(
                  activeColor: HexColor(AppColors.appMainColor),
                  title: Text(
                      list[0].languageName != null ? list[0].languageName : ""),
                  value:
                      list[0].isSelected != null ? list[0].isSelected : false,
                  onChanged: (bool value) {
                    list[0].isSelected = true;
                    setState(() {});
                  },
                ),
                CheckboxListTile(
                  activeColor: HexColor(AppColors.appMainColor),
                  title: Text(
                      list[1].languageName != null ? list[1].languageName : ""),
                  value:
                      list[0].isSelected != null ? list[0].isSelected : false,
                  onChanged: (bool value) {
                    list[1].isSelected = true;
                    setState(() {});
                  },
                ),
                CheckboxListTile(
                  activeColor: HexColor(AppColors.appMainColor),
                  title: Text(
                      list[2].languageName != null ? list[2].languageName : ""),
                  value:
                      list[0].isSelected != null ? list[0].isSelected : false,
                  onChanged: (bool value) {
                    list[2].isSelected = true;
                    setState(() {});
                  },
                )
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context).translate('rate_expertise'),
                        style: styleElements.subtitle1ThemeScalable(context),
                      ),
                    ),
                  ),
                  RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 36.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    ratingWidget: RatingWidget(
                      empty: Icon(
                        Icons.star_outline,
                        color: HexColor(AppColors.appMainColor),
                      ),
                      half:  Icon(
                        Icons.star_half_outlined,
                        color: HexColor(AppColors.appMainColor),
                      ),
                      full:  Icon(
                        Icons.star_outlined,
                        color: HexColor(AppColors.appMainColor),
                      ),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Text(
                          AppLocalizations.of(context).translate('rate_average'),
                          style: styleElements.overlineThemeScalable(context),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 30),
                        child: Text(
                          AppLocalizations.of(context).translate('rate_verygood'),
                          style: styleElements.overlineThemeScalable(context),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    height: 50,
                    child: VerticalDivider(color: HexColor(AppColors.appColorGrey500))),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    AppLocalizations.of(context).translate('submit'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
