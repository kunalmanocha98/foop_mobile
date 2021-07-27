/*
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/app_chat_footer.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/answersmodels.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post_view_response.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postModule/rating_review_post_card.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NewNewsAndArticleDetailPage extends StatefulWidget {
  PostListItem postData;

  int postId;

  NewNewsAndArticleDetailPage({this.postData, this.postId});

  @override
  _PostDetailScrollerPage createState() =>
      _PostDetailScrollerPage(postData: postData, postId: postId);
}

class _PostDetailScrollerPage extends State<NewNewsAndArticleDetailPage> {
  PostListItem postData;
  int postId;
  List<int> postIds = [];

  _PostDetailScrollerPage({this.postData, this.postId});

  SharedPreferences prefs = locator<SharedPreferences>();
  TextStyleElements styleElements;
  GlobalKey<appChatFooterState> chatFooterKey = GlobalKey();
  PAGINATOR_ENUMS pageEnum_answer;
  PAGINATOR_ENUMS pageEnum_comment;
  PAGINATOR_ENUMS pageEnum_assignment;
  bool isPostDataAvailable = true;
  String errorMessage;
  List<NotesListItem> notesList = [];
  List<AnswersListItem> answersList = [];
  List<AnswersListItem> assignmentList = [];
  int totalComment = 0;
  int pageComment = 1;
  int totalAnswers = 0;
  int pageAnswer = 1;
  int totalAssignment = 0;
  int pageAssignment = 1;
  int j = 0;

  var commentSliverKey = GlobalKey();
  var answerSliverKey = GlobalKey();
  var assignmentSliverKey = GlobalKey();
  GlobalKey<PostCardHeaderState> headerKey = GlobalKey();

  var _controller = PageController(initialPage: 1);

  int currentId = 0;
  List<PostListItem> postItemList = [];

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        print("NEXT");
      } else {
        print("PREV");
      }
    });
    // if (postId != null) {

    WidgetsBinding.instance.addPostFrameCallback((_) => getPost(postId));
    // }
    // else {
    //   bool isFollowed = false;
    //
    //   for (var i in postData.postContent.header.action) {
    //     if (i.type == 'is_followed') {
    //       isFollowed = i.value;
    //       break;
    //     }
    //   }
    //   // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //   headerKey.currentState.update(
    //   //     postListItem: postData,
    //   //     prefs: prefs,
    //   //     onFollowCallback: (isFollow) {
    //   //       // _onFollowCallback(isFollow);
    //   //     },
    //   //     isFollowing: isFollowed,
    //   //     hidePostCallback: () {},
    //   //     deletePostCallback: () {},
    //   //   );
    //   // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(
      body: postItemList.length > 0
          ? PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: postItemList.length,
              itemBuilder: (BuildContext context, int index) {
                print(
                    "Build--------------------------------------------------$index-----------------");
                // return _PostCardScrollable(
                //   postId: postIds[index],
                //   postData: null,
                //   postDataCallback: postCallback,
                // );
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: getPostCard(postItemList[index])),
                  ],
                );
              },
              onPageChanged: (index) {
                print("index" + index.toString());
                // isPrev = index < pageIndex;
                // isNext = index > pageIndex;
                // pageIndex = index;
              },
            )
          : Container(
              child: CustomPaginator(context).loadingWidgetMaker(),
            ),
      bottomNavigationBar: postData != null
          ? PostCardActionButtons(
              sharecallBack: _onShareCallback,
              postId: postData.postId,
              isBookMarked: postData.isBookmarked,
              isRated: getIsRated(),
              ratingCallback: () {
                _onRatingCallback();
              },
              bookmarkCallback: (isBookmarked) {
                _onBookmarkCallback(postData.postId, isBookmarked);
              },
              talkCallback: () {
                onTalkCallback();
              },
              commentCallback: _onCommentCallback,
            )
          : Container(),
    );
  }

  void postCallback(PostListItem item) {
    log("PostReagarding- ${item.postId}");
    log("Prev- ${item.prevId}");
    log("Next- ${item.nextId}");
    log("postIds list- ${postIds.toList().toString()}");

    if (postIds.contains(item.postId)) {
      var ind = postIds.indexOf(item.postId);
      if (ind == 0) {
        if (item.prevId != null) {
          log("Inside Prev- ${item.prevId}");
          postIds.insert(0, item.prevId);
        }
      }

      if (ind == postIds.length - 1) {
        if (item.nextId != null) {
          log("Inside Next- ${item.prevId}");
          postIds.insert(postIds.length, item.nextId);
        }
      }
      log("postIds list After- ${postIds.toList().toString()}");
    }
    // if (isPrev) {
    //   print("@%@#%@!@#!@#!@-PREV-#!@#!@#!@#!@#!@#!@${item.prevId.toString()}");
    //   listIndex = 1;
    //   postIds.insert(0, item.prevId);
    // } this.postData = item;
    // if (isNext) {
    //   print("@%@#%@!@#!@#!-NEXT-@#!@#!@#!@#!@#!@#!@${item.nextId.toString()}");
    //   postIds.insert(postIds.length, item.nextId);
    // }
    postItemList.add(postData);
    setState(() {});
    _controller.jumpToPage(postIds.indexOf(currentId));
  }

  void getPrev(int postId) async {
    final body = jsonEncode({"post_id": postId, "post_type": "news"});
    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        // _controller.jumpToPage(1);
        setState(() {
          postItemList[0] = res.rows;
          if (res.rows.prevId != null) {
            postItemList.insert(
                0, PostListItem(postType: 'prev', prevId: res.rows.prevId));
          }
        });
      }
    });
  }

  void getNext(int postId) async {
    log("PRINT NEXT***********************************************");
    final body = jsonEncode({"post_id": postId, "post_type": "news"});
    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          postItemList[postItemList.length - 1] = res.rows;
        });
        if (res.rows.nextId != null) {
          postItemList
              .add(PostListItem(postType: 'next', prevId: res.rows.nextId));
        }
      }
    });
  }

  void getPost(int postId) async {
    final body = jsonEncode({"post_id": postId, "post_type": "news"});

    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          if (res.rows != null) {
            isPostDataAvailable = true;
            if (isFirstTime) {
              if (res.rows.prevId != null) {
                postIds.add(res.rows.prevId);
                postItemList.add(
                    PostListItem(postType: 'prev', prevId: res.rows.prevId));
              }
              postIds.add(postId);
              postItemList.add(res.rows);
              if (res.rows.nextId != null) {
                postIds.add(res.rows.nextId);
                postItemList.add(
                    PostListItem(postType: 'next', nextId: res.rows.nextId));
              }
            }
            // postData = res.rows;
          }
        });
      } else if (res.statusCode == "E100002") {
        print(
            "not availbale -------------------------------------------------------------------------");
        setState(() {
          isPostDataAvailable = false;
          res.message;
          // }
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getPostCard(PostListItem item) {
    Widget card;
    if (item.postType == 'prev') {
      // getPrev(item.prevId);
      card = Container(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (item.postType == 'next') {
      getNext(item.nextId);
      card = Container(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else {
      card = appPostCard(
        cardData: item,
        isPostHeaderVisible: false,
        isPostActionVisible: false,
        isNewsPage: false,
        isFilterPage: false,
        download: () {
          Navigator.pop(context);
        },
        preferences: prefs,
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
      return card;
    }
  }

  final CreateDeeplink createDeeplink = locator<CreateDeeplink>();

  void _onShareCallback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(),
        postData.postId,
        DEEPLINKTYPE.POST.type,
        context);
    // _showModalBottomSheet(context);
  }

  void _onRatingCallback() {
    // postRatingKey.currentState.updateData();
    setState(() {
      for (var i in postData.postContent.header.action) {
        if (i.type == 'is_rated') {
          i.value = true;
        }
      }
    });
  }

  void onTalkCallback() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: postData.postContent.content.contentMeta.title,
              okCallback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CreateEventPage(
                    type: 'talk',
                    standardEventId: 5,
                    title: postData.postContent.content.contentMeta.title,
                  );
                }));
              },
              cancelCallback: () {});
        });
  }

  void _onBookmarkCallback(int postId, bool isBookmarked) {
    bookmarkPost(postId, isBookmarked);
  }

  void _onCommentCallback() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommentSheet(postId: postData.postId);
        });
    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=> PostCardDetailPage()));
  }

  bool getIsRated() {
    bool isRated;
    for (var i in postData.postContent.header.action) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }

  void bookmarkPost(int postId, bool isBookMarked) {
    setState(() {
      postData.isBookmarked = isBookMarked;
    });
  }
}

class CommentSheet extends StatefulWidget {
  final int postId;

  CommentSheet({this.postId});

  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  GlobalKey<appChatFooterState> chatFooterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context).translate('comments'),
            style: styleElements
                .headline6ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Paginator<NotesListResponse>.listView(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            key: paginatorKey,
            pageLoadFuture: fetchData,
            shrinkWrap: true,
            pageItemsGetter: CustomPaginator(context).listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
            errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
            emptyListWidgetBuilder:
                CustomPaginator(context).emptyListWidgetMaker,
            totalItemsGetter: CustomPaginator(context).totalPagesGetter,
            pageErrorChecker: CustomPaginator(context).pageErrorChecker,
          ),
        ),
        appChatFooter(
          chatFooterKey,
          isShowAddIcon: false,
          hintText: AppLocalizations.of(context).translate('enter_comment'),
          onValueRecieved: (value) {
            submitComment(value);
            // chatFooterKey.currentState.clearData();
            // addNote(value);
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  Future<NotesListResponse> fetchData(int page) async {
    var body = jsonEncode({
      "note_subject_type": "post",
      "note_subject_id": widget.postId,
      "page_number": page,
      "page_size": 10
    });
    var res = await Calls().call(body, context, Config.COMMENTS_LIST);
    return NotesListResponse.fromJson(res);
  }

  Widget listItemBuilder(itemData, int index) {
    NotesListItem item = itemData;
    return CommentItemCard(
        data: item,
        ratingCallBack: () {
          setState(() {
            // notesList[index].commRateCount =
            //     notesList[index].commRateCount + 1;
          });
        });
  }

  void submitComment(String value) async {
    prefs = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "note_type": "comment",
      "note_created_by_type": "person",
      "note_created_by_id": prefs.getInt(Strings.userId),
      "note_subject_type": "post",
      "note_subject_id": widget.postId,
      "note_content": value,
      "note_format": ["T"],
      "note_status": "A",
      "has_attachment": false,
      "make_anonymous": false,
      // "rating_subject_type":"post",
      // "rating_subject_id":postData.postId,
      // "rating_context_type":"person",
      // "rating_context_id":prefs.getInt(Strings.id),
      // "rating_given_by_id":prefs.getInt(Strings.id),
      // "rating_given":"5"
    });
    GenericCommentReviewFeedback(context, body)
        .apiCallCreate()
        .then((isSuccess) {
      print(isSuccess);
      if (isSuccess) {
        Timer(Duration(milliseconds: 500), () {
          refresh();
        });
        // refresh();
        // chatFooterKey.currentState.clearData();
      }
    });
  }

  refresh() {
    chatFooterKey.currentState.clearData();
    paginatorKey.currentState.changeState(resetState: true);
  }
}
// class _PostScrollableStateless extends StatelessWidget{
//   final int postId;
//   final PostListItem postData;
//   _PostScrollableStateless({this.postId,this.postData});
//   @override
//   Widget build(BuildContext context) {
//     return _PostCardScrollable(postId: postId,postData: postData,);
//   }
//
// }

class _PostCardScrollable extends StatefulWidget {
  final int postId;
  final PostListItem postData;
  final Function(PostListItem) postDataCallback;

  _PostCardScrollable({this.postId, this.postData, this.postDataCallback});

  @override
  _PostCardScrollableState createState() =>
      _PostCardScrollableState(postData: postData);
}

class _PostCardScrollableState extends State<_PostCardScrollable> {
  PostListItem postData;
  SharedPreferences prefs = locator<SharedPreferences>();

  _PostCardScrollableState({this.postData});

  bool isPostDataAvailable;
  GlobalKey<PostRatingCardState> postRatingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (postData == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getPost(widget.postId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" +
        (postData != null).toString());
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: getPostCard(),
        ),
        postData != null
            ? SliverToBoxAdapter(
                child: PostRatingCard(
                  key: postRatingKey,
                  postId: postData.postId,
                  ownerId: postData.postOwnerTypeId,
                  ownerType: postData.postOwnerType,
                ),
              )
            : SliverToBoxAdapter(),
      ],
    );
  }

  getPostCard() {
    Widget card;
    card = postData != null
        ? appPostCard(
            cardData: postData,
            isPostHeaderVisible: false,
            isPostActionVisible: false,
            isNewsPage: false,
            isFilterPage: false,
            download: () {
              Navigator.pop(context);
            },
            preferences: prefs,
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
              _onFollowCallback(isFollow);
            },
            hidePostCallback: () {},
            deletePostCallback: () {},
            onVoteCallback: () {},
            onSubmitAnswer: () {},
            onAnswerClickCallback: () {},
          )
        : Container(
            height: 150,
          );
    return card;
  }

  void getPost(int postId) async {
    final body = jsonEncode({"post_id": postId, "post_type": "news"});

    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        setState(() {
          if (res.rows != null) {
            isPostDataAvailable = true;
            postData = res.rows;
            widget.postDataCallback(postData);
          }
        });
      } else if (res.statusCode == "E100002") {
        print(
            "not availbale -------------------------------------------------------------------------");
        setState(() {
          isPostDataAvailable = false;
          res.message;
          // }
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void _onFollowCallback(bool isFollow) {
    setState(() {
      for (var i in postData.postContent.header.action) {
        if (i.type == 'is_followed') {
          i.value = isFollow;
        }
      }
    });
  }
}
*/
