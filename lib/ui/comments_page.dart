import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/commonComponents.dart';
import 'package:oho_works_app/generic_libraries/generic_comment_review_feedback.dart';
import 'package:oho_works_app/models/comment_list_entity.dart';
import 'package:oho_works_app/profile_module/common_cards/comment_item.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CommentsPage extends StatefulWidget {
  String pageTitle;

  CommentsPage(this.pageTitle);

  _CommentsPage createState() => _CommentsPage(pageTitle);
}

class _CommentsPage extends State<CommentsPage>
    with SingleTickerProviderStateMixin {

  final commentController = TextEditingController();
  SharedPreferences? prefs;
  var pageTitle = "";
  var color1 = HexColor(AppColors.appMainColor);
  int? instituteId;
  var color2 = HexColor(AppColors.appColorWhite);
  var isSearching = false;
  var color3 = HexColor(AppColors.appColorWhite);
  var isCheckedColor = HexColor(AppColors.appColorWhite);
  List<CommentsItem>? listComments = [];
  bool _enabled = true;
  late TextStyleElements styleElements;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => getComments(null));

    super.initState();
  }

  void getComments(String? searchValue) async {


    final body =
        jsonEncode({"note_subject_type": "institution", "note_subject_id": 1});
    Calls().call(body, context, Config.COMMENTS_LIST).then((value) async {

      isSearching = false;
      if (value != null) {

        var data = CommentsListEntity.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          setState(() {
            _enabled = false;
            listComments = data.rows;
            print(listComments.toString() +
                "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          });
        }
      }
    }).catchError((onError) async {
      ToastBuilder().showToast(onError.toString(), context,HexColor(AppColors.information));

    });
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    ScreenUtil.init;
    pageTitle = AppLocalizations.of(context)!.translate('comments');
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar: TricycleAppBar().getCustomAppBarWithSearch(
            context,
            appBarTitle: pageTitle,
            onBackButtonPress: (){},
            onSearchValueChanged: (value){}),
        body: Container(
            child: Scaffold(
                backgroundColor: HexColor(AppColors.appColorBackground),
                body: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                      backgroundColor: HexColor(AppColors.appColorBackground),
                      body: NestedScrollView(
                          headerSliverBuilder: (context, value) {
                            return [];
                          },
                          body: Stack(
                            children: <Widget>[
                              Visibility(
                                visible: _enabled,
                                child: PreloadingView(
                                    url: "assets/appimages/dice.png"),
                              ),
                              Visibility(
                                  visible: !_enabled,
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8, top: 24, bottom: 70),
                                      child: Visibility(
                                        visible: listComments!.length > 0,
                                        child: Card(
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  bottom: 8,
                                                  top: 8),
                                              itemCount: listComments!.length,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                return CommentItem(
                                                    data: listComments![index]);
                                              }),
                                        ),
                                      ))),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: HexColor(AppColors.appColorGrey50),
                                  height: 61,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: HexColor(AppColors.appColorWhite),
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                              boxShadow: [
                                                CommonComponents()
                                                    .getShadowforBox()
                                              ],
                                            ),
                                            child: Expanded(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      icon: Icon(Icons.face),
                                                      onPressed: () {}),
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          commentController,
                                                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                                                        color: HexColor(AppColors.appColorBlack65)
                                                      ),
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.multiline,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Comment..........",
                                                          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                                                          border:
                                                              InputBorder.none),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: HexColor(AppColors
                                                          .appColorBlack85),
                                                    ),
                                                    onPressed: () {},
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          padding: const EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                              color: HexColor(
                                                  AppColors.appMainColor),
                                              shape: BoxShape.circle),
                                          child: InkWell(
                                            child: Icon(
                                              Icons.send,
                                              color: HexColor(AppColors.appColorWhite),
                                            ),
                                            onTap: () {
                                              GenericCommentReviewFeedback(
                                                      context, getBodyComment())
                                                  .apiCallCreate();
                                              setState(() {
                                                var data = CommentsItem();
                                                DateTime today =
                                                    new DateTime.now();
                                                data.createdDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(today);
                                                data.noteContent =
                                                    commentController.text;
                                                data.notesCreatedByName = "savil";
                                                listComments!.add(data);
                                                commentController.clear();
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))),
                ))),
      ),
    );
  }

  String getBodyComment() {
    return jsonEncode({
      "note_type": "review",
      "note_created_by_type": "person",
      "note_created_by_id": 17,
      "note_subject_type": "institution",
      "note_subject_id": 1,
      "note_content": "it is good institution",
      "note_format": ["T"],
      "note_status": "A",
      "has_attachment": false,
      "make_anonymous": false
    });
  }

  _CommentsPage(this.pageTitle);
}
