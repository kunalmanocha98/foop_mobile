import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/e_learning_module/model/create_chapter_response.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post_view_response.dart';
import 'package:oho_works_app/ui/postModule/two_way_scroll_posts.dart';
import 'package:oho_works_app/ui/postcreatepage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lesson_list_response.dart';

// ignore: must_be_immutable
class CreateLessonsPage extends StatefulWidget {
  final int? chapterId;
  final String? chapterName;
  final PostCreatePayload? createLessonData;
  final Function? callBack;
  final bool isEdit ;
  final bool? isFromDetailPage;

  const CreateLessonsPage({
    Key? key,
    this.chapterId,
    this.chapterName,
    this.createLessonData,
    this.callBack,
    this.isFromDetailPage,
    this.isEdit = false,
  }) : super(key: key);

  _CreateLessonsPage createState() => _CreateLessonsPage();
}

class _CreateLessonsPage extends State<CreateLessonsPage> {
 late BuildContext context;
  String? searchVal;
  SharedPreferences? prefs;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    setPrefs();
  }

  refresh() {
    paginatorKey.currentState!.changeState(resetState: true);
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: OhoAppBar().getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('lessons'),
            actions: [
              Padding(
                padding:
                const EdgeInsets.only(top: 2.0, left: 16.0, right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.add_box_outlined),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return PostCreatePage(
                            callBack: () {
                              Navigator.of(context).pop();
                              widget.callBack!();
                            },
                            createLessonData: widget.createLessonData,
                            type: 'lesson',
                            isEdit: false,
                          );
                        }));
                    // showModalBottomSheet(
                    //     context: context,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(12),
                    //       topRight: Radius.circular(12),
                    //     )),
                    //     isScrollControlled: true,
                    //     builder: (BuildContext context) {
                    //       return CommentSheet(
                    //           chapterId: widget.chapterId,
                    //           userId: prefs.getInt(Strings.userId),
                    //           chapterCreateCallBack: () {
                    //             refresh();
                    //           });
                    //     });
                  },
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              //   child: InkWell(
              //     onTap: () {
              //       if (widget.createLessonData.lessonListItem != null)
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => PostCreatePage(
              //                   createLessonData: widget.createLessonData,
              //                   type: 'learning',
              //                   question: null,
              //                   postId: 12,
              //                   prefs: null,
              //                 )));
              //     },
              //     child: Text(
              //       AppLocalizations.of(context).translate('next'),
              //       style: styleElements
              //           .subtitle2ThemeScalable(context)
              //           .copyWith(color: HexColor(AppColors.appMainColor)),
              //     ),
              //   ),
              // ),
            ],
            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(
            children: [
              prefs != null
                  ? Container(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 20, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, bottom: 8.0),
                            child: Text(
                              widget.chapterName ?? "",
                              style: styleElements
                                  .headline6ThemeScalable(context)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Paginator.listView(
                                key: paginatorKey,
                                pageLoadFuture: fetchList,
                                pageItemsGetter: CustomPaginator(context)
                                    .listItemsGetter,
                                listItemBuilder: listItemBuilder,
                                loadingWidgetBuilder:
                                CustomPaginator(context)
                                    .loadingWidgetMaker,
                                errorWidgetBuilder: CustomPaginator(context)
                                    .errorWidgetMaker,
                                emptyListWidgetBuilder:
                                CustomPaginator(context)
                                    .emptyListWidgetMaker,
                                totalItemsGetter: CustomPaginator(context)
                                    .totalPagesGetter,
                                pageErrorChecker: CustomPaginator(context)
                                    .pageErrorChecker),
                          ),
                        ],
                      )

                    /*  ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left :16.0,bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context).translate('chapter_name_type'),
                            style: styleElements
                                .headline6ThemeScalable(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Lesson1 :Big Bang Theory",
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                              ),
                            ),
                            onTap: () async {

                            },
                          ),
                        ),
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Lesson2 :Big Bang Theory",
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                              ),
                            ),
                            onTap: () async {

                            },
                          ),
                        ),
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Lesson3 :Big Bang Theory",
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                              ),
                            ),
                            onTap: () async {

                            },
                          ),
                        ),
                        Visibility(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: appCard(

                              child: ListTile(
                                tileColor: HexColor(AppColors.listBg),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Lesson4 :Big Bang Theory",
                                    style: styleElements
                                        .subtitle1ThemeScalable(context),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                              ),
                            ),
                            onTap: () async {

                            },
                          ),
                        ),


                      ],
                    )*/
                  ))
                  : Container(),
            ],
          )),
    );
  }

  Widget listItemBuilder(value, int index) {
    LessonListItem item = value;
    return Visibility(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: appCard(
          child: ListTile(
            tileColor: HexColor(AppColors.listBg),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("${index+1}. "+
                item.lessonName!,
                style: styleElements.subtitle1ThemeScalable(context),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        onTap: () async {
          final body = jsonEncode({"post_id": item.referenceId});
          Calls().call(body, context, Config.POST_VIEW).then((value) {
            var res = PostViewResponse.fromJson(value);
            if (res.statusCode == Strings.success_code) {
              widget.createLessonData!.lessonListItem = item;
              widget.createLessonData!.contentMeta!.meta =
                  res.rows!.postContent!.content!.contentMeta!.meta;
              widget.createLessonData!.contentMeta!.title =
                  res.rows!.postContent!.content!.contentMeta!.title;
              widget.isEdit
                  ? Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return NewNewsAndArticleDetailPage(postData: res.rows);
                  }))
                  : Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostCreatePage(
                    callBack: () {
                      Navigator.of(context).pop();
                      widget.callBack!();
                    },
                    mediaFromEdit: res.rows!.postContent!.content!.media,
                    createLessonData: widget.createLessonData,
                    type: 'lesson',
                    postId: res.rows!.postId,
                    contentData:
                    res.rows!.postContent!.content!.contentMeta!.meta,
                    isEdit: true,
                  )));
            } else {
              ToastBuilder()
                  .showToast(res.message!, context, HexColor(AppColors.failure));
            }
          });
        },
      ),
    );
  }

  Future<LessonListResponse> fetchList(int page) async {
    var body = jsonEncode({
      "searchVal": searchVal,
      "page_number": page,
      "owner_type": "person",
      "owner_id": prefs!.getInt(Strings.userId),
      "chapter_id": widget.chapterId,
      "page_size": 10,
      "list_type": "all"
    });
    var res = await Calls().call(body, context, Config.LESSON_LIST);
    var model = LessonListResponse.fromJson(res);

    if(page==1)
      {
        if(model!=null && model.rows!=null && model.rows!.isEmpty &&widget.isFromDetailPage!=null &&  widget.isFromDetailPage!)
          {

            ToastBuilder().showToast(
                AppLocalizations.of(context)!
                    .translate("no_more_lessons"),
                context,
                HexColor(AppColors.information));
            Navigator.pop(context);
          }

      }
    return model;
  }

  _CreateLessonsPage();
}

