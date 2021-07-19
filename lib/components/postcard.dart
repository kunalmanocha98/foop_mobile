import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/postcardmedia.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/ui/imgevideoFullScreenViewPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:delta_markdown/delta_markdown.dart' hide Document;
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:html/parser.dart';
import 'package:markdown/markdown.dart' hide Document,Text;
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PostCardFooter.dart';

// ignore: must_be_immutable
class TricyclePostCard extends StatefulWidget {
  PostListItem cardData;
  Function sharecallBack;
  Function download;
  Function(bool) bookmarkCallback;
  Function commentCallback;
  Function ratingCallback;
  Function onAnswerClickCallback;
  SharedPreferences preferences;
  Function(bool) onFollowCallback;
  Function hidePostCallback;
  Function deletePostCallback;
  Function onVoteCallback;
  bool isDetailPage;
  Function onBackPressed;
  bool isBackButtonVisible;
  bool isTitleVisible;
  bool isNewsPage;
  bool isFilterPage;
  Function onTalkCallback;
  Function onSubmitAnswer;
  FlutterTts tts;
  bool isPostHeaderVisible;
  bool isPostActionVisible;

  bool horizontalMediaList;
  bool isTranslateVisible;
  Function translateCallback;
  Function textToSpeechCallback;
  bool isTextToSpeechVisible;
bool isLearningPage;
final String searchHighlightWord;

  TricyclePostCard(
      {Key key,
        @required this.cardData,
        this.sharecallBack,
        this.download,
        this.tts,
        this.bookmarkCallback,
        this.onFollowCallback,
        this.ratingCallback,
        this.commentCallback,
        this.preferences,
        this.hidePostCallback,
        this.deletePostCallback,
        this.isDetailPage,
        this.onBackPressed,
        this.isNewsPage,
        this.isFilterPage,
        this.isLearningPage = false,
        this.onTalkCallback,
        @required this.onVoteCallback,
        this.isBackButtonVisible,
        this.isTitleVisible,
        this.onSubmitAnswer,
        this.searchHighlightWord,
        this.isPostHeaderVisible = true,
        this.isPostActionVisible = true,
        this.horizontalMediaList = false,
        this.translateCallback,
        this.isTranslateVisible,
        this.isTextToSpeechVisible,
        this.textToSpeechCallback,
        this.onAnswerClickCallback})
      : super(key: key);

  @override
  PostCardState createState() => PostCardState(
      cardData: cardData,
      sharecallBack: sharecallBack,
      download: download,
      onFollowCallback: onFollowCallback,
      ratingCallback: ratingCallback,
      bookmarkCallback: bookmarkCallback,
      commentCallback: commentCallback,
      preferences: preferences,
      hidePostCallback: hidePostCallback,
      deletePostCallback: deletePostCallback,
      isDetailPage: isDetailPage,
      onBackPressed: onBackPressed,
      isTitleVisible: isTitleVisible,
      onVoteCallback: onVoteCallback,
      onSubmitAnswer:onSubmitAnswer,
      isBackButtonVisible: isBackButtonVisible,
      isNewsPage: isNewsPage,
      onAnswerClickCallback: onAnswerClickCallback);
}

class PostCardState extends State<TricyclePostCard> {
  TextStyleElements styleElements;
  PostListItem cardData;
  Function sharecallBack;
  Function download;
  Function(bool) bookmarkCallback;
  Function commentCallback;
  Function ratingCallback;
  Function onVoteCallback;
  Function onAnswerClickCallback;
  SharedPreferences preferences;
  Function(bool) onFollowCallback;
  Function hidePostCallback;
  Function deletePostCallback;
  bool isDetailPage;
  Function onBackPressed;
  bool isBackButtonVisible;
  bool isTitleVisible;
  int position = 0;
  bool isNewsPage;
  Function onSubmitAnswer;


  // GlobalKey<TricycleDownloadButtonState> downloadButtonKey = GlobalKey();


  PostCardState(
      {@required this.cardData,
        this.sharecallBack,
        this.bookmarkCallback,
        this.onFollowCallback,
        this.ratingCallback,
        this.commentCallback,
        this.preferences,
        this.download,
        this.hidePostCallback,
        this.deletePostCallback,
        this.isDetailPage,
        this.onBackPressed,
        this.onVoteCallback,
        this.isBackButtonVisible,
        this.onAnswerClickCallback,
        this.isNewsPage,
        this.onSubmitAnswer,
        this.isTitleVisible});

  // @override
  // void didUpdateWidget(Widget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }
  @override
  void initState() {
    setInitial();
    super.initState();
  }

