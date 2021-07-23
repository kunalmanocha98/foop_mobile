import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/TricycleCaughtupComponent.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/updaterecipientlist.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../postcardDetail.dart';

class PostListPage extends StatefulWidget {
  final bool isOthersPostList;
  final String? postOwnerType;
  final int? postOwnerTypeId;
  final bool? isFromProfile;
  final int? excludeRecordsNumber;

  PostListPage(
      {Key? key,
        required this.isOthersPostList,
        this.postOwnerTypeId,
        this.isFromProfile,
        this.excludeRecordsNumber = 0,
        this.postOwnerType})
      : super(key: key);

  @override
  PostListState createState() => PostListState(
    isOthersPostList: isOthersPostList,
    postOwnerType: postOwnerType,
    isFromProfile: isFromProfile,
    postOwnerTypeId: postOwnerTypeId,
  );
}

class PostListState extends State<PostListPage> {
  final bool? isFromProfile;
  SharedPreferences? prefs;
  List<PostListItem> postList = [];
  bool? isOthersPostList;
  String? postOwnerType;
  int? postOwnerTypeId;
  late TextStyleElements styleElements;
  PAGINATOR_ENUMS? pageEnum;
  int page = 0;

  // ScrollController _sc = new ScrollController();
  bool isLoading = false;
  int? totalItems = 0;
  bool loadSuggestions = false;
  int i = 0;

  PostListState(
      {this.isOthersPostList,
        this.postOwnerTypeId,
        this.postOwnerType,
        this.isFromProfile});

