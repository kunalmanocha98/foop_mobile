import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/tricycleProgressButton.dart';
import 'package:oho_works_app/components/tricycle_chat_footer.dart';
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
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/ui/postModule/rating_review_post_card.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CalenderModule/create_event_page.dart';
import 'dialogs/dialog_audio_post.dart';

// ignore: must_be_immutable
class PostCardDetailPage extends StatefulWidget {
  PostListItem? postData;

  int? postId;

  PostCardDetailPage({this.postData, this.postId});

  @override
  _PostCardDetail createState() =>
      _PostCardDetail(postData: postData, postId: postId);
}

class _PostCardDetail extends State<PostCardDetailPage> {
  PostListItem? postData;

  int? postId;

  _PostCardDetail({this.postData, this.postId});

  SharedPreferences? prefs = locator<SharedPreferences>();
  late TextStyleElements styleElements;
  GlobalKey<TricycleChatFooterState> chatFooterKey = GlobalKey();
  PAGINATOR_ENUMS? pageEnum_answer;
  PAGINATOR_ENUMS? pageEnum_comment;
  PAGINATOR_ENUMS? pageEnum_assignment;
  bool isPostDataAvailable = true;
  String? errorMessage;
  List<NotesListItem> notesList = [];
  List<AnswersListItem> answersList = [];
  List<AnswersListItem> assignmentList = [];
  int? totalComment = 0;
  int pageComment = 1;
  int? totalAnswers = 0;
  int pageAnswer = 1;
  int? totalAssignment = 0;
  int pageAssignment = 1;
  int j = 0;
  GlobalKey<PostRatingCardState> postRatingKey = GlobalKey();

