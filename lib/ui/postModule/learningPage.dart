import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/post_sub_type_list.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postModule/campusNewsHelperPages.dart';
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
import 'package:translator/translator.dart';

class LearningListPage extends StatefulWidget{
  @override
  LearningListPageState createState()=> LearningListPageState();
}

class LearningListPageState extends State<LearningListPage>{

  PAGINATOR_ENUMS pageEnum ;
  List<PostListItem> feedList = [];
  int totalItems = 0;
  SharedPreferences prefs;
  int page = 0;
  String postType = 'news';
  TextStyleElements styleElements;
  List<PostSubTypeListItem> selectedList = [];
  List<String> listOfSelections = [];
  String topic="Choose topic";
  GlobalKey<PostCardHeaderState> headerKey = GlobalKey();
  PageController _controller = PageController();

  @override
  void initState() {
    pageEnum = PAGINATOR_ENUMS.LOADING;
    _initialFutureCall();
    super.initState();

  }
  void refresh() {
    Future((){headerKey.currentState.clear();});
    setState(() {
      pageEnum = PAGINATOR_ENUMS.LOADING;
      feedList.clear();
      page = 0;
    });
    _initialFutureCall();
  }

  void _initialFutureCall() async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page + 1;
    payload.pageSize = 10;
    payload.personId = prefs.getInt(Strings.userId);
    payload.isOwnPost = false;
    payload.postSubTypes = listOfSelections;
    if (postType != 'all') payload.postType = postType;
    // if(postRecipientStatus != POST_RECIPIENT_STATUS.UNREAD.status) {
    //   payload.postRecipientStatus = postRecipientStatus;
    // }else{
    payload.postRecipientStatus = null;
    // }
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    var response = PostListResponse.fromJson(res);
    totalItems = response.total;

