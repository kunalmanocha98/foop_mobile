import 'dart:convert';
import 'dart:math';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appbar_with_profile%20_image.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/app_find_card.dart';
import 'package:oho_works_app/components/app_lesson_card.dart';
import 'package:oho_works_app/e_learning_module/ui/lesson_list_response.dart';
import 'package:oho_works_app/e_learning_module/ui/lessons_page.dart';
import 'package:oho_works_app/e_learning_module/ui/selected_lesson_list.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/search_module/globl_search_new.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/postModule/postListPage.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../postcreatepage.dart';

class LessonsListPage extends StatefulWidget {
  final bool headerVisible;
  final bool isBookmark;
  final bool isOwnPost;
  final bool isDrafted;
final Function? callBack;
  LessonsListPage(
      {this.headerVisible = true,
      this.isBookmark = false,
      this.isDrafted = false,
        this.callBack,
      this.isOwnPost = false});

  @override
  _LessonsListPage createState() => _LessonsListPage();
}

class _LessonsListPage extends State<LessonsListPage> {
  List<PostListItem> lessonsList = [];
  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();

  Widget _simplePopup() {
    return PopupMenuButton(
      icon: Icon(
        Icons.segment,
        size: 30,
        color: HexColor(AppColors.appColorBlack65),
      ),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: HexColor(AppColors.appColorBackground),
      itemBuilder: (context) => LessonDropMenu(context: context).menuList,
      onSelected: (dynamic value) {
        switch (value) {
          case 'drafted':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SelectedLessonList(
                  callBack: () {

                   refresh();
                  },
                  isBookmark: false,
                  isDrafted: true,
                  isOwnPost: true,
                );
              }));
              break;
            }

          case 'created_by_me':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SelectedLessonList(
                  isBookmark: false,
                  isOwnPost: true,
                );
              }));
              break;
            }
          case 'bookmark':
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SelectedLessonList(
                  isBookmark: true,
                  isOwnPost: false,
                );
              }));
              break;
            }

          case 'learning':
          {  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return WelComeScreen(
                institutionIdtoDelete: prefs!.getInt(Strings.instituteId),
                isEdit: true,
              );
            })).then((value){
              if(value!=null && value){
               refresh();
              }
            });
          break;
          }
          default:
            {
              break;
            }
        }
      },
    );
  }

  void refresh() {
    print("********************REFRESHING**********************************");
    lessonsList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }
