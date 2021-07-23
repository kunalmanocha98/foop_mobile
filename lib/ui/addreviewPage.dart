import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/post/answersmodels.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddReviewPage extends StatefulWidget {
  String? imageUrl;
  String? name;
  int? id;
  String? ratingType;
  double? previousRating;
  int? ratingId;
  CommonCardData? data;
  bool isAssignment;
  final Null Function()? callback;
  final int? postId;
  final AnswerOtherDetails? answerOtherDetails;
  final String? answerStatus;
  final String? answerDetails;
  final int? answerId;
  final String? assignmentTitle;
  final DateTime? assignmentDate;
  final String? maxmarks;

  AddReviewPage(
      {Key? key,
        required this.ratingType,
        this.id,
        this.imageUrl,
        this.name,
        this.previousRating,
        this.ratingId,
        this.data,
        this.isAssignment = false,
        this.postId,
        this.answerOtherDetails,
        this.answerStatus,
        this.answerDetails,
        this.answerId,
        this.assignmentTitle,
        this.assignmentDate,
        this.maxmarks,
        this.callback})
      : super(key: key);

  @override
  _AddReviewPage createState() => _AddReviewPage(
      imageUrl, name, id, previousRating, ratingId, ratingType, data, callback);
}

class _AddReviewPage extends State<AddReviewPage> {
  bool isChanged = false;
  late TextStyleElements styleElements;
  String? imageUrl;
  String? name;
  int? id;
  final Null Function()? callback;
  SharedPreferences? prefs = locator<SharedPreferences>();
  String? ratingType;
  double? previousRating;
  int? ratingId;
  final controller = TextEditingController();
  final marksController = TextEditingController();
  CommonCardData? data;
  bool isLoading = false;

