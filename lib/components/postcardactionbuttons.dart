import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/updaterecipientlist.dart';
import 'package:oho_works_app/profile_module/pages/raters_page.dart';
import 'package:oho_works_app/ui/dialogs/ratingcarddialog.dart';
import 'package:oho_works_app/ui/dialogs/set_reminder_dilog.dart';
import 'package:oho_works_app/ui/dialogs/sorry_rate_dialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/buttonTapNotifier.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PostCardActionButtons extends StatefulWidget {
  Statistics? stats;
  Function? sharecallBack;
  Function(bool?)? bookmarkCallback;
  Function? commentCallback;
  Function? ratingCallback;
  SharedPreferences? prefs;
  bool? isBookMarked;
  int? postId;
  Function? bookMarkCallBack;
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
  Function? talkCallback;
  Function? translateCallback;
  bool? isTranslateVisible;
  Function? textToSpeechCallback;
  bool? isTextToSpeechVisible;
  bool? isBellAvailable;
  bool? isBellPressed;

  // GlobalKey<appDownloadButtonState> downloadButtonKey;
  List<Media>? media;
  Function? bellIconCallBack;


  PostCardActionButtons(
      {this.stats,
        this.bellIconCallBack,
        this.isBellPressed,
        this.isBellAvailable,
        this.sharecallBack,
        this.bookmarkCallback,
        this.ratingCallback,
        this.isRated,
        this.isDocument,
        this.commentCallback,
        this.prefs,
        this.bookMarkCallBack,
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
        this.actionButton,
        this.startTime,
        this.minimumMinutes,
        this.totalMinutes,
        this.inviteuserCallback,
        this.talkCallback,
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
  PostCardActionButtonsState createState() => PostCardActionButtonsState(
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
      media: media,
      // downloadButtonKey: downloadButtonKey,
      isDarkTheme: isDarkTheme,
      ownerType: ownerType,
      ownerId: ownerId);
}

class PostCardActionButtonsState extends State<PostCardActionButtons> {
  late TextStyleElements styleElements;
  Statistics? stats;
  Function? sharecallBack;
  String? mediaUrl;
  Function(bool?)? bookmarkCallback;
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

  PostCardActionButtonsState(
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
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    print("refreshing post card actions button");
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: ((stats!.starRating ?? 0) > 0 ||
                    (stats!.commentCount ?? 0) > 0) &&
                widget.rateCountShow,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RatersPage(
                            id: postId,
                            name: prefs!.getString(Strings.userName),
                            ratingId: 0,
                            imageUrl: "",
                            ratingType: 'post',
                            ownerId: widget.ownerId,
                            ownerType: widget.ownerType,
                            data: null,
                            callback: () {})));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: (stats!.starRating).toString(),
                        style: styleElements
                            .captionThemeScalable(context)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme!
                                    ? HexColor(AppColors.appColorWhite)
                                    : HexColor(AppColors.appColorBlack35))),
                    TextSpan(
                        text: ' rated ',
                        style: styleElements
                            .captionThemeScalable(context)
                            .copyWith(
                                color: isDarkTheme!
                                    ? HexColor(AppColors.appColorWhite)
                                    : HexColor(AppColors.appColorBlack35))),
                    widget.isCommentVisible
                        ? TextSpan(
                            text: stats!.commentCount.toString(),
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkTheme!
                                        ? HexColor(AppColors.appColorWhite)
                                        : HexColor(AppColors.appColorBlack35)))
                        : WidgetSpan(child: Container()),
                    widget.isCommentVisible
                        ? TextSpan(
                            text: ' commented',
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(
                                    color: isDarkTheme!
                                        ? HexColor(AppColors.appColorWhite)
                                        : HexColor(AppColors.appColorBlack35)))
                        : WidgetSpan(child: Container()),
                  ]),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Visibility(
                visible: widget.isRatingVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: IconButton(
                    icon: (isRated != null && isRated!)
                        ? Icon(
                            Icons.star,
                            color: HexColor(AppColors.appMainColor),
                          )
                        : Icon(
                            Icons.star_border_outlined,
                            color: isDarkTheme!
                                ? HexColor(AppColors.appColorWhite)
                                : HexColor(AppColors.appColorBlack35),
                          ),
                    onPressed: widget.ratingFunction != null
                        ? widget.ratingFunction as void Function()?
                        : () {
                            if (widget.applyTimeCheck) {
                              if (Utility().getTotalMinutes(
                                      widget.totalMinutes!, widget.startTime!) >=
                                  widget.minimumMinutes!) {
                                showDialog(
                                    context: context,
                                    barrierColor:
                                        HexColor(AppColors.appColorTransparent),
                                    barrierDismissible: true,
                                    builder: (BuildContext context) =>
                                        RatingCardDialog(
                                          contextId: ownerId,
                                          contexType: ownerType,
                                          subjectId: widget.subjectId ?? postId,
                                          subjectType:
                                              widget.subjectType ?? 'post',
                                        )).then((value) {
                                  if (value) {
                                    setState(() {
                                      if (!isRated!) {
                                        if (stats!.starRating != null)
                                          stats!.starRating =
                                              stats!.starRating! + 1;
                                      }
                                      isRated = true;
                                      ratingCallback!();
                                    });
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SorryRateDialog();
                                    });
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  barrierColor:
                                      HexColor(AppColors.appColorTransparent),
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      RatingCardDialog(
                                        contextId: ownerId,
                                        contexType: ownerType,
                                        subjectId: widget.subjectId ?? postId,
                                        subjectType:
                                            widget.subjectType ?? 'post',
                                      )).then((value) {
                                if (value) {
                                  setState(() {
                                    if (!isRated!) {
                                      if (stats!.starRating != null)
                                        stats!.starRating = stats!.starRating! + 1;
                                    }
                                    isRated = true;
                                    ratingCallback!();
                                  });
                                }
                              });
                            }
                            // this._overlayEntry = this.createOverlayforRating();
                            // Overlay.of(context).insert(this._overlayEntry);
                          },
                  ),
                ),
              ),
              Visibility(
                visible: widget.isCommentVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: isDarkTheme!
                          ? HexColor(AppColors.appColorWhite)
                          : HexColor(AppColors.appColorBlack35),
                    ),
                    onPressed: commentCallback as void Function()?,
                  ),
                ),
              ),
              Visibility(
                visible: widget.isShareVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: isDarkTheme!
                          ? HexColor(AppColors.appColorWhite)
                          : HexColor(AppColors.appColorBlack35),
                    ),
                    onPressed: sharecallBack as void Function()?,
                  ),
                ),
              ),
              /*  Visibility(
                visible: mediaUrl!=null,
                child:mediaUrl!=null?GenericDownloader(
                 fileUrl: Config.BASE_URL+mediaUrl??"",
                  fileName:"test",
                ):Container(),
              ),*/
              Visibility(
                visible: widget.isTalkIconVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.mic_none_rounded,
                      color: isDarkTheme!
                          ? HexColor(AppColors.appColorWhite)
                          : HexColor(AppColors.appColorBlack35),
                    ),
                    onPressed: widget.talkCallback as void Function()?,
                  ),
                ),
              ),
              Spacer(),
              Visibility(
                visible: widget.isTextToSpeechVisible ?? false,
                child: IconButton(
                  icon: Icon(
                    Icons.multitrack_audio_rounded,
                    color: isDarkTheme!
                        ? HexColor(AppColors.appColorWhite)
                        : HexColor(AppColors.appColorBlack35),
                  ),
                  onPressed: widget.textToSpeechCallback as void Function()?,
                ),
              ),
              Visibility(
                visible: widget.isTranslateVisible ?? false,
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

              // (media!=null && media.length>0 && isDocument)?appDownloadButton(key:downloadButtonKey,isDarkTheme: isDarkTheme,listOfLinks: List<String>.generate(media.length,(int index){return media[index].mediaUrl;}),
              // ):Container(),
              // appDownloadButton(listOfLinks: ["https://www.tricycle.life/logo.png"],key: UniqueKey(),),
              widget.actionButton != null
                  ? widget.actionButton!
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: widget.isBellAvailable!=null && widget.isBellAvailable!,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: IconButton(
                                icon: (widget.isBellPressed != null &&
                                        widget.isBellPressed!)
                                    ? Icon(
                                        Icons.alarm,
                                        color: HexColor(AppColors.appMainColor),
                                      )
                                    : Icon(
                                        Icons.alarm,
                                        color: isDarkTheme!
                                            ? HexColor(AppColors.appColorWhite)
                                            : HexColor(
                                                AppColors.appColorBlack35),
                                      ),
                                onPressed: () {
                                  if (!buttonTapManager.buttonState) {
                                    buttonTapManager.buttonPressed();

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SetReminderDilog(
                                              updateButton: () {
                                                setReminder(widget.subjectId);
                                              },
                                            ));
                                  }
                                }),
                          ),
                        ),
                        Visibility(
                          visible: widget.isBookMarkVisible,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: IconButton(
                                icon: (isBookMarked != null && isBookMarked!)
                                    ? Icon(
                                        Icons.bookmark,
                                        color: HexColor(AppColors.appMainColor),
                                      )
                                    : Icon(
                                        Icons.bookmark_border_outlined,
                                        color: isDarkTheme!
                                            ? HexColor(AppColors.appColorWhite)
                                            : HexColor(
                                                AppColors.appColorBlack35),
                                      ),
                                onPressed: () {
                                  if (!buttonTapManager.buttonState) {
                                    buttonTapManager.buttonPressed();
                                    bookmarkPost();
                                  }
                                }),
                          ),
                        ),
                        Visibility(
                          visible: widget.isInviteUserVisible,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.group_add_outlined,
                                  color: HexColor(AppColors.appColorBlack35),
                                ),
                                onPressed: () {
                                  if (!buttonTapManager.buttonState) {
                                    buttonTapManager.buttonPressed();
                                    widget.inviteuserCallback!();
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
            ],
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
    bookmarkCallback!(isBookMarked);
  }

  setReminder(int? id) async {
    var body = jsonEncode({"event_id": id});

    Calls().call(body, context, Config.SET_REMINDER_CALENDAR).then((value) {
      var res = BaseResponses.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          if (widget.bellIconCallBack != null) widget.bellIconCallBack!();
          if (widget.isBellPressed != null) {
            widget.isBellPressed = !widget.isBellPressed!;
          } else {
            widget.isBellPressed = true;
          }
        });
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("something_wrong"),
            context,
            HexColor(AppColors.information));
      }
    });
  }
}
