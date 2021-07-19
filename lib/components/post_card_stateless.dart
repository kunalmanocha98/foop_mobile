import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcard.dart';
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
class TricyclePostCardStateLess extends StatelessWidget {
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

  bool isPostHeaderVisible;
  bool isPostActionVisible;

  bool horizontalMediaList;
  bool isTranslateVisible;
  Function translateCallback;
  Function textToSpeechCallback;
  bool isTextToSpeechVisible;
  bool isLearningPage;
  final String searchHighlightWord;

  TricyclePostCardStateLess(
      {Key key,
        @required this.cardData,
        this.sharecallBack,
        this.download,
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
  Widget build(BuildContext context) {
    return TricyclePostCard(
      cardData: cardData,
      isPostHeaderVisible: false,
      isPostActionVisible: false,
      isNewsPage: false,
      isFilterPage: false,
      isLearningPage: true,
      searchHighlightWord: searchHighlightWord,
      download: () {
        Navigator.pop(context);
      },
      preferences: preferences,
      isBackButtonVisible: true,
      onBackPressed: () {
        Navigator.pop(context);
      },
      isDetailPage: true,
      sharecallBack: () {},
      ratingCallback: () {},
      bookmarkCallback: (isBookmarked) {},
      onTalkCallback: () {},
      commentCallback: () {},
      onFollowCallback: (isFollow) {
        // _onFollowCallback(isFollow);
      },
      hidePostCallback: () {},
      deletePostCallback: () {},
      onVoteCallback: () {},
      onSubmitAnswer: () {},
      onAnswerClickCallback: () {},
    );
  }
}


