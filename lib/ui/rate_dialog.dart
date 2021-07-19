import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class RateDialog extends StatefulWidget {
  String title;
  String subtitle;
  String type;
  Null Function(bool isSubmitted, double rateStarValue) callback;

  RateDialog({
    Key key,
    @required this.type,
    @required this.title,
    @required this.subtitle,
    this.callback,
  }) : super(key: key);

  _RateDialog createState() => _RateDialog(
      title: title, subtitle: subtitle, type: type, callback: callback);
}

class _RateDialog extends State<RateDialog> {
  String title;
  String subtitle;
  double ratingValue = 1;
  TextStyleElements styleElements;
  Null Function(bool isSubmitted, double rateStarValue) callback;
  Map<String, bool> language = {
    'Read': false,
    'Write': false,
    'Speak': false,
    'Understand': false,
  };
  String type;

  _RateDialog(
      {@required this.type,
      @required this.title,
      @required this.subtitle,
      this.callback});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16, top: 16),
                    child: Text(
                      title,
                      style: styleElements.headline5ThemeScalable(context),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    RatingBar(
                      initialRating: 1,
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
                        setState(() {
                          ratingValue = rating;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Text(
                            AppLocalizations.of(context).translate('rate_average'),
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Text(
                            AppLocalizations.of(context).translate('rate_verygood'),
                            style: styleElements.captionThemeScalable(context),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        AppLocalizations.of(context).translate('cancel'),
                        style: styleElements.subtitle1ThemeScalable(context),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      child: VerticalDivider(color: HexColor(AppColors.appColorGrey500))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context, null);
                        callback(true, ratingValue);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          AppLocalizations.of(context).translate('submit'),
                          style: styleElements.subtitle1ThemeScalable(context),
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
