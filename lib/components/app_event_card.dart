import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/app_user_images_list.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/Rooms/rooms_view.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/ui/campus_talk/talk_live_date_tag.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class appEventCard extends StatefulWidget {
  final String? cardImage;
  final String? byImage;
  final String byTitle;
  final String? title;
  final bool isPrivate;
  final double? cardRating;
  final bool isModerator;
  final String? description;
  final List<String?>? listofImages;
  final Widget? actionButton;
  final int? ownerId;
  final String? ownerType;
  final Function? shareCallback;
  final Function? ratingCallback;
  final bool isShareVisible;
  final bool? isRated;
  final String? subjectType;
  final int? subjectId;
  final int? totalRatedUsers;
  final Function? onClickEvent;
  final Function? bookMarkCallBack;
  final bool onlyHeader;
  final bool withCard;
  final bool noActions;
  final bool showRateCount;
  final bool dateVisible;
  final DateTime? date;
  final bool isLive;
  final Function? ratingFunction;
  final SERVICE_TYPE? serviceType;
  final Function(double?)? averageRatingCallback;
  final bool isRoom;
  final bool isRatingVisible;
  final bool isBookMarkVisible;
  final bool isHorizontalCard;
  final double? cardHeight;
  final bool inviteUsersVisible;
  final Function? inviteUsersCallback;
  final bool? isBellAvailable;
  final bool? isBellPressed;
final Function? bellIconCallBack;
  appEventCard(
      {Key? key,
        this.bellIconCallBack,
      this.isBellAvailable,
      this.isBellPressed,
      this.bookMarkCallBack,
      this.cardImage = "",
      this.byImage = "",
      this.byTitle = "",
      this.title = "",
      this.actionButton,
      this.listofImages = const [],
      this.description = "",
      this.isPrivate = false,
      this.cardRating = 0.0,
      this.isModerator = false,
      this.onlyHeader = false,
      this.ownerId,
      this.ownerType,
      this.ratingFunction,
      this.isShareVisible = true,
      this.noActions = false,
      this.shareCallback,
      this.ratingCallback,
      this.isRated = false,
      this.withCard = true,
      this.showRateCount = true,
      this.isLive = false,
      this.isRoom = false,
      this.isRatingVisible = false,
      this.isBookMarkVisible = false,
      this.inviteUsersVisible = false,
      this.inviteUsersCallback,
      this.date,
      this.subjectType,
      this.subjectId,
      this.totalRatedUsers = 0,
      this.cardHeight,
      this.onClickEvent,
      this.dateVisible = false,
      this.isHorizontalCard = false,
      this.averageRatingCallback,
      this.serviceType})
      : super(key: key);

  @override
  appEventCardState createState() => appEventCardState();
}

