
import 'dart:math';

import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/app_auto_size_text.dart';
import 'package:oho_works_app/components/app_user_images_list.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class appLessonCard extends StatefulWidget {
  final Function? onPressed;
  final bool? headerVisible;
  final PostListItem? item;
  Function(bool)? onFollowCallback;
  Function? hidePostCallback;
  Function? deletePostCallback;
  Function? sharecallBack;
  Function(bool?)? bookmarkCallback;
  Function? commentCallback;
  Function? ratingCallback;
  Function? onTalkCallback;
  Function? editCallback;
  appLessonCard({
    this.onPressed,

    this.headerVisible,
    this.item,
  this.onFollowCallback,
  this.hidePostCallback,
    this.deletePostCallback,
    this.sharecallBack,
    this.bookmarkCallback,
    this.ratingCallback,
    this.commentCallback,
    this.onTalkCallback,
    this.editCallback
  });
  @override
  _appLessonCard createState() => _appLessonCard(item: item);
}

class _appLessonCard extends State<appLessonCard> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  PostListItem? item;
  String? status;
  _appLessonCard({this.item});
  @override
  Widget build(BuildContext context) {
    status = getStatus();
    styleElements = TextStyleElements(context);
    return appListCard(
      onTap: widget.onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: widget.headerVisible!,
                child: SizedBox(height: 8,)),
            Visibility(
              visible: widget.headerVisible!,
              child: PostCardHeader(
                key: UniqueKey(),
                prefs: prefs,
                postListItem: item,
                isLesson:true,
                onFollowCallback: widget.onFollowCallback,
                isBackButtonVisible: false,
                onBackPressed: null,
                hidePostCallback: widget.hidePostCallback,
                deletePostCallback: widget.deletePostCallback,
                isFollowing: getIsFollowing(),
                isDarkTheme: false,
                editCallback: widget.editCallback,
              )
            ),
            SizedBox(height: 16,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Container(
                 height: 100,width: 70,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child:appAutoSizeText(item!.postContent!.content!.contentMeta!.title!.toUpperCase(),
                     style: styleElements.headline6ThemeScalable(context).copyWith(
                       color: HexColor(AppColors.appColorWhite),
                       fontWeight: FontWeight.bold
                     ),
                   maxLines: 4,) ,
                   // Text(item.postContent.content.contentMeta.title.toUpperCase(),
                   // softWrap: true,
                   // style: styleElements.headline6ThemeScalable(context).copyWith(
                   //   color: HexColor(AppColors.appColorWhite),
                   //   fontSize: 36,
                   //   fontWeight: FontWeight.bold
                   // ),),
                 ),
                 decoration: BoxDecoration(
                   color: item!.bookcovercolor ??= Colors.accents[Random().nextInt(Colors.accents.length)],
                   borderRadius: BorderRadius.circular(4),
                   // image: DecorationImage(
                   //   image: CachedNetworkImageProvider(
                   //     "https://i.pinimg.com/564x/2f/67/16/2f6716cf33aff2bec88296e8d213011b.jpg"
                   //   ),
                   //   fit: BoxFit.fill
                   // )
                 ),
               ),
                Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8, bottom: 2),
                      child: Column(mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          item!.postContent!.content!.contentMeta!.title?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item!.postContent!.statistics!.starRating!.toDouble()} ',
                              style: styleElements
                                  .subtitle1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(AppColors.appMainColor),
                                  fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                              visible: true,
                              child: RatingBar(
                                initialRating: item!.postContent!.statistics!.starRating!.toDouble(),
                                ignoreGestures: true,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 15.0,
                                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                ratingWidget: RatingWidget(
                                  empty: Icon(
                                    Icons.star_outline,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                  half: Icon(
                                    Icons.star_half_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                  full: Icon(
                                    Icons.star_outlined,
                                    color: HexColor(AppColors.appMainColor),
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: status!=null,
                          child: Text(
                           status!=null?status!:"",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleElements.bodyText2ThemeScalable(context),
                          ),
                        ),

                            (item!.membersList!=null && item!.membersList!.length>0)?Padding(
                          padding: EdgeInsets.only(top:8),
                          child: appUserImageList(
                            listOfImages: List<String?>.generate(item!.membersList!.length,(int index){
                              return item!.membersList![index].profileImage;
                            }),
                          ),
                        ):Container(),

                            Row(
                              children: [
                                Text("${(item!.lessonReadDetails!=null && item!.lessonReadDetails!.percentage!=null)?item!.lessonReadDetails!.percentage:0}%"),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left:16,top:8,bottom: 8),
                                    child: LinearPercentIndicator(
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      animation: true,
                                      padding: EdgeInsets.all(0),
                                      animationDuration: 900,
                                      lineHeight: 6,
                                      percent: (item!.lessonReadDetails!=null && item!.lessonReadDetails!.percentage!=null)?item!.lessonReadDetails!.percentage!/100:0.0,
                                      backgroundColor: HexColor(AppColors.pollBackground),
                                      progressColor: HexColor(AppColors.appMainColor).withOpacity(0.75),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ]),
                    ))
              ],
            ),
            PostCardActionButtons(
              isCommentVisible: false,
                isTranslateVisible: false,
                translateCallback: null,
                isTextToSpeechVisible: false,
                textToSpeechCallback: null,
                // downloadButtonKey: downloadButtonKey,
                media:null,
                ownerId: item!.postOwnerTypeId,
                ownerType: item!.postOwnerType,
                isDocument: false,
                stats: item!.postContent!.statistics,
                isBookMarked: item!.isBookmarked,
                isRated: getIsRated(),
                isTalkIconVisible:true,
                talkCallback: widget.onTalkCallback,
                mediaUrl: "",
                sharecallBack: widget.sharecallBack,
                bookmarkCallback: widget.bookmarkCallback,
                commentCallback: widget.commentCallback,
                ratingCallback: widget.ratingCallback,
                prefs: prefs,
                postId: item!.postId
            )
          ],
        ));
  }
  bool getIsRated() {
    bool? isRated;
    for (var i in item!.postContent!.header!.action!) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }
  bool getIsFollowing() {
    bool? isFollowed;
    for (var i in item!.postContent!.header!.action!) {
      if (i.type == 'is_followed') {
        isFollowed = i.value;
        break;
      }
    }
    return isFollowed ??= false;
  }

  String? getStatus() {
    String? status ="";
    try {
      if (item!.affiliatedList != null && item!.affiliatedList!.length > 0) {
        status = status+item!.affiliatedList![0].organizationName!;
        status = status+", ";
      }
      if (item!.programmesList != null && item!.programmesList!.length > 0) {
        status = status+item!.programmesList![0].programName!;
        status = status+", ";
      }
      if (item!.disciplineList != null && item!.disciplineList!.length > 0) {
        status = status+item!.disciplineList![0].departmentName!;
        status = status+", ";
      }
      if (item!.classesList != null && item!.classesList!.length > 0) {
        status = status+item!.classesList![0].className!;
      }
    }catch(error){
      status=null;
    }
    return status;
  }
}