  @override
  void initState() {
    controller.text = data!.givenReview != "none" && data!.givenReview != "None"
        ? data!.givenReview ?? ""
        : "";
    previousRating = data!.givenRating!=null?data!.givenRating!.toDouble():0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: "Rate " + name!,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (widget.isAssignment) {
                        if (marksController.text.isNotEmpty) {
                          if(int.parse(marksController.text.toString())<=int.parse(widget.maxmarks!)) {
                            if (data!.givenratingid == null) {
                              apiCreateRatings(context);
                            } else {
                              apiUpdateRatings(context);
                            }
                            if (controller.text != null &&
                                controller.text.isNotEmpty) {
                              submitComment(controller.text);
                            }
                            submitMarks();
                          }else{
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!.translate('please_give_marks_less_than',arguments: {"marks":widget.maxmarks}),
                                context,
                                HexColor(AppColors.information));
                          }
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!.translate('please_give_marks'),
                              context,
                              HexColor(AppColors.information));
                        }
                      } else {
                        if (data!.givenratingid == null)
                          apiCreateRatings(context);
                        else
                          apiUpdateRatings(context);

                        if (controller.text != null &&
                            controller.text.isNotEmpty)
                          submitComment(controller.text);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('submit'),
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(
                              color: HexColor(AppColors.appMainColor)),
                        ),
                        Visibility(
                          visible: isLoading,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ], onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 4),
                      child: Center(
                        child: Column(
                          children: [
                            TricycleAvatar(
                              imageUrl: imageUrl,
                              size: 120,
                              isFullUrl: true,
                              key: UniqueKey(),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              child: Center(
                                child: Text(
                                  name!,
                                  style:
                                  styleElements.headline6ThemeScalable(context),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isAssignment,
                              child: Container(
                                margin:
                                EdgeInsets.only(top: 6, left: 32, right: 32),
                                child: Center(
                                  child: Text(
                                    widget.assignmentTitle ?? "",
                                    textAlign: TextAlign.center,
                                    style: styleElements
                                        .subtitle1ThemeScalable(context)
                                        .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(
                                            AppColors.appColorBlack65)),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isAssignment,
                              child: Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Center(
                                  child: Text("Submission date- "+Utility().getDateFormat('dd MMM yyyy HH:mm', widget.assignmentDate!=null?widget.assignmentDate!:DateTime.now())
                                    ,textAlign: TextAlign.center,
                                    style:
                                    styleElements.captionThemeScalable(context),
                                  ),
                                ),
                              ),
                            ),
                            /* Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              "Science",
                              style: styleElements.headline4ThemeScalable(context),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              "28 July 2020 - 3rd Period - 12:20 to 14:30",
                              style: styleElements.captionThemeScalable(context),
                            ),
                          ),
                        ),*/
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 12.w, right: 12.w, top: 8.h, bottom: 8.h),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0.w),
                          ),
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: new LinearGradient(
                                  colors: [
                                    HexColor(AppColors.appMainColor),
                                    HexColor(AppColors.appMainColor65),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 24.h,
                                    bottom: 24.h,
                                    left: 16.w,
                                    right: 16.w),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(16.w),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('leave_your_review'),
                                        style: styleElements
                                            .subtitle2ThemeScalable(context)
                                            .copyWith(
                                            color: HexColor(
                                                AppColors.appColorWhite)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 8.h,
                                          bottom: 8.h,
                                          left: 16.w,
                                          right: 16.w),
                                      child: RatingBar(
                                        initialRating:
                                        previousRating!,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 36.0,
                                        unratedColor:
                                        HexColor(AppColors.appColorBlack35),
                                        itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0.h),
                                        ratingWidget: RatingWidget(
                                            empty: Icon(
                                              Icons.star_border,
                                              color:
                                              HexColor(AppColors.appColorWhite),
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color:
                                              HexColor(AppColors.appColorWhite),
                                            ),
                                            full: Icon(
                                              Icons.star,
                                              color:
                                              HexColor(AppColors.appColorWhite),
                                            )),
                                        onRatingUpdate: (rating) {
                                          previousRating = rating;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isAssignment,
                      child: TricycleListCard(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate('marks'),
                              style: styleElements.headline6ThemeScalable(context),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('marks'),
                                    style: styleElements
                                        .bodyText2ThemeScalable(context),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Flexible(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: marksController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    cursorColor: HexColor(AppColors.appMainColor),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                        color: HexColor(AppColors.appColorBlack65)
                                    ),
                                    // scrollPadding: EdgeInsets.only(
                                    //     bottom: MediaQuery.of(context).viewInsets.bottom),
                                    decoration: InputDecoration(
                                      // focusedBorder: InputBorder.none,
                                      // enabledBorder: InputBorder.none,
                                      // errorBorder: InputBorder.none,
                                      // disabledBorder: InputBorder.none,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(4, 4, 4, 4),
                                      hintText: AppLocalizations.of(context)!
                                          .translate('marks'),
                                      hintStyle: styleElements
                                          .bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '/${widget.maxmarks}',
                                    style:
                                    styleElements.captionThemeScalable(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)!.translate('review'),
                              style: styleElements.headline6ThemeScalable(context),
                            ),
                          ),
                          Container(
                              height: 200,
                              // margin: EdgeInsets.only(top:16),
                              // decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: HexColor(AppColors.appColorGrey500),
                              //     ),
                              //     borderRadius:
                              //     BorderRadius.all(Radius.circular(8))),
                              child: TextField(
                                maxLines: 16,
                                controller: controller,
                                textInputAction: TextInputAction.newline,
                                cursorColor: HexColor(AppColors.appMainColor),
                                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                                scrollPadding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                                  hintText: AppLocalizations.of(context)!
                                      .translate('write_review'),
                                  hintStyle:
                                  styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
                                ),
                              )),
                        ],
                      ),
                    ),
                    /*  Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    width: 240,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: HexColor(AppColors.appMainColor),
                          value: isChanged,
                          onChanged: (val) {
                            if (this.mounted) {
                              setState(() {
                                isChanged = true;
                              });
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('make_anonymous'),
                              style: styleElements.bodyText2ThemeScalable(context)),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 36),
                    child: TricycleElevatedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: HexColor(AppColors.appMainColor))),
                      onPressed: () {

                        if(data.givenratingid==null)
                        apiCreateRatings(context);
                        else
                          apiUpdateRatings(context);

                      if(controller.text!=null && controller.text.isNotEmpty)
                      submitComment(controller.text??"");
                      },
                      color: HexColor(AppColors.appMainColor),
                      textColor: HexColor(AppColors.appColorWhite),
                      child: Container(
                        width: 260,
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 40, right: 40),
                        alignment: Alignment.center,
                        child: Text(
                          "Submit Rating",
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),
                        ),
                      ),
                    ),

                    // child: TricycleElevatedButton(
                    //   onPressed: (){},
                    //   textColor: HexColor(AppColors.appColorWhite),
                    //   color:HexColor(AppColors.appMainColor) ,
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 12,bottom: 12,left: 16,right: 16),
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.rectangle,
                    //         borderRadius: BorderRadius.circular(20)
                    //     ),
                    //     width: 160,
                    //     child: Text(
                    //       "Submit Rating",
                    //       style: TextStyle(
                    //           fontSize: 16,
                    //           fontFamily: 'Source sans pro',
                    //           fontWeight: FontWeight.bold
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),*/
                  ],
                ),
              ))),
    );
  }

  _AddReviewPage(this.imageUrl, this.name, this.id, this.previousRating,
      this.ratingId, this.ratingType, this.data, this.callback);

  void submitComment(String value) async {
    prefs = await SharedPreferences.getInstance();

    if (data!.givenreviewid == null) {
      var body = jsonEncode({
        "note_type": "review",
        "note_created_by_type": prefs!.getString(Strings.ownerType),
        "note_created_by_id": prefs!.getInt(Strings.userId),
        "note_subject_type": widget.isAssignment
            ? 'postanswer'
            : (ratingType == "thirdPerson" ? "person" : ratingType),
        "note_subject_id": widget.isAssignment ? widget.answerId : id,
        "note_content": value,
        "note_context_type": ratingType == "thirdPerson" ? "person" : ratingType,
        "note_context_id": id,
        "note_format": ["T"],
        "note_status": "A",
        "has_attachment": false,
        "make_anonymous": false,
      });

      GenericCommentReviewFeedback(context, body)
          .apiCallCreate()
          .then((isSuccess) async {});
    } else {
      var body = jsonEncode({
        "id": data!.givenreviewid,
        "note_type": "review",
        "note_created_by_type": prefs!.getString(Strings.ownerType),
        "note_created_by_id": prefs!.getInt(Strings.userId),
        "note_subject_type":
        ratingType == "thirdPerson" ? "person" : ratingType,
        "note_subject_id": id,
        "note_context_type": ratingType == "thirdPerson" ? "person" : ratingType,
        "note_context_id": id,
        "note_content": value,
        "note_format": ["T"],
        "note_status": "A",
        "has_attachment": false,
        "make_anonymous": false,
      });
      GenericCommentReviewFeedback(context, body)
          .apiCallUpdate()
          .then((isSuccess) async {});
    }
  }

  void apiCreateRatings(BuildContext ctx) async {
    prefs = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "rating_note_id": null,
      "rating_subject_type": widget.isAssignment
          ? 'postanswer'
          : (ratingType == "thirdPerson" ? "person" : ratingType),
      "rating_subject_id": widget.isAssignment ? widget.answerId : id,
      "rating_context_type":
      ratingType == "thirdPerson" ? "person" : ratingType,
      "rating_context_id": id,
      "rating_given_by_id": prefs!.getInt("userId"),
      "rating_given": previousRating
    });
    setState(() {
      isLoading = true;
    });
    Calls().call(body, ctx, Config.CREATE_RATINGS).then((value) async {
      if (value != null) {
        setState(() {
          isLoading = false;
        });
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          callback!();
          Navigator.of(ctx).pop(true);
        } else {
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,
              HexColor(AppColors.information));
        }
      } else {
        ToastBuilder().showToast(
            "Please Try Again", ctx, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      setState(() {
        isLoading = false;
      });
      ToastBuilder()
          .showToast(onError.toString(), ctx, HexColor(AppColors.information));
      print(onError.toString());
    });
  }

  void apiUpdateRatings(BuildContext ctx) async {
    prefs = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "id": data!.givenratingid,
      "rating_note_id": null,
      "rating_subject_type":
      ratingType == "thirdPerson" ? "person" : ratingType,
      "rating_subject_id": id,
      "rating_context_type": prefs!.getString(Strings.ownerType),
      "rating_context_id": ratingType == "person" ? prefs!.getInt("userId") : id,
      "rating_given_by_id": prefs!.getInt("userId"),
      "rating_given": previousRating
    });
    setState(() {
      isLoading = true;
    });
    Calls().call(body, ctx, Config.UPDATE_RATINGS).then((value) async {
      if (value != null) {
        setState(() {
          isLoading = false;
        });
        var data = DynamicResponse.fromJson(value);
        if (data != null && data.statusCode == 'S10001') {
          callback!();
          Navigator.of(ctx).pop(true);
        } else {
          setState(() {
            isLoading = false;
          });
          ToastBuilder().showToast(data.message ?? "Please Try Again", ctx,
              HexColor(AppColors.information));
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ToastBuilder().showToast(
            "Please Try Again", ctx, HexColor(AppColors.information));
      }
    }).catchError((onError) async {
      setState(() {
        isLoading = false;
      });
      ToastBuilder()
          .showToast(onError.toString(), ctx, HexColor(AppColors.information));
      print(onError.toString());
    });
  }

  void submitMarks() async{
    CreateAnswerPayload payload = CreateAnswerPayload();
    payload.id = widget.answerId;
    payload.answerStatus =widget.answerStatus;
    payload.answerDetails = widget.answerDetails;
    payload.answerOtherDetails = AnswerOtherDetails(
      mediaDetails: widget.answerOtherDetails!=null?widget.answerOtherDetails!.mediaDetails:null,
      marks: marksController.text.toString()
    );
    Calls().call(jsonEncode(payload), context, Config.ANSWER_UPDATE);
  }
}
