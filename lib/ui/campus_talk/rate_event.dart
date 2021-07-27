import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateEventDilog extends StatelessWidget{
  final Null Function()? callBack;
  final Null Function()? callBackCancel;
  RateEventDilog({this.callBack,this.callBackCancel});
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16,left:16,right: 16),
              child: Text(AppLocalizations.of(context)!.translate('rate_event'),style: styleElements.headline6ThemeScalable(context),)),
          Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16,left:16,right: 16),
              child: Text(AppLocalizations.of(context)!.translate('pl_rate'),style: styleElements.subtitle1ThemeScalable(context),)),
          Padding(
            padding: const EdgeInsets.only(top:24.0),
            child: Center(
              child: Text(AppLocalizations.of(context)!.translate('rate'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appMainColor)
              ),),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Column(
              children: <Widget>[

                RatingBar(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 39.7,
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

                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Text(
                        AppLocalizations.of(context)!.translate('rate_average'),
                        style: styleElements.captionThemeScalable(context),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: Text(
                        AppLocalizations.of(context)!.translate('excellent'),
                        style: styleElements.captionThemeScalable(context),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:8.0,right: 8.0),
            child: Row(
              children: [
                Spacer(),
                appTextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    callBackCancel!();
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('cancel'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                  ),),
                ),
                appTextButton(
                  onPressed: (){

                    Navigator.pop(context);
                    callBack!();
                  },
                  shape: StadiumBorder(),
                  child: Text(AppLocalizations.of(context)!.translate('rate'),style: styleElements.bodyText2ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appMainColor)
                  ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}