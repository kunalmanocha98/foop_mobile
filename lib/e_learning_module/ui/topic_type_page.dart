import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/customcard.dart';

import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/e_learning/topic_list.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chapter_lessons_page.dart';
import 'learner_category_page.dart';

// ignore: must_be_immutable
class TopicTypePage extends StatefulWidget {
  final TopicListItem? selectedItem;
  final List<PostCreatePayload?>? list;
  final PostReceiverListItem? selectedReceiverData;
final Function? callBack;
final PostCreatePayload? createLessonData;
  TopicTypePage({this.selectedItem, this.list, this.selectedReceiverData,this.callBack, this.createLessonData});

  _TopicTypePage createState() => _TopicTypePage(
    selectedItem: selectedItem,
    list: list,
    selectedReceiverData: selectedReceiverData,
    createLessonData: createLessonData
  );
}

class _TopicTypePage extends State<TopicTypePage> {
  late BuildContext context;
  late TextStyleElements styleElements;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonKeyNext = GlobalKey();
  List<TopicListItem> topicList = [];
  List<PostCreatePayload?>? list;
  PostReceiverListItem? selectedReceiverData;
  String? searchVal;
  TopicListItem? selectedItem;
  PostCreatePayload? createLessonData;

  _TopicTypePage({
    this.selectedItem,
    this.list,
    this.selectedReceiverData,
    this.createLessonData,
  });

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    this.context = context;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appAppBar().getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('topic_type'),

            onBackButtonPress: () {
              Navigator.pop(context);
            },
          ),
          body:Container(
            margin: const EdgeInsets.only(
                left: 16, right: 16, top: 20, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2,left: 8,right: 8,bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all( Radius.circular(12)),
                      color: HexColor(AppColors.appColorRed50)
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(top:16,left: 16,right: 16,bottom: 8),
                      child: Text(
                        AppLocalizations.of(context)!.translate("topic_des"),
                        style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w500),

                      )
                    // child: Text('Rooms are groups. You can create rooms to engage with more than one person together. Please click + on the top of the page to create new rooms.',style:
                    //   styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.w600),),
                  ),
                ),
                Expanded(
                  child: Paginator<TopicListResponse>.listView(
                    pageLoadFuture: fetchData,
                    pageItemsGetter: listItemGetter,
                    listItemBuilder: listItemBuilder,
                    loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                    errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                    emptyListWidgetBuilder:
                    CustomPaginator(context).emptyListWidgetMaker,
                    totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                    pageErrorChecker: CustomPaginator(context).pageErrorChecker,
                  ),
                ),
              ],
            ),
          ),),
    );
  }

  // _TopicTypePage();

  Future<TopicListResponse> fetchData(int page) async {
    TopicListRequest payload = TopicListRequest();
    payload.searchVal = searchVal;
    payload.pageSize = 10;
    payload.pageNumber = page;
    payload.parentTopicId = null;
    var value =
        await Calls().call(jsonEncode(payload), context, Config.TOPIC_LIST);
    return TopicListResponse.fromJson(value);
  }

  List<TopicListItem>? listItemGetter(TopicListResponse? pageData) {
    if (selectedItem != null) {
      pageData!.rows!.forEach((element) {
        element.isSelected = element.topicId == selectedItem!.topicId;
      });
    }
    topicList.addAll(pageData!.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    TopicListItem item = itemData;
    return appListCard(
      onTap: () {
        if (item.topicCode == "academic") {

      /*    for(int i=0;i<widget.list.length;i++)
          {
            widget.list[i].lessonType=item.topicCode;
            widget.list[i].lessonTopic=LessonTopic(topic: item);
            widget.list[i].learnerItem = <LearnerListItem>[
              LearnerListItem(
                  learnerCategoryId: item.topicId,
                  learnerCategoryType: item.topicCode
              )
            ];
          }*/
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateChapterLessonsPage(
                  list: list,
                  callBack:(){Navigator.of(context).pop();
                  if(widget.callBack!=null)
                    widget.callBack!();
                  },
                  createLessonData:createLessonData,
                  selectedReceiverData: widget.selectedReceiverData,
                ),
              ));
        } else
         {

       /*    for(int i=0;i<widget.list.length;i++)
           {
             widget.list[i].lessonType=item.topicCode;
             if(widget.list[i].lessonTopic!=null && widget.list[i].lessonTopic.topic!=null)
             widget.list[i].lessonTopic.topic=item;

           }*/
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {

                  return LearnerCategoryPage(
                    topicListItem: item,
                      callBack:(){Navigator.of(context).pop();
                      if(widget.callBack!=null)
                        widget.callBack!();},
                      list: list,
                      selectedReceiverData:selectedReceiverData
                  );
                }
              )).then((value) {
            if (value != null) {
              /*  setState(() {
              widget.createLessonData.learnerItem=value;
              learnerItem = value;
            });*/
            }
          });}
        // Navigator.pop(context,item);
      },
      child: ListTile(
        title: Text(
          item.topicName!,
          style: styleElements.subtitle1ThemeScalable(context),
        ),
        trailing: Visibility(
          visible: (item.isSelected != null && item.isSelected!),
          child: Icon(
            Icons.check_circle,
            color: HexColor(AppColors.appColorGreen),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class CommentSheet extends StatefulWidget {
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
              child: Text(
                AppLocalizations.of(context)!.translate('next'),
                style: styleElements
                    .subtitle2ThemeScalable(context)
                    .copyWith(color: HexColor(AppColors.appMainColor)),
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
}

// body: Container(
// child: Container(
// margin: const EdgeInsets.only(
// left: 16, right: 16, top: 20, bottom: 16),
// child: ListView(
// children: [
// Padding(
// padding:
// const EdgeInsets.only(left: 16.0, bottom: 8.0),
// child: Text(
// AppLocalizations.of(context)
// .translate('topic_name'),
// style: styleElements
//     .headline6ThemeScalable(context)
// .copyWith(fontWeight: FontWeight.bold),
// ),
// ),
// Visibility(
// child: GestureDetector(
// behavior: HitTestBehavior.translucent,
// child: appCard(
//
// child: ListTile(
// tileColor: HexColor(AppColors.listBg),
// title: Align(
// alignment: Alignment.centerLeft,
// child: Text(
// AppLocalizations.of(context)
// .translate('entity_topic'),
// style: styleElements
//     .subtitle1ThemeScalable(context),
// textAlign: TextAlign.left,
// ),
// ),
// subtitle: Align(
// alignment: Alignment.centerLeft,
// child: Text(
// AppLocalizations.of(context)
// .translate("entity_desc"),
// style: styleElements
//     .bodyText2ThemeScalable(context),
// textAlign: TextAlign.left,
// ),
// ),
// ),
// ),
// onTap: () async {},
// ),
// ),
// Visibility(
// child: GestureDetector(
// behavior: HitTestBehavior.translucent,
// child: appCard(
//
// child: ListTile(
// tileColor: HexColor(AppColors.listBg),
// title: Align(
// alignment: Alignment.centerLeft,
// child: Text(
// AppLocalizations.of(context)
// .translate('non_entity_topic'),
// style: styleElements
//     .subtitle1ThemeScalable(context),
// textAlign: TextAlign.left,
// ),
// ),
//
// subtitle: Align(
// alignment: Alignment.centerLeft,
// child: Text(
// AppLocalizations.of(context)
// .translate("non_entity_desc"),
// style: styleElements
//     .bodyText2ThemeScalable(context),
// textAlign: TextAlign.left,
// ),
// ),
// ),
// ),
// onTap: () async {},
// ),
// ),
//
// ],
// )))
