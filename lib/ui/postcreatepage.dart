import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/select_news_topic_widget.dart';
import 'package:oho_works_app/components/appColorSelector.dart';
import 'package:oho_works_app/components/appHtmlViewer.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/appAttachmentComponent.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/components/wordcounterchecker.dart';
import 'package:oho_works_app/e_learning_module/model/chapter_response.dart';
import 'package:oho_works_app/e_learning_module/model/create_chapter_response.dart';
import 'package:oho_works_app/e_learning_module/model/save_as_draft_reponse.dart';
import 'package:oho_works_app/e_learning_module/ui/lesson_list_response.dart';
import 'package:oho_works_app/e_learning_module/ui/topic_type_page.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/post/answersmodels.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/ui/BottomSheets/CreateNewSheet.dart';
import 'package:oho_works_app/ui/BottomSheets/select_profile_sheet.dart';
import 'package:oho_works_app/ui/postModule/campusNewsHelperPages.dart';
import 'package:oho_works_app/ui/postrecieverlistpage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PostCreatePage extends StatefulWidget {
  String? type;
  String? question;
  int? postId;
  SharedPreferences? prefs;
  PostReceiverListItem? selectedReceiverData;
  String? text;
  final PostCreatePayload? createLessonData;
  final String? contentData;
  final bool isEdit;
  final Function? callBack;
  final String? titleLesson;
  final String? topicName;
  final List<Media>? mediaFromEdit;

  PostCreatePage(
      {this.type,
      this.question,
      this.postId,
      this.prefs,
      this.text,
      this.mediaFromEdit,
      this.titleLesson,
      this.createLessonData,
      this.callBack,
      this.topicName,
      this.selectedReceiverData,
      this.isEdit = false,
      this.contentData});

  @override
  _PostCreatePage createState() => _PostCreatePage(
        type: type,
        question: question,
        postId: postId,
        prefs: prefs,
        text: text,
      );
}

class _PostCreatePage extends State<PostCreatePage> with CommonMixins {
  String? title, subTitle, weblink;
  late TextStyleElements styleElements;
  String? type = 'feed';
  String? text;
  bool isSavingDraft = false;
  final titleController = TextEditingController();
  SharedPreferences? prefs;
  String _selectedColor = AppColors.information;
  String? question;
  int? postId;
  String? questionContent;
  String urlPreview = "";

  String? postOwnerType;
  String? image_url;
  bool isLessonAlreadyAdded = false;
  int? postOwnerTypeId;
  List<String> mentions = [];
  List<String> keywords = [];
  int wordCount = 0;
  int wordLimit = 200;
  BuildContext? ctx;
  List<PostCreatePayload?> lessonsList = [];
  List<PostCreatePayload?> draftedLessonsList = [];
  GlobalKey<WordCounterCheckerState> wordCounterKey = GlobalKey();
  int lessonNumber = 1;

  _PostCreatePage({
    this.type,
    this.question,
    this.postId,
    this.prefs,
    this.text,
  });

  TextEditingController subtitleController = TextEditingController();

  // final ZefyrController _controller = ZefyrController(NotusDocument());
  QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  GlobalKey<appAttachmentsState> attachmentKey = GlobalKey();
  GlobalKey<SelectNewsTopicWidgetState> topicsKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  List<MediaDetails> mediaList = [];

  //final linkPreview = GlobalKey<FlutterLinkPreviewState>();
  final avatarKey = GlobalKey<appAvatarState>();
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  TextEditingController editingController3 = TextEditingController();
  TextEditingController editingController4 = TextEditingController();
  int optionsCount = 2;

  bool isAssignmentDetails = false;
  PostCreatePayload? detailsPayload;

  Future<void> setPref() async {
    prefs ??= await SharedPreferences.getInstance();
    image_url = prefs != null && prefs!.getString(Strings.profileImage) != null
        ? prefs!.getString(Strings.profileImage)
        : "";
    postOwnerTypeId = prefs != null ? prefs!.getInt(Strings.userId) : null;
    postOwnerType = 'person';

    if (widget.isEdit && widget.createLessonData != null) {
      lessonsList.add(widget.createLessonData);
    }
  }

  getSharedData() async {
    if (text != null && text!.isNotEmpty) {
      _controller.document.insert(0, text);
    }

    if (widget.mediaFromEdit != null && widget.mediaFromEdit!.isNotEmpty)
    {

      await Future.forEach(widget.mediaFromEdit!, (dynamic item)async{
        MediaDetails mediaDetails = MediaDetails();
        mediaDetails.mediaUrl = item.mediaUrl;
        mediaDetails.mediaType = item.mediaType;
        mediaDetails.mediaThumbnailUrl = item.mediaThumbnailUrl;

        mediaList.add(mediaDetails);
        setState(() {
          attachmentKey.currentState!.mediaList = mediaList;
        });
      });






    }
  }

  @override
  initState() {
    setPref();
    super.initState();
    _controller.addListener(() {
      var editingValue = _controller.plainTextEditingValue;
      wordCount = Utility().getWordsCountFromRegex(editingValue.text);
      wordCounterKey.currentState!.updateWidget(wordCount);
    });
    if (widget.isEdit) {
/*      Document doc = Document.fromJson(jsonDecode(widget.contentData));
      _controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));*/
      _controller.document.insert(0, jsonDecode(widget.contentData!)[0]['insert']);
      try {
        title = widget.createLessonData != null &&
                widget.createLessonData!.lessonListItem != null
            ? widget.createLessonData!.lessonListItem!.lessonName
            : widget.titleLesson;

        print(title);
        titleController.text = title!;
      } catch (e) {
        print(e);
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getSharedData();
      if (type != 'blog' && type != 'feed' && type != "lesson") {
        showContentDetailsSheet();
      }


    });

    if(type=="news")
      wordLimit = 60;
  }

