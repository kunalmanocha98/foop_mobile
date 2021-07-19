import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/tricycle_user_images_list.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/CalenderModule/calenderModels.dart';
import 'package:oho_works_app/models/post/dateTagPostComponent.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TricycleCalenderCard extends StatefulWidget {
  final CalenderEventItem data;

  TricycleCalenderCard({Key key, this.data});

  @override
  TricycleCalenderCardState createState() =>
      TricycleCalenderCardState(data: data);
}

class TricycleCalenderCardState extends State<TricycleCalenderCard> {
  final CalenderEventItem data;

  TricycleCalenderCardState({this.data});

  TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return TricycleListCard(
        child: Container(
          margin: EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DateTagPostComponent(
                        date: DateTime.parse(data.endTime),
                        showTime: true,
                      ),
                      data.startTime != null ? Text("to") : Container(),
                      data.startTime != null
                          ? DateTagPostComponent(
                        date: DateTime.parse(data.startTime),
                        showTime: true,
                      )
                          : Container(),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8, bottom: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TricycleAvatar(
                                size: 16,
                                imageUrl: Utility().getUrlForImage(
                                    data.header.avatar,
                                    RESOLUTION_TYPE.R64,
                                    SERVICE_TYPE.PERSON),
                                key: UniqueKey(),
                              ),
                              Flexible(
                                  child:
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                      children: [
                                        TextSpan(text: ' by '),
                                        TextSpan(text: data.header.title),
                                        TextSpan(text:', '),
                                        TextSpan(text:data.header.subtitle1)
                                      ]
                                    ),
                                  )
                              )
                            ],
                          ),
                          Text(
                            data.title,
                            style: styleElements
                                .subtitle1ThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data.header.rating.toString(),
                                style: styleElements
                                    .subtitle2ThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appMainColor)),
                              ),
                              RatingBar(
                                initialRating: data.header.rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 14.0,
                                itemPadding: EdgeInsets.all(0),
                                ratingWidget: RatingWidget(
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    full: Icon(
                                      Icons.star,
                                      color: Theme.of(context).accentColor,
                                    )),
                                // itemBuilder: (context, _) => Icon(
                                //   Icons.star,
                                //   color: Theme.of(context).accentColor,
                                // ),
                                onRatingUpdate: null,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 6, right: 6),
                                height: 20,
                                width: 1,
                                color: HexColor(AppColors.failure),
                              ),
                              Text(
                                "public",
                                style: styleElements
                                    .captionThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(AppColors.appColorBlack35)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            data.subtitle,
                            style: styleElements.bodyText2ThemeScalable(context),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TricycleUserImageList(
                            listOfImages: List.generate(
                                data.participantList != null
                                    ? data.participantList.length
                                    : 0,
                                    (index) => data.participantList[index].profileImage),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          (data.eventLocation != null)
                              ? Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 16,
                                color: HexColor(AppColors.appColorBlack35),
                              ),
                              Text(
                                data.eventLocation.state,
                                style: styleElements
                                    .captionThemeScalable(context)
                                    .copyWith(
                                    color: HexColor(
                                        AppColors.appColorBlack35)),
                              )
                            ],
                          )
                              : Container(),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left:60.0),
                child: PostCardActionButtons(
                  isCommentVisible: false,
                ),
              )
            ],
          ),
        ));
  }
}