BuildContext? ctx;
  @override
  Widget build(BuildContext context) {
    this.ctx=context;
    return widget.headerVisible
        ? SafeArea(
            child: Scaffold(
                appBar: AppBarWithOnlyTitle(
                  title: AppLocalizations.of(context)!
                      .translate('microlearning_heading'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 16.0, right: 16.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: HexColor(AppColors.appColorBlack65),
                        ),
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostCreatePage(
                            type: 'lesson',
                            callBack: () {
                              refresh();
                            },
                            question: null,
                            prefs: null,
                          )));






                        },
                      ),
                    ),
                    _simplePopup()
                  ],
                ),
                body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: SearchBox(
                            onvalueChanged: (value) {},
                            isFilterVisible: false,
                            isDemoBox: true,
                            onBoxClick: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return  GlobalSearchNew(
                                      entitySubType: 'lesson',
                                      onlyOneSearch: true,
                                      isSearching: true,
                                    );
                                  }));
                            },
                            hintText: AppLocalizations.of(context)!
                                .translate('search'),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: appFindCard(
                            title: AppLocalizations.of(context)!.translate("learn_title"),
                            subtitle: AppLocalizations.of(context)!.translate("learn_subtitle"),
                            titleColor: HexColor(AppColors.appColorBlack85),
                            subtitleColor: HexColor(AppColors.appColorBlack35),
                            image: Container(
                              child: Image.asset(
                                'assets/appimages/learningbanner.png',
                              fit: BoxFit.cover,
                              height: 180,
                              width: 200,),
                            ),

                            color: HexColor(AppColors.appColorWhite),
                          ),
                        )
                      ];
                    },
                    body: _buildList(EdgeInsets.only(bottom: 160)))),
          )
        : _buildList(EdgeInsets.only(bottom: 0));
  }

  Widget _buildList(EdgeInsets padding) {
    return Paginator<PostListResponse>.listView(
      padding:padding,
        pageLoadFuture: fetchData,
        key: paginatorKey,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
        errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
        emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
        totalItemsGetter: CustomPaginator(context).totalPagesGetter,
        pageErrorChecker: CustomPaginator(context).pageErrorChecker);
  }

  Future<PostListResponse> fetchData(int page) async {
    PostListRequest payload = PostListRequest();
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.postType = 'lesson';
    payload.postStatus = widget.isDrafted ? "draft" : "posted";
    payload.isOwnPost = widget.isOwnPost;
    payload.isBookmarked = widget.isBookmark;
    var value =
        await Calls().call(jsonEncode(payload), context, Config.POSTLIST);
    return PostListResponse.fromJson(value);
  }

  List<PostListItem>? listItemsGetter(PostListResponse? pageData) {
    pageData!.rows!.forEach((element) {
      element.bookcovercolor =
          Colors.accents[Random().nextInt(Colors.accents.length)];
    });
    lessonsList.addAll(pageData.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    PostListItem item = itemData;
    return appLessonCard(
      onPressed: () {
        if (widget.isDrafted) {
          editCallback(index);
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return NewNewsAndArticleDetailPage(postData:item,callBack: (){
                  refresh();
                },);
              }));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ChapterDetailPage(item: item)));
        }
      },

      headerVisible: widget.headerVisible,
      item: item,
      onFollowCallback: (isFollow) {
        _onFollowCallback(isFollow, index);
      },
      hidePostCallback: () {
        removeFromList(index);
      },
      deletePostCallback: () {
        removeFromList(index);
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
      onTalkCallback: () {
        onTalkCallback(index);
      },
      editCallback: () {
        editCallback(index);
      },
    );
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  void _onShareCallback(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(), id, DEEPLINKTYPE.POST.type, context);
  }

  void _onRatingCallback(int index) {
    // setState(() {
    for (var i in lessonsList[index].postContent!.header!.action!) {
      if (i.type == 'is_rated') {
        i.value = true;
      }
    }
    // });
  }

  void _onBookmarkCallback(int? postId, int index, bool isBookmarked) {
    lessonsList[index].isBookmarked = isBookmarked;
  }

  void _onCommentCallback(int index) {}

  void onTalkCallback(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AudioPostDialog(
              title: lessonsList[index].postContent!.content!.contentMeta!.title,
              okCallback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CreateEventPage(
                    type: 'talk',
                    standardEventId: 5,
                    title: lessonsList[index]
                        .postContent!
                        .content!
                        .contentMeta!
                        .title,
                  );
                }));
              },
              cancelCallback: () {});
        });
  }

  void removeFromList(int index) {
    setState(() {
      print("remove++++++++++++++++++++++++++++++++++++++++++++++++++++");
      refresh();
    });
  }

  void _onFollowCallback(bool isFollow, int index) {
    setState(() {
      print("follow");
      var desiredList = lessonsList.where((element) {
        return element.postOwnerTypeId == lessonsList[index].postOwnerTypeId;
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

  void editCallback(int index) async{
    if (lessonsList[index].lessonListItem == null ||
        lessonsList[index].lessonListItem!.id == null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostCreatePage(
            callBack:(){
              if( widget.callBack!()!=null)
              {Navigator.pop(context);
              widget.callBack!();}
              refresh();
            },
            topicName:lessonsList[index].lessonTopic!=null?
            lessonsList[index].lessonTopic!.title:null,
            mediaFromEdit:lessonsList[index].postContent!.content!.media,
                createLessonData: PostCreatePayload(
                    postId: lessonsList[index].postId,
                    id: lessonsList[index].postId,
                  contentMeta: ContentMetaCreate(title:lessonsList[index].postContent!.content!.contentMeta!.title,meta: lessonsList[index].postContent!.content!.contentMeta!.meta )
                    ),
                type:'lesson',

                postId: lessonsList[index].postId,
                contentData:
                    lessonsList[index].postContent!.content!.contentMeta!.meta,
                titleLesson:
                    lessonsList[index].postContent!.content!.contentMeta!.title,

                isEdit: true,
              )));
    } else {

      var body = jsonEncode({
        "searchVal": '',
        "page_number": 1,
        "owner_type": "person",
        "owner_id": prefs!.getInt(Strings.userId),
        "chapter_id":lessonsList[index].chapterItem!=null? lessonsList[index].chapterItem!.id:null,
        "page_size": 1,
        "list_type": "all"
      });
      var res = await Calls().call(body, context, Config.LESSON_LIST);
      var model = LessonListResponse.fromJson(res);
      if(model.total! > 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return CreateLessonsPage(
                isEdit: true,
                chapterId:lessonsList[index].chapterItem!=null? lessonsList[index].chapterItem!.id:null,
                chapterName: lessonsList[index].chapterItem!=null?lessonsList[index].chapterItem!.chapterName:"",
                callBack: () {
                  if (widget.callBack!() != null) {
                    Navigator.pop(context);
                    widget.callBack!();
                  }
                  refresh();
                },
                createLessonData: PostCreatePayload(
                    postId: lessonsList[index].postId,
                    id: lessonsList[index].postId,
                    postStatus: "posted",
                    contentMeta: ContentMetaCreate(
                        title: lessonsList[index].postContent!.content!
                            .contentMeta!.title,
                        meta: lessonsList[index].postContent!.content!.contentMeta!
                            .meta),
                    chapterItem: lessonsList[index].chapterItem,
                    lessonTopic: lessonsList[index].lessonTopic,
                    lessonListItem: lessonsList[index].lessonListItem,
                    affiliatedList: lessonsList[index].affiliatedList,
                    classesList: lessonsList[index].classesList,
                    disciplineList: lessonsList[index].disciplineList,
                    learnerItem: lessonsList[index].learnerItem,
                    programmesList: lessonsList[index].programmesList,
                    subjectsList: lessonsList[index].subjectsList),
              );
            })).then((value) {
          refresh();
        });
      }else{
        Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => PostCreatePage(
    callBack: () {
    // Navigator.of(context).pop();
    widget.callBack!();
    },
    mediaFromEdit: res.rows.postContent.content.media,
    createLessonData: PostCreatePayload(
    postId: lessonsList[index].postId,
        id: lessonsList[index].postId,
        postStatus: "posted",
        contentMeta: ContentMetaCreate(
            title: lessonsList[index].postContent!.content!
                .contentMeta!.title,
            meta: lessonsList[index].postContent!.content!.contentMeta!
                .meta),
        chapterItem: lessonsList[index].chapterItem,
        lessonTopic: lessonsList[index].lessonTopic,
        lessonListItem: lessonsList[index].lessonListItem,
        affiliatedList: lessonsList[index].affiliatedList,
        classesList: lessonsList[index].classesList,
        disciplineList: lessonsList[index].disciplineList,
        learnerItem: lessonsList[index].learnerItem,
        programmesList: lessonsList[index].programmesList,
        subjectsList: lessonsList[index].subjectsList),
    type: 'lesson',
    postId: res.rows.postId,
    contentData:
    res.rows.postContent.content.contentMeta.meta,
    isEdit: true,
    )));
      }
    }
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return PostCreatePage(
    //         type: 'lesson',
    //         isEdit: true,
    //         contentData: lessonsList[index].postContent.content.contentMeta.meta,
    //         createLessonData: PostCreatePayload(
    //           chapterItem: lessonsList[index].chapterItem,
    //           lessonTopic: lessonsList[index].lessonTopic,
    //           lessonListItem: lessonsList[index].lessonListItem,
    //           affiliatedList: lessonsList[index].affiliatedList,
    //           classesList: lessonsList[index].classesList,
    //           disciplineList: lessonsList[index].disciplineList,
    //           learnerItem: lessonsList[index].learnerItem,
    //           programmesList: lessonsList[index].programmesList,
    //           subjectsList: lessonsList[index].subjectsList
    //         ),
    //
    //       );
    //     }),
    // );
  }
}