class CommentSheet extends StatefulWidget {
  final int? chapterId;
  final int? userId;
  final Function? chapterCreateCallBack;

  const CommentSheet(
      {Key? key, this.chapterId, this.userId, this.chapterCreateCallBack})
      : super(key: key);

  @override
  _CommentSheet createState() => _CommentSheet();
}

class _CommentSheet extends State<CommentSheet> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    final name = TextField(
        controller: lastNameController,
        style: styleElements
            .subtitle1ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack65)),
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            lastNameController.text = text.toUpperCase();
            lastNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: lastNameController.text.length));
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 15.0, 20.0, 4.0),
          hintText: AppLocalizations.of(context)!.translate('give_lessons_name'),
          hintStyle: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appColorBlack35)),
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate(''),
                style: styleElements
                    .headline6ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                AppLocalizations.of(context)!.translate('name_of_lesson'),
                style: styleElements
                    .subtitle1ThemeScalable(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostCreatePage(
                        type: 'learning',
                        question: null,
                        prefs: null,
                      )));
                },
                child: InkWell(
                  onTap: () {
                    if (lastNameController.text != null &&
                        lastNameController.text.isNotEmpty)
                      createLesson(widget.chapterId,
                          lastNameController.text.toString(), widget.userId);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('next'),
                    style: styleElements
                        .subtitle2ThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 30),
          child: name,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 45.0, right: 45.0, top: 20, bottom: 60),
          child: Text(
            AppLocalizations.of(context)!.translate('give_lesson_name'),
            style: styleElements.bodyText1ThemeScalable(context),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  void createLesson(int? chapterId, String lessonName, int? userId) async {
    var body = jsonEncode({
      "lesson_name": lessonName,
      "chapter_id": chapterId,
      "owner_id": userId,
      "owner_type": "person"
    });
    var res = await Calls().call(body, context, Config.CREATE_LESSON);
    var model = CreateChaptersResponse.fromJson(res);
    if (model.statusCode == Strings.success_code) {
      Navigator.of(context).pop();
      widget.chapterCreateCallBack!();
    } else {
      ToastBuilder().showToast(
          AppLocalizations.of(context)!.translate("something_wrong"),
          context,
          HexColor(AppColors.information));
    }
  }
}