  @override
  void initState() {
    pageEnum = PAGINATOR_ENUMS.LOADING;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshPage();
    });
  }

  void refreshPage() async {
    await Utility().refreshList(context);
    if (isOthersPostList!) {
      _initialFutureCallOthers();
    } else {
      _initialFutureCall();
    }
  }

  Future<PostListResponse> fetch(int page) {
    if (isOthersPostList!)
      return fetchOthersList(page).then((value) => value as PostListResponse);
    else
      return fetchList(page);
  }

  @override
  void dispose() {
    // _sc.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      print("refresh");
      pageEnum = PAGINATOR_ENUMS.LOADING;
      postList.clear();
      page = 0;
      loadSuggestions = false;
    });
    if (isOthersPostList!) {
      _initialFutureCallOthers();
    } else {
      _initialFutureCall();
    }
  }

  Widget simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 32,
        color: HexColor(AppColors.appColorBlack85),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => PostListMenu(context: context).menuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'notice':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle: AppLocalizations.of(context)!
                        .translate('notice_board'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.NOTICE.status,
                  )));
              break;
            }
          case 'bookmark':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    isBookMarked: true,
                    appBarTitle: AppLocalizations.of(context)!
                        .translate('bookmarked_posts'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                  )));
              break;
            }
          case 'news':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CampusNewsListPage()));
              break;
            }
          case 'blog':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                    AppLocalizations.of(context)!.translate('article'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.BLOG.status,
                  )));
              break;
            }
          case 'qa':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle: AppLocalizations.of(context)!
                        .translate('ask_expert'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.QNA.status,
                  )));
              break;
            }
          case 'poll':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PollsListPage(
                    prefs: prefs,
                  )));
              break;
            }
          case 'old':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle: 'Older Posts',
                    postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                  )));
              break;
            }
          case 'general':
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                    AppLocalizations.of(context)!.translate('general'),
                    postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                  )));
              break;
            }
          default:
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                    AppLocalizations.of(context)!.translate('notice'),
                    postRecipientStatus:
                    POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.NOTICE.status,
                  )));
              break;
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return _buildPage();

    // return NestedScrollView(
    //   headerSliverBuilder: (context, value) => [
    //     !isFromProfile
    //         ? SliverToBoxAdapter(
    //       child: Padding(
    //         padding: const EdgeInsets.only(
    //             left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Text(
    //                     AppLocalizations.of(context)
    //                         .translate("welcome_name") +
    //                         " " +
    //                         (prefs != null
    //                             ? prefs.getString(
    //                             Strings.firstName) ??
    //                             ""
    //                             : "") ??
    //                         " ",
    //                     style: styleElements
    //                         .headline6ThemeScalable(context)
    //                         .copyWith(
    //                         fontWeight: FontWeight.bold,
    //                         color:
    //                         HexColor(AppColors.appColorBlack85)),
    //                     textAlign: TextAlign.left,
    //                   ),
    //                   Text(
    //                     AppLocalizations.of(context)
    //                         .translate("have_nice_day"),
    //                     style:
    //                     styleElements.subtitle2ThemeScalable(context),
    //                     textAlign: TextAlign.left,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             _simplePopup()
    //           ],
    //         ),
    //       ),
    //     )
    //         : SliverToBoxAdapter(
    //       child: Container(),
    //     ),
    //   ],
    //   body: _buildPage(),
    // );
    // return !isFromProfile ? Scaffold(
    //     appBar: TricycleAppBar().getCustomAppBar(context,
    //         appBarTitle: 'Campus Circle',
    //         isIconVisible: false,
    //         actions: [
    //           _simplePopup()
    //         ],
    //         onBackButtonPress: () {
    //           Navigator.pop(context);
    //         }),
    //     resizeToAvoidBottomInset: false,
    //     body: _buildPage()
    // ) : _buildPage();
  }

  _buildPage() {
    switch (pageEnum) {
      case PAGINATOR_ENUMS.SUCCESS:
        return InViewNotifierList(
          physics: ClampingScrollPhysics(),
          isInViewPortCondition:
              (double deltaTop, double deltaBottom, double viewPortDimension) {
            return deltaTop < (0.5 * viewPortDimension) + 200 &&
                deltaBottom > (0.5 * viewPortDimension) - 200;
          },
          itemCount: _getItemCount(),
          shrinkWrap: true,
          builder: _itemBuilder,
        );

      case PAGINATOR_ENUMS.LOADING:
        return Center(child: CustomPaginator(context).loadingWidgetMaker());

      case PAGINATOR_ENUMS.ERROR:
        return Center(
            child: CustomPaginator(context).errorWidgetMaker(null, () {
              refresh();
            }));

      case PAGINATOR_ENUMS.EMPTY:
      default:
        return CustomPaginator(context).emptyListWidgetMaker(null);
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index < postList.length) {
      return InViewNotifierWidget(
        key: UniqueKey(),
        id: '$index',
        child: listItemBuilder(postList[index], index),
        builder: (BuildContext context, bool isInView, Widget? child) {
          if (isInView)
            postStatusUpdate(
                postList[index].postId, postList[index].isBookmarked ??= false);
          {
            if (postList[index].isBookmarked != null &&
                postList[index].isBookmarked!) {
              postStatusUpdate(postList[index].postId, true);
            }
          }
          if (index == postList.length) {
            return CustomPaginator(context).loadingWidgetMaker();
          } else {
            print("returning chiild");
            return child!;
          }
        },
      );
    } else {
      return FutureBuilder(
        future: loadSuggestions ? fetchSuggestions(page + 1) : fetch(page + 1),
        builder:
            (BuildContext context, AsyncSnapshot<PostListResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CustomPaginator(context).loadingWidgetMaker();
            case ConnectionState.done:
              postList.addAll(snapshot.data!.rows!);
              page++;
              Future.microtask(() {
                setState(() {
                  print("itembuilder");
                });
              });
              return CustomPaginator(context).loadingWidgetMaker();
            default:
              return CustomPaginator(context).loadingWidgetMaker();
          }
        },
      );
    }
  }

  void _initialFutureCall() async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page + 1;
    payload.pageSize = 25;
    payload.personId = prefs!.getInt(Strings.userId);
    payload.isOwnPost = false;
    payload.postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
    payload.excludeNRecords = widget.excludeRecordsNumber;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    var response = PostListResponse.fromJson(res);
    if (response != null) {
      totalItems = response.total;
      if (response.statusCode != Strings.success_code) {
        setState(() {
          print("error");
          pageEnum = PAGINATOR_ENUMS.ERROR;
        });
      } else {
        if (totalItems == 0) {
          setState(() {
            print("success");
            pageEnum = PAGINATOR_ENUMS.SUCCESS;
          });
        } else {
          // isLoading = false;
          page++;
          postList.addAll(response.rows!);
          setState(() {
            print("success");
            pageEnum = PAGINATOR_ENUMS.SUCCESS;
          });
        }
      }
    } else {
      setState(() {
        print("error");
        pageEnum = PAGINATOR_ENUMS.ERROR;
      });
    }
  }

  void _initialFutureCallOthers() async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.postOwnerType = postOwnerType;
    payload.postOwnerTypeId = postOwnerTypeId;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.OTHER_POST_LIST);
    var response = PostListResponse.fromJson(res);
    totalItems = response.total;
    if (totalItems == 0) {
      setState(() {
        print("empty");
        pageEnum = PAGINATOR_ENUMS.EMPTY;
      });
    } else {
      // isLoading = false;
      page++;
      postList.addAll(response.rows!);
      setState(() {
        print("success");
        pageEnum = PAGINATOR_ENUMS.SUCCESS;
      });
    }
  }

  int? _getItemCount() {
    if (!loadSuggestions) {
      if (totalItems! > postList.length) {
        return postList.length + 1;
      } else {
        loadSuggestions = true;
        page = 0;
        return postList.length + 1;
      }
    } else {
      if (totalItems! > postList.length) {
        return postList.length + 1;
      } else {
        return totalItems;
      }
    }
    // return totalItems;
  }

  Future<PostListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 25;
    payload.personId = prefs!.getInt(Strings.userId);
    payload.isOwnPost = false;
    payload.excludeNRecords = widget.excludeRecordsNumber;
    payload.postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    return PostListResponse.fromJson(res);
    // totalItems = response.total;
    //   if (totalItems == 0) {
    //   setState(() {
    //     pageEnum = PAGINATOR_ENUMS.EMPTY;
    //   });
    // } else {
    //     isLoading = false;
    //   page++;
    //   postList.addAll(response.rows);
    //   setState(() {
    //     pageEnum = PAGINATOR_ENUMS.SUCCESS;
    //   });
    // }
  }

  Future fetchOthersList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.postOwnerType = postOwnerType;
    payload.postOwnerTypeId = postOwnerTypeId;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.OTHER_POST_LIST);
    return PostListResponse.fromJson(res);
    // setState(() {
    //   isLoading = false;
    //   postList.addAll(response.rows);
    //   page++;
    // });
  }

  Future<PostListResponse> fetchSuggestions(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.type = 'post';
    payload.personId = prefs!.getInt(Strings.userId);
    // payload.isOwnPost = false;
    // payload.postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.SUGGESTIONS_LIST);
    PostListResponse response = PostListResponse.fromJson(res);
    if (i == 0) {
      i = 1;
      if (response != null) {
        response.rows!.insert(
            0,
            PostListItem(
                postType: 'banner',
                postContent: PostContent(
                    header: Header(
                        layout: postList.length > 0 ? 'old' : 'new',
                        title: postList.length > 0
                            ? "You are done with new messages"
                            : "Welcome. Start posting your knowledge, idea, opportunities, and more that helps you and others learn from each other",
                        subtitle1: postList.length > 0
                            ? "view older messages"
                            : "Create New Post"))));
      } else {
        response = PostListResponse();
        List<PostListItem> list = [];
        list.add(PostListItem(
            postType: 'banner',
            postContent: PostContent(
                header: Header(
                    layout: postList.length > 0 ? 'old' : 'new',
                    title: postList.length > 0
                        ? "You are done with new messages"
                        : "Welcome. Start posting your knowledge, idea, opportunities, and more that helps you and others learn from each other",
                    subtitle1: postList.length > 0
                        ? "view older messages"
                        : "Create New Post"))));
        response.rows = list;
        response.total = 0;
      }
      if (response.total! > 0) {
        response.rows!.insert(
            1,
            PostListItem(
                postType: 'title',
                postContent:
                PostContent(header: Header(title: 'Suggestions'))));
        totalItems = totalItems! + response.total! + 2;
      } else {
        totalItems = totalItems! + response.total! + 1;
      }
    }
    return response;
  }

  Widget listItemBuilder(PostListItem item, int index) {
    if (item.postType == 'banner') {
      print("banner");
      return TricycleCaughtUpComponent(
        title: item.postContent!.header!.title,
        actionTitle: item.postContent!.header!.subtitle1,
        onClick: () {
          if (item.postContent!.header!.layout == 'old') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectedFeedListPage(
                  isFromProfile: false,
                  appBarTitle: 'Older Posts',
                  postRecipientStatus: POST_RECIPIENT_STATUS.READ.status,
                )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostCreatePage(
                  type: 'feed',
                  prefs: prefs,
                )));
          }
        },
      );
    } else if (item.postType == 'title') {
      print("title");
      return Padding(
        padding: EdgeInsets.only(top: 8, bottom: 16, left: 8),
        child: Text(
          item.postContent!.header!.title!,
          style: styleElements.headline6ThemeScalable(context),
        ),
      );
    } else {
      print("card-----");
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context)  {
                  if(item.postType =='lesson' ) {
                    return NewNewsAndArticleDetailPage(postData: item,);
                    // return ExampleScreen();
                  }else{
                    return PostCardDetailPage(postData: item,);
                  }
                }));
          },
          child: TricyclePostCard(
              key: UniqueKey(),
              // color: isInView?HexColor(AppColors.appColorBlue)[200]:HexColor(AppColors.appColorWhite),
              preferences: prefs,
              cardData: item,
              isFilterPage: false,
              isDetailPage: false,
              download: () {
                Navigator.pop(context);
              },
              sharecallBack: () {
                _onShareCallback(item.postId);
              },
              ratingCallback: () {
                _onRatingCallback(index);
              },
              bookmarkCallback: (isBookmarked) {
                _onBookmarkCallback(item.postId, index, isBookmarked!);
              },
              commentCallback: () {
                _onCommentCallback(index);
              },
              onFollowCallback: (isFollow) {
                _onFollowCallback(isFollow, index);
              },
              hidePostCallback: () {
                removeFromList(index);
              },
              deletePostCallback: () {
                removeFromList(index);
              },
              onTalkCallback: () {
                onTalkCallback(index);
              },
              onAnswerClickCallback: () {
                openAnswerPage(
                    item.postContent!.content!.contentMeta!.title, item.postId);
              },
              onSubmitAnswer:(){
                openSubmitAssignPage(
                    item.postContent!.content!.contentMeta!.title, item.postId, index
                );
              },
              onVoteCallback: () {
                onVoteCallback(index);
              }));
    }
  }
  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: postList[index].postContent!.content!.contentMeta!.title,
              okCallback:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title: postList[index].postContent!.content!.contentMeta!.title,
                      );
                    }));
              },
              cancelCallback:(){}
          );
        });
  }

  void onVoteCallback(int index) {
    // setState(() {
    postList[index].isVoted = true;
    // postList[index].postContent.content.contentMeta.others.totalResponses = postList[index].postContent.content.contentMeta.others.totalResponses+1;
    // });
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
  void openSubmitAssignPage(String? question, int? postId, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostCreatePage(
          type: 'submit_assign',
          question: question,
          postId: postId,
          prefs: prefs,
        ))).then((value) {
          if(value!=null){
            if(value){
              setState(() {
                postList[index].isVoted = true;
              });
            }
          }
    });
  }

  void postStatusUpdate(int? postId, bool bookmarkStatus) {
    PostRecipientUpdatePayload payload = PostRecipientUpdatePayload();
    payload.postId = postId;
    payload.postRecipientStatus = POST_RECIPIENT_STATUS.READ.status;
    payload.isBookmarked = bookmarkStatus;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_RECIPIENT_LIST);
  }

  void removeFromList(int index) {
    setState(() {
      print("remove");
      postList.removeAt(index);
      totalItems = totalItems! - 1;
    });
  }

  void _onShareCallback(int? id) {
    _onShare(id);
  }

  void _onRatingCallback(int index) {
    // setState(() {
    for (var i in postList[index].postContent!.header!.action!) {
      if (i.type == 'is_rated') {
        i.value = true;
      }
    }
    // });
  }

  void _onBookmarkCallback(int? postId, int index, bool isBookmarked) {
    bookmarkPost(postId, index, isBookmarked);
  }

  void _onCommentCallback(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)  {
          if(postList[index].postType =='lesson' ) {
            return NewNewsAndArticleDetailPage(postData: postList[index],);
          }else{
            return PostCardDetailPage(postData: postList[index],);
          }
        }));
  }

  void _onFollowCallback(bool isFollow, int index) {
    setState(() {
      print("follow");
      var desiredList = postList.where((element) {
        return element.postOwnerTypeId == postList[index].postOwnerTypeId;
      });
      for (var i in desiredList) {
        for (var j in i.postContent!.header!.action!) {
          if (j.type == 'is_followed') {
            j.value = isFollow;
          }
        }
      }
    });
  }

  void bookmarkPost(int? postId, int index, bool isBookMarked) {
    // setState(() {
    postList[index].isBookmarked = isBookMarked;
    // });
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void _onShare(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
  }
}

