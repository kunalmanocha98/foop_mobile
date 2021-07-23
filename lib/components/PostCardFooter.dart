import 'package:oho_works_app/components/tricycleHtmlViewer.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/models/post/dateTagPostComponent.dart';
import 'package:oho_works_app/models/post/postPollComponent.dart';
import 'package:oho_works_app/models/post/postTagComponent.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class PostCardFooter extends StatefulWidget {
  Content? contentData;
  Statistics? stats;
  Function? commentCallback;
  bool? isDetailPage;
  int? dateTime;
  String? postType;
  Function? onAnswerClickCallback;
  Function? onVoteCallback;
  int? postId;
  bool isVoted;
  int? postOwnerTypeId;
  SharedPreferences? prefs;
  bool? isNewsPage;
  String? webLink;
  bool? isFilterPage;
  Function? onSubmitAnswer;
  String? searchHighlightWord;

  PostCardFooter(
      {this.contentData,
        this.stats,
        this.commentCallback,
        this.isDetailPage,
        this.dateTime,
        this.postType,
        this.postId,
        this.isFilterPage=false,
        this.onVoteCallback,
        this.isVoted = false,
        this.postOwnerTypeId,
        this.prefs,
        this.isNewsPage,
        this.webLink,
        this.onSubmitAnswer,
        this.searchHighlightWord,
      this.onAnswerClickCallback});

  @override
  _PostCardFooter createState() => _PostCardFooter(
    contentData: contentData,
    stats: stats,
    isDetailPage: isDetailPage,
    commentCallback: commentCallback,
    dateTime: dateTime,
    postId: postId,
    postType: postType,
      prefs: prefs,
      postOwnerTypeId: postOwnerTypeId,
      onVoteCallback: onVoteCallback,
      isVoted:isVoted,
      webLink:webLink,
      onSubmitAnswer:onSubmitAnswer,
      onAnswerClickCallback:onAnswerClickCallback

  );
}

class _PostCardFooter extends State<PostCardFooter> {
  late TextStyleElements styleElements;
  Statistics? stats;
  Content? contentData;
  int? comments;
  Function? commentCallback;
  bool? isDetailPage;
  int? dateTime;
  String? postType;
  int? postId;
  Function? onVoteCallback;
  bool isVoted;
  Function? onAnswerClickCallback;
  int? postOwnerTypeId;
  SharedPreferences? prefs;
  String? webLink;
  Function? onSubmitAnswer;

  _PostCardFooter(
      {this.contentData,
        this.stats,
        this.commentCallback,
        this.isDetailPage,
        this.dateTime,
        this.postType,
        this.postId,
        this.onVoteCallback,
        this.isVoted = false,
        this.postOwnerTypeId,
        this.prefs,
        this.webLink,
        this.onSubmitAnswer,
      this.onAnswerClickCallback});