  void showContentDetailsSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (BuildContext context) {
          return PostDetailsSheet(
            type: type,
            onColorSelect: (value) {
              setState(() {
                _selectedColor = value!;
              });
            },
          );
        }).then((value) {
      if (value != null) {
        detailsPayload = value;
      }
    });
  }


  void clearData() async {
    title=null;
    titleController.clear();

    FocusScope.of(context).unfocus();
    attachmentKey.currentState!.mediaList.clear();
    _focusNode.unfocus();
    _controller = QuillController.basic();
    setState(() {});

  }

  // ignore: missing_return
  Future<bool>? _onBackPressed() {
    Navigator.pop(context);
    return new Future(() => false);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.ctx=context;
    final form = Column(
      children: [
        GestureDetector(
          onTap: () {
            _showModalBottomSheet(context);
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onLongPress: () {
                    _showSelectorBottomSheet(context);
                  },
                  child: appAvatar(
                    key: avatarKey,
                    size: 36,
                    resolution_type: RESOLUTION_TYPE.R64,
                    service_type: postOwnerType == 'person'
                        ? SERVICE_TYPE.PERSON
                        : SERVICE_TYPE.INSTITUTION,
                    imageUrl: image_url,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: !(type == 'answer' || type == 'submit_assign'),
                      child: Text("(long press on Image to see options)",
                          style: styleElements.captionThemeScalable(context))),
                  Text(
                    (type == 'answer')
                        ? 'You are answering'
                        : (type == 'submit_assign')
                            ? 'You are submitting assignment'
                            : 'You are creating',
                    style: styleElements.captionThemeScalable(context),
                  ),
                  (type == 'answer' || type == 'submit_assign')
                      ? Text(
                          question!,
                          style: styleElements.subtitle1ThemeScalable(context),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTitle(),
                              style:
                                  styleElements.subtitle1ThemeScalable(context),
                            ),
                            Icon(Icons.arrow_drop_down_rounded)
                          ],
                        ),
                ],
              )),
              Visibility(
                  visible: !(type == 'answer' ||
                      type == 'submit_assign' ||
                      type == 'feed' ||
                      type == 'blog' ||
                      type == 'lesson'),
                  child: IconButton(
                    onPressed: () {
                      showContentDetailsSheet();
                    },
                    icon: Icon(Icons.note_add_outlined),
                  )
                  // Text(
                  //   AppLocalizations.of(context).translate('change'),
                  //   style: styleElements.subtitle2ThemeScalable(context),
                  // ),
                  ),
            ],
          ),
        ),
        Expanded(child: getContentArea()),
        // Container(
        //   padding: EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
        //   child: FlutterLinkPreview(
        //     url: urlPreview,
        //     builder: (InfoBase info) {
        //       if (info == null) return const SizedBox();
        //       if (info is WebImageInfo) {
        //         return CachedNetworkImage(
        //           imageUrl: info.image,
        //           fit: BoxFit.contain,
        //         );
        //       }
        //       final WebInfo webInfo = info;
        //       if (!WebAnalyzer.isNotEmpty(webInfo.title))
        //         return const SizedBox();
        //
        //       return Container(
        //         child: ListTile(
        //           leading: (webInfo.icon != null || webInfo.image != null)
        //               ? CachedNetworkImage(
        //             imageUrl: webInfo.image != null
        //                 ? webInfo.image
        //                 : webInfo.icon,
        //             height: 72,
        //             width: 72,
        //             fit: BoxFit.cover,
        //           )
        //               : null,
        //           title: Text(
        //             webInfo.title,
        //             style: styleElements
        //                 .bodyText2ThemeScalable(context)
        //                 .copyWith(
        //                 color: HexColor(AppColors.appColorBlue),
        //                 fontWeight: FontWeight.w600),
        //           ),
        //           subtitle: Text(
        //             webInfo.description,
        //             maxLines: 3,
        //             overflow: TextOverflow.fade,
        //           ),
        //         ),
        //       );
        //     },
        //     titleStyle: TextStyle(
        //       color: HexColor(AppColors.appColorBlue),
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),

        Visibility(
          visible: type != 'answer',
          child: appAttachments(
            attachmentKey,
            isMentionVisible: type != 'qa' && type != 'poll',
            mentionCallback: (value) {
              mentions.add(value!);
              int length = _controller.plainTextEditingValue.text.length;
              setState(() {
                _controller.document
                    .insert(length > 0 ? length - 1 : 0, ' @' + value+ ' ');
              });
            },
            hashTagCallback: (value) {
              keywords.add(value);
              int length = _controller.plainTextEditingValue.text.length;
              setState(() {
                _controller.document
                    .insert(length > 0 ? length - 1 : 0, ' #' + value + ' ');
              });
            },
          ),
        ),
        Visibility(
            visible: _toolbarVisible(),
            child: Container(
                height: 48,
                child: QuillToolbar.basic(
                  toolbarIconSize: 24,
                  controller: _controller,
                  multiRowsDisplay: false,
                  onImagePickCallback: _uploadImageCallBack,
                ))),
      ],
    );

    final result = SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: OhoAppBar().getCustomAppBar(context,
          centerTitle: type != 'lesson',
          actions: [
            type == 'lesson'
                ? Container(
                    margin: EdgeInsets.only(top: 14, bottom: 14, left: 4),
                    child: appElevatedButton(
                        onPressed: () async {
                          var plainContent =
                              _controller.document.toPlainText().trim();

                          var delta = _controller.document.toDelta();

                          var mdList=List.of( attachmentKey.currentState!.mediaList);
                          String html = jsonEncode(delta.toJson());
                          if (plainContent.isNotEmpty && title != null && title!.isNotEmpty) {
                            if (lessonsList.isNotEmpty) {
                             await checkIfLessonAlreadyDrafted(html, title, subTitle,
                                 mdList , true);
                            } else {
                            lessonsList.add(getPostPayload(
                                html,
                                title,
                                subTitle,
                              mdList,
                              ));
                            }

                            clearData();
                            setState(() {
                              lessonNumber += 1;
                            });
                          } else {
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("complete_lessons_collage"),
                                context,
                                HexColor(AppColors.information));
                          }
                        },
                        color: HexColor(AppColors.appMainColor),
                        child: Text(
                          AppLocalizations.of(context)!.translate('add_lesson'),
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appColorWhite)),
                        )),
                  )
                : Container(),
            isSavingDraft
                ? Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : appTextButton(
                    onPressed: () async {
                      if (type == 'notice' || type == 'blog') {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          // Delta _delta = _controller.document.toDelta();
                          // String html =
                          // markdownToHtml(notusMarkdown.encode(_delta).toString());
                          // final converter = NotusHtmlCodec();
                          var plainText =
                              _controller.document.toPlainText().trim();
                          var delta = _controller.document.toDelta();
                          String html = jsonEncode(delta.toJson());
                          if (plainText != null &&
                              plainText.trim().isNotEmpty &&
                              title!.isNotEmpty) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => PostReceiverListPage(
                                          payload: getPostPayload(
                                            html,
                                            title,
                                            subTitle,
                                            attachmentKey
                                                .currentState!.mediaList,
                                          ),
                                      callBack:(){
                                            if(widget.callBack!=null)
                                              widget.callBack!();},
                                          selectedReceiverData:
                                              widget.selectedReceiverData,
                                        )))
                                .then((value) {
                              if (value != null) {
                                Navigator.pop(context, true);
                              }
                            });
                          } else {
                            if (title!.isEmpty)
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate("add_title"),
                                  context,
                                  HexColor(AppColors.information));

                            if (plainText.trim().isEmpty)
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate("add_content"),
                                  context,
                                  HexColor(AppColors.information));
                          }
                        }
                      } else if (type == 'assignment') {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          var plainText =
                              _controller.document.toPlainText().trim();
                          if (plainText != null &&
                              plainText.trim().isNotEmpty &&
                              title!.isNotEmpty) {
                            if (detailsPayload != null &&
                                detailsPayload!.contentMeta != null &&
                                detailsPayload!.contentMeta!.others != null) {
                              if (attachmentKey.currentState!.mediaList.length >
                                  0) {
                                var delta = _controller.document.toDelta();
                                String html = jsonEncode(delta.toJson());
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            PostReceiverListPage(
                                              payload: getPostPayload(
                                                html,
                                                title,
                                                subTitle,
                                                attachmentKey
                                                    .currentState!.mediaList,
                                              ),
                                              callBack:(){
                                                if(widget.callBack!=null)
                                                  widget.callBack!();
                                              },
                                              selectedReceiverData:
                                                  widget.selectedReceiverData,
                                            )))
                                    .then((value) {
                                  if (value != null) {
                                    Navigator.pop(context, true);
                                  }
                                });
                              } else {
                                ToastBuilder().showToast(
                                    'Please upload atleast 1 media file',
                                    context,
                                    HexColor(AppColors.information));
                              }
                            } else {
                              ToastBuilder().showToast(
                                  'Please fill all the details',
                                  context,
                                  HexColor(AppColors.information));
                              showContentDetailsSheet();
                            }
                          } else {
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("add_content"),
                                context,
                                HexColor(AppColors.information));
                          }
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!
                                  .translate("add_content"),
                              context,
                              HexColor(AppColors.information));
                        }
                      } else if (type == 'answer') {
                        // Delta _delta = _controller.document.toDelta();
                        // String html =
                        // markdownToHtml(notusMarkdown.encode(_delta).toString());
                        // final converter = NotusHtmlCodec();
                        var plainText =
                            _controller.document.toPlainText().trim();
                        var delta = _controller.document.toDelta();

                        String html = jsonEncode(delta.toJson());

                        if (plainText != null && plainText.trim().isNotEmpty) {
                          createAnswer(html);
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!
                                  .translate("add_content"),
                              context,
                              HexColor(AppColors.information));
                        }
                      } else if (type == 'submit_assign') {
                        // Delta _delta = _controller.document.toDelta();
                        // String html =
                        // markdownToHtml(notusMarkdown.encode(_delta).toString());
                        // final converter = NotusHtmlCodec();
                        var plainText =
                            _controller.document.toPlainText().trim();
                        var delta = _controller.document.toDelta();

                        String html = jsonEncode(delta.toJson());

                        if (plainText != null && plainText.trim().isNotEmpty) {
                          createAnswer(html);
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!
                                  .translate("add_content"),
                              context,
                              HexColor(AppColors.information));
                        }
                      } else if (type == 'poll') {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (detailsPayload != null &&
                              detailsPayload!.contentMeta!.others!.pollEnd !=
                                  null) {
                            String? html = title;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => PostReceiverListPage(
                                          payload: getPostPayload(
                                            html,
                                            title,
                                            subTitle,
                                            attachmentKey
                                                .currentState!.mediaList,
                                          ),
                                      callBack:(){
                                        if(widget.callBack!=null)
                                          widget.callBack!();
                                      },
                                          selectedReceiverData:
                                              widget.selectedReceiverData,
                                        )))
                                .then((value) {
                              if (value != null) {
                                Navigator.pop(context, true);
                              }
                            });
                          } else {
                            ToastBuilder().showToast("Please select a date",
                                context, HexColor(AppColors.information));
                            showContentDetailsSheet();
                          }
                        }
                      } else if (type == 'news') {
                        if (formKey.currentState!.validate()) {
                          if (attachmentKey.currentState!.mediaList.length > 0) {
                            if (wordCount <= 60) {
                              formKey.currentState!.save();
                              var plainContent =
                                  _controller.document.toPlainText().trim();
                              // final converter = NotusHtmlCodec();
                              var delta = _controller.document.toDelta();

                              String html = jsonEncode(delta.toJson());

                              if (title!.isNotEmpty) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            CampusNewsHelperPages(
                                              CAMPUS_NEWS_TYPE.assure,
                                              callBack: widget.callBack,
                                              postCreatePayload: getPostPayload(
                                                html,
                                                title,
                                                subTitle,
                                                attachmentKey
                                                    .currentState!.mediaList,
                                              ),
                                              selectedReceiverData:
                                                  widget.selectedReceiverData,
                                            )))
                                    .then((value) {
                                  if (value != null && value) {
                                    Navigator.pop(context, true);
                                  }
                                });
                              } else {
                                if (title!.isEmpty)
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate("add_title"),
                                      context,
                                      HexColor(AppColors.information));

                                if (plainContent.trim().isEmpty)
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate("add_content"),
                                      context,
                                      HexColor(AppColors.information));
                              }
                            } else {
                              ToastBuilder().showToast(
                                  'You Exceeded Maximum Word limit',
                                  context,
                                  HexColor(AppColors.information));
                            }
                          } else {
                            ToastBuilder().showToast(
                                AppLocalizations.of(context)!
                                    .translate("please_select_atleast_media"),
                                context,
                                HexColor(AppColors.information));
                          }
                        }
                      } else if (type == 'qa') {
                        String? html = questionContent;
                        if (title != null && title!.isNotEmpty) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => PostReceiverListPage(
                                        payload: getPostPayload(
                                          html,
                                          title,
                                          subTitle,
                                          attachmentKey.currentState!.mediaList,
                                        ),
                                    callBack:(){
                                      if(widget.callBack!=null)
                                        widget.callBack!();
                                    },
                                        selectedReceiverData:
                                            widget.selectedReceiverData,
                                      )))
                              .then((value) {
                            if (value != null) {
                              Navigator.pop(context, true);
                            }
                          });
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!
                                  .translate("add_question"),
                              context,
                              HexColor(AppColors.information));
                        }
                      } else {
                        var plainContent =
                            _controller.document.toPlainText().trim();

                        var delta = _controller.document.toDelta();
                        var mdList=List.of( attachmentKey.currentState!.mediaList);
                        String html = jsonEncode(delta.toJson());
                        if (plainContent.isNotEmpty) {
                          if (type == "lesson") {


                            if (plainContent.isNotEmpty ) {

                              if (wordCount >= 100)
                             { if (lessonsList.isNotEmpty) {
                                checkIfLessonAlreadyDrafted(
                                  html,
                                  title,
                                  subTitle,
                                    mdList,false
                                );
                              }
                              else {
                                lessonsList.add(getPostPayload(
                                  html,
                                  title,
                                  subTitle,
                                  mdList,
                                ));
                                saveDraftOrUpdate(lessonsList);
                              }}
                              else {
                                ToastBuilder().showToast(
                                    AppLocalizations.of(context)!
                                        .translate('minimum_word'),
                                    context,
                                    HexColor(AppColors.information));
                              }
                            } else if (lessonsList != null &&
                                lessonsList.isNotEmpty) {
                              saveDraftOrUpdate(lessonsList);
                            } else {
                              ToastBuilder().showToast(
                                  AppLocalizations.of(context)!
                                      .translate('add_content'),
                                  context,
                                  HexColor(AppColors.information));
                            }
                          } else {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => PostReceiverListPage(
                                          payload: getPostPayload(
                                            html,
                                            title,
                                            subTitle,
                                            attachmentKey
                                                .currentState!.mediaList,
                                          ),
                                      callBack:(){
                                        if(widget.callBack!=null)
                                          widget.callBack!();
                                      },
                                          selectedReceiverData:
                                              widget.selectedReceiverData,
                                        )))
                                .then((value) {
                              if (value != null) {
                                Navigator.pop(context, true);
                              }
                            });
                          }
                        } else {
                          ToastBuilder().showToast(
                              AppLocalizations.of(context)!
                                  .translate('add_content'),
                              context,
                              HexColor(AppColors.information));
                        }
                      }
                    },
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          type == 'answer'
                              ? AppLocalizations.of(context)!.translate('submit')
                              : AppLocalizations.of(context)!.translate('next'),
                          style: styleElements
                              .subtitle2ThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appMainColor)),
                        ),
                        Icon(Icons.keyboard_arrow_right,
                            color: HexColor(AppColors.appMainColor))
                      ],
                    ),
                    shape: CircleBorder(),
                  ),
            // Icon(Icons.keyboard_arrow_right)
          ],
          appBarTitle: getAppBarTitle(),
          onBackButtonPress: () {
            _onBackPressed();
      }),
      body: Form(
        key: formKey,
        child: appListCard(child: form),
      ),
    ));
    return result;
  }

  Future<void> checkIfLessonAlreadyDrafted(String html, String? title,
      String? subTitle, List<MediaDetails> mediaList,bool isAddNewLesson) async {
    if (lessonNumber == lessonsList.length) {
      print(" lesson already added----------------------------");
      lessonsList[(lessonsList.length - 1)]!.contentMeta!.title = title;
      if(lessonsList[(lessonsList.length - 1)]!.lessonListItem!=null)
      lessonsList[(lessonsList.length - 1)]!.lessonListItem!.lessonName = title;
      lessonsList[(lessonsList.length - 1)]!.contentMeta!.meta = html;
      lessonsList[(lessonsList.length - 1)]!.mediaDetails = mediaList;
      lessonsList[(lessonsList.length - 1)]!.postOwnerType = postOwnerType;
      lessonsList[(lessonsList.length - 1)]!.postOwnerTypeId = postOwnerTypeId;
      lessonsList[(lessonsList.length - 1)]!.postCreatedById =
          prefs!.getInt(Strings.userId);
      lessonsList[(lessonsList.length - 1)]!.postInstitutionId =
          prefs!.getInt(Strings.instituteId);
      lessonsList[(lessonsList.length - 1)]!.postType = type != null
          ? type == 'feed'
              ? 'general'
              : type
          : 'general';
      lessonsList[(lessonsList.length - 1)]!.postStatus = 'posted';
      lessonsList[(lessonsList.length - 1)]!.postCategory = 'normal';
      lessonsList[(lessonsList.length - 1)]!.mediaDetails = mediaList;
      lessonsList[(lessonsList.length - 1)]!.postMentions = mentions;
      if(!isAddNewLesson)
      saveDraftOrUpdate(lessonsList);
    } else {
      print("new lesson ----------------------------");
      lessonsList.add(getPostPayload(html, title, subTitle, mediaList));
      if(!isAddNewLesson)
      saveDraftOrUpdate(lessonsList);
    }
  }

  Future saveDraftOrUpdate(List<PostCreatePayload?> list) async {
    setState(() {
      isSavingDraft = true;
    });

    for (int i = 0; i < lessonsList.length; i++) {
      await (saveAsDRaft(
          lessonsList[i]!, i == lessonsList.length - 1 ? true : false));
    }
  }

  Future saveAsDRaft(PostCreatePayload payload, bool isFinalCall) async {
    payload.postStatus = "draft";
    var body = jsonEncode(payload);
    await Calls()
        .call(body, context,
            payload.id != null ? Config.UPDATE_POST : Config.CREATE_POST)
        .then((value) {
      var res = SaveAsDraftResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        res.rows!.postId = res.rows!.id;
        setState(() {
          draftedLessonsList.add(res.rows);
          if (isFinalCall) {
            lessonsList = List.of(draftedLessonsList);
            print(lessonsList.length.toString() +
                "---------------------------------------------"
                    "+");
            setState(() {
              isSavingDraft = false;
              draftedLessonsList.clear();
            });
            print(draftedLessonsList.length.toString() +
                "---------------------------------------------"
                    "-");
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return CommentSheet(
                      topicName: widget.topicName,
                      chapterItem: widget.createLessonData != null
                          ? widget.createLessonData!.chapterItem
                          : null,
                      lessonListItem: widget.createLessonData != null
                          ? widget.createLessonData!.lessonListItem
                          : null,
                      chapterCreateCallBack: (lessonsList) {
                        if(widget.callBack!=null)
                          widget.callBack!();
                       Navigator.pop(context);
                      },
                      list: lessonsList,
                      selectedReceiverData: widget.selectedReceiverData);
                });
          }
        });
      } else {
        setState(() {
          isSavingDraft = false;
        });
      }
    }).catchError((onError) {
      print(onError);
      setState(() {
        isSavingDraft = false;
      });
    });
  }

  Future<String> _uploadImageCallBack(File file) async {
    print("#####PATH###  "+file.path);
    var pr = ToastBuilder().setProgressDialogWithPercent(context,'Uploading Image...');
    var contentType = ImagePickerAndCropperUtil().getMimeandContentType(
        file.path);
    var value = await UploadFile(
        baseUrl: Config.BASE_URL,
        context: context,
        token: prefs!.getString("token"),
        contextId: '',
        contextType: CONTEXTTYPE_ENUM.FEED.type,
        ownerId: prefs!.getInt(Strings.userId).toString(),
        ownerType: OWNERTYPE_ENUM.PERSON.type,
        file: file,
        subContextId: "",
        subContextType: "",
        onProgressCallback: (int value){
          pr.update(progress:value.toDouble());
        },
        mimeType: contentType[1],
        contentType: contentType[0])
        .uploadFile();
    var imageResponse = ImageUpdateResponse.fromJson(value);
    return Config.BASE_URL+imageResponse.rows!.fileThumbnailUrl!;
  }

  bool _toolbarVisible() {
    if (type == 'qa' || type == 'poll') {
      return false;
    } else {
      return _keyboardIsVisible();
    }
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  Widget buildEditor() {
    return getEditor(HexColor(AppColors.appColorWhite), "feed");
  }

  Widget getLessons() {
    return Container(
        margin: EdgeInsets.all(0),
        child: getEditor(HexColor(AppColors.appColorWhite), "lesson"));
  }

  Widget getBlogEditor() {
    return Container(
        margin: EdgeInsets.all(0),
        child: getEditor(HexColor(AppColors.appColorWhite), "blog"));
  }

  Widget getQAndA() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  validator: validateTextField,
                  onChanged: (value) {
                    title = value;
                  },
                  maxLines: 3,
                  minLines: 1,
                  maxLength: 150,
                  textCapitalization: TextCapitalization.sentences,
                  style: styleElements
                      .headline6ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .translate('ask_questions'),
                      hintStyle: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: HexColor(AppColors.appColorBlack35)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: TextField(
                  onChanged: (value) {
                    questionContent = value;
                  },
                  maxLength: 300,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  style: styleElements
                      .subtitle1ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appColorBlack65)),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintStyle: styleElements
                          .bodyText2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appColorBlack35)),
                      hintText:
                          'Optional : write some additional inputs or copy a link that gives a context'),
                ),
              ),
            ],
          )),
    );
  }

  Widget getGoalsAndObjectives() {
    return Container(
      height: 200,
      child: Center(
          child: Text(
              AppLocalizations.of(context)!.translate('goals_and_objectives'))),
    );
  }

  Widget getNoticeWidget() {
    return Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: getEditor(
            _selectedColor != null
                ? HexColor(_selectedColor)
                : HexColor(AppColors.information),
            "circular"));
  }

  Widget getAnswers() {
    return getEditor(HexColor(AppColors.appColorWhite), "answer");
  }

  Widget getPolls() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.w600),
                maxLength: 150,
                maxLines: 3,
                minLines: 1,
                validator: validateTextField,
                onSaved: (value) {
                  title = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    hintText: AppLocalizations.of(context)!
                        .translate('write_poll_question'),
                    hintStyle: styleElements
                        .headline6ThemeScalable(context)
                        .copyWith(
                            fontWeight: FontWeight.w600,
                            color: HexColor(AppColors.appColorBlack35))),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: optionsCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 32.0),
                      child: Row(children: [
                        Flexible(
                          child: TextField(
                            controller: _getController(index),
                            maxLines: 2,
                            maxLength: 30,
                            minLines: 1,
                            style: styleElements
                                .subtitle1ThemeScalable(context)
                                .copyWith(
                                    color: HexColor(AppColors.appColorBlack65)),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                        .translate('option') +
                                    '${index + 1}',
                                hintStyle: styleElements
                                    .bodyText2ThemeScalable(context)
                                    .copyWith(
                                        color: HexColor(
                                            AppColors.appColorBlack35))),
                          ),
                        ),
                        Visibility(
                          visible: (index != 0 && index != 1),
                          child: IconButton(
                            icon: Icon(Icons.remove_circle_outline_rounded),
                            onPressed: () {
                              addRemoveOption(false);
                            },
                          ),
                        )
                      ]),
                    );
                  },
                )),
            Visibility(
              visible: optionsCount != 4,
              child: Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: appElevatedButton(
                  onPressed: () {
                    addRemoveOption(true);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('add_options'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appColorWhite)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAssignments() {
    return Container(
        child: getEditor(HexColor(AppColors.appColorWhite), "assignment"));
  }

  Widget getCampusNews() {
    return Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: getEditor(HexColor(AppColors.appColorWhite), "news"));
  }

  Widget getEditor(Color color, String name) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            name == "lesson"
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      name == "lesson"
                          ? AppLocalizations.of(context)!.translate(
                              'write_title',
                              arguments: {"type": lessonNumber.toString()})
                          : "",
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: titleController,
                  validator: validateTextField,
                  onChanged: (value) {
                    title = value;
                  },
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  style: styleElements
                      .headline6ThemeScalable(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      hintText: name == "lesson"
                          ? AppLocalizations.of(context)!
                              .translate('write_title_name')
                          : name == "news"
                              ? AppLocalizations.of(context)!
                                  .translate('write_heading_news')
                              : name == "blog"
                                  ? AppLocalizations.of(context)!
                                      .translate('write_heading_blog')
                                  : name == "circular"
                                      ? AppLocalizations.of(context)!
                                          .translate('write_heading_notice')
                                      :name == "feed"
                          ? AppLocalizations.of(context)!
                          .translate('write_heading_feed')
                          : "",
                      border: InputBorder.none,
                      hintStyle: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: HexColor(AppColors.appColorBlack35)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: color,
            margin: EdgeInsets.all(0),
            child:
            QuillEditor(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: ScrollController(),
              scrollable: true,
              enableInteractiveSelection: true,
              padding: EdgeInsets.all(16),
              autoFocus: false,
              readOnly: false,
              expands: true,
              placeholder: 'Write your content here...',
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
        WordCounterChecker(
          key: wordCounterKey,
          currentWordCount: wordCount,
          wordLimit: wordLimit,
        )
      ],
    );
  }

  // ignore: missing_return

  TextEditingController _getController(int index) {
    if (index == 0) {
      return editingController1;
    } else if (index == 1) {
      return editingController2;
    } else if (index == 2) {
      return editingController3;
    } else {
      return editingController4;
    }
  }

  void addRemoveOption(bool addRemove) {
    setState(() {
      if (addRemove) {
        optionsCount++;
      } else {
        optionsCount--;
      }
    });
  }

  getAppBarTitle() {
    switch (type) {
      case 'feed':
        {
          return "Create Post";
        }
      case 'blog':
        {
          return "Create Blog";
        }
      case 'qa':
        {
          return "Create Questions";
        }
      case 'notice':
        {
          return 'Create Circular';
        }
      case 'goal':
        {
          return 'Create Goals';
        }
      case 'answer':
        {
          return 'Answer';
        }
      case 'submit_assign':
        {
          return 'Submit assignment';
        }
      case 'poll':
        {
          return "Create Poll";
        }
      case 'news':
        {
          return "Campus News";
        }
      case 'assignment':
        {
          return "Assignment";
        }
      case 'lesson':
        {
          return 'Create lessons';
        }
      default:
        {
          return 'default';
        }
    }
  }

  String getTitle() {
    switch (type) {
      case 'feed':
        {
          return "Feed Post";
        }
      case 'blog':
        {
          return "Blog";
        }
      case 'qa':
        {
          return "Ask Question";
        }
      case 'notice':
        {
          return 'Notice/Circular';
        }
      case 'goal':
        {
          return 'Goals';
        }
      case 'answer':
        {
          return "Answer";
        }
      case 'submit_assign':
        {
          return 'Submit assignment';
        }
      case 'poll':
        {
          return "Poll";
        }
      case 'news':
        {
          return "News";
        }
      case 'assignment':
        {
          return "Assignment";
        }
      case 'lesson':
        {
          return "Lessons";
        }
      default:
        {
          return 'default';
        }
    }
  }

  Widget getContentArea() {
    switch (type) {
      case 'feed':
        {
          return buildEditor();
        }
      case 'blog':
        {
          return getBlogEditor();
        }
      case 'qa':
        {
          return getQAndA();
        }
      case 'notice':
        {
          return getNoticeWidget();
        }
      case 'goal':
        {
          return getGoalsAndObjectives();
        }
      case 'answer':
        {
          return getAnswers();
        }
      case 'submit_assign':
        {
          return getAnswers();
        }
      case 'poll':
        {
          return getPolls();
        }
      case 'news':
        {
          return getCampusNews();
        }
      case 'assignment':
        {
          return getAssignments();
        }
      case 'lesson':
        {
          return getLessons();
        }
      default:
        {
          return buildEditor();
        }
    }
  }

  void createAnswer(String html) async {
    prefs ??= await SharedPreferences.getInstance();
    CreateAnswerPayload payload = CreateAnswerPayload();
    payload.answerById = prefs!.get(Strings.userId) as int?;
    payload.answerByType = 'person';
    payload.answerDetails = html;
    payload.postId = postId;
    if (type == 'submit_assign') {
      payload.answerOtherDetails = AnswerOtherDetails(
          mediaDetails: attachmentKey.currentState!.mediaList);
    }
    var value =
        await Calls().call(jsonEncode(payload), context, Config.ANSWER_CREATE);
    var res = CreateAnswerResponse.fromJson(value);
    if (res.statusCode == Strings.success_code) {
      Navigator.pop(context, true);
    } else {
      ToastBuilder()
          .showToast(res.message!, context, HexColor(AppColors.information));
    }
  }

  PostCreatePayload getPostPayload(String? html, String? title, String? subTitle,
      List<MediaDetails> mediaList) {



    PostCreatePayload payload = PostCreatePayload();

    payload.postId = (lessonsList.length == 0 && lessonsList.length < 1)
        ? widget.postId
        : null;
    payload.id = (lessonsList.length == 0 && lessonsList.length < 1)
        ? widget.postId
        : null;
    payload.contentMeta =
        ContentMetaCreate(meta: html, others: getOptions(), title: title);
    payload.postSubTypes = type == 'news'
        ? detailsPayload != null
            ? detailsPayload!.postSubTypes
            : null
        : null;
    payload.sourceLink =
        detailsPayload != null ? detailsPayload!.sourceLink : null;
    payload.postOwnerType = postOwnerType;
    payload.postOwnerTypeId = postOwnerTypeId;
    payload.postCreatedById = prefs!.getInt(Strings.userId);
    payload.postInstitutionId = prefs!.getInt(Strings.instituteId);
    payload.postType = type != null
        ? type == 'feed'
            ? 'general'
            : type
        : 'general';
    payload.postStatus = 'posted';
    payload.postCategory = 'normal';
    payload.mediaDetails = mediaList;
    payload.postMentions = mentions;
    payload.postKeywords = attachmentKey.currentState!.getListOfTags;
    if (type == 'notice') {
      payload.postColor = _selectedColor;
    }
    return payload;
  }

  OtherPollRequest? getOptions() {
    if (type == 'poll') {
      OtherPollRequest otherRequest = OtherPollRequest();
      otherRequest.pollStart = DateTime.now().millisecondsSinceEpoch;
      otherRequest.pollEnd = detailsPayload!.contentMeta!.others!.pollEnd;
      List<Options> listOptions = [];
      for (int i = 0; i < optionsCount; i++) {
        listOptions.add(Options(
            option: _getController(i).text,
            numberSelected: 0,
            optionSequence: i + 1,
            percentage: 0));
      }
      otherRequest.options = listOptions;
      otherRequest.totalResponses = 0;
      return otherRequest;
    } else if (type == 'assignment') {
      print('asign');
      return detailsPayload!.contentMeta!.others;
    } else {
      return null;
    }
  }

  void _showSelectorBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      builder: (context) {
        return SelectProfileSheet(prefs, postOwnerTypeId,
            (int ?id, String ?type, String? imageUrl, String ?name) {
          postOwnerType = type;
          postOwnerTypeId = id;
          image_url = imageUrl;
          avatarKey.currentState!.refresh(Utility().getUrlForImage(
              imageUrl,
              RESOLUTION_TYPE.R64,
              type == 'person'
                  ? SERVICE_TYPE.PERSON
                  : SERVICE_TYPE.INSTITUTION));
        });
        // return BottomSheetContent();
      },
    );
  }

  void _showModalBottomSheet(BuildContext context) async {
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
            if (value != type) {
              isAssignmentDetails = false;
              switch (value) {
                case 'feed':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'feed';
                    });
                    break;
                  }
                case 'blog':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'blog';
                    });
                    break;
                  }
                case 'qa':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'qa';
                    });
                    break;
                  }
                case 'goal':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'goal';
                    });
                    break;
                  }
                case 'notice':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'notice';
                    });
                    break;
                  }
                case 'poll':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'poll';
                    });
                    break;
                  }
                case 'news':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'news';
                    });
                    break;
                  }
                case 'lesson':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'lesson';
                    });
                    break;
                  }
                case 'assignment':
                  {
                    Navigator.pop(context);
                    setState(() {
                      type = 'assignment';
                    });
                    break;
                  }
              }
            }
          },
        );
      },
    );
  }
}