// ignore: must_be_immutable
class BottomSheetContent extends StatefulWidget {
  int id;

  BottomSheetContent(this.id);

  @override
  _ShareBottomSheet createState() => _ShareBottomSheet(id);
}

class _ShareBottomSheet extends State<BottomSheetContent> {
  late TextStyleElements styleElements;
  int? _selectedshareoption;
  int id;

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
                            print("share");
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
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Padding(
              //       padding: EdgeInsets.all(0),
              //       child: ListTile(
              //         leading: Radio(
              //           value: 2,
              //           groupValue: _selectedshareoption,
              //           onChanged: (value) {
              //             setState(() {
              //               _selectedshareoption = value;
              //             });
              //           },
              //         ),
              //         title: Text(
              //           "Share through Tricycle messenger",
              //           style: styleElements.bodyText2ThemeScalable(context),
              //         ),
              //       )),
              // ),
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
                            print("share");
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
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
  }

  _ShareBottomSheet(this.id);
}

class PostListMenu {
  late TextStyleElements styleElements;
  BuildContext context;
  String? type;

  PostListMenu({required this.context, this.type}) {
    styleElements = TextStyleElements(context);
    this.type = type ?? "";
  }

  List<PopupMenuItem> get menuList {
    List<PopupMenuItem> list = [];
    list.add(PopupMenuItem(
        enabled: false,
        value: POST_TYPE.GENERAL.status,
        child: Center(
          child: Text(
            'Campus Circle',
            style: styleElements
                .subtitle1ThemeScalable(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        )));
    if (type != POST_TYPE.GENERAL.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.GENERAL.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('general'),
              'Classmates, teachers & experts',
              'assets/appimages/general-post.png')));
    }
    if (type != POST_TYPE.BLOG.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.BLOG.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('article'),
              'You learn a lot & get more idea, by reading',
              'assets/appimages/create-articles.png')));
    }
    if (type != POST_TYPE.QNA.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.QNA.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('ask_expert'),
              'Learn more by asking & answering',
              'assets/appimages/create-ask.png')));
    }
    if (type != POST_TYPE.POLL.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.POLL.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('poll'),
              'Run polls to see validate your views & ideas',
              'assets/appimages/polls.png')));
    }
    if (type != POST_TYPE.NOTICE.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.NOTICE.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('notice_board'),
              'Announcement & circulars in one place',
              'assets/appimages/create-notice.png')));
    }
    if (type != POST_TYPE.NEWS.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.NEWS.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('news'),
              'Your friends are the journalists',
              'assets/appimages/news.png')));
    }
    // if (type != POST_TYPE.ASSIGNMENT.status) {
    //   list.add(PopupMenuItem(
    //       value: POST_TYPE.ASSIGNMENT.status,
    //       child: getUiElement(
    //           AppLocalizations.of(context).translate('assignment'),
    //           'Your friends are the journalists',
    //           'assets/appimages/assignment.png')));
    // }
    if (type != POST_TYPE.BOOKMARK.status) {
      list.add(PopupMenuItem(
          value: POST_TYPE.BOOKMARK.status,
          child: getUiElement(
              AppLocalizations.of(context)!.translate('bookmarked_posts'),
              'What you want to remember!',
              'assets/appimages/bookmark.png')));
    }
    if (type != 'old') {
      list.add(PopupMenuItem(
        value: 'old',
        child: getUiElement(
            AppLocalizations.of(context)!.translate('old_messages'),
            'Classmates, teachers & experts',
            'assets/appimages/read-post.png'),
      ));
    }
    return list;
  }

  Widget getUiElement(String title, String subtitle, String assetimage) {
    return TricycleListCard(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
      child: Row(
        children: [
          Image.asset(
            assetimage,
            width: 16,
            height: 16,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
