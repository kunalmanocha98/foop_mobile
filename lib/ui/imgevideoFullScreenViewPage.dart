import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/postcardmedia.dart';
import 'package:oho_works_app/components/tricycle_chat_footer.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ImageVideoFullPage extends StatefulWidget {
  List<Media> mediaList;

  Statistics stats;
  Function sharecallBack;
  Function(bool) bookmarkCallback;
  Function commentCallback;
  Function ratingCallback;
  SharedPreferences prefs;
  bool isBookMarked;
  int postId;
  bool isRated;
  PostListItem postListItem;
  Function(bool) onFollowCallback;
  int ownerId;
  String ownerType;
  bool isWithOutData;
  bool isFollowing;
  int position;
  int pageNumber;
  bool isMediaPage;
  int totalItems;
  bool isLocalFile;
  Function talkcallback;

  ImageVideoFullPage(
      {this.mediaList,
      this.stats,
      this.sharecallBack,
      this.bookmarkCallback,
      this.ratingCallback,
      this.isRated,
      this.commentCallback,
      this.prefs,
      this.isBookMarked,
      this.postId,
      this.postListItem,
      this.onFollowCallback,
      this.ownerType,
      this.ownerId,
      this.isWithOutData,
      this.isFollowing,
      this.position,
      this.pageNumber,
      this.isMediaPage,
      this.isLocalFile,
        this.talkcallback,
      this.totalItems});

  @override
  _ImageVideoFullPage createState() => _ImageVideoFullPage(
      mediaList: mediaList,
      stats: stats,
      isBookMarked: isBookMarked,
      isRated: isRated,
      isWithOutData: isWithOutData,
      ratingCallback: ratingCallback,
      sharecallBack: sharecallBack,
      postId: postId,
      bookmarkCallback: bookmarkCallback,
      commentCallback: commentCallback,
      prefs: prefs,
      postListItem: postListItem,
      onFollowCallback: onFollowCallback,
      ownerId: ownerId,
      isFollowing: isFollowing,
      position: position,
      pageNumber: pageNumber,
      isMediaPage: isMediaPage,
      totalItems: totalItems,
      isLocalFile: isLocalFile,
      talkcallback: talkcallback,
      ownerType: ownerType);
}

class _ImageVideoFullPage extends State<ImageVideoFullPage> {
  List<Media> mediaList;
  bool isWithOutData;

  Statistics stats;
  Function sharecallBack;
  Function(bool) bookmarkCallback;
  Function commentCallback;
  Function ratingCallback;
  SharedPreferences prefs;
  bool isBookMarked;
  int postId;
  bool isRated;
  PostListItem postListItem;
  Function(bool) onFollowCallback;
  TextStyleElements styleElements;
  int ownerId;
  String ownerType;
  int position;
  bool isFollowing;
  int pageNumber;
  bool isMediaPage;
  bool isLocalFile;
  int totalItems;
  Function talkcallback;
  GlobalKey<TricycleChatFooterState> chatFooterKey = GlobalKey();

  _ImageVideoFullPage(
      {this.mediaList,
      this.stats,
      this.isLocalFile,

      this.isWithOutData,
      this.sharecallBack,
      this.bookmarkCallback,
      this.ratingCallback,
      this.isRated,
      this.commentCallback,
      this.prefs,
      this.isBookMarked,
      this.postId,
      this.postListItem,
      this.onFollowCallback,
      this.ownerType,
      this.position,
      this.isFollowing,
      this.pageNumber,
      this.isMediaPage,
      this.totalItems,
        this.talkcallback,
      this.ownerId});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(AppColors.appColorBlack85),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !isWithOutData
                          ? Visibility(
                              visible: !isWithOutData,
                              child: PostCardHeader(
                                key: UniqueKey(),
                                prefs: prefs,
                                isFollowing: isFollowing,
                                postListItem: postListItem,
                                onFollowCallback: onFollowCallback,
                                isDarkTheme: true,
                                onBackPressed: () {
                                  Navigator.pop(context);
                                },
                                isBackButtonVisible: true,
                              ))
                          : Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Visibility(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.keyboard_backspace_rounded,
                                        size: 20,
                                        color:
                                            HexColor(AppColors.appColorWhite),
                                        // add custom icons also
                                      )),
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: PostCardMedia(
                    isLocalFile: isLocalFile,
                    totalItems: totalItems,
                    ownerType: ownerType,
                    ownerId: ownerId,
                    pageNumber: pageNumber,
                    isMediaPage: isMediaPage,
                    mediaList: mediaList,
                    onPositionChange: (position) {},
                    fullPage: true,
                    pagePosition: position),
              ),
              Visibility(
                visible: !isWithOutData,
                child: !isWithOutData
                    ? PostCardActionButtons(
                        isDarkTheme: true,
                        stats: stats,
                        prefs: prefs,
                        isDocument: false,
                        mediaUrl: null,
                        isBookMarked: isBookMarked,
                        isRated: isRated,
                        sharecallBack: sharecallBack,
                        bookmarkCallback: bookmarkCallback,
                        commentCallback: commentCallback,
                        ratingCallback: ratingCallback,
                        talkCallback: talkcallback,
                        isTalkIconVisible: !(postListItem.postType == 'poll' || postListItem.postType == 'general'),
                        ownerType: ownerType,
                        ownerId: ownerId,
                        postId: postId)
                    : Container(),
              ),
              Visibility(
                visible: isLocalFile != null && isLocalFile,
                child: TricycleChatFooter(
                  chatFooterKey,
                  data: null,
                  userName: null,
                  onCrossCLicked: () {},
                  isEmptyTextAccepted:true,
                  hintText: AppLocalizations.of(context).translate("enter_text"),
                  isShowAddIcon: false,
                  onTyping: (String v) {},
                  onValueRecieved: (value) async {
                    Navigator.of(context).pop({'result': value});
                  },
                  onReceiveOption: (value) async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