  var commentSliverKey = GlobalKey();
  var answerSliverKey = GlobalKey();
  var assignmentSliverKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (postId != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => getPost(postId));
    }
    pageEnum_answer = PAGINATOR_ENUMS.LOADING;
    pageEnum_comment = PAGINATOR_ENUMS.EMPTY;
    pageEnum_assignment = PAGINATOR_ENUMS.LOADING;
    if (postData != null && postData!.postType == 'qa') {
      initialcallAnswer();
    }
    if (postData!=null && postData!.postType == 'assignment') {
      inititalCallAssignment();
    } else {
      initialcallComment();
    }
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    print(
        "build++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return SafeArea(
      child: Scaffold(
        // appBar: TricycleAppBar().getCustomAppBar(context,
        //     appBarTitle: 'PostCardDetail', onBackButtonPress: () {
        //       Navigator.pop(context);
        //     }),
        body: isPostDataAvailable
            ? Column(children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        getPostCard(),
                        /*  RatingAndReviewCard(data: null,
        callback: null,
            persondata: null,
            userId: null,
            userName:null,
            ownerId: null,
            type: null)*/
                      ],
                    )),
                postData != null
                    ? SliverToBoxAdapter(
                  child: PostRatingCard(
                    key: postRatingKey,
                    postId: postData!.postId,
                    ownerId: postData!.postOwnerTypeId,
                    ownerType: postData!.postOwnerType,
                  ),
                )
                    : SliverToBoxAdapter(),
                postData != null && postData!.postType == 'assignment'
                    ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 8, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('assignment_submission'),
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                    : SliverToBoxAdapter(),
                postData != null && postData!.postType == 'assignment'
                    ? getAssignmentSliver()
                    : SliverToBoxAdapter(),
                postData != null && postData!.postType == 'qa'
                    ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 8, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('answers'),
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                    : SliverToBoxAdapter(),
                postData != null && postData!.postType == 'qa'
                    ? getAnswerSliver()
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 8, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!.translate('comments'),
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                getCommentSliver()
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TricycleChatFooter(
                  chatFooterKey,
                  isShowAddIcon: false,
                  hintText: AppLocalizations.of(context)!
                      .translate('enter_comment'),
                  onValueRecieved: (value) {
                    submitComment(value!);
                    chatFooterKey.currentState!.clearData();
                    addNote(value);
                  },
                ),
              ],
            ),
          ),
        ])
            : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaginator(context).emptyListWidgetMaker(null,
                  message: errorMessage != null
                      ? errorMessage
                      : 'This post is not available'),
              SizedBox(
                height: 8,
              ),
              TricycleProgressButton(
                child: Text(
                  AppLocalizations.of(context)!.translate('go_back'),
                  style: styleElements
                      .captionThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appColorWhite)),
                ),
                elevation: 0,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  getAssignmentSliver() {
    if (pageEnum_assignment == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_assignment == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: assignmentSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < assignmentList.length) {
              return CommentItemCard(
                isAnswer: true,
                isAssignment:  postData!.postType == 'assignment',
                key: UniqueKey(),
                isGiveMarksVisible: postData!.postOwnerTypeId == prefs!.getInt(Strings.userId),
                rating: assignmentList[index].ratingDetails!.rating,
                reviewNote : assignmentList[index].ratingDetails!.comment,
                answerOtherDetails: assignmentList[index].answerOtherDetails,
                answerStatus : assignmentList[index].answerStatus,
                postId : assignmentList[index].postId,
                refreshCallback:refresh,
                maxMarks: postData!.postContent!.content!.contentMeta!.others!.maxMarks.toString(),
                assignmentDate :
                (postData!=null && postData!.postContent!.content!.contentMeta!.others!=null && postData!.postContent!.content!.contentMeta!.others!.submissionDateTime!=null)
                    ?DateTime.fromMillisecondsSinceEpoch(postData!.postContent!.content!.contentMeta!.others!.submissionDateTime!)
                    :DateTime.now(),
                assignmentTitle: postData!.postContent!.content!.contentMeta!.title,
                data: NotesListItem(
                    note_id:  assignmentList[index].id,
                    noteContent: assignmentList[index].answerDetails,
                    notesCreatedByName: assignmentList[index].answerByName,
                    createdDate: assignmentList[index].answerDatetime.toString(),
                    notesCreatedByProfile: assignmentList[index].answerByImageUrl,
                    noteCreatedById: assignmentList[index].answerById.toString(),
                    noteCreatedByType: assignmentList[index].answerByType),
              );
            } else {
              return FutureBuilder(
                future: fetchListAssignment(pageAssignment),
                builder: (BuildContext context,
                    AsyncSnapshot<AnswerListResponse> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageAssignment++;
                      assignmentList.addAll(snapshot.data!.rows!);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountAssignment()),
        ),
      );
    }
  }

  getAnswerSliver() {
    if (pageEnum_answer == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_answer == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: answerSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < answersList.length) {
              return CommentItemCard(
                isAnswer: postData!.postType == 'qa',
                key: UniqueKey(),
                data: NotesListItem(
                    noteContent: answersList[index].answerDetails,
                    notesCreatedByName: answersList[index].answerByName,
                    createdDate: answersList[index].answerDatetime.toString(),
                    notesCreatedByProfile: answersList[index].answerByImageUrl,
                    noteCreatedById: answersList[index].answerById.toString(),
                    noteCreatedByType: answersList[index].answerByType),
              );
            } else {
              return FutureBuilder(
                future: fetchListAnswers(pageAnswer),
                builder: (BuildContext context,
                    AsyncSnapshot<AnswerListResponse> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageAnswer++;
                      answersList.addAll(snapshot.data!.rows!);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountAnswer()),
        ),
      );
    }
  }

  getCommentSliver() {
    if (pageEnum_comment == PAGINATOR_ENUMS.LOADING) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).loadingWidgetMaker(),
      );
    } else if (pageEnum_comment == PAGINATOR_ENUMS.EMPTY) {
      return SliverToBoxAdapter(
        child: CustomPaginator(context).emptyListWidgetMaker(null),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 8, right: 8),
        sliver: SliverList(
          key: commentSliverKey,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < notesList.length) {
              return CommentItemCard(
                  key: UniqueKey(),
                  data: notesList[index],
                  ratingCallBack: () {
                    setState(() {
                      notesList[index].commRateCount =
                          notesList[index].commRateCount! + 1;
                    });
                  });
            } else {
              return FutureBuilder(
                future: fetchListComments(pageComment),
                builder: (BuildContext context,
                    AsyncSnapshot<NotesListResponse> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return CustomPaginator(context).loadingWidgetMaker();
                    case ConnectionState.done:
                      pageComment++;
                      notesList.addAll(snapshot.data!.rows!);
                      Future.microtask(() {
                        setState(() {});
                      });
                      return CustomPaginator(context).loadingWidgetMaker();
                    default:
                      return CustomPaginator(context).loadingWidgetMaker();
                  }
                },
              );
            }
          }, childCount: getItemsCountComment()),
        ),
      );
    }
  }

  void getPost(int? postId) async {
    final body = jsonEncode({"post_id": postId});

    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        // setState(() {
        if (res.rows != null) {
          isPostDataAvailable = true;
          postData = res.rows;
          refresh();
        }
        // });
      } else if (res.statusCode == "E100002") {
        print(
            "not availbale -------------------------------------------------------------------------");
        setState(() {
          // if(res.rows!=null) {
          isPostDataAvailable = false;
          errorMessage = res.message;
          // }
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void initialcallComment() async {
    prefs ??= await SharedPreferences.getInstance();
    var body = jsonEncode({
      "note_subject_type": "post",
      "note_subject_id": postId != null ? postId : postData!.postId,
      "page_number": pageComment,
      "page_size": 10
    });
    var res = await Calls().call(body, context, Config.COMMENTS_LIST);
    var response = NotesListResponse.fromJson(res);
    totalComment = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        notesList.addAll(response.rows!);
        setState(() {
          pageEnum_comment = PAGINATOR_ENUMS.SUCCESS;
          pageComment++;
        });
      } else {
        setState(() {
          pageEnum_comment = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_comment = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int? getItemsCountComment() {
    if (totalComment! > notesList.length) {
      return notesList.length + 1;
    } else {
      return totalComment;
    }
  }

  void inititalCallAssignment() async {
    AnswerListRequest payload = AnswerListRequest();
    payload.postId = postId != null ? postId : postData!.postId;
    payload.pageNumber = pageAnswer;
    payload.pageSize = 10;
    var res =
    await Calls().call(jsonEncode(payload), context, Config.ANSWER_LIST);
    var response = AnswerListResponse.fromJson(res);
    totalAssignment = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        assignmentList.addAll(response.rows!);
        setState(() {
          pageEnum_assignment = PAGINATOR_ENUMS.SUCCESS;
          pageAssignment++;
        });
      } else {
        setState(() {
          pageEnum_assignment = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_assignment = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  void initialcallAnswer() async {
    AnswerListRequest payload = AnswerListRequest();
    payload.postId = postId != null ? postId : postData!.postId;
    payload.pageNumber = pageAnswer;
    payload.pageSize = 10;
    var res =
    await Calls().call(jsonEncode(payload), context, Config.ANSWER_LIST);
    var response = AnswerListResponse.fromJson(res);
    totalAnswers = response.total;
    if (response.statusCode == Strings.success_code) {
      if (response.total! > 0) {
        answersList.addAll(response.rows!);
        setState(() {
          pageEnum_answer = PAGINATOR_ENUMS.SUCCESS;
          pageAnswer++;
        });
      } else {
        setState(() {
          pageEnum_answer = PAGINATOR_ENUMS.EMPTY;
        });
      }
    } else {
      setState(() {
        pageEnum_answer = PAGINATOR_ENUMS.EMPTY;
      });
    }
  }

  int? getItemsCountAssignment() {
    if (totalAssignment! > assignmentList.length) {
      return assignmentList.length + 1;
    } else {
      if (j == 0) {
        j = 1;
        initialcallComment();
      }
      return totalAssignment;
    }
  }

  int? getItemsCountAnswer() {
    if (totalAnswers! > answersList.length) {
      return answersList.length + 1;
    } else {
      if (j == 0) {
        j = 1;
        initialcallComment();
      }
      return totalAnswers;
    }
  }

  Future<NotesListResponse> fetchListComments(int page) async {
    var body = jsonEncode({
      "note_subject_type": "post",
      "note_subject_id": postData!.postId,
      "page_number": page,
      "page_size": 10
    });
    var res = await Calls().call(body, context, Config.COMMENTS_LIST);
    return NotesListResponse.fromJson(res);
  }

  Future<AnswerListResponse> fetchListAnswers(int page) async {
    AnswerListRequest payload = AnswerListRequest();
    payload.postId = postData!.postId;
    payload.pageNumber = page;
    payload.pageSize = 10;
    var res =
    await Calls().call(jsonEncode(payload), context, Config.ANSWER_LIST);
    return AnswerListResponse.fromJson(res);
  }

  Future<AnswerListResponse> fetchListAssignment(int page) async {
    AnswerListRequest payload = AnswerListRequest();
    payload.postId = postData!.postId;
    payload.pageNumber = page;
    payload.pageSize = 10;
    var res =
    await Calls().call(jsonEncode(payload), context, Config.ANSWER_LIST);
    return AnswerListResponse.fromJson(res);
  }

  // List<NotesListItem> listItemsGetter(NotesListResponse response) {
  //   notesList.addAll(response.rows);
  //   return response.rows;
  // }
  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void _onShareCallback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(),
        postData!.postId,
        DEEPLINKTYPE.POST.type,
        context);
    // _showModalBottomSheet(context);
  }

  void _onRatingCallback() {
    postRatingKey.currentState!.updateData();
    setState(() {
      for (var i in postData!.postContent!.header!.action!) {
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
              title: postData!.postContent!.content!.contentMeta!.title,
              okCallback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title: postData!.postContent!.content!.contentMeta!.title,
                      );
                    }));
              },
              cancelCallback: () {});
        });
  }

  void _onBookmarkCallback(int? postId, bool isBookmarked) {
    bookmarkPost(postId, isBookmarked);
  }

  void _onCommentCallback() {
    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=> PostCardDetailPage()));
  }

  void onVoteCallback() {
    // setState(() {
    postData!.isVoted = true;
    // postList[index].postContent.content.contentMeta.others.totalResponses = postList[index].postContent.content.contentMeta.others.totalResponses+1;
    // });
  }

  void _onFollowCallback(bool isFollow) {
    setState(() {
      for (var i in postData!.postContent!.header!.action!) {
        if (i.type == 'is_followed') {
          i.value = isFollow;
        }
      }
    });
  }

  // void _showModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
  //     ),
  //     builder: (context) {
  //       return BottomSheetContentDetail(postData.postId);
  //     },
  //   );
  // }

  void bookmarkPost(int? postId, bool isBookMarked) {
    setState(() {
      postData!.isBookmarked = isBookMarked;
    });
  }

  getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  getPostCard() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        Widget card;
        if (snapshot.hasData) {
          card = postData != null
              ? TricyclePostCard(
            cardData: postData,
            isFilterPage: false,
            download: () {
              Navigator.pop(context);
            },
            preferences: snapshot.data,
            isBackButtonVisible: true,
            onBackPressed: () {
              Navigator.pop(context);
            },
            isDetailPage: true,
            sharecallBack: _onShareCallback,
            ratingCallback: () {
              _onRatingCallback();
            },
            bookmarkCallback: (isBookmarked) {
              _onBookmarkCallback(postData!.postId, isBookmarked!);
            },
            onTalkCallback: () {
              onTalkCallback();
            },
            commentCallback: _onCommentCallback,
            onFollowCallback: (isFollow) {
              _onFollowCallback(isFollow);
            },
            hidePostCallback: () {},
            deletePostCallback: () {},
            onVoteCallback: () {
              onVoteCallback();
            },
            onSubmitAnswer: (){
              openSubmitAssignPage(
                  postData!.postContent!.content!.contentMeta!.title,
                  postData!.postId
              );
            },
            onAnswerClickCallback: () {
              openAnswerPage(
                  postData!.postContent!.content!.contentMeta!.title,
                  postData!.postId);
            },
          )
              : Container(
            height: 150,
          );
        } else if (snapshot.hasError) {
          card = Center(
            child: Text(AppLocalizations.of(context)!.translate('error')),
          );
        } else {
          card = Center(
            child: Text(AppLocalizations.of(context)!.translate('loading')),
          );
        }
        return card;
      },
    );
  }

  void openAnswerPage(String? question, int? postId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostCreatePage(
          type: 'answer',
          question: question,
          postId: postId,
          prefs: prefs,
        )));
  }
  void openSubmitAssignPage(String? question, int? postId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostCreatePage(
          type: 'submit_assign',
          question: question,
          postId: postId,
          prefs: prefs,
        ))).then((value){
      if(value!=null){
        if(value){
          postData!.isVoted = true;
        }
        setState(() {
          refresh();
        });
      }
    });
  }

  void submitComment(String value) async {
    prefs = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "note_type": "comment",
      "note_created_by_type": "person",
      "note_created_by_id": prefs!.getInt(Strings.userId),
      "note_subject_type": "post",
      "note_subject_id": postData!.postId,
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

  void refresh() {
    notesList.clear();
    answersList.clear();
    assignmentList.clear();
    pageComment = 1;
    pageAnswer = 1;
    pageAssignment = 1;
    if (postData != null && postData!.postType == 'qa') {
      pageAnswer = 1;
      j = 0;
      initialcallAnswer();
    } else if(postData != null && postData!.postType == 'assignment'){
      j = 0;
      inititalCallAssignment();
    }else {
      initialcallComment();
    }
    // paginatorKey.currentState.changeState(resetState: true);
  }

  void addNote(String noteContent) {
    NotesListItem note = NotesListItem();
    note.notesCreatedByName = prefs!.getString(Strings.userName);
    note.noteCreatedById = prefs!.getInt(Strings.userId).toString();
    note.noteCreatedByType = 'person';
    note.noteContent = noteContent;
    note.notesCreatedByProfile = prefs!.getString(Strings.profileImage);
    setState(() {
      pageEnum_comment = PAGINATOR_ENUMS.SUCCESS;
      notesList.insert(0, note);
      totalComment =totalComment!+1;
    });
    Timer(Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(commentSliverKey.currentContext!);
    });
    // refresh();
  }
}