class PostDetailsSheet extends StatefulWidget {
  final String? type;
  final Function(String?)? onColorSelect;

  PostDetailsSheet({this.type, this.onColorSelect});

  @override
  PostDetailSheetState createState() => PostDetailSheetState();
}

class PostDetailSheetState extends State<PostDetailsSheet> with CommonMixins {
  late TextStyleElements styleElements;
  GlobalKey<SelectNewsTopicWidgetState> topicsKey = GlobalKey();

  String? weblink;
  var selectedDate = "Select end date for polls";
  var selectedDateEpoch;
  String _maxMarks = "0";
  int? selectedStartEpoch;

  String selectedStartDate = "Submission date";
  TimeOfDay? selectedStartTimeOfDay;
  String selectedStartTime = 'Submission time';

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 24, left: 16, right: 16),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        getDetails(),
                        style: styleElements.headline6ThemeScalable(context),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        PostCreatePayload payload = PostCreatePayload();
                        if (widget.type == 'news') {
                          payload.sourceLink = weblink;
                          payload.postSubTypes =
                              topicsKey.currentState!.getSelectedList();
                          Navigator.pop(context, payload);
                        } else if (widget.type == 'poll') {
                          if (selectedDateEpoch != null) {
                            payload.contentMeta = ContentMetaCreate(
                                others: OtherPollRequest(
                                    pollEnd: selectedDateEpoch));
                            Navigator.pop(context, payload);
                          } else {
                            ToastBuilder().showToast("Please select a date",
                                context, HexColor(AppColors.information));
                          }
                        } else if (widget.type == 'assignment') {
                          if (selectedStartEpoch != null) {
                            if (selectedStartTimeOfDay != null) {
                              if (int.parse(_maxMarks) > 0) {
                                OtherPollRequest otherRequest =
                                    OtherPollRequest();
                                var d = DateTime.fromMillisecondsSinceEpoch(
                                    selectedStartEpoch!);
                                var sd = DateTime(
                                    d.year,
                                    d.month,
                                    d.day,
                                    selectedStartTimeOfDay!.hour,
                                    selectedStartTimeOfDay!.minute);
                                otherRequest.submissionDateTime =
                                    sd.millisecondsSinceEpoch;
                                otherRequest.maxMarks = int.parse(_maxMarks);
                                otherRequest.subjects =
                                    topicsKey.currentState!.getSubjects();
                                payload.contentMeta =
                                    ContentMetaCreate(others: otherRequest);
                                Navigator.pop(context, payload);
                              } else {
                                ToastBuilder().showToast(
                                    'Marks should be greater than 0',
                                    context,
                                    HexColor(AppColors.information));
                              }
                            } else {
                              ToastBuilder().showToast('Please select due time',
                                  context, HexColor(AppColors.information));
                            }
                          } else {
                            ToastBuilder().showToast('Please select due date',
                                context, HexColor(AppColors.information));
                          }
                        } else {
                          Navigator.pop(context, payload);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          AppLocalizations.of(context)!.translate('done'),
                          style: styleElements
                              .captionThemeScalable(context)
                              .copyWith(
                                  color: HexColor(AppColors.appMainColor)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 36,
            ),
            getContentArea(),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 120,
            )
          ],
        ),
      ),
    );
  }

  Widget getContentArea() {
    if (widget.type == 'news') {
      return news();
    } else if (widget.type == 'poll') {
      return polls();
    } else if (widget.type == 'notice') {
      return notice();
    } else if (widget.type == 'qa') {
      return qnA();
    } else if (widget.type == 'assignment') {
      return assignment();
    } else {
      return Container();
    }
  }

  Widget news() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectNewsTopicWidget(topicsKey),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: HexColor(AppColors.appColorWhite),
            child: Row(
              children: [
                Flexible(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      validator: validateWebLink,
                      onChanged: (value) {
                        weblink = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.url,
                      style: styleElements
                          .subtitle1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .translate('copy_web_link'),
                          hintStyle: styleElements
                              .bodyText2ThemeScalable(context)
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: HexColor(AppColors.appColorBlack35)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CampusNewsHelperPages(
                              CAMPUS_NEWS_TYPE.help,
                              selectedReceiverData: null,
                            );
                          }));
                        },
                        icon: Icon(
                          Icons.help_outline_rounded,
                          color: HexColor(AppColors.appColorBlack35),
                        )),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget polls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              _showModalBottomSheetDatePicker(context);
            },
            child: Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      //
                      color: HexColor(AppColors.appColorGrey500),
                      width: 1.0,
                    ),
                  ), // set border width
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$selectedDate",
                      textAlign: TextAlign.left,
                      style: styleElements
                          .bodyText2ThemeScalable(context)
                          .copyWith(fontSize: 14),
                    )))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('poll_ins1'),
            style: styleElements.bodyText2ThemeScalable(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.translate('poll_ins2'),
              style: styleElements.bodyText2ThemeScalable(context)),
        )
      ],
    );
  }

  Widget notice() {
    return appColorSelector(onColorSelect: widget.onColorSelect);
  }

  Widget qnA() {
    return appHtmlViewer(
      sourceString: AppLocalizations.of(context)!.translate('tips_to_answer'),
      isDetailPage: false,
      isNewsPage: true,
      isNoticeCard: false,
    );
  }

  Widget assignment() {
    final startDateWidget = GestureDetector(
        onTap: () {
          _selectStartDate(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: HexColor(AppColors.appColorGrey50),
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedStartDate != "Submission date"
                      ? DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(selectedStartDate))
                      : "Submission date",
                  textAlign: TextAlign.left,
                  style: selectedStartDate != "Submission date"
                      ? styleElements.subtitle1ThemeScalable(context)
                      : styleElements.bodyText2ThemeScalable(context),
                ))));
    final startTimeWidget = GestureDetector(
        onTap: () {
          _selectStartTime(context);
        },
        child: Container(
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: Colors.grey,
                  width: 1.0,
                ),
              ), // set border width
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedStartTime,
                  textAlign: TextAlign.left,
                  style: selectedStartTime != "Submission time"
                      ? styleElements.subtitle1ThemeScalable(context)
                      : styleElements.bodyText2ThemeScalable(context),
                ))));
    final maxMarks = TextFormField(
      validator: validateTextField,
      onChanged: (value) {
        _maxMarks = value;
      },
      keyboardType: TextInputType.number,
      style: styleElements
          .subtitle1ThemeScalable(context)
          .copyWith(color: HexColor(AppColors.appColorBlack65)),
      decoration: InputDecoration(
          hintText: 'Ex. 20',
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appColorBlack35))),
    );
    return Container(
        child: Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(bottom: 16, left: 16.0, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: getAssignmentPostDetailCard(
                  'Submission date',
                  startDateWidget,
                )),
                Expanded(
                    child: getAssignmentPostDetailCard(
                  'Submission time',
                  startTimeWidget,
                )),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 16, left: 16.0, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: getAssignmentPostDetailCard(
                    'Maximum marks',
                    maxMarks,
                  ),
                ),
                Spacer()
              ],
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 16, left: 16.0, right: 16),
            child: getAssignmentPostDetailCard(
              'Select subject',
              SelectNewsTopicWidget(
                topicsKey,
                isCard: false,
                type: 'subject',
              ),
            ))
      ],
    ));
  }

  _showModalBottomSheetDatePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: _showCuperTinoDatePicker(),
            ),
          );
        });
  }

  Widget _showCuperTinoDatePicker() {
    DateTime today = new DateTime.now();
    var newDate = new DateTime(today.year, today.month, today.day + 1);
    var maxDate = new DateTime(today.year, today.month, today.day + 15);
    var minDate = new DateTime(today.year, today.month, today.day + 1);
    return Column(
      children: [
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: appTextButton(onPressed: (){
                Navigator.pop(context);
              },
                shape: StadiumBorder(),
                child: Text(AppLocalizations.of(context)!.translate('done'),
                  style: styleElements.captionThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appMainColor)
                ),),),
            )
        ),
        Expanded(
          child: CupertinoDatePicker(
            initialDateTime: newDate,
            maximumDate: maxDate,
            minimumDate: minDate,
            onDateTimeChanged: (DateTime newdate) {
              setState(() {
                selectedDateEpoch = newdate.millisecondsSinceEpoch;
                selectedDate = DateFormat('yyyy-MM-dd').format(newdate);
              });
            },
            mode: CupertinoDatePickerMode.date,
          ),
        ),
      ],
    );
  }

  String getDetails() {
    if (widget.type == 'feed') {
      return "Feed";
    } else if (widget.type == 'news') {
      return "News Details";
    } else if (widget.type == 'poll') {
      return "Poll Details";
    } else if (widget.type == 'notice') {
      return "Circular Details";
    } else if (widget.type == 'qa') {
      return "Tips to get good answers";
    } else if (widget.type == 'assignment') {
      return "Assignment Details";
    } else {
      return "Details";
    }
  }

  Widget getAssignmentPostDetailCard(String title, Widget child,
      {EdgeInsets? padding}) {
    return Container(
        margin: EdgeInsets.only(left: 4, right: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            Padding(
              padding: padding ?? EdgeInsets.all(0),
              child: child,
            )
          ],
        ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    var newDate;

    newDate = new DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: newDate,
        firstDate: newDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.black,
              accentColor: Colors.black,
              colorScheme: ColorScheme.dark(
                primary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        lastDate: DateTime(DateTime.now().year + 100));
    if (picked != null)
      setState(() {
        selectedStartEpoch = picked.millisecondsSinceEpoch;
        selectedStartDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            accentColor: Colors.black,
            colorScheme: ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedStartTimeOfDay = picked;
        selectedStartTime =
            picked.hour.toString() + ':' + picked.minute.toString();
      });
  }
}

