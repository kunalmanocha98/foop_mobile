import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/components/micro_learning_side_buttons.dart';
import 'package:oho_works_app/components/postcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/components/app_chat_footer.dart';
import 'package:oho_works_app/e_learning_module/ui/lessons_page.dart';
import 'package:oho_works_app/enums/create_deeplink.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/enums/post_enums.dart';
import 'package:oho_works_app/enums/share_item_type.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/models/post/post_sub_type_list.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/updaterecipientlist.dart';
import 'package:oho_works_app/models/post_view_response.dart';
import 'package:oho_works_app/models/review_rating_comment/noteslistmodel.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/ui/CalenderModule/create_event_page.dart';
import 'package:oho_works_app/ui/commentItem.dart';
import 'package:oho_works_app/ui/dialogs/dialog_audio_post.dart';
import 'package:oho_works_app/ui/dialogs/search_keyword_dialog.dart';
import 'package:oho_works_app/ui/language_update.dart';
import 'package:oho_works_app/ui/postModule/CampusNewsListPage.dart';
import 'package:oho_works_app/ui/postModule/assignments_page.dart';
import 'package:oho_works_app/ui/postModule/pollsListPage.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:html/parser.dart';
import 'package:lottie/lottie.dart';
import 'package:markdown/markdown.dart' hide Document, Text;
import 'package:quill_delta/quill_delta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../home/locator.dart';
import '../../home/locator.dart';

enum TtsState { playing, stopped, paused, continued }

// ignore: must_be_immutable
class NewNewsAndArticleDetailPage extends StatefulWidget {
  Null Function()? callBack;
  PostListItem? postData;
  int? postId;

  NewNewsAndArticleDetailPage({this.postData, this.postId,this.callBack});

  @override
  NewNewsAndArticleDetailPageState createState() =>
      NewNewsAndArticleDetailPageState();
}