    if (response.statusCode != Strings.success_code) {
      setState(() {
        pageEnum = PAGINATOR_ENUMS.ERROR;
      });
    } else {
      if (totalItems == 0) {
        setState(() {
          pageEnum = PAGINATOR_ENUMS.EMPTY;
        });
      } else {
        // isLoading = false;
        page++;
        feedList.addAll(response.rows);
        setState(() {
          pageEnum = PAGINATOR_ENUMS.SUCCESS;
        });
      }
    }
  }
  Future<PostListResponse> fetchList(int page) async {
    prefs ??= await SharedPreferences.getInstance();
    PostListRequest payload = PostListRequest();
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.personId = prefs.getInt(Strings.userId);
    payload.isOwnPost = false;
    payload.postType = postType;
    payload.postSubTypes = listOfSelections;
    // if(postRecipientStatus != POST_RECIPIENT_STATUS.UNREAD.status) {
    //   payload.postRecipientStatus = postRecipientStatus;
    // }else{
    payload.postRecipientStatus = null;
    // }
    var data = jsonEncode(payload);
    var res = await Calls().call(data, context, Config.POSTLIST);
    return PostListResponse.fromJson(res);
  }


  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
        onWillPop:_onBackButtonPress,
        child: SafeArea(child: Scaffold(
          appBar: _buildAppBar2(),
          body: _buildPage(),
        )
        )
    );
  }
  // _buildAppBar(){
  //   return  TricycleAppBar().getCustomAppBar(context,
  //       titleWidget: Flexible(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //                 "Campus news",
  //                 style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600)
  //             ),
  //             Text(
  //                 " | ",
  //                 style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600)
  //             ),
  //             Flexible(
  //               child: Text(
  //                   "$topic",
  //                   style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.w600)
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       appBarTitle: '',
  //       centerTitle: false,
  //       actions: [
  //         InkWell(
  //           onTap: (){
  //             Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
  //               return  CampusNewsHelperPages(CAMPUS_NEWS_TYPE.topics,selectedList: selectedList,);
  //             })).then((value){
  //               if(value!=null) {
  //                 selectedList = value;
  //                 listOfSelections.clear();
  //                 selectedList.forEach((element) {
  //                   listOfSelections.add(element.postSubTypeName);
  //                 });
  //                 topic = listOfSelections.length>1?"${listOfSelections[0]} & Others":listOfSelections[0];
  //                 refresh();
  //               }
  //             });
  //           },
  //           child: Center(
  //             child: Padding(
  //               padding: const EdgeInsets.only(left:4.0,right: 16),
  //               child: Text(
  //                 'change',
  //                 style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       onBackButtonPress: (){  Navigator.pop(context);});
  // }
  void updateHeader(PostListItem item, int index) {
    bool isFollowed = false;
    for (var i in item.postContent.header.action) {
      if (i.type == 'is_followed') {
        isFollowed = i.value;
        break;
      }
    }
    Future((){
      headerKey.currentState.update(
        postListItem: item,
        prefs: prefs,
        onFollowCallback: (isFollow) {
          _onFollowCallback(isFollow, index);
        },
        isFollowing: isFollowed,
        hidePostCallback: () {
          removeFromList(index);
        },
        deletePostCallback: () {
          removeFromList(index);
        },

      );
    });
  }
  _buildAppBar2(){
    return CustomPrefferedSizedWidget(
      height: 56,
      child: PostCardHeader(
        key: headerKey,
        prefs: prefs,
        color: HexColor(AppColors.appColorWhite),
        postListItem: null,
        onFollowCallback: null,
        isBackButtonVisible: true,
        onBackPressed: (){
          if(listOfSelections.length>0){
            listOfSelections.clear();
            selectedList.clear();
            refresh();
          }else {
            Navigator.pop(context);
          }
        },
        hidePostCallback: null,
        deletePostCallback: null,
        isFollowing: true,
        isDarkTheme: false,
        isNewsPage: true,
        topicsPageCallback: _topicsPageCallback,
      ),
    );
  }
  void _topicsPageCallback(){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return  CampusNewsHelperPages(CAMPUS_NEWS_TYPE.topics,selectedList: selectedList,selectedReceiverData: null,);
    })).then((value){
      if(value!=null) {
        selectedList = value;
        listOfSelections.clear();
        selectedList.forEach((element) {
          listOfSelections.add(element.postSubTypeName);
        });
        topic = listOfSelections.length>1?"${listOfSelections[0]} & Others":listOfSelections[0];
        refresh();
      }
    });
  }
  void _onPageChange(int index){
    updateHeader(feedList[index], index);
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
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: _getItemCount(),
            itemBuilder: (BuildContext context, int index) {
              return _itemBuilder(context, index);
            },
            onPageChanged: _onPageChange,
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
  int _getItemCount() {
    if (totalItems > feedList.length) {
      return feedList.length + 1;
    } else {
      return totalItems;
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
        future: fetchList(page + 1),
        builder:
            (BuildContext context, AsyncSnapshot<PostListResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CustomPaginator(context).loadingWidgetMaker();
            case ConnectionState.done:
              feedList.addAll(snapshot.data.rows);
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
    if(index==0)
      updateHeader(item, index);
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostCardDetailPage(
                postData: item,
              )));
        },
        child: TricyclePostCard(
            key: UniqueKey(),
            isFilterPage: true,
            // color: isInView?HexColor(AppColors.appColorBlue)[200]:HexColor(AppColors.appColorWhite),
            preferences: prefs,
            isNewsPage: true,
            horizontalMediaList: true,
            cardData: item,
            download: (){},
            isTitleVisible: !(postType==POST_TYPE.NOTICE.status),
            isDetailPage: false,
            sharecallBack: (){_onShareCallback(item.postId);},
            isTranslateVisible: true,
            isTextToSpeechVisible:true,
            textToSpeechCallback:(){},
            ratingCallback: () {
              _onRatingCallback(index);
            },
            bookmarkCallback: (isBookmarked) {
              _onBookmarkCallback(item.postId, index, isBookmarked);
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
            onVoteCallback: (){
              onVoteCallback(index);
            },
            onTalkCallback: (){
              onTalkCallback(index);
            },
            translateCallback: () async{

               final translator = GoogleTranslator();

               final input = "Hello, My name is kunal";

               translator.translate(input, from: 'en', to: 'hi').then((value) {
                 print(value.text);
               });
               var translation = await translator.translate("Dart is very cool!", to: 'hi');
               print(translation.text);
               print(await "example".translate(to: 'pt'));
            },
            onAnswerClickCallback: () {
              openAnswerPage(
                  item.postContent.content.contentMeta.title, item.postId);
            }));
  }
  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: feedList[index].postContent.content.contentMeta.title,
              okCallback:(){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CreateEventPage(
                        type: 'talk',
                        standardEventId: 5,
                        title: feedList[index].postContent.content.contentMeta.title,
                      );
                    }));
              },
              cancelCallback:(){}
          );
        });
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
      totalItems = totalItems - 1;
    });
  }

  void openAnswerPage(String question, int postId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostCreatePage(
          type: 'answer',
          question: question,
          postId: postId,
          prefs: prefs,
        )));
  }
  final CreateDeeplink  createDeeplink =locator<CreateDeeplink>();
  void _onShareCallback(int id) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    createDeeplink.getDeeplink(SHAREITEMTYPE.DETAIL.type,prefs.getInt("userId").toString(),id,DEEPLINKTYPE.POST.type, context);
    // _showModalBottomSheet(context,id);
  }

  void _onRatingCallback(int index) {
    // setState(() {
    for (var i in feedList[index].postContent.header.action) {
      if (i.type == 'is_rated') {
        i.value = true;
      }
    }
    // });
  }

  void _onBookmarkCallback(int postId, int index, bool isBookmarked) {
    bookmarkPost(postId, index, isBookmarked);
  }

  void _onCommentCallback(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostCardDetailPage(
          postData: feedList[index],
        )));
  }

  void _onFollowCallback(bool isFollow, int index) {
    setState(() {
      for (var i in feedList[index].postContent.header.action) {
        if (i.type == 'is_followed') {
          i.value = isFollow;
        }
      }
    });
  }
  void bookmarkPost(int postId, int index, bool isBookMarked) {
    // setState(() {
    feedList[index].isBookmarked = isBookMarked;
    // });
  }

  Future<bool> _onBackButtonPress() async{
    if(listOfSelections.length>0){
      listOfSelections.clear();
      selectedList.clear();
      refresh();
      return false;
    }else {
      return true;
    }
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
  TextStyleElements styleElements;
  int _selectedshareoption;
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
                  child: Text(AppLocalizations.of(context).translate('who_want_share'),
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
                        onChanged: (value) {
                          setState(() {
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(AppLocalizations.of(context).translate('share_within'),
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
                        onChanged: (value) {
                          _onShare();
                          setState(() {
                            _selectedshareoption = value;
                          });
                        },
                      ),
                      title: Text(AppLocalizations.of(context).translate('share_through_other'),
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

  final CreateDeeplink createDeeplink = locator<CreateDeeplink>();

  void _onShare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
  }

  _ShareBottomSheet(this.id);
}