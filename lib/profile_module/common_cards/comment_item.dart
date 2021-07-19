import 'dart:convert';

import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/models/comment_list_entity.dart';
import 'package:oho_works_app/ui/rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class CommentItem extends StatelessWidget {
  CommentsItem data;
  TextStyleElements styleElements;
  BuildContext context;
  Null Function(int replyTo) callback;

  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context).translate('report_abuse')),
          ),
        ],
        onSelected: (value) {},
        icon: Icon(
          Icons.more_vert,
          size: 20,
          color: HexColor(AppColors.appColorBlack85),
        ),
      );

  CommentItem({Key key, @required this.data,this.styleElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
        margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              /*data.url != null
                              ? CachedNetworkImageProvider(data.mediaUrl ?? "") :*/
                              AssetImage("assets/appimages/student.png"))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    data.notesCreatedByName ?? "",
                    style: styleElements.subtitle2ThemeScalable(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    data.createdDate ?? "",
                    style: styleElements.overlineThemeScalable(context),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Align(
                      alignment: Alignment.topRight, child: _simplePopup()),
                ),
              ],
            ),
            Visibility(
              visible: data.ratingGiven != null,
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 24),
                child: RatingBar(
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15.0,
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, top: 12, bottom: 8),
              child: Text(
                data.noteContent ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: styleElements.subtitle2ThemeScalable(context),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => RateDialog(
                              type: "",
                              title: AppLocalizations.of(context).translate('rate_comment'),
                              subtitle: "",
                              callback: (isSubmitted, rateStarValue) {
                                updateRatings(isSubmitted, rateStarValue);
                              },
                            ));

                    /*  GenericCommentReviewFeedback(context, getBody()
                    ).apiCallCreate();*/
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 1),
                        child: Text(
                          data.averageRating.toString(),
                          style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                        ),
                      ),
                      RatingBar(
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 12.0,
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(AppLocalizations.of(context).translate('reply'),
                    style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void updateRatings(isSubmitted, rateStarValue) {
    GenericCommentReviewFeedback(context, getBodyRating(rateStarValue))
        .apiCreateRatings();
  }

  String getBodyRating(double ratingValue) {
    return jsonEncode({
      "rating_note_id": null,
      "rating_subject_type": "person",
      "rating_subject_id": 17,
      "rating_context_type": "institution",
      "rating_context_id": null,
      "rating_given_by_id": 170,
      "rating_given": ratingValue.toInt().toString()
    });
  }
}
