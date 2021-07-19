import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:oho_works_app/components/tricycleHtmlViewer.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/post/answersmodels.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/ui/addreviewPage.dart';
import 'package:oho_works_app/ui/report_abuse.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'dialogs/ratingcarddialog.dart';

// ignore: must_be_immutable
class CommentItemCard extends StatefulWidget {
  NotesListItem data;
  TextStyleElements styleElements;
  BuildContext context;
  Function ratingCallBack;
  bool isAnswer;
  Color color;
  bool isAssignment;
  double rating;
  String reviewNote;
  AnswerOtherDetails answerOtherDetails;
  String answerStatus;
  int postId;
  DateTime assignmentDate;
  String assignmentTitle;
  String maxMarks;
  Function refreshCallback;
  bool isGiveMarksVisible;

  CommentItemCard({Key key,
    @required this.data,
    this.styleElements,
    this.ratingCallBack,
    this.color,
    this.isAssignment = false,
    this.isAnswer = false,
    this.isGiveMarksVisible = false,
    this.rating,
    this.reviewNote,
    this.answerOtherDetails,
    this.answerStatus,
    this.assignmentDate,
    this.postId,
    this.assignmentTitle,
    this.refreshCallback,
    this.maxMarks
  })
      : super(key: key);

  @override
  CommentItemCardState createState() =>
      CommentItemCardState(
          data: data,
          styleElements: styleElements,
          ratingCallBack: ratingCallBack,
          color: color,
          isAnswer: isAnswer);
}

class CommentItemCardState extends State<CommentItemCard> {
  NotesListItem data;
  TextStyleElements styleElements;
  Function ratingCallBack;
  bool isAnswer;
  Color color;

  CommentItemCardState({@required this.data,
    this.styleElements,
    this.ratingCallBack,
    this.color,
    this.isAnswer});

