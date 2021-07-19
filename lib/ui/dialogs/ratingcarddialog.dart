import 'dart:convert';

import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/models/post/ratingcreatemodels.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RatingCardDialog extends StatelessWidget{
  TextStyleElements styleElements ;
  double ratingGiven = 0.0;
  SharedPreferences prefs;
  String contexType;
  int contextId;
  String subjectType;
  int subjectId;
  RatingCardDialog({this.contextId,this.contexType,this.subjectId,this.subjectType});

  void setSharedPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    setSharedPrefs();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Container(
        height: 180,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // gradient: new LinearGradient(
          //     colors: [
          //       HexColor(AppColors.appMainColor),
          //       HexColor(AppColors.appColorRed50),
          //     ],
          //     begin: const FractionalOffset(0.0, 0.0),
          //     end: const FractionalOffset(1.0, 0.0),
          //     stops: [0.0, 1.0],
          //     tileMode: TileMode.clamp),
        ),
        child: Center(
          child:Padding(
            padding: EdgeInsets.only(top: 12,bottom: 12,left: 12,right: 12),
            child: Column(
              children: [
                Container(
                  margin:  EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context).translate('leave_your_rating'),
                    style: styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack65)),),
                ),
                Container(
                  margin:  EdgeInsets.only(top:8,bottom: 8,left: 16,right: 16),
                  child: RatingBar(
                    initialRating: ratingGiven,
                    minRating: 0.0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 36.0,
                    unratedColor: HexColor(AppColors.appColorBlack35),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    ratingWidget: RatingWidget(
                        empty:Icon(
                          Icons.star_border,
                          color: HexColor(AppColors.appMainColor),
                        ) ,
                        half:Icon(
                          Icons.star_half,
                          color: HexColor(AppColors.appMainColor),
                        )  ,
                        full: Icon(
                          Icons.star,
                          color: HexColor(AppColors.appMainColor),
                        )
                    ),
                    onRatingUpdate: (rating) {
                      ratingGiven  = rating;
                      print(rating);
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: TricycleTextButton(
                            shape: RoundedRectangleBorder(),
                            onPressed: () {
                              Navigator.pop(context,false);
                              },
                            child: Text(AppLocalizations.of(context).translate('cancel'),style: styleElements.captionThemeScalable(context).copyWith(color:HexColor(AppColors.appMainColor)),),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: TricycleTextButton(
                            shape: RoundedRectangleBorder(),
                            onPressed: () {
                              submitRating(context);
                            },
                            child: Text(AppLocalizations.of(context).translate('submit'),style: styleElements.captionThemeScalable(context).copyWith(color:HexColor(AppColors.appMainColor))),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitRating(BuildContext context) {
    if(ratingGiven != 0.0 && ratingGiven >  0.0) {
      CreateRatingPayload payload = CreateRatingPayload();
      payload.ratingContextId = contextId;
      payload.ratingContextType = contexType;
      payload.ratingGivenById = prefs.getInt(Strings.userId);
      // payload.ratingNoteId = prefs.getInt(Strings.institutionId);
      payload.ratingSubjectId = subjectId;
      payload.ratingSubjectType = subjectType;
      payload.ratingGiven = ratingGiven.toString();
      var body = jsonEncode(payload);
      GenericCommentReviewFeedback(context, body).apiCreateRatings();
      Navigator.pop(context, true);
    }else{
      ToastBuilder().showToast(AppLocalizations.of(context).translate('please_give_rating'), context, HexColor(AppColors.information));
      Navigator.pop(context, false);
    }
  }

}