  Future<void> setInitial() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    // ignore: unrelated_type_equality_checks
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    print("post_card_____________________");
    styleElements = TextStyleElements(context);
    return TricycleCard(
        color: cardData.postContent.specifications.color != null
            ? HexColor(cardData.postContent.specifications.color)
            : null,
        // color: color,
        padding: EdgeInsets.all(0),
        margin: (widget.isLearningPage && cardData.postType == 'lesson')?EdgeInsets.only(top:75):null,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (!widget.isPostHeaderVisible || (isNewsPage!=null && isNewsPage))?Container(): Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 8, bottom: 8.0),
                  child: PostCardHeader(
                    key: UniqueKey(),
                    prefs: preferences,
                    postListItem: cardData,
                    onFollowCallback: onFollowCallback,
                    isBackButtonVisible: isBackButtonVisible,
                    onBackPressed: onBackPressed,
                    hidePostCallback: hidePostCallback,
                    deletePostCallback: deletePostCallback,
                    isFollowing: getIsFollowing(),
                    isDarkTheme: false,
                  ),
                ),
                // Visibility(
                //   visible: !(cardData.postType == 'poll' ||
                //       cardData.postType == 'general'),
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                //     child: Row(
                //       children: [
                //         Spacer(),
                //         PostTagComponent(
                //           type: cardData.postType,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                (cardData != null &&
                    cardData.postType == 'notice' &&
                    (isTitleVisible ??= false))
                    ? Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, bottom: 8.0),
                  child: Text(
                    cardData.postContent.content.typeHeading ??= '',
                    style: styleElements
                        .headline6ThemeScalable(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                )
                    :
                // (cardData.postContent.content.media != null &&
                //     cardData.postContent.content.media.length > 0)
                //     ?
                // PostCardMediaList(
                //   mediaList: cardData.postContent.content.media,
                // ),

                cardData.postContent.content.media!=null && cardData.postContent.content.media.isNotEmpty  ?  PostCardMedia(
                    // downloadButtonKey:downloadButtonKey,
                    isLearningPage:widget.isLearningPage,
                    postType:cardData.postType,
                    isFilterPage:widget.isFilterPage,
                    mediaList: cardData.postContent.content.media,
                    fullPage: false,
                    link:getLink(cardData.postContent.content.contentMeta.meta),
                    pagePosition: 0,
                    isNewsPage: isNewsPage,
                    onlyHorizontalList: widget.horizontalMediaList,
                    onPositionChange: (p) {
                      position = p;
                    },
                    onItemClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImageVideoFullPage(
                            ownerId: cardData.postOwnerTypeId,
                            ownerType: cardData.postOwnerType,
                            mediaList: cardData.postContent.content.media,
                            stats: cardData.postContent.statistics,
                            isBookMarked: cardData.isBookmarked,
                            isRated: getIsRated(),
                            sharecallBack: sharecallBack,
                            bookmarkCallback: bookmarkCallback,
                            commentCallback: commentCallback,
                            prefs: preferences,
                            ratingCallback: ratingCallback,
                            postId: cardData.postId,
                            postListItem: cardData,
                            isWithOutData: false,
                            talkcallback: widget.onTalkCallback,
                            onFollowCallback: onFollowCallback,
                            position: position,
                            isFollowing: getIsFollowing(),
                          )));
                    }):
                Container(
/*
                  child:
    cardData.postType=="lesson" && widget.isLearningPage!=null &&   widget.isLearningPage?

                  SizedBox(
                    height: 120,
                  ):Container(),*/
                )
                //     :
                // SizedBox(
                //   width: 0,
                //   height: 0,
                // )
                ,
                (cardData != null)
                    ? Padding(
                  padding:  EdgeInsets.only(left: isDetailPage?60:8, right: 16),
                  child: PostCardFooter(
                      prefs: preferences,
                      isFilterPage:widget.isFilterPage,
                      searchHighlightWord:widget.searchHighlightWord,
                      postOwnerTypeId: cardData.postOwnerTypeId,
                      postId: cardData.postId,
                      postType: cardData.postType,
                      contentData: cardData.postContent.content,
                      stats: cardData.postContent.statistics,
                      commentCallback: commentCallback,
                      isDetailPage: isDetailPage,
                      dateTime: cardData.postDatetime,
                      onVoteCallback: onVoteCallback,
                      isVoted: cardData.isVoted ?? false,
                      webLink: cardData.sourceLink,
                      isNewsPage:isNewsPage,
                      onSubmitAnswer:onSubmitAnswer,
                      onAnswerClickCallback: onAnswerClickCallback),
                )
                    : Container(),
                Visibility(
                  visible: isNewsPage??=false,
                    child: Spacer()),
                Visibility(
                  visible: !(isNewsPage!=null && isNewsPage) && widget.isPostActionVisible,
                  child:
                  (cardData != null)
                      ? Align(
                    alignment: Alignment.bottomCenter,
                    child: PostCardActionButtons(
                        isTranslateVisible: widget.isTranslateVisible,
                        translateCallback: widget.translateCallback,
                        isTextToSpeechVisible: widget.isTextToSpeechVisible,
                        textToSpeechCallback: widget.textToSpeechCallback,
                        // downloadButtonKey: downloadButtonKey,
                        media:cardData.postContent.content.media,
                        ownerId: cardData.postOwnerTypeId,
                        ownerType: cardData.postOwnerType,
                        isDocument: isDocument(cardData),
                        stats: cardData.postContent.statistics,
                        isBookMarked: cardData.isBookmarked,
                        isRated: getIsRated(),
                        isTalkIconVisible: !(cardData.postType == 'poll' || cardData.postType == 'general'),
                        talkCallback: widget.onTalkCallback,
                        mediaUrl: isDocument(cardData)
                            ? cardData
                            .postContent.content.media[position].mediaUrl
                            : "",
                        sharecallBack: sharecallBack,
                        bookmarkCallback: bookmarkCallback,
                        commentCallback: commentCallback,
                        ratingCallback: ratingCallback,
                        prefs: preferences,
                        postId: cardData.postId),
                  )
                      : Container(),)

              ],
            ),
            Visibility(
              visible: (isNewsPage!=null && isNewsPage),
              child:
            (cardData != null)
                ? Align(
              alignment: Alignment.bottomCenter,
                  child: PostCardActionButtons(
                    backgroundColor: HexColor(AppColors.appColorWhite),
                      // downloadButtonKey: downloadButtonKey,
                      isTranslateVisible: widget.isTranslateVisible,
                      isTextToSpeechVisible: widget.isTextToSpeechVisible,
                      textToSpeechCallback: ()async{
                     widget. tts.stop();
                      var text = "";
                        try {
                          Document doc = Document.fromJson(jsonDecode(
                              cardData.postContent.content.contentMeta.meta));
                          QuillController _controller = QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
                        text = _controller.document.toPlainText();
                        }catch(error){
                          var html =  cardData.postContent.content.contentMeta.meta;
                          print(html);
                          text = parse(html).documentElement.text;
                          print(text);
                        }

                     widget. tts.setLanguage("hi-IN");
                     widget. tts.setPitch(1);
                     widget. tts.speak(text);
                      },
                      translateCallback: (){
                      String html="";
                      try {
                        Document doc = Document.fromJson(jsonDecode(
                            cardData.postContent.content.contentMeta.meta));
                        QuillController _controller = QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
                        // Delta delta = Delta.fromJson(jsonDecode(jsonEncode(_controller.document.toDelta().toJson())));
                        // var markdown = deltaToMarkdown(delta.toString());
                        // html=  markdownToHtml(markdown);
                        // print(html);

                        var markdown = deltaToMarkdown(jsonEncode(_controller.document.toDelta().toJson()));
                        html=  markdownToHtml(markdown);
                         // html  = NotusHtmlCodec().encode(delta);
                      }catch(error){
                        log(error);
                        html =  cardData.postContent.content.contentMeta.meta;
                      }

                        var input1 = html.replaceAll("<br><br><br><br>", "<br><br>");
                        var input  = input1.replaceRange(input1.length-8,input1.length, "");
                        log(input);
                        Utility().translate(context,input, "en", "hi", "html").then((value){
                          setState(() {
                            cardData.postContent.content.contentMeta.meta = value;
                          });
                        });
                      },
                      media:cardData.postContent.content.media,
                      ownerId: cardData.postOwnerTypeId,
                        ownerType: cardData.postOwnerType,
                        isDocument: isDocument(cardData),
                        stats: cardData.postContent.statistics,
                        isBookMarked: cardData.isBookmarked,
                        isRated: getIsRated(),
                        isTalkIconVisible: cardData.postType != 'poll',
                        talkCallback: widget.onTalkCallback,
                        mediaUrl: isDocument(cardData)
                            ? cardData
                            .postContent.content.media[position].mediaUrl
                            : "",
                        sharecallBack: sharecallBack,
                        bookmarkCallback: bookmarkCallback,
                        commentCallback: commentCallback,
                        ratingCallback: ratingCallback,
                        prefs: preferences,
                        postId: cardData.postId),
                )
                : Container(),)
          ],
        ));
  }

  bool isDocument(PostListItem cardData) {
    if (cardData.postContent.content.media != null &&
        cardData.postContent.content.media.length > 0) {
      for (var i in cardData.postContent.content.media) {
        if (i.mediaType != null) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  bool getIsRated() {
    bool isRated;
    for (var i in cardData.postContent.header.action) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }

  bool getIsFollowing() {
    bool isFollowed;
    for (var i in cardData.postContent.header.action) {
      if (i.type == 'is_followed') {
        isFollowed = i.value;
        break;
      }
    }
    return isFollowed ??= false;
  }

  String _localPath;

  String getLink(String meta) {
    try {
      Document doc = Document.fromJson(jsonDecode(meta));
      var _controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));
      print("quill--------"+_controller.document.toPlainText());
      return Utility().matchLinkRegex(_controller.document.toPlainText());
    }catch(onError){
      try {
        final document = parse(meta);
        final String parsedString = parse(document.body.text).documentElement
            .text;
        print("html--------" + parsedString);
        return Utility().matchLinkRegex(parsedString);
      }
      catch(onError){
        return "";
      }
    }
  }
}
