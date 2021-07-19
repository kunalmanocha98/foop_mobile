import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'TextStyles/TextStyleElements.dart';
import 'app_localization.dart';
import 'colors.dart';

// ignore: must_be_immutable
class PointsDialog extends StatefulWidget {
  String title;
  String subtitle;
  String type;

  PointsDialog({
    Key key,
    @required this.type,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  _RateDialog createState() =>
      _RateDialog(title: title, subtitle: subtitle, type: type);
}

class _RateDialog extends State<PointsDialog> {
  String title;
  TextStyleElements styleElements;
  String subtitle;
  Map<String, bool> language = {
    'Read': false,
    'Write': false,
    'Speak': false,
    'Understand': false,
  };
  String type;

  _RateDialog({
    @required this.type,
    @required this.title,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: HexColor(AppColors.appMainColor),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0))),
                height: 150,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          child: Image(
                        image: AssetImage('assets/appimages/award.png'),
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      )),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 16, top: 16, left: 16, right: 16),
                    child: Text(
                      title,
                      style:  styleElements.headline5ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      subtitle,
                      style:  styleElements.subtitle1ThemeScalable(context),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
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
                          child: Text(AppLocalizations.of(context).translate('very_bad'),
                            style:  styleElements.overlineThemeScalable(context),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Text(AppLocalizations.of(context).translate('very_good'),
                            style: styleElements.overlineThemeScalable(context),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () async {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorWhite65), shape: BoxShape.circle),
                            margin: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.message,
                                  color: HexColor(AppColors.appColorPurpleAccent)),
                            ))),
                    GestureDetector(
                        onTap: () async {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorWhite65), shape: BoxShape.circle),
                            margin: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child:
                                  Icon(Icons.favorite, color: HexColor(AppColors.appMainColor)),
                            ))),
                    GestureDetector(
                        onTap: () async {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: HexColor(AppColors.appColorWhite65), shape: BoxShape.circle),
                            margin: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.g_translate,
                                  color: HexColor(AppColors.appColorGreenAccent)),
                            )))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