class LessonDropMenu {
  TextStyleElements? styleElements;
  BuildContext context;

  LessonDropMenu({required this.context}) {
    styleElements = TextStyleElements(context);
  }

  List<PopupMenuItem> get menuList {
    List<PopupMenuItem> list = [];
    list.add(PopupMenuItem(
        value: 'learning',
        child: PostListMenu(context: context).getUiElement(
            'Set your learning details',
            'Programme, classes, subjects, etc.',
            'assets/appimages/create-articles.png')));
    list.add(PopupMenuItem(
        value: 'created_by_me',
        child: PostListMenu(context: context).getUiElement(
            'Lessons created by me',
            'All lessons created by you',
            'assets/appimages/create-articles.png')));

    list.add(PopupMenuItem(
        value: 'drafted',
        child: PostListMenu(context: context).getUiElement(
            'Drafts',
            'All lessons created by you',
            'assets/appimages/create-articles.png')));
/*    list.add(PopupMenuItem(
        value: 'completed',
        child: PostListMenu(context: context).getUiElement(
            'Lessons completed',
            'Lessons completed by you',
            'assets/appimages/create-articles.png')));*/
    list.add(PopupMenuItem(
        value: 'bookmark',
        child: PostListMenu(context: context).getUiElement('Bookmarked lessons',
            'Lessons by you', 'assets/appimages/create-articles.png')));

    return list;
  }
}
