import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/ui/postcardDetail.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CampusNewsListPage.dart';

class SelectedFeedListPage extends StatefulWidget {
  final String? postType;
  final String? postRecipientStatus;
  final String appBarTitle;
  final bool isOthersPostList;
  final String? postOwnerType;
  final int? postOwnerTypeId;
  final bool? isFromProfile;
  final bool? isOwnPost;
  final bool isBookMarked;
  final bool isRoomPost;
  final int? roomId;
  final bool isEventPost;
  final int? eventId;
  final Function? callBack;
  final bool isReceivedPost;
  SelectedFeedListPage(
      {Key? key, this.postType,
      this.postRecipientStatus,
      required this.appBarTitle,
      this.isOthersPostList = false,
      this.postOwnerTypeId,
        this.isFromProfile,
        this.isOwnPost,
        this.callBack,
        this.isBookMarked = false,
        this.isRoomPost =false,
        this.roomId,
        this.isEventPost =false,
        this.isReceivedPost = false,
        this.eventId,
      this.postOwnerType}):super(key:key);

  @override
  SelectedFeedPageState createState() => SelectedFeedPageState(
      postType: postType,
      postRecipientStatus: postRecipientStatus,
      appBarTitle: appBarTitle,
      isFromProfile:isFromProfile,
      postOwnerTypeId: postOwnerTypeId,
      postOwnerType: postOwnerType,
      isOwnPost: isOwnPost,
      isBookMarked:isBookMarked,
      isReceivedPost: isReceivedPost,
      isOthersPostList: isOthersPostList);
}

class SelectedFeedPageState extends State<SelectedFeedListPage> {
  List<PostListItem> feedList = [];
  int? totalItems = 0;
  SharedPreferences? prefs;
  int page = 0;
  PAGINATOR_ENUMS? pageEnum;
  String? appBarTitle;
  String? postType;
  String? postRecipientStatus;
  late TextStyleElements styleElements;
  bool isOthersPostList;
  final String? postOwnerType;
  final int? postOwnerTypeId;
  bool? isFromProfile;
  bool? isOwnPost;
  bool? isBookMarked;
  bool loadSuggestions=  false;
  bool? isReceivedPost;
  int i=0;
  SelectedFeedPageState(
      {this.postType,
      this.postRecipientStatus,
      this.appBarTitle,
        this.isBookMarked,
        this.isFromProfile,
      this.isOthersPostList = false,
      this.postOwnerTypeId,
        this.isOwnPost,
        this.isReceivedPost,
      this.postOwnerType}) ;

  @override
  void initState() {
    pageEnum = PAGINATOR_ENUMS.LOADING;
    if (!isOthersPostList) {
      _initialFutureCall();
    } else {
      _initialFutureCallOthers();
    }
    super.initState();
  }

  void refresh() {
    setState(() {
      pageEnum = PAGINATOR_ENUMS.LOADING;
      feedList.clear();
      page = 0;
      i=0;
      loadSuggestions= false;
    });
    if (!isOthersPostList) {
      _initialFutureCall();
    } else {
      _initialFutureCallOthers();
    }
  }

