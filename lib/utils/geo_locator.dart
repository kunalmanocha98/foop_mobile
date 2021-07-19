/*
import 'package:oho_works_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oho_works_app/utils/hexColors.dart';

// ignore: must_be_immutable
class GeoLocatorDialog extends StatefulWidget {
  String title;
  String subtitle;
  String type;
  Null Function(bool isSubmitted, double rateStarValue) callback;

  GeoLocatorDialog({
    Key key,
    @required this.type,
    @required this.title,
    @required this.subtitle,
    this.callback,
  }) : super(key: key);

  _GeoLocatorDialog createState() =>
      _GeoLocatorDialog(
          title: title, subtitle: subtitle, type: type, callback: callback);
}

class _GeoLocatorDialog extends State<GeoLocatorDialog> {
  String title;
  String subtitle;
  double ratingValue=1;
  Null Function(bool isSubmitted, double rateStarValue) callback;
  Map<String, bool> language = {
    'Read': false,
    'Write': false,
    'Speak': false,
    'Understand': false,
  };
  String type;

  _GeoLocatorDialog({Key key,
    @required this.type,
    @required this.title,
    @required this.subtitle,
    this.callback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 230,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16, top: 16),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'bold',
                        fontSize: 24,
                        color: const Color(0xd9000000),
                        letterSpacing: 1.28,
                        fontWeight: FontWeight.w800,
                      ),
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
                      itemBuilder: (context, _) =>
                          Icon(
                            Icons.star_border,
                            color: HexColor(AppColors.appMainColor),
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
                            style: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              fontSize: 10,
                              color: HexColor(AppColors.appColorBlack65),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Text(
                            AppLocalizations.of(context).translate('rate_verygood'),
                            style: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              fontSize: 10,
                              color: HexColor(AppColors.appColorBlack65),
                              fontWeight: FontWeight.w500,
                            ),
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
                        style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: 18,
                          color: HexColor(AppColors.appColorBlack85),
                          fontWeight: FontWeight.w500,
                        ),
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
                        callback(true,ratingValue);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          AppLocalizations.of(context).translate('submit'),
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            fontSize: 18,
                            color: HexColor(AppColors.appColorBlack85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
*/