class CommentSheet extends StatefulWidget {
  final Function(List<PostCreatePayload?>? list)? chapterCreateCallBack;
  final List<PostCreatePayload?>? list;
  final PostReceiverListItem? selectedReceiverData;
  final ChapterItem? chapterItem;
  final LessonListItem? lessonListItem;
  final String? topicName;

  const CommentSheet(
      {Key? key,
      this.chapterCreateCallBack,
      this.list,
      this.topicName,
      this.chapterItem,
      this.lessonListItem,
      this.selectedReceiverData})
      : super(key: key);

  @override
  _CommentSheet createState() =>
      _CommentSheet(chapterItem: chapterItem, lessonListItem: lessonListItem);
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  final lastNameController = TextEditingController();
  ChapterItem? chapterItem;
  LessonListItem? lessonListItem;

  _CommentSheet({this.chapterItem, this.lessonListItem});

  @override
  void initState() {
    super.initState();
    isChapterCreatedAlready=chapterItem!=null && chapterItem!.chapterName!=null;
    if (chapterItem != null) lastNameController.text = chapterItem!.chapterName!;
  }
late bool isChapterCreatedAlready;
  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    final typeAheadChapter =   TypeAheadField<ChapterItem>(
      getImmediateSuggestions: false,
      debounceDuration: Duration(milliseconds: 700),
      suggestionsCallback: (String pattern) async {
        if (pattern.isNotEmpty) {
          var body = jsonEncode({
            "searchVal": pattern,
            "page_number": 1,
            "page_size": 10,
            "list_type": "all"
          });
          var res = await Calls().call(body, context, Config.CHAPTERS_LIST);
          if (ChaptersResponse.fromJson(res).rows!.length > 0) {
            return ChaptersResponse.fromJson(res).rows!;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } as FutureOr<Iterable<ChapterItem>> Function(String),
      itemBuilder: (BuildContext context, ChapterItem itemData) {
        return ListTile(
          title: Text(
            itemData.chapterName!,
            style: styleElements.subtitle1ThemeScalable(context),
          ),
        );
      },
      onSuggestionSelected: (ChapterItem suggestion) {
        for (int i = 0; i < widget.list!.length; i++) {
          widget.list![i]!.chapterItem =suggestion;
        }
        createLessons();

      },
      direction: AxisDirection.up,
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        controller: lastNameController,
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('give_chapter_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appColorBlack35)),
        )
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () async {
                  if (widget.list!.isNotEmpty && widget.list!.length == 1)
                    await createLessons();
                },
                child: Text(
                  (widget.list!.isNotEmpty && widget.list!.length == 1)
                      ? AppLocalizations.of(context)!.translate('skip')
                      : "",
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                AppLocalizations.of(context)!.translate('name_chapter'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () async {
                  if (lastNameController.text != null && lastNameController.text.isNotEmpty )
                   {
                     print("clickedddd---------------------");
                 if(!isChapterCreatedAlready)
                   {
                     print("create chapter---------------------");
                     createChapter(lastNameController.text.toString());}
                  else
                    {

                      print("create chapter---------------------");
                        await createLessons();
                    }
                   }
                  else
                    ToastBuilder().showToast(
                        AppLocalizations.of(context)!
                            .translate("name_chapter_required"),
                        context,
                        HexColor(AppColors.information));
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('next'),
                  style: styleElements
                      .subtitle2ThemeScalable(context)
                      .copyWith(color: HexColor(AppColors.appMainColor)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 30),
          child: typeAheadChapter,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 45.0, right: 45.0, top: 20, bottom: 60),
          child: Text(
            AppLocalizations.of(context)!.translate('chapter_dec'),
            style: styleElements.bodyText1ThemeScalable(context),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  void createChapter(String name) async {
    if (chapterItem == null) {
      var body = jsonEncode({"chapter_name": name});
      var res = await Calls().call(body, context, Config.CREATE_CHAPTER);
      var model = CreateChaptersResponse.fromJson(res);
      if (model.statusCode == Strings.success_code) {

setState(() {
  isChapterCreatedAlready=model.rows!=null && model.rows!.chapterName!=null;
});
        for (int i = 0; i < widget.list!.length; i++) {
          widget.list![i]!.chapterItem = model.rows;
        }
        createLessons();
      } else {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("something_wrong"),
            context,
            HexColor(AppColors.information));
      }
    } else {
      chapterItem!.chapterName = lastNameController.text;
      for (int i = 0; i < widget.list!.length; i++) {
        widget.list![i]!.chapterItem = chapterItem;
      }
      createLessons();
    }
  }

  Future<void> createLessons() async {
    var chapterId= widget.list![0]!.chapterItem != null
        ? widget.list![0]!.chapterItem!.id
        : null;
var chapter=widget.list![0]!.chapterItem != null?widget.list![0]!.chapterItem :null;
    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i]!.lessonListItem == null ||
          widget.list![i]!.lessonListItem!.id == null) {
        createLesson(
            chapter,
            chapterId,
            widget.list![i]!.contentMeta!.title ?? "",
            prefs!.getInt(Strings.userId),
            i);
      } else {
        /* lessonListItem.lessonName = widget.list[i].contentMeta.title;*/
        widget.list![i]!.lessonListItem!.lessonName =
            widget.list![i]!.contentMeta!.title;

        if (i == widget.list!.length - 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicTypePage(
                  list: widget.list,
                  createLessonData: null,
                  callBack: () {

                    Navigator.pop(context);
                    widget.chapterCreateCallBack!(widget.list);
                  },
                  selectedReceiverData:
                  widget.selectedReceiverData,
                  selectedItem: null,
                ),
              ));
         /* widget.chapterCreateCallBack(widget.list);*/
        }
      }
    }
  }

  void createLesson(
    ChapterItem? chapter,  int? chapterId, String lessonName, int? userId, int index) async {
    var body = jsonEncode({
      "lesson_name": lessonName,
      "chapter_id": chapterId,
      "owner_id": userId,
      "owner_type": "person"
    });
    var res = await Calls().call(body, context, Config.CREATE_LESSON);
    var model = LessonResponse.fromJson(res);
    if (model.statusCode == Strings.success_code) {
      widget.list![index]!.lessonListItem = model.rows;
      if(chapter!=null)
        widget.list![index]!.chapterItem=chapter;
      if (index == widget.list!.length - 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicTypePage(
                list: widget.list,
                createLessonData: null,
                callBack: () {

                  Navigator.pop(context);
                  widget.chapterCreateCallBack!(widget.list);
                },
                selectedReceiverData:
                widget.selectedReceiverData,
                selectedItem: null,
              ),
            ));
      }
    } else {
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("something_wrong"),
          context,
          HexColor(AppColors.information));
    }
  }
}

