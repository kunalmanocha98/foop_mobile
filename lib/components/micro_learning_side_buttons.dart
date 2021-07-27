import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/updaterecipientlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/buttonTapNotifier.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MicroLearningSideButtons extends StatefulWidget {
  Statistics? stats;
  Function? sharecallBack;
  Function(bool)? bookmarkCallback;
  Function? commentCallback;
  Function? ratingCallback;
  SharedPreferences? prefs;
  bool? isBookMarked;
  int? postId;
  bool? isRated;
  bool? isDocument;
  bool? isDarkTheme;
  int? ownerId;
  String? ownerType;
  String? mediaUrl;
  bool isCommentVisible;
  bool isBookMarkVisible;
  bool isShareVisible;
  int? subjectId;
  String? subjectType;
  Color? backgroundColor;
  bool isInviteUserVisible;
  Function? inviteuserCallback;
  bool rateCountShow;
  Function? ratingFunction;
  bool applyTimeCheck;
  DateTime? startTime;
  int? minimumMinutes;
  int? totalMinutes;
  Widget? actionButton;
  bool isRatingVisible;
  bool isTalkIconVisible;
  Function? filterCallBack;
  Function? translateCallback;
  bool isTranslateVisible;
  Function? textToSpeechCallback;
  bool? isTextToSpeechVisible;
  // GlobalKey<appDownloadButtonState> downloadButtonKey;
  List<Media>? media;
Function? homeCallBack;
Function? searchCallBAck;
bool isPlaying;
bool isLoading;


  MicroLearningSideButtons(
      {this.stats,
        this.searchCallBAck,
        this.sharecallBack,
        this.bookmarkCallback,
        this.ratingCallback,
        this.isRated,
        this.homeCallBack,
        this.isDocument,
        this.commentCallback,
        this.prefs,
        this.isBookMarked,
        this.postId,
        this.isDarkTheme,
        this.ownerType,
        this.mediaUrl,
        this.ratingFunction,
        this.isCommentVisible = true,
        this.isRatingVisible = true,
        this.backgroundColor,
        this.subjectId,
        this.subjectType,
        this.isShareVisible =true,
        this.isBookMarkVisible = true,
        this.isInviteUserVisible= false,
        this.rateCountShow= true,
        this.applyTimeCheck = false,
        this.isTranslateVisible = false,
        this.isPlaying =false,
        this.isLoading = false,
        this.actionButton,
        this.startTime,
        this.minimumMinutes,
        this.totalMinutes,
        this.inviteuserCallback,
        this.filterCallBack,
        this.isTalkIconVisible = false,
        this.translateCallback,
        this.isTextToSpeechVisible,
        this.textToSpeechCallback,
        this.media,
        // this.downloadButtonKey,
        this.ownerId}) {
    this.stats = stats ?? Statistics();
  }

  @override
  MicroLearningSideButtonsState createState() => MicroLearningSideButtonsState(
      stats: stats,
      isBookMarked: isBookMarked,
      isRated: isRated,
      isDocument: isDocument,
      ratingCallback: ratingCallback,
      sharecallBack: sharecallBack,
      postId: postId,
      mediaUrl: mediaUrl,
      bookmarkCallback: bookmarkCallback,
      commentCallback: commentCallback,
      prefs: prefs,
      media:media,
      // downloadButtonKey: downloadButtonKey,
      isDarkTheme: isDarkTheme,
      ownerType: ownerType,
      ownerId: ownerId);
}

class MicroLearningSideButtonsState extends State<MicroLearningSideButtons> {
  TextStyleElements? styleElements;
  Statistics? stats;
  Function? sharecallBack;
  String? mediaUrl;
  Function(bool)? bookmarkCallback;
  Function? commentCallback;
  Function? ratingCallback;
  bool? isRated;
  bool? isDocument;
  bool? isDarkTheme;
  SharedPreferences? prefs;
  bool? isBookMarked;
  int? postId;
  int counter = 0;
  String? ownerType;
  int? ownerId;
  // GlobalKey<appDownloadButtonState> downloadButtonKey;
  List<Media>? media;
  ButtonTapManager buttonTapManager = ButtonTapManager();


  MicroLearningSideButtonsState(
      {this.stats,
        this.sharecallBack,
        this.bookmarkCallback,
        this.commentCallback,
        this.mediaUrl,
        this.isRated,
        this.isDocument,
        this.ratingCallback,
        this.prefs,
        this.isBookMarked,
        this.postId,
        this.ownerId,
        this.ownerType,
        this.media,
        // this.downloadButtonKey,
        this.isDarkTheme}) {
    isDarkTheme ??= false;
  }


  @override
  void didUpdateWidget(MicroLearningSideButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    print("refreshing post card actions button");
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.school_outlined,
                  color: isDarkTheme!
                      ? HexColor(AppColors.appColorWhite)
                      : HexColor(AppColors.appColorBlack35),
                ),
                onPressed: widget.homeCallBack as void Function()?,
              ),
            ),
          ),

          Visibility(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: isDarkTheme!
                      ? HexColor(AppColors.appColorWhite)
                      : HexColor(AppColors.appColorBlack35),
                ),
                onPressed: widget.filterCallBack as void Function()?,
              ),
            ),
          ),
          Visibility(
            visible: widget.isTextToSpeechVisible ?? false,
            child: IconButton(
              icon: widget.isLoading?
                 CustomPaginator(context).loadingWidgetMaker()
              :Icon(widget.isPlaying
                ?Icons.pause_circle_outline_rounded
                :Icons.play_circle_outline,
                color: isDarkTheme!
                    ? HexColor(AppColors.appColorWhite)
                    : HexColor(AppColors.appColorBlack35),
              ),
              onPressed:widget.isLoading?null: (){
                setState(() {
                  widget.isLoading = true;
                  widget.textToSpeechCallback!();
                });
              }
            ),
          ),
          Visibility(
            visible: widget.isTranslateVisible,
            child: IconButton(
              icon: Icon(
                Icons.translate,
                color: isDarkTheme!
                    ? HexColor(AppColors.appColorWhite)
                    : HexColor(AppColors.appColorBlack35),
              ),
              onPressed: widget.translateCallback as void Function()?,
            ),
          ),

          Visibility(
            visible: widget.isTranslateVisible,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: isDarkTheme!
                    ? HexColor(AppColors.appColorWhite)
                    : HexColor(AppColors.appColorBlack35),
              ),
              onPressed: widget.searchCallBAck as void Function()?,
            ),
          ),
        ],
      ),
    );
  }

  void bookmarkPost() {
    PostRecipientUpdatePayload payload = PostRecipientUpdatePayload();
    payload.postId = postId;
    payload.postRecipientStatus = null;
    payload.isBookmarked = isBookMarked != null ? !isBookMarked! : false;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_RECIPIENT_LIST).then((value) {
      // PostCreateResponse res = PostCreateResponse.fromJson(value);
      // if (res.statusCode == Strings.success_code) {
      //   ToastBuilder()
      //       .showToast(res.message, context, HexColor(AppColors.information));
      //
      // } else {
      //   ToastBuilder()
      //       .showToast(res.message, context, HexColor(AppColors.information));
      // }
    }).catchError((onError) {
      print(onError);
    });

    setState(() {
      if (isBookMarked != null) {
        isBookMarked = !isBookMarked!;
      } else {
        isBookMarked = true;
      }
    });
    bookmarkCallback!(isBookMarked!);
  }
}