class appEventCardState extends State<appEventCard> {
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return widget.withCard
        ? appListCard(
            margin: EdgeInsets.only(left: 8, right: 8.0, top: 6.0, bottom: 6.0),
            onTap: widget.onClickEvent,
            child: _child,
          )
        : GestureDetector(
            onTap: widget.onClickEvent as void Function()?,
            child: _child,
          );
  }

  Widget get _child => SizedBox(
        height: widget.isHorizontalCard
            ? widget.cardHeight != null
                ? widget.cardHeight
                : null
            : null,
        child: Stack(
          children: [
            Visibility(
              visible: widget.dateVisible,
              child: Row(
                children: [
                  Spacer(),
                  DateLiveTag(
                      isLive: widget.isLive,
                      date: widget.date ?? DateTime.now())
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, left: 12, right: 12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          appAvatar(
                            key: UniqueKey(),
                            withBorder: true,
                            size: 56,
                            resolution_type: RESOLUTION_TYPE.R64,
                            service_type: widget.serviceType,
                            imageUrl: widget.isRoom
                                ? widget.cardImage
                                : widget.byImage,
                          )
                        ],
                      ),
                      Flexible(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 8, bottom: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.onlyHeader
                                      ? Container()
                                      : widget.isRoom
                                          ? appAvatar(
                                              size: 16,
                                              resolution_type:
                                                  RESOLUTION_TYPE.R64,
                                              service_type: widget.ownerType ==
                                                      'person'
                                                  ? SERVICE_TYPE.PERSON
                                                  : SERVICE_TYPE.INSTITUTION,
                                              imageUrl: widget.byImage,
                                              shouldPrintLog: false,
                                              key: UniqueKey(),
                                            )
                                          : Container(),
                                  Flexible(
                                    child: Text(
                                      widget.byTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleElements
                                            .subtitle1ThemeScalable(context)
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.isPrivate,
                                      child: Icon(
                                        Icons.lock,
                                        color:
                                            HexColor(AppColors.appColorBlack65),
                                        size: 16,
                                      ),
                                    )
                                  ]),
                              // Text(
                              //   roomData.roomName,
                              //   maxLines: 3,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: styleElements
                              //       .subtitle1ThemeScalable(context)
                              //       .copyWith(fontWeight: FontWeight.bold),
                              // ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.cardRating} ',
                                    style: styleElements
                                        .subtitle1ThemeScalable(context)
                                        .copyWith(
                                            color: HexColor(
                                                AppColors.appMainColor),
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: RatingBar(
                                      initialRating: widget.cardRating!,
                                      ignoreGestures: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 15.0,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      ratingWidget: RatingWidget(
                                        empty: Icon(
                                          Icons.star_outline,
                                          color:
                                              HexColor(AppColors.appMainColor),
                                        ),
                                        half: Icon(
                                          Icons.star_half_outlined,
                                          color:
                                              HexColor(AppColors.appMainColor),
                                        ),
                                        full: Icon(
                                          Icons.star_outlined,
                                          color:
                                              HexColor(AppColors.appMainColor),
                                        ),
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.isModerator,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Container(
                                        width: 1,
                                        height: 16,
                                        color:
                                            HexColor(AppColors.appColorBlack35),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.isModerator,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 4, left: 2),
                                      child: Container(
                                        child: RoomButtons(context: context)
                                            .moderatorImage,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              widget.onlyHeader
                                  ? Container()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        widget.description != null &&
                                                widget.description!.isNotEmpty
                                            ? Text(
                                                widget.description!,
                                                softWrap: true,
                                                maxLines:
                                                    widget.isHorizontalCard
                                                        ? 2
                                                        : 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: styleElements
                                                    .bodyText2ThemeScalable(
                                                        context),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        (widget.listofImages != null &&
                                                widget.listofImages!.length > 0)
                                            ? appUserImageList(
                                                listOfImages:
                                                    widget.listofImages)
                                            : Container(),
                                        // Row(
                                        //   children: [
                                        //     Spacer(),
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(4.0),
                                        //       child: widget.actionButton,
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  widget.isHorizontalCard ? Spacer() : Container(),
                  widget.onlyHeader
                      ? Container()
                      : widget.noActions
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(left: 60.0),
                              child: PostCardActionButtons(
                                isCommentVisible: false,
                                bellIconCallBack:widget.bellIconCallBack,
                                isBellAvailable: widget.isBellAvailable,
                                bookMarkCallBack: widget.bookMarkCallBack,
                                inviteuserCallback: widget.inviteUsersCallback,
                                isInviteUserVisible: widget.inviteUsersVisible,
                                isBookMarkVisible: widget.isBookMarkVisible,
                                isRatingVisible: widget.isRatingVisible,
                                actionButton: widget.actionButton,
                                isBellPressed:widget.isBellPressed,
                                ratingFunction: widget.ratingFunction,
                                rateCountShow: widget.showRateCount,
                                isShareVisible: widget.isShareVisible,
                                sharecallBack: widget.shareCallback,
                                subjectId: widget.subjectId,
                                subjectType: widget.subjectType,
                                isBookMarked: widget.isBookMarkVisible,
                                stats: Statistics(
                                  starRating: widget.totalRatedUsers,
                                ),
                                isRated: widget.isRated,
                                ownerId: widget.ownerId,
                                ownerType: widget.ownerType,
                                ratingCallback: () {
                                  if (widget.isRoom) {
                                    Future.delayed(Duration(milliseconds: 600),
                                        () {
                                      refreshCard();
                                    });
                                  } else {
                                    widget.ratingCallback!();
                                  }
                                },
                              ),
                            )
                ],
              ),
            ),
          ],
        ),
      );

  void refreshCard() {
    RoomViewRequest payload = RoomViewRequest();
    payload.id = widget.subjectId;
    Calls().call(jsonEncode(payload), context, Config.ROOM_VIEW).then((value) {
      var response = RoomViewResponse.fromJson(value);
      if (response.statusCode == Strings.success_code) {
        widget.averageRatingCallback!(response.rows!.otherDetails!.rating);
        widget.ratingCallback!();
        // roomData.otherDetails = response.rows.otherDetails;
      }
    });
  }
}