  Widget _simplePopup() =>
      PopupMenuButton<int>(
        padding: EdgeInsets.all(0),

        itemBuilder: (context) =>
        [
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context).translate('report_abuse')),
          ),
        ],
        onSelected: (value) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ReportAbuse(
                    contextId: data.note_id,
                    contextType: CONTEXTTYPE_ENUM.COMMENT.type,
                  )));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => CommentsPage("Comments")));
        },
        icon: Icon(
          Icons.more_vert,
          size: 20,
          color: HexColor(AppColors.appColorBlack65),
        ),
      );

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Container(
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
        color: color ??= HexColor(AppColors.appColorWhite),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                TricycleAvatar(
                  size: 24,
                  imageUrl: data.notesCreatedByProfile,
                  resolution_type: RESOLUTION_TYPE.R64,
                  service_type: SERVICE_TYPE.PERSON,
                ),
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: (isAnswer != null && isAnswer)
                          ? EdgeInsets.only(left: 4, right: 4)
                          : EdgeInsets.only(left: 4, right: 4, top: 14),
                      child: Text(
                        data.notesCreatedByName ??= "Name",
                        style: styleElements
                            .subtitle2ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    (isAnswer != null && isAnswer)
                        ? Container()
                        : Padding(
                      padding: EdgeInsets.only(left: 4.0, top: 4),
                      child: RatingBar(
                        initialRating: double.parse(data.postRate != null
                            ? data.postRate.toString()
                            : "0"),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 14.0,
                        itemPadding: EdgeInsets.all(0),
                        ratingWidget: RatingWidget(
                            empty: Icon(
                              Icons.star_border,
                              color: HexColor(AppColors.appMainColor),
                            ),
                            half: Icon(
                              Icons.star_half,
                              color: HexColor(AppColors.appMainColor),
                            ),
                            full: Icon(
                              Icons.star,
                              color: HexColor(AppColors.appMainColor),
                            )),
                        // itemBuilder: (context, _) => Icon(
                        //   Icons.star,
                        //   color: HexColor(AppColors.appMainColor),
                        // ),
                        onRatingUpdate: null,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 12, right: 8),
                  child: Text(
                    (isAnswer != null && isAnswer)
                        ? Utility().getDateFormat(
                        "dd MMM yyyy,hh:mm",
                        data.createdDate != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                            int.parse(data.createdDate))
                            : DateTime.now())
                        : Utility().getDateFormat(
                        "dd MMM yyyy,hh:mm",
                        data.createdDate != null
                            ? DateTime.parse(data.createdDate)
                            : DateTime.now()),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(fontSize: 10),
                  ),
                ),

                Spacer(),
                Visibility(
                  visible: !widget.isAssignment,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: _simplePopup(),
                  ),
                ),
                // _simplePopup(),
              ],
            ),
            (isAnswer) ?
            TricycleHtmlViewer(
              isNewsPage: false,
              isDetailPage: true,
              sourceString: data.noteContent,
            )
            // Html(data: data.noteContent, shrinkWrap: true, style: {
            //   "body": Style(
            //     fontSize: FontSize(20)
            //   ),
            // })
                : Padding(
              padding: EdgeInsets.only(top: 12, bottom: 2),
              child: Text(
                data.noteContent ??= "content",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: styleElements.subtitle2ThemeScalable(context),
              ),
            ),
            Visibility(
              visible: !(isAnswer != null && isAnswer),
              child: Row(
                children: [
                  Text(
                    data.commRateCount != null
                        ? data.commRateCount.toString()
                        : "0",
                    style: styleElements.captionThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appMainColor),
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor: HexColor(AppColors.appColorTransparent),
                          barrierDismissible: true,
                          builder: (BuildContext context) =>
                              RatingCardDialog(
                                contextId: int.parse(data.noteCreatedById),
                                contexType: data.noteCreatedByType,
                                subjectId: data.note_id,
                                subjectType: 'comment',
                              )).then((value) {
                        if (value) {
                          ratingCallBack();
                          // setState(() {
                          //   data.commRateCount = data.commRateCount+1;
                          // });
                        }
                      });
                    },
                    splashRadius: 30,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.star,
                      size: 16,
                      color: HexColor(AppColors.appMainColor),
                    ),
                  ),
                  // TricycleTextButton(
                  //     onPressed: () {},
                  //     shape: RoundedRectangleBorder(),
                  //     padding: EdgeInsets.all(0),
                  //     child: Text(
                  //       'reply',
                  //       style:
                  //       styleElements.captionThemeScalable(context).copyWith(
                  //         color: HexColor(AppColors.appMainColor),
                  //       ),
                  //     ))
                ],
              ),
            ),

            Visibility(
              visible: widget.isAssignment,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8,),
                  Visibility(
                    visible: (widget.answerOtherDetails!=null && widget.answerOtherDetails.mediaDetails!=null && widget.answerOtherDetails.mediaDetails.length>0),
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (widget.answerOtherDetails!=null && widget.answerOtherDetails.mediaDetails!=null)?
                        widget.answerOtherDetails.mediaDetails.length:0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(left: 4,right: 4),
                            child: InkWell(
                              onTap: (){
                                // TricycleDownloadButtonState.requestDownloadFromOutSide(widget.answerOtherDetails.mediaDetails[index].mediaUrl);
                              },
                              child: Chip(
                                label: Text(getFileName(widget.answerOtherDetails.mediaDetails[index].mediaUrl)),
                                padding: EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(children: [
                    Text(
                      "${widget.rating}",
                      style: styleElements.captionThemeScalable(context)
                          .copyWith(
                          color: HexColor(AppColors.appMainColor),
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: HexColor(AppColors.appMainColor),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      "Marks- ${(widget.answerOtherDetails!=null && widget.answerOtherDetails.marks!=null)?widget.answerOtherDetails.marks:"0"}/${widget.maxMarks}",
                      style: styleElements.captionThemeScalable(context)
                          .copyWith(
                          color: HexColor(AppColors.appMainColor),
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Visibility(
                      visible: widget.isGiveMarksVisible,
                      child: TricycleTextButton(
                        onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (
                            BuildContext context) {
                          return AddReviewPage(isAssignment: true,
                            ratingType:data.noteCreatedByType,
                            id:int.parse(data.noteCreatedById),
                            name: data.notesCreatedByName,
                            imageUrl:Utility().getUrlForImage(data.notesCreatedByProfile , RESOLUTION_TYPE.R64, SERVICE_TYPE.PERSON),
                            answerDetails: data.noteContent,
                            answerOtherDetails: widget.answerOtherDetails,
                            answerStatus: widget.answerStatus,
                            answerId: data.note_id,
                            postId: widget.postId,
                            data: CommonCardData(),
                            assignmentDate: widget.assignmentDate,
                            assignmentTitle: widget.assignmentTitle,
                            maxmarks: widget.maxMarks,
                            callback: (){},
                          );
                        })).then((value) {
                          widget.refreshCallback();
                        }); },
                        child: Text(
                          AppLocalizations.of(context).translate('give_marks'),
                          style: styleElements.captionThemeScalable(context)
                              .copyWith(
                              color: HexColor(AppColors.appMainColor),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ]),
                  SizedBox(height: 4,),

                  Visibility(
                    visible: widget.reviewNote != null &&
                        widget.reviewNote.isNotEmpty,
                    child: Text(
                      AppLocalizations.of(context).translate('review_note'),
                      style: styleElements
                          .subtitle1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: widget.reviewNote != null &&
                        widget.reviewNote.isNotEmpty,
                    child: Text(widget.reviewNote ?? "",
                      style: styleElements.bodyText2ThemeScalable(context),
                    ),
                  ),
                  SizedBox(height: 8,),
                ],
              ),
            ),


          ],
        ));
  }

  String getFileName(String mediaUrl) {
    if(mediaUrl!=null && mediaUrl.isNotEmpty){
      var s = mediaUrl.split('/');
      return s[s.length - 1];
    }else{
      return "";
    }
  }
}