// ignore: must_be_immutable
class BottomSheetContentDetail extends StatefulWidget {
  int postId;

  @override
  _ShareBottomSheetDetail createState() => _ShareBottomSheetDetail(postId);

  BottomSheetContentDetail(this.postId);
}

class _ShareBottomSheetDetail extends State<BottomSheetContentDetail> {
  late TextStyleElements styleElements;
  int? _selectedshareoption;
  int postId;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Wrap(children: [
        Container(
          decoration: new BoxDecoration(
              color: HexColor(AppColors.appColorWhite),
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.translate('who_want_share'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Radio(
                        value: 1,
                        groupValue: _selectedshareoption,
                        onChanged: (dynamic value) {
                          setState(() {
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.translate('share_within'),
                        style: styleElements.bodyText2ThemeScalable(context),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Radio(
                        value: 2,
                        groupValue: _selectedshareoption,
                        onChanged: (dynamic value) {
                          setState(() {
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(
                        AppLocalizations.of(context)!
                            .translate('share_through_messanger'),
                        style: styleElements.bodyText2ThemeScalable(context),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Radio(
                        value: 3,
                        groupValue: _selectedshareoption,
                        onChanged: (dynamic value) {
                          _onShare();
                          setState(() {
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(
                        AppLocalizations.of(context)!
                            .translate('share_through_other'),
                        style: styleElements.bodyText2ThemeScalable(context),
                      ),
                    )),
              ),
            ],
          ),
        )
      ]),
    );
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void _onShare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(),
        postId,
        DEEPLINKTYPE.POST.type,
        context);
  }

  _ShareBottomSheetDetail(this.postId);
}
