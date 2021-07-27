
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class appPostCardStateLess extends StatelessWidget {
  PostListItem cardData;
  Function? sharecallBack;
  Function? download;
  Function(bool)? bookmarkCallback;
  Function? commentCallback;
  Function? ratingCallback;
  Function? onAnswerClickCallback;
  SharedPreferences? preferences;
  Function(bool)? onFollowCallback;
  Function? hidePostCallback;
  Function? deletePostCallback;
  Function onVoteCallback;
  bool? isDetailPage;
  Function? onBackPressed;
  bool? isBackButtonVisible;
  bool? isTitleVisible;
  bool? isNewsPage;
  bool? isFilterPage;
  Function? onTalkCallback;
  Function? onSubmitAnswer;

  bool isPostHeaderVisible;
  bool isPostActionVisible;

  bool horizontalMediaList;
  bool? isTranslateVisible;
  Function? translateCallback;
  Function? textToSpeechCallback;
  bool? isTextToSpeechVisible;
  bool isLearningPage;
  final String? searchHighlightWord;

  appPostCardStateLess(
      {Key? key,
        required this.cardData,
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
        required this.onVoteCallback,
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
    return appPostCard(
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