  @override
  Widget build(BuildContext context) {
    print("refreshing post card footer");
    // Utility().screenUtilInit(context);
    // DateTime time =
    // print(timeago.format(time));
    styleElements = TextStyleElements(context);
    comments = stats!=null?stats!.commentCount!=null?stats!.commentCount:0:0;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Padding(
                padding:  EdgeInsets.only(top:0.0,bottom: 8.0),
                child: Row(
                  children: [
                    postType=='poll'?
                    DateTagPostComponent(
                      date: (contentData!.contentMeta!.others!=null && contentData!.contentMeta!.others!.pollEnd!=null)?DateTime.fromMillisecondsSinceEpoch(contentData!.contentMeta!.others!.pollEnd!):DateTime.now(),
                    ):postType=='assignment'?DateTagPostComponent(
                      showTime: true,
                      date: (contentData!.contentMeta!.others!=null && contentData!.contentMeta!.others!.submissionDateTime!=null)?DateTime.fromMillisecondsSinceEpoch(contentData!.contentMeta!.others!.submissionDateTime!):DateTime.now(),
                    ):Visibility(
                      visible: false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 0, top: 4),
                        child: Text(
                          timeago.format(DateTime.fromMillisecondsSinceEpoch(dateTime!)),
                          style: styleElements
                              .captionThemeScalable(context)
                              .copyWith(fontSize: 10.sp, color: HexColor(AppColors.appColorBlack35)),
                        ),
                      ),
                    ),
                    Spacer(),
                    (postType!='general' && !widget.isFilterPage! && widget.contentData!.media!=null && widget.contentData!.media!.isEmpty)?PostTagComponent(
                      type: postType,
                    ):Container()
                  ],
                ),
              )
              ,
          (isDetailPage! || (widget.isNewsPage!=null && widget.isNewsPage!))
              ? Visibility(
            visible: (contentData!.contentMeta!.title!=null && contentData!.contentMeta!.title!.isNotEmpty),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: (webLink!=null && widget.isNewsPage!=null && widget.isNewsPage!) ,
                    child: Padding(
                      padding:  EdgeInsets.only(left:8.0),
                      child: Text(getHost(webLink),style: styleElements.overlineThemeScalable(context),),
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Text(
                          contentData!.contentMeta!.title ??= '',
                          style: styleElements
                              .subtitle1ThemeScalable(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (webLink!=null && webLink!.isNotEmpty),
                      child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:4.0,bottom: 4.0,left: 6,right: 8),
                            child: Icon(Icons.open_in_new,
                            size: 18,color: HexColor(AppColors.appColorBlack35),),
                          ),
                          onTap: (){
                            Utility().openWebView(context,widget.webLink??="");
                          }),
                    )
                  ],
                ),
              ],
            ),
          )
              : Visibility(
            visible: (contentData!.contentMeta!.title != null &&
                contentData!.contentMeta!.title!.isNotEmpty),
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(
                contentData!.contentMeta!.title ??= '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Visibility(
            visible: false,/*(contentData.contentMeta.subtitle1 != null &&
                contentData.contentMeta.subtitle1.isNotEmpty),*/
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: HexColor(AppColors.appColorBlack35),
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      contentData!.contentMeta!.subtitle1 ??= "",
                      style: styleElements.captionThemeScalable(context),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pin_drop_outlined,
                    color: HexColor(AppColors.appColorBlack35),
                    size: 16,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        contentData!.contentMeta!.subtitle2 ??= "",
                        style: styleElements.captionThemeScalable(context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          (postType=='poll')?
              PostPollComponent(
                postId:postId,
                prefs:prefs,
                postOwnerTypeId:postOwnerTypeId,
                contentMeta: contentData!.contentMeta,
                onVoteCallback: onVoteCallback,
                isVoted: isVoted,
              )
              :Visibility(
            visible: (contentData!.contentMeta!.meta != null &&
                contentData!.contentMeta!.meta!.isNotEmpty),
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                // child: Text(
                child: TricycleHtmlViewer(
                  isNewsPage: widget.isNewsPage,
                  isDetailPage: isDetailPage,
                  sourceString: contentData!.contentMeta!.meta,
                  searchHighlightWord: widget.searchHighlightWord
                )
              ),
            ),
          ),

          Visibility(
              visible: contentData!.keywords != null,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: getlistofkeywords(),
                ),
              )
          ),
          // Visibility(
          //     visible: contentData.mentions != null,
          //     child: SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Row(
          //         children: getlistofmentions(),
          //       ),
          //     )
          // ),
          // SizedBox(height: 8,),
          Visibility(
            visible: !isVoted && (postType==POST_TYPE.QNA.status || (postType==POST_TYPE.ASSIGNMENT.status && postOwnerTypeId != prefs!.getInt(Strings.userId))),
            child: Container(
              alignment: Alignment.bottomRight ,
              margin: EdgeInsets.only(top: 8, left: 24, right: 24),
              child: TricycleElevatedButton(
                onPressed:postType==POST_TYPE.QNA.status?onAnswerClickCallback:(){
                  var b = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).isAfter(DateTime.fromMillisecondsSinceEpoch(contentData!.contentMeta!.others!.submissionDateTime!));
                  if(b){
                   ToastBuilder().showToast(AppLocalizations.of(context)!.translate('cannot_submit'),
                   context, HexColor(AppColors.information));
                  }else {
                    onSubmitAnswer!();
                  }
                },
                color: HexColor(AppColors.appMainColor),
                child: Text(postType==POST_TYPE.QNA.status?
                AppLocalizations.of(context)!.translate('give_answers'):
                AppLocalizations.of(context)!.translate('submit_assignment'),
                  style: styleElements
                      .bodyText2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appColorWhite)),
                ),
              ),
            ),
          ),
          // Visibility(
          //   visible: !isDetailPage && stats.commentCount>0,
          //   child: TricycleTextButton(onPressed: commentCallback,
          //   padding: EdgeInsets.all(8 ),
          //   shape: RoundedRectangleBorder(side: BorderSide(color: HexColor(AppColors.appColorWhite))),
          //       child: Text('see all $comments comments',style: styleElements.captionThemeScalable(context),)),
          // ),
        ],
      ),
    );
  }


  getlistofkeywords() {
    if (contentData!.keywords != null && contentData!.keywords!.length > 0) {
      List<Widget> list = [];
      for (int i = 0; i < contentData!.keywords!.length; i++) {
        list.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Chip(
            label: Text(
              contentData!.keywords![i].toString(),
              style: styleElements.captionThemeScalable(context),
            ),
            backgroundColor: HexColor(AppColors.appColorGrey300),
          ),
        ));
      }
      return list;
    } else {
      List<Widget> list = [];
      list.add(Text(''));
      return list;
    }
  }
  // getlistofmentions() {
  //   if (contentData.mentions != null && contentData.mentions.length > 0) {
  //     List<Widget> list = [];
  //     for (int i = 0; i < contentData.mentions.length; i++) {
  //       list.add(Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: Chip(
  //           label: Text(
  //             '@'+contentData.mentions[i].toString(),
  //             style: styleElements.captionThemeScalable(context),
  //           ),
  //           backgroundColor: HexColor(AppColors.appColorGrey500)[300],
  //         ),
  //       ));
  //     }
  //     return list;
  //   } else {
  //     List<Widget> list = [];
  //     list.add(Text(''));
  //     return list;
  //   }
  // }


String getHost(String? path)
{
  try {
    if(path!=null)
     return Uri.parse(path).host;
      else
        return "";
  } catch (e) {
    print(e);
    return "";
  }
}
}