class NewNewsAndArticleDetailPageState
    extends State<NewNewsAndArticleDetailPage>
    with SingleTickerProviderStateMixin {
  Null Function()? callBack;
  PAGINATOR_ENUMS? pageEnum;
  List<PostListItem?> detailPagesList = [];
  int totalItems = 0;
  SharedPreferences? prefs;
  int page = 1;
  String postType = 'news';
  TextStyleElements? styleElements;
  List<PostSubTypeListItem> selectedList = [];
  List<String> listOfSelections = [];
  String topic = "Choose topic";
  GlobalKey<PostCardHeaderState> headerKey = GlobalKey();
  int _currentPage = 0;
  int mSelectedPosition = 0;
  bool isFirstCall = true;
  int? previousId;
  int? nextId;
  FlutterTts tts = FlutterTts();
  String? searchValue;
  String? textToSpeach;
  bool showAnimation = true;
  bool isPlaying = false;
  bool isLoading = false;
  String? inputLan;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? outPutLan;
  bool isTranslate = false;

  TtsState ttsState = TtsState.stopped;

  get playing => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    pageEnum = PAGINATOR_ENUMS.SUCCESS;
    if (widget.postData != null) detailPagesList.add(widget.postData);
    if (widget.postId != null) getPost(widget.postId);
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => {showAnimations(), updateHeader(widget.postData, 0)});
    initTts();
    super.initState();
  }

  Future _getDefaultEngine() async {
    var engine = await tts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
  Future _speak() async {
    await tts.setVolume(volume);
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);

    if (textToSpeach != null) {
      if (textToSpeach!.isNotEmpty) {
        await tts.awaitSpeakCompletion(true);
        await tts.speak(textToSpeach!);
      }
    }
  }
  initTts() {
    tts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    tts.setStartHandler(() {
      setState(() {
        print("Playing");
        isPlaying=true;
        ttsState = TtsState.playing;
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        isPlaying=false;
        ttsState = TtsState.stopped;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        print("Cancel");

        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      tts.setPauseHandler(() {
        setState(() {

          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      tts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    tts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  _toggelLanguage() {
    setState(() {
      isTranslate = true;
      var temp = inputLan;
      inputLan = outPutLan;
      outPutLan = temp;
    });
  }

  Future _stop() async {
    await tts.stop();
  }

  Future pausePlay() async {
    if (isPlaying) {
      print("pausing----------------------------");
      await tts.stop();
      setState(() {
        isLoading = false;
        isPlaying = false;
      });
    } else {
      print("play----------------------------");
      await tts.speak(textToSpeach!);
      setState(() {
        isLoading = false;
        isPlaying = true;
      });
    }
  }

  void showAnimations() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showAnimation = false;
      });
      // navigationPage(context);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return SafeArea(
      child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              body: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 62),
                  child: _buildPage(),
                ),
              ),
              Align(alignment: Alignment.topCenter, child: _buildAppBar2()),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.55),
                  decoration: BoxDecoration(
                      color: HexColor(AppColors.appColorWhite),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      boxShadow: [
                        CommonComponents().getShadowforBoxSideCard()
                      ]),
                  child: detailPagesList.isNotEmpty
                      ? MicroLearningSideButtons(
                          isTranslateVisible: true,
                          isTextToSpeechVisible: true,
                          isPlaying: isPlaying,
                          isLoading: isLoading,
                          searchCallBAck: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SearchKeywordDialog(
                                    okCallback: (value) {
                                      setState(() {
                                        searchValue = value;
                                      });
                                    },
                                  );
                                });
                            /*  Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GlobalSearchNew(
                                whichTabToShow: "post",
                              )));*/
                          },
                          homeCallBack: () {
                            _onBackPressed();
                          },
                          textToSpeechCallback: () async {
                            if (!isPlaying) {
                              tts.stop();
                              var text = "";
                              try {
                                Document doc = Document.fromJson(jsonDecode(
                                    detailPagesList[_currentPage]!
                                        .postContent!
                                        .content!
                                        .contentMeta!
                                        .meta!));
                                QuillController _controller = QuillController(
                                    document: doc,
                                    selection:
                                        TextSelection.collapsed(offset: 0));
                                text = _controller.document.toPlainText();
                              } catch (error) {
                                var html = detailPagesList[_currentPage]!
                                    .postContent!
                                    .content!
                                    .contentMeta!
                                    .meta;
                                print(html);
                                text = parse(html).documentElement!.text;
                                print(text);
                              }

                              tts.setLanguage("en-IN");
                              tts.setPitch(1);
                              tts.speak(text);
                              setState(() {
                                textToSpeach = text;
                              });
                              pausePlay();
                            } else {
                              pausePlay();
                            }
                          },
                          translateCallback: () async {
                            if (prefs!.getBool(
                                        Strings.isTranslationLanguageSet) ==
                                    null ||
                                !prefs!.getBool(
                                    Strings.isTranslationLanguageSet)!) {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateLanguagePage(
                                          true, null, true)));
                              if (result != null && result['code'] != null) {
                                outPutLan = result['code'];

                                translate(outPutLan!);
                              } else {
                                ToastBuilder().showToast(
                                    AppLocalizations.of(context)!.translate(
                                        "select_translation_language"),
                                    context,
                                    HexColor(AppColors.information));
                              }
                            } else {
                              translate(outPutLan!);
                            }
                          },
                          sharecallBack: () {
                            _onShareCallback(detailPagesList[_currentPage]!);
                          },
                          postId: detailPagesList[_currentPage]!.postId,
                          isBookMarked:
                              detailPagesList[_currentPage]!.isBookmarked,
                          isRated: getIsRated(detailPagesList[_currentPage]!),
                          ratingCallback: () {
                            _onRatingCallback(detailPagesList[_currentPage]);
                          },
                          bookmarkCallback: (isBookmarked) {
                            _onBookmarkCallback(
                                detailPagesList[_currentPage]!.postId,
                                isBookmarked);
                          },
                          filterCallBack: () {
                            redirectToLessonListPage();
                            // redirectToFeedPage(
                            //     detailPagesList[_currentPage].postType);
                          },
                          commentCallback: () {
                            _onCommentCallback(detailPagesList[_currentPage]);
                          },
                        )
                      : Container(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: detailPagesList.isNotEmpty
                    ? Container(
                        color: HexColor(AppColors.appColorWhite),
                        child: PostCardActionButtons(
                          isTranslateVisible: false,
                          isTextToSpeechVisible: false,
                          sharecallBack: () {
                            _onShareCallback(detailPagesList[_currentPage]!);
                          },
                          postId: detailPagesList[_currentPage]!.postId,
                          isBookMarked:
                              detailPagesList[_currentPage]!.isBookmarked,
                          isRated: getIsRated(detailPagesList[_currentPage]!),
                          ratingCallback: () {
                            _onRatingCallback(detailPagesList[_currentPage]);
                          },
                          bookmarkCallback: (isBookmarked) {
                            _onBookmarkCallback(
                                detailPagesList[_currentPage]!.postId,
                                isBookmarked!);
                          },
                          talkCallback: () {
                            onTalkCallback(detailPagesList[_currentPage]);
                          },
                          commentCallback: () {
                            _onCommentCallback(detailPagesList[_currentPage]);
                          },
                        ),
                      )
                    : Container(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: showAnimation,
                  child: Container(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.center,
                            colors: [
                              HexColor(AppColors.appColorBlack85),
                              HexColor(AppColors.appColorGreen)
                            ]).createShader(bounds);
                      },
                      child: Lottie.asset(
                        'assets/swipe_left.json',
                        width: 200,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ))),
    );
  }

  void translate(String outPutCode) {
    print(outPutCode +
        "---------------------------------------------------------------------------------");
    String? html;

    try {
      Document doc = Document.fromJson(jsonDecode(
          detailPagesList[_currentPage]!.postContent!.content!.contentMeta!.meta!));
      QuillController _controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));
      // Delta delta = Delta.fromJson(
      //     jsonDecode(jsonEncode(_controller.document.toDelta().toJson())));
      var markdown =
          deltaToMarkdown(jsonEncode(_controller.document.toDelta().toJson()));
      html = markdownToHtml(markdown);
      print(html);
      // html = NotusHtmlCodec().encode(delta);
    } catch (error) {
      html = detailPagesList[_currentPage]!.postContent!.content!.contentMeta!.meta;
    }

    var input1 = html!.replaceAll("<br><br><br><br>", "<br><br>");
    var input = input1.replaceRange(input1.length - 8, input1.length, "");
    log(input);
    Utility()
        .translate(context, input, inputLan, outPutCode, "html")
        .then((value) {
      print(value);
      setState(() {
        detailPagesList[_currentPage]!.postContent!.content!.contentMeta!.meta =
            value;
      });
    });
    _toggelLanguage();
  }

  final CreateDeeplink? createDeeplink = locator<CreateDeeplink>();

  Future<void> updateHeader(PostListItem? item, int index) async {
    prefs = await SharedPreferences.getInstance();
    outPutLan = prefs!.getString(Strings.translation_code);
    if (item != null) {
      bool? isFollowed = false;
      for (var i in item.postContent!.header!.action!) {
        if (i.type == 'is_followed') {
          isFollowed = i.value;
          break;
        }
      }
      Future(() {
        headerKey.currentState!.update(
          postListItem: item,
          prefs: prefs,
          onFollowCallback: (isFollow) {
            _onFollowCallback(isFollow, index);
          },
          isFollowing: isFollowed,
        );
      });
    }
  }

  void _onFollowCallback(bool isFollow, int index) {
    setState(() {
      for (var i in detailPagesList[index]!.postContent!.header!.action!) {
        if (i.type == 'is_followed') {
          i.value = isFollow;
        }
      }
    });
  }

  _buildAppBar2() {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: CustomPrefferedSizedWidget(
        height: 72,
        child: Container(
          color: HexColor(AppColors.appColorWhite).withOpacity(0.5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: PostCardHeader(
                  key: headerKey,
                  prefs: prefs,
                  color: HexColor(AppColors.appColorTransparent),
                  postListItem: null,
                  onFollowCallback: null,
                  isBackButtonVisible: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  hidePostCallback: null,
                  deletePostCallback: null,
                  isFollowing: true,
                  isDarkTheme: false,
                  isNewsPage: false,
                  topicsPageCallback: null,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void _onShareCallback(PostListItem postData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createDeeplink!.getDeeplink(
        SHAREITEMTYPE.DETAIL.type,
        prefs.getInt("userId").toString(),
        postData.postId,
        DEEPLINKTYPE.POST.type,
        context);
    // _showModalBottomSheet(context);
  }

  void _onRatingCallback(PostListItem? postData) {
    // postRatingKey.currentState.updateData();
    setState(() {
      for (var i in postData!.postContent!.header!.action!) {
        if (i.type == 'is_rated') {
          i.value = true;
        }
      }
    });
  }

  void onTalkCallback(PostListItem? postData) {
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
                    title: postData.postContent!.content!.contentMeta!.title,
                  );
                }));
              },
              cancelCallback: () {});
        });
  }

  void _onBookmarkCallback(int? postId, bool isBookmarked) {
    bookmarkPost(postId, isBookmarked);
  }

  void _onCommentCallback(PostListItem? postData) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommentSheet(postId: postData!.postId);
        });
    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=> PostCardDetailPage()));
  }

  bool getIsRated(PostListItem postData) {
    bool? isRated;
    for (var i in postData.postContent!.header!.action!) {
      if (i.type == 'is_rated') {
        isRated = i.value;
        break;
      }
    }
    return isRated ??= false;
  }

  void bookmarkPost(int? postId, bool isBookMarked) {
    setState(() {
      // postData.isBookmarked = isBookMarked;
    });
  }

  void redirectToFeedPage(String value) {
    switch (value) {
      case 'notice':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                        AppLocalizations.of(context)!.translate('notice_board'),
                    postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
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
                    postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                  )));
          break;
        }
      case 'news':
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CampusNewsListPage()));
          break;
        }
      case 'blog':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                        AppLocalizations.of(context)!.translate('article'),
                    postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.BLOG.status,
                  )));
          break;
        }
      case 'assignment':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AssignmentPage();
          }));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => SelectedFeedListPage(
          //       isFromProfile: false,
          //       appBarTitle:
          //       AppLocalizations.of(context).translate('assignment'),
          //       postRecipientStatus:
          //       POST_RECIPIENT_STATUS.UNREAD.status,
          //       postType: POST_TYPE.ASSIGNMENT.status,
          //     )));
          break;
        }
      case 'qa':
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectedFeedListPage(
                    isFromProfile: false,
                    appBarTitle:
                        AppLocalizations.of(context)!.translate('ask_expert'),
                    postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
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
                    postRecipientStatus: POST_RECIPIENT_STATUS.UNREAD.status,
                    postType: POST_TYPE.NOTICE.status,
                  )));
          break;
        }
    }
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  void postStatusUpdate(int? postId, bool? isBookmarked) {
    PostRecipientUpdatePayload payload = PostRecipientUpdatePayload();
    payload.postId = postId;
    payload.postRecipientStatus = POST_RECIPIENT_STATUS.READ.status;
    payload.isBookmarked = isBookmarked;
    var body = jsonEncode(payload);
    Calls().call(body, context, Config.UPDATE_RECIPIENT_LIST);
  }

  _buildPage() {
    postStatusUpdate(detailPagesList[_currentPage]!.postId,
        detailPagesList[_currentPage]!.isBookmarked);
    setState(() {
      if (!isTranslate)
        inputLan = detailPagesList[_currentPage]!.languageCode ?? "";
      print(
          inputLan! + "------------------------------------------language code");
    });
    // ignore: missing_enum_constant_in_switch
    switch (pageEnum) {
      case PAGINATOR_ENUMS.SUCCESS:
        return detailPagesList.isNotEmpty
            ? SingleChildScrollView(
                child: new Dismissible(
                  resizeDuration: null,
                  background: SingleChildScrollView(
                    child: new Center(
                      child: _currentPage - 1 < detailPagesList.length &&
                              _currentPage - 1 != -1
                          ? appPostCard(
                              cardData: detailPagesList[_currentPage - 1],
                              isPostHeaderVisible: false,
                              isPostActionVisible: false,
                              isNewsPage: false,
                              isFilterPage: false,
                              isLearningPage: true,
                              download: () {
                                Navigator.pop(context);
                              },
                              searchHighlightWord: searchValue,
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
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.only(top: 62, bottom: 60),
                              child: PreloadingView(
                                  url: "assets/appimages/dice.png")),
                    ),
                  ),
                  secondaryBackground: SingleChildScrollView(
                      child: new Center(
                    child: _currentPage + 1 < detailPagesList.length &&
                            _currentPage + 1 != -1
                        ? appPostCard(
                            cardData: detailPagesList[_currentPage + 1],
                            isPostHeaderVisible: false,
                            isPostActionVisible: false,
                            isNewsPage: false,
                            isFilterPage: false,
                            isLearningPage: true,
                            searchHighlightWord: searchValue,
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
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 62, bottom: 60),
                            child: PreloadingView(
                                url: "assets/appimages/dice.png")),
                  )),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      isPlaying = false;
                      isTranslate = false;
                      textToSpeach = "";
                      _stop();
                      if (direction == DismissDirection.endToStart) {
                        if (_currentPage == 0 && detailPagesList.length == 1) {
                          fetchList("next");
                        } else if (_currentPage == detailPagesList.length - 1) {
                          fetchList("next");
                        } else {
                          _currentPage +=
                              direction == DismissDirection.endToStart ? 1 : -1;
                          updateHeader(
                              detailPagesList[_currentPage], _currentPage);
                        }
                      } else if (direction == DismissDirection.startToEnd) {
                        if (_currentPage == 0) {
                          fetchList("previous");
                        } else {
                          _currentPage = _currentPage - 1;
                          updateHeader(
                              detailPagesList[_currentPage], _currentPage);
                        }
                      }
                    });
                  },
                  key: new ValueKey(_currentPage),
                  child: new Container(
                    height: MediaQuery.of(context).size.height,
                    child: _currentPage < detailPagesList.length &&
                            _currentPage != -1
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 120.0),
                              child: appPostCard(
                                cardData: detailPagesList[_currentPage],
                                isPostHeaderVisible: false,
                                isPostActionVisible: false,
                                isNewsPage: false,
                                isFilterPage: false,
                                isLearningPage: true,
                                searchHighlightWord: searchValue,
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
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 62, bottom: 60),
                            child: PreloadingView(
                                url: "assets/appimages/dice.png")),
                  ),
                ),
              )
            : Container();
      case PAGINATOR_ENUMS.LOADING:
        return Container(
            margin: const EdgeInsets.only(top: 62, bottom: 60),
            child: PreloadingView(url: "assets/appimages/dice.png"));
      case PAGINATOR_ENUMS.ERROR:
        // TODO: Handle this case.
        break;
      case PAGINATOR_ENUMS.EMPTY:
        // TODO: Handle this case.
        break;
    }
  }

  void getPost(int? postId) async {
    final body = jsonEncode({"post_id": postId});

    Calls().call(body, context, Config.POST_VIEW).then((value) {
      var res = PostViewResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        if (res.rows != null) {
          setState(() {
            detailPagesList.add(res.rows);
            updateHeader(res.rows, 0);
          });
        }
      } else if (res.statusCode == "E100002") {
        print(
            "not availbale -------------------------------------------------------------------------");
        setState(() {
          // }
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    setState(() async {
      await _stop();
      if (widget.callBack != null) widget.callBack!();
      Navigator.of(context).pop(true);
    });
    return new Future(() => false);
  }

  Future<void> fetchList(String listType) async {
    final body = jsonEncode({
      "post_id": widget.postData!.postId,
      "page_size": 5,
      "page_number": page,
      "post_type": widget.postData!.postType,
      "list_type": listType
    });
    setState(() {
      pageEnum = PAGINATOR_ENUMS.LOADING;
    });
    var res = await Calls().call(body, context, Config.DETAIL_PAGE_PAGINATION);
    setState(() {
      pageEnum = PAGINATOR_ENUMS.SUCCESS;
    });
    PostListResponse.fromJson(res);
    if (PostListResponse.fromJson(res).statusCode == Strings.success_code &&
        PostListResponse.fromJson(res).rows != null &&
        PostListResponse.fromJson(res).rows!.isNotEmpty) {
      listType == "previous"
          ? detailPagesList =
              (new List.from(PostListResponse.fromJson(res).rows!)
                ..addAll(detailPagesList))
          : detailPagesList.addAll(PostListResponse.fromJson(res).rows!);

      listType == "previous"
          ? _currentPage = PostListResponse.fromJson(res).rows!.length - 1
          : _currentPage++;
      updateHeader(detailPagesList[_currentPage], _currentPage);
      page++;
    }
  }

  void redirectToLessonListPage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CreateLessonsPage(
        isFromDetailPage: true,
        chapterId: detailPagesList[_currentPage]!.chapterItem!=null ?detailPagesList[_currentPage]!.chapterItem!.id:null,
        chapterName: detailPagesList[_currentPage]!.chapterItem!=null ?detailPagesList[_currentPage]!.chapterItem!.chapterName:"",
        isEdit: false,
        createLessonData: PostCreatePayload(
            postId: detailPagesList[_currentPage]!.postId,
            id: detailPagesList[_currentPage]!.postId,
            postStatus: "posted",
            contentMeta: ContentMetaCreate(),
            chapterItem: detailPagesList[_currentPage]!.chapterItem,
            lessonTopic: detailPagesList[_currentPage]!.lessonTopic,
            lessonListItem: detailPagesList[_currentPage]!.lessonListItem,
            affiliatedList: detailPagesList[_currentPage]!.affiliatedList,
            classesList: detailPagesList[_currentPage]!.classesList,
            disciplineList: detailPagesList[_currentPage]!.disciplineList,
            learnerItem: detailPagesList[_currentPage]!.learnerItem,
            programmesList: detailPagesList[_currentPage]!.programmesList,
            subjectsList: detailPagesList[_currentPage]!.subjectsList),
      );
    }));
  }
}

class CommentSheet extends StatefulWidget {
  final int? postId;

  CommentSheet({this.postId});

  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
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
            AppLocalizations.of(context)!.translate('comments'),
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
          hintText: AppLocalizations.of(context)!.translate('enter_comment'),
          onValueRecieved: (value) {
            submitComment(value!);
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
      "note_created_by_id": prefs!.getInt(Strings.userId),
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
    chatFooterKey.currentState!.clearData();
    paginatorKey.currentState!.changeState(resetState: true);
  }
}