  Widget _simplePopup() {
    // var name = headerData.title;
    return PopupMenuButton(
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => PostListMenu(context: context).menuList,
      onSelected: (dynamic value) {
        if(postType!=value) {
          switch (value) {
            case 'all':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('all');
                postType = POST_TYPE.ALL.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'general':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('general');
                postType = POST_TYPE.GENERAL.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'assignment':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('assignment');
                postType = POST_TYPE.ASSIGNMENT.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'notice':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('notice_board');
                postType = POST_TYPE.NOTICE.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'blog':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('article');
                postType = POST_TYPE.BLOG.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'qa':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('ask_expert');
                postType = POST_TYPE.QNA.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'poll':
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PollsListPage(prefs: prefs,)
                ));
                break;
              }
            case 'old':
              {
                appBarTitle = 'Older Posts';
                postType = null;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.READ.status;
                refresh();
                break;
              }
            case 'bookmark':
              {
                appBarTitle = AppLocalizations.of(context)!.translate('bookmarked_posts');
                postType = null;
                isBookMarked = true;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
            case 'news':
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CampusNewsListPage()
                ));
                break;
              }
            default:
              {
                appBarTitle = AppLocalizations.of(context)!.translate('notice');
                postType = POST_TYPE.NOTICE.status;
                isBookMarked = false;
                postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
                refresh();
                break;
              }
          }
        }
      },
      icon: Icon(
        Icons.segment,
        color: HexColor(AppColors.appColorBlack65),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return!isFromProfile!? SafeArea(
      child: Scaffold(
          appBar: appAppBar().getCustomAppBar(context,
              appBarTitle: appBarTitle,
              actions: isOthersPostList
                  ? []
                  : [
                      InkWell(
                          onTap: () {
                            _showModalSelectorSheet(context);
                          },
                          child: Icon(
                            Icons.add,
                            color: HexColor(AppColors.appColorBlack65),
                          )),
                      _simplePopup()
                    ], onBackButtonPress: () {
            Navigator.pop(context);
          }),
          body: _buildPage()),
    ):_buildPage();
  }

  void _showModalSelectorSheet(BuildContext context) async {

    prefs ??= await SharedPreferences.getInstance();
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return CreateNewBottomSheet(
          isRoomsVisible: false,
          prefs: prefs,
          onClickCallback: (value) {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostCreatePage(
                      type: value,
                  callBack: (){

                        refresh();
                  },
                    )));
          },
        );
      },
    );
  }
  Future<Null> refreshList() async {
   refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
  }
  _buildPage() {
    switch (pageEnum) {
      case PAGINATOR_ENUMS.SUCCESS:
        return RefreshIndicator(
          onRefresh: refreshList,
          child: ListView.builder(
            itemCount: _getItemCount(),
            itemBuilder: (BuildContext context, int index) {
              return _itemBuilder(context, index);
            },
          ),
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

  int? _getItemCount() {
    if(!loadSuggestions) {
      if (totalItems! > feedList.length) {
        return feedList.length + 1;
      } else {
        if(!isBookMarked!) {
          loadSuggestions = true;
          page = 0;
          return feedList.length + 1;
        }else{
          return totalItems;
        }
      }
    }else{
      if (totalItems! > feedList.length) {
        return feedList.length + 1;
      } else {
        return totalItems;
      }
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index < feedList.length) {
      if (index == feedList.length) {
        return CustomPaginator(context).loadingWidgetMaker();
      } else {
        return listItemBuilder(feedList[index], index);
      }
    } else {
      return FutureBuilder(
        future:
        isOthersPostList ? fetchOthersList(page + 1) : loadSuggestions?fetchSuggestions(page+1):fetchList(page+1),
        builder:
            (BuildContext context, AsyncSnapshot<PostListResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CustomPaginator(context).loadingWidgetMaker();
            case ConnectionState.done:
                feedList.addAll(snapshot.data!.rows!);
                page++;
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
  }

  Widget listItemBuilder(PostListItem item, int index) {
    if(item.postType == 'title'){
      return Padding(
        padding: EdgeInsets.only(top: 8, bottom: 16,left: 8),
        child: Text(item.postContent!.header!.title!,
          style: styleElements.headline6ThemeScalable(context),),
      );
    }else {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context)  {
                  if(item.postType =='lesson' ) {
                    return NewNewsAndArticleDetailPage(postData: item,);
                  }else{
                    return PostCardDetailPage(postData: item,);
                  }
                }));
          },
          child: appPostCard(
              key: UniqueKey(),
              isFilterPage: true,
              // color: isInView?HexColor(AppColors.appColorBlue)[200]:HexColor(AppColors.appColorWhite),
              preferences: prefs,
              cardData: item,
              download: () {},
              isTitleVisible: !(postType == POST_TYPE.NOTICE.status),
              isDetailPage: false,
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
              onVoteCallback: () {
                onVoteCallback(index);
              },
              onTalkCallback: () {
                onTalkCallback(index);
              },
              onAnswerClickCallback: () {
                openAnswerPage(
                    item.postContent!.content!.contentMeta!.title, item.postId);
                // openSubmitAssignPage(
                //     item.postContent.content.contentMeta.title, item.postId
                // );
              },
            onSubmitAnswer:(){
              openSubmitAssignPage(
                  item.postContent!.content!.contentMeta!.title, item.postId,index
              );
            },
              ));
    }
  }

  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: feedList[index].postContent!.content!.contentMeta!.title,
              okCallback:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title: feedList[index].postContent!.content!.contentMeta!.title,
                      );
                    }));
              },
              cancelCallback:(){}
          );
        });
  }
  void _initialFutureCall() async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page + 1;
    payload.pageSize = 25;
    payload.personId = prefs!.getInt(Strings.userId);
    payload.isBookmarked = isBookMarked;
    payload.isOwnPost = isOwnPost??=false;
    payload.isReceived = isReceivedPost ??= false;
    if (postType != 'all') payload.postType = postType;
    if(postRecipientStatus != POST_RECIPIENT_STATUS.UNREAD.status) {
      payload.postRecipientStatus = postRecipientStatus;
    }else{
      payload.postRecipientStatus = null;
    }
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    var response = PostListResponse.fromJson(res);
    if(response!=null) {
      
      totalItems = response.total;
      if (response.statusCode != Strings.success_code) {
        setState(() {
          pageEnum = PAGINATOR_ENUMS.SUCCESS;
        });
      } else {
        if (totalItems == 0) {
          setState(() {
            pageEnum = PAGINATOR_ENUMS.SUCCESS;
          });
        } else {
          // isLoading = false;
          page++;
          feedList.addAll(response.rows!);
          setState(() {
            pageEnum = PAGINATOR_ENUMS.SUCCESS;
          });
        }
      }
    } else {
      
      setState(() {
        print("error");
        pageEnum = PAGINATOR_ENUMS.SUCCESS;
      });
    }
  }

  void _initialFutureCallOthers() async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 25;
    payload.postOwnerType = postOwnerType;
    payload.postOwnerTypeId = postOwnerTypeId;
    payload.roomId = widget.roomId;
    payload.isRoomPost = widget.isRoomPost;
    payload.isEventPost = widget.isEventPost;
    payload.eventId = widget.eventId;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.OTHER_POST_LIST);
    var response = PostListResponse.fromJson(res);
    
    totalItems = response.total;
    if (totalItems == 0) {
      setState(() {
        pageEnum = PAGINATOR_ENUMS.EMPTY;
      });
    } else {
      // isLoading = false;
      page++;
      feedList.addAll(response.rows!);
      setState(() {
        pageEnum = PAGINATOR_ENUMS.SUCCESS;
      });
    }
  }

  Future<PostListResponse> fetchSuggestions(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 25;
    payload.type = 'post';
    payload.personId = prefs!.getInt(Strings.userId);
    payload.postType = postType;
    // payload.isOwnPost = false;
    // payload.postRecipientStatus = POST_RECIPIENT_STATUS.UNREAD.status;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.SUGGESTIONS_LIST);
    PostListResponse response = PostListResponse.fromJson(res);
    if(i==0) {
      i=1;
      if(response!=null) {
        if (response.total! > 0) {
          response.rows!.insert(0, PostListItem(
              postType: 'title',
              postContent: PostContent(
                  header: Header(
                      title: 'Suggestions'
                  )
              )
          ));
          totalItems = totalItems! + response.total! + 1;
        } else {
          totalItems = totalItems! + response.total!;
        }
      }
    }
    return response;
  }

  Future<PostListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 25;
    payload.personId = prefs!.getInt(Strings.userId);
    payload.isOwnPost = isOwnPost??=false;
    payload.isReceived = isReceivedPost ??= false;
    payload.postType = postType;
    payload.isBookmarked = isBookMarked;
    if(postRecipientStatus != POST_RECIPIENT_STATUS.UNREAD.status) {
      payload.postRecipientStatus = postRecipientStatus;
    }else{
      payload.postRecipientStatus = null;
    }
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    return PostListResponse.fromJson(res);
  }

  Future<PostListResponse> fetchOthersList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 20;
    payload.postOwnerType = postOwnerType;
    payload.postOwnerTypeId = postOwnerTypeId;
    payload.roomId = widget.roomId;
    payload.isRoomPost = widget.isRoomPost;
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.OTHER_POST_LIST);
    return PostListResponse.fromJson(res);
  }
  void onVoteCallback(int index){
    // setState(() {
    feedList[index].isVoted = true;
    // postList[index].postContent.content.contentMeta.others.totalResponses = postList[index].postContent.content.contentMeta.others.totalResponses+1;
    // });
  }
  void removeFromList(int index) {
    setState(() {
      feedList.removeAt(index);
      totalItems = totalItems! - 1;
    });
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
  void openSubmitAssignPage(String? question, int? postId,int index) {
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
                feedList[index].isVoted = true;
              });
            }
          }
    });
  }

  final CreateDeeplink?  createDeeplink =locator<CreateDeeplink>();
  void _onShareCallback(int? id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,prefs.getInt("userId").toString(),id,DEEPLINKTYPE.POST.type, context);
    // _showModalBottomSheet(context,id);
  }

  void _onRatingCallback(int index) {
    // setState(() {
      for (var i in feedList[index].postContent!.header!.action!) {
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
          if(feedList[index].postType =='lesson' ) {
            return NewNewsAndArticleDetailPage(postData: feedList[index],);
          }else{
            return PostCardDetailPage(postData: feedList[index],);
          }
        }));
  }

  void _onFollowCallback(bool isFollow, int index) {
    setState(() {
      for (var i in feedList[index].postContent!.header!.action!) {
        if (i.type == 'is_followed') {
          i.value = isFollow;
        }
      }
    });
  }
  void bookmarkPost(int? postId, int index, bool isBookMarked) {
    // setState(() {
    feedList[index].isBookmarked = isBookMarked;
    // });
  }

  // void _showModalBottomSheet(BuildContext context,int id) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
  //     ),
  //     builder: (context) {
  //       return BottomSheetContent(id);
  //     },
  //   );
  // }


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
                  child: Text(AppLocalizations.of(context)!.translate('who_want_share'),
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
                      title: Text(AppLocalizations.of(context)!.translate('share_within'),
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
              //           "Share through app messenger",
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
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(AppLocalizations.of(context)!.translate('share_through_other'),
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